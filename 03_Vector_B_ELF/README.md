# Vector B — Parcheador ELF para Keymaster (LIEF + Capstone + Keystone)

**Estado**: herramienta **validada y operativa**, pero **NO aplicada** a
producción — el binario analizado resultó ser el AOSP stock (ver §3).

## 1. Ficheros

| Fichero | Descripción |
|---|---|
| `elf_patcher.py` | Parcheador ELF (LIEF 1.x + Capstone 5.x + Keystone) |
| `raw/libkm_compat.so` | El binario analizado (182 976 bytes) |

## 2. Uso

```bash
# listar las constantes vendor (0x8xxxxxxx-0xFFFFFFFF) presentes en el binario
python3 elf_patcher.py libkm_compat.so --scan

# diagnosticar el sitio de un tag concreto (no escribe nada)
python3 elf_patcher.py libkm_compat.so --tag 0x80000010

# aplicar: neutraliza el salto condicional asociado al tag
python3 elf_patcher.py libkm_compat.so --tag 0x80000010 --apply -o parcheado.so

# alternativa: forzar el retorno 0 de la función completa
python3 elf_patcher.py libkm_compat.so \
    --patch-func convertKeyParametersToLegacy --apply -o parcheado.so
```

## 3. Análisis del binario subido — hallazgos

```
$ python3 -c "import lief; b=lief.ELF.parse('libkm_compat.so'); ..."
arch        : ARCH.AARCH64
type        : FILE_TYPE.DYN
entry       : 0xf000
secciones   : 25
segmentos   : 10
símbolos    : 287 (dynsym)
```

### 3.1 Búsqueda de `KM_TAG_SAMSUNG_ROT_REQUIRED`

| Búsqueda | Resultado |
|---|---|
| String `KM_TAG_SAMSUNG_ROT_REQUIRED` | ❌ ausente |
| String `ROT` / `SAMSUNG` de Samsung | ❌ ninguno (sólo `SAMSUNG` en el path de la AIDL) |
| Formato de log `!@` de Samsung | ❌ ninguno |
| String `convertKeyParametersToLegacy` | ❌ ausente (función estática) |
| Path del código fuente | ✅ `system/security/keystore2/src/km_compat/km_compat.cpp` |

Los 154 strings del binario, filtrados por relevancia:

```
'No secure Keymaster implementation found, but device offers insecure Keymaster HAL. Using as default.'
'system/security/keystore2/src/km_compat/km_compat.cpp'
' Masked by other implementation of Keymaster'
```

**Conclusión**: es la build **AOSP sin modificar**. El parche de Samsung
(que añade el log `!@ convertKeyParametersToLegacy : KM_TAG_SAMSUNG_ROT_REQUIRED`)
**no está aquí**.

### 3.2 Mapeo de `convertKeyParametersToLegacy` en el ensamblador

La función es `static` (namespace anónimo) → **no exportada**, y el `.symtab`
está strippeado. Se localizó por desensamblado y **firma**:

| Evidencia | Detalle |
|---|---|
| Retorno indirecto | `mov x19, x8` → devuelve `std::vector` por `sret` |
| Entrada | `ldp x9, x8, [x0]` → `begin`/`end` del vector de entrada |
| Tamaño de entrada | `add x23, x23, #0x28` → **40 bytes** = `keymint::KeyParameter` |
| Tamaño de salida | `add x8, x8, #0x20` → **32 bytes** = `keymaster::V4_0::KeyParameter` |
| Reservado | `bl 0x27d60` → `std::vector::reserve` |

**Dirección: `0x10b78`** (fin en `0x12bec`, 8 312 bytes, 2 077 instrucciones).

Llamantes (coinciden con "convierto los parámetros al principio del método"):

```
generateKey  (0x105a4)  -> bl 0x10b78 @0x10750
begin        (0x148fc)  -> bl 0x10b78 @0x149f8
importKey    (0x13a7c)  -> bl 0x10b78 @0x13b68
```

El desensamblado completo y anotado está en
`../05_Assembly_ARM64/libkm_compat/convertKeyParametersToLegacy.asm`.

### 3.3 Estructura interna

