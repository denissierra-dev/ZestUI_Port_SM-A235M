# ABI AAPCS64 — referencia para leer el desensamblado ARM64

Resumen de lo necesario para interpretar correctamente el `.asm` generado por
`annotate_asm.py`.

## Registros de uso general

| Reg. | Rol AAPCS64 | Nota |
|---|---|---|
| `x0`–`x7` | argumentos / resultados | `w0`–`w7` = versión de 32 bits |
| `x8` | **resultado indirecto** (`sret`) | Se usa cuando el retorno no cabe en `x0`–`x7` (p.ej. un `std::vector` de 24 bytes) |
| `x9`–`x15` | temporales | IP0–IP5 (`x16`/`x17` son IP0/IP1) |
| `x16`–`x18` | temporales de plataforma | IP0, IP1, y x18 (plataforma) |
| `x19`–`x28` | **callee-saved** | El callee debe restaurarlos |
| `x29` | frame pointer (`FP`) | |
| `x30` | link register (`LR`) | Dirección de retorno |
| `sp` | stack pointer | 16 bytes alineado |

### El caso de `convertKeyParametersToLegacy`

El retorno es un `std::vector<km::V4_0::KeyParameter>` (24 bytes: puntero,
fin, capacidad). No cabe en `x0`–`x7`, así que C++ usa el **retorno indirecto**:

```asm
; x0 = puntero a la lista de entrada (begin), x1 = end
; x8 = puntero de salida (sret)
mov  x19, x8          ; se guarda el sret en un callee-saved
...
stp  xzr, xzr, [x19]  ; vector de salida vacio (begin=end=0)
str  xzr, [x19, #0x10]
```

## Tamaño de los elementos

Detectado del propio desensamblado (incremento del puntero de iteración):

| Struct | Tamaño | Comprobación |
|---|---|---|
| `aidl::...::keymint::KeyParameter` (entrada) | **0x28 = 40 bytes** | `add x23, x23, #0x28` en el bucle |
| `android::hardware::keymaster::V4_0::KeyParameter` (salida) | **0x20 = 32 bytes** | `add x8, x8, #0x20` al avanzar la salida |

## Convenciones de compilación relevantes

### Materialización de constantes de 32 bits

Un inmediato ARM64、`mov` sólo admite 16 bits con shift opcional (0/16/32/48).
Para una constante de 32 bits el compilador emite:

```asm
movz w1, #0x0010            ; parte baja
movk w1, #0x8000, lsl #16   ; parte alta
```

**Ojo**: `movz` con shift 0 es alias de `mov` en Capstone, y `movk` conserva
su ID. Además, el compilador puede **separar** el `movk` del `movz` varios
instrucciones de distancia (ver §2.4.2 de este documento).

Ésta es la razón por la que buscar "el inmediato 0x8000xxxx" no funciona: hay
que **reconstruir** el par.

### Firmado vs. no firmado

Capstone devuelve los inmediatos con **signo**. Para comparar un tag de 32
bits hay que enmascarar:

```python
(op.imm & 0xFFFFFFFF) == (valor & 0xFFFFFFFF)
```

Sin el máscara, `0x80000010` (2 147 483 664) nunca coincidiría con
`-2147483632`.

### Tablas de saltos (`switch`)

Para un `switch` sobre tags, clang genera un **bias** para que los índices
del switch empiecen en 0:

```asm
movz w9, #0xfd3f
movk w9, #0xcfff, lsl #16   ; w9 = 0xcffffd3f  (bias)
add  w9, w8, w9              ; w9 = tag + bias
cmp  w9, #0xe                ; limite superior del indice
b.hi <caso_default>
adrp x11, <tabla>
add  x11, x11, #<offset>
adr  x8, <base>
ldrh w10, [x11, w9, lsl #1]  ; offset de 16 bits por caso
add  x8, x8, w10, lsl #2
br   x8                      ; salto indirecto
```

**Consecuencia crítica para el análisis**: la constante `0xCFFFFD3F` **parece**
un vendor tag Samsung (tipo ≥ 0xC0000000) pero **no lo es**: es el bias del
switch. Confundirlo produciría un parche sobre el sitio equivocado. Por eso
`annotate_asm.py` detecta el patrón de dispatch completo y etiqueta el bias
como tal.

### Polaridad de los saltos condicionales

En Capstone, `b.ne` **no** aparece en `op_str` (sólo el destino). La
condición está en el atributo `ins.cc`:

```python
ins.id == ARM64_INS_B and ins.cc not in (ARM64_CC_INVALID, ARM64_CC_AL)
```

`ARM64_CC_INVALID = 0`, `ARM64_CC_AL = 15` (rama incondicional).

### `skipdata`

Al desensamblar un segmento completo hay bytes que no son código (cabeceras
ELF, padding). Capstone con `skipdata=True` los emite como pseudo-instrucciones
con `id == 0`, y **acceder a `.operands` sobre ellas lanza `CS_ERR_SKIPDATA`**.
Hay que filtrar `ins.id == 0`.

## Cheatsheet de opcodes usados

| Patrón | Bytes | Significado |
|---|---|---|
| `nop` | `1f 20 03 d5` | No-op |
| `ret` | `c0 03 5f d6` | `ret x30` |
| `mov w0, #0` | `00 00 80 52` | Poner a 0 el retorno |
| `b <abs>` | `xx xx xx 14` | Salto incondicional (cond = AL) |
| `b.eq` | `xx xx xx 54` | Salto condicional, cond = 1 (EQ) |
| `b.ne` | `xx xx xx 54` | Salto condicional, cond = 2 (NE) |
| `br xN` | `00 01 1f d6` | Salto indirecto |
| `blr xN` | `xx xx 3f d6` | Llamada indirecta |
| `stp x29,x30,[sp,#..]` | `fd 7b xx a9` | Guardar FP+LR |
| `ldp x29,x30,[sp,#..]` | `fd 7b xx a9` | Restaurar FP+LR |
| `mrs x8, tpidr_el0` | `48 d0 3b d5` | Leer TPIDR_EL0 (canary de stack) |