```
0x10b78  prologue; prepara el vector de salida (sret en x19)
0x10bb8  lee begin/end de la entrada; calcula el numero de elementos
0x10bd4  bl 0x27d60            -> reserve() del vector de salida
0x10be4  precarga constantes de tag: w28=0x30000192, w25=0x900003e8, w26=0x70000006
0x10c04  escribe un KeyParameter de 32 bytes (salida)
0x10c44  avanza el puntero de entrada: +0x28 (40 bytes)
0x10c50  cabeza del bucle: carga el tag del elemento (ldr w8, [x23])
0x10fec  add w9, w8, w9        -> index = tag + bias
0x10ff0  cmp w9, #0xe          -> comprobacion de rango
0x10ff8  adrp/ldr/ldrh/br      -> salto indirecto a la tabla de casos
0x12bb8  epilogue; return
```

El cuerpo es un `switch` grande sobre el tag, con **tabla de saltos** en
`.rodata` (`adrp x11, #0x9000` + `add x11, x11, #0xae6`) y **bias** `0xCFFFFD3F`
para que el índice del switch empiece en 0.

> ⚠️ El bias `0xCFFFFD3F` **parece** un vendor tag Samsung (tipo ≥ 0xC0000000)
> pero **no lo es**: es el bias del switch. Confundirlo produciría un parche
> sobre el sitio equivocado. Por eso `annotate_asm.py` detecta el patrón de
> dispatch completo y etiqueta el bias como tal.

### 3.4 Cero constantes vendor en el código

El escaneo de los segmentos sólo devuelve **una** constante en rango
`0x8xxxxxxx`:

```
0x80000300  (1 sitio, vaddr 0x2064)   -> KM_BIGNUM | 0x300  (tag estándar, en datos)
```

**Ninguna** constante ≥ 0xC0000000 aparece en el `.text`. Coherente con una
build AOSP.

## 4. Cómo la herramienta localiza el tag

Tres vías, complementarias:

| Vía | Mecanismo | Cuándo aplica |
|---|---|---|
| A | Inmediato directo de 32 bits en la instrucción (con máscara de signo) | `mov w1, #0x80000010` directo |
| B | Reconstrucción de pares `movz` + `movk` (con barrido de ventana) | vendor tags 0x8xxxxxxx, que no caben en 16 bits |
| C | Búsqueda del LE-uint32 en `.rodata` + xrefs (`ldr` literal / `adrp`+`ldr`) | constantes en tabla |

## 5. Neutralización según polaridad

El parche **no** es un NOP ciego: depende de la polaridad del salto.

| Salto | Significado | Acción aplicada |
|---|---|---|
| `b.ne` (salta si **no** es el tag) | el fall-through es el path malo | convertir en `b` incondicional → siempre va a la rama segura |
| `b.eq` (salta si **es** el tag) | el destino es el path malo | `NOP` → siempre cae a la rama segura |
| `cbz`/`cbnz`/`tbz`/`tbnz` | caso ambiguo | `NOP` + aviso `[verificar polaridad]` |

Conversión `b.ne` → `b` con Keystone, respetando la dirección de la
instrucción para calcular el offset relativo:

```python
code = asm(f"b {target:#x}", addr=branch.address)
binary.patch_address(branch.address, list(code))
```

## 6. Validación

La herramienta se validó **end-to-end** contra un ELF ARM64 sintético
construido con Keystone que contiene los dos patrones (A y B), verificando:

1. detección correcta del tag en ambas codificaciones;
2. localización del `cmp` y del branch;
3. aplicación del parche con la polaridad correcta;
4. escritura del binario y verificación de los bytes parcheados.

```
[+] xref  @0x100200: mov w1, #0x10
    cmp   @0x100208: w0, w1
    branch @0x10020c: b.ne #0x100218
    accion: b.ne -> b (incondicional a la rama segura)
[+] xref  @0x100220: ldr w1, #0x10023c
    cmp   @0x100224: w0, w1
    branch @0x100228: b.ne #0x100234
    accion: b.ne -> b (incondicional a la rama segura)
```

## 7. Siguiente paso

Para que este vector sea aplicable hace falta el binario correcto:

> **`libkm_compat.so` de la ROM ZestUI (A235F)**, no el del A235M.

El flujo A235M -> ZestUI tiene dos rutas posibles:

1. Extraer `libkm_compat.so` de la partición `system` de la ROM ZestUI
   (el `system.img` de `ZestUI-4.2.9-SM-A235F-S911BXXSAFZH3.zip`).
2. O bien comprobar si el A235M **también** tiene el parche de Samsung en
   otro binario (p.ej. `libpuresoftkeymasterdevice.so`).

Con el binario correcto:

```bash
python3 elf_patcher.py libkm_compat_ZestUI.so --scan
# -> lista las constantes vendor presentes; el valor de ROT_REQUIRED debe aparecer
```
