# Bitácora del puerto

Registro cronológico de las acciones realizadas, con el razonamiento y el
resultado de cada una. Para la foto de estado actual, ver
`../00_Overview/01_ESTADO_Y_PLAN.md`.

---

## Fase 0 — Preparación del entorno

| # | Acción | Resultado |
|---|---|---|
| 0.1 | Inventario de herramientas disponibles | `lz4`, `cpio`, `simg2img`, `lpunpack` presentes en Fedora 44 |
| 0.2 | Instalación de librerías de reversing | `lief 1.0.0`, `capstone 5.0.7`, `keystone-engine 0.9.2`, `hexdump 3.3` vía `pip --user` |
| 0.3 | Verificación de imports y APIs críticas de LIEF 1.0 | `parse`, `patch_address`, `write`, `get_function_address`, `Section.FLAGS` — OK |

> **Nota LIEF 1.0**: la API cambió respecto a 0.x. `get_function_address`
> devuelve `lief.lief_errors.not_found` (no `None`) cuando no encuentra el
> símbolo, y `Section.flags` es un `int` plano mientras que `Section.FLAGS.*`
> es un enum: hay que normalizar con `int()`.

---

## Fase 1 — Vector A: fstab (crash @ 39 s)

| # | Acción | Resultado |
|---|---|---|
| 1.1 | Recepción de `fstab_vendor.txt` | fstab de `vendor/etc/` del A235M stock |
| 1.2 | Escritura de `fstab_patcher.py` | Filtro por token, limpia campos 4 y 5, preserva tabs |
| 1.3 | Prueba con fstab sintético | OK, salvo el doble `check,,fileencryption` del stock |
| 1.4 | Aplicación sobre el fstab real | 3 banderas eliminadas: `inlinecrypt`, `fileencryption=...`, `keydirectory=...` |
| 1.5 | **Verificación en dispositivo** | ✅ **El crash de los 39 s desaparece** |

Detalle del antes/después en `../02_Vector_A_fstab/README.md`.

---

## Fase 2 — Vector B: análisis de `libkm_compat.so`

| # | Acción | Resultado |
|---|---|---|
| 2.1 | Recepción de `libkm_compat.so` | 182 976 bytes, AArch64, ET_DYN, 25 secciones |
| 2.2 | Búsqueda de strings | 154 strings; **ninguno** con `ROT`, `SAMSUNG` ni el formato `!@` |
| 2.3 | Búsqueda de símbolos | `convertKeyParametersToLegacy` **no aparece** (es `static`) |
| 2.4 | Escaneo de constantes vendor | 1 sola constante `0x80000300` (estándar, en datos). **Ninguna ≥ 0xC0000000** |
| 2.5 | **Conclusión** | Es la build **AOSP stock**. El parche de Samsung **no está en este binario** |
| 2.6 | Mapeo por desensamblado | `convertKeyParametersToLegacy` → **`0x10b78`** (fin `0x12bec`, 8 312 bytes) |
| 2.7 | Verificación de la firma | entrada 0x28 (40 B) = `keymint::KeyParameter`; salida 0x20 (32 B) = `keymaster::V4_0::KeyParameter` |
| 2.8 | Confirmación de los llamantes | `generateKey` (0x10750), `begin` (0x149f8), `importKey` (0x13b68) |

> **Conclusión operativa**: el Vector B **no se puede aplicar** con el binario
> disponible. Hay que extraer el `libkm_compat.so` de la **ROM ZestUI**.

---

## Fase 3 — Vector C: análisis del crash @ 55 s

| # | Acción | Resultado |
|---|---|---|
| 3.1 | Recepción de `console-ramoops-0` | 261 620 bytes, **muy corrupto** (bits invertidos intercalados) |
| 3.2 | Búsqueda de `Kernel panic` / `not syncing` | **0 resultados** → no es un panic de kernel |
| 3.3 | Reconstrucción de la cola del log | WARN en `blk_cleanup_queue` **durante** el shutdown (secundario) |
| 3.4 | Identificación del servicio fallido | **`netbpfload`** (aparece como `bpfloader`/`bpBloaDer` por corrupción) |
| 3.5 | Mensaje de error clave | `netbpfload: ... requires kernel 5.4.` |
| 3.6 | Versión de kernel | `4.19.151-perf` → requisito imposible |
| 3.7 | Descripción del `.rc` | `reboot_on_failure` + `shutdown_command reboot,bootloader,failed` |
| 3.8 | Rastro del reinicio | `Got shutdown_command 'reboot,bootloader,failed'` → `S_D_Z_B_TGT= bootload-failed` |

---

## Fase 4 — Extracción del firmware stock A235M

| # | Acción | Resultado |
|---|---|---|
| 4.1 | Localización de la USB | `/dev/sdb1` (117 GB, NTFS) en `/run/media/denissierra/128GB` |
| 4.2 | Extracción de `boot.img.lz4` | Descomprimido (100 663 296 B). Nombre de build: **`SRPUL29A015`** |
| 4.3 | Parseo de la cabecera | header v2, kernel 18 180 606 B, ramdisk 810 683 B, page 4096 |
| 4.4 | Desempaquetado del ramdisk | **3 ficheros**: `fstab.default`, `init`, `dpolicy` |
| 4.5 | Lectura del fstab first-stage | **Contiene las mismas 3 banderas de cifrado** → Vector A pendiente |
| 4.6 | Extracción de `super.img.lz4` | ⚠️ **FALLO**: el fichero estaba a medio copiar a la USB → `lz4` error 26 → `lpunpack` sin geometry |
| 4.7 | Montajes `vendor`/`odm` en `/run/media` | ⚠️ **I/O error** — probable consecuencia de 4.6 |
| 4.8 | Desconexión de la USB | El móvil se conectó por USB (SAMSUNG_Android, `R58T43LK9LJ`) y provocó un reset del bus → se perdió el montaje y el árbol documental |

> **Lección**: 4.6 y 4.8 tienen la misma causa raíz. Hay que **verificar el
> tamaño del fichero antes de descomprimir** y no asumir que una copia a USB
> en curso ha terminado.

---

## Fase 5 — Documentación

| # | Acción | Resultado |
|---|---|---|
| 5.1 | Estructura de carpetas en la USB | 9 carpetas + índice |
| 5.2 | `annotate_asm.py` | Generador de `.asm` anotado (ABI, tags, switches) |
| 5.3 | Detección de bias de switch | Evita falsos positivos sobre vendor tags |
| 5.4 | `patch_init_rc_netbpfload.sh` | Parche del guardián, con backup, diff y verificación |
| 5.5 | Tests del script Vector C | ✅ Formato con llaves y sin llaves, y no toca otros servicios |
| 5.6 | Documentación Markdown | Resumen, 2 análisis de log, 3 READMEs de vector, notas técnicas, bitácora |
| 5.7 | `build_documentacion.sh` | Reconstruye el árbol completo de forma reproducible e idempotente |
| 5.8 | Reconstrucción en local | El árbol se regenera en local tras la pérdida del montaje de la USB (Fase 4.8) |

---

## Errores y trampas encontrados (para no repetirlos)

| Trampa | Detalle | Solución aplicada |
|---|---|---|
| `capstone` `skipdata` | Acceder a `.operands` de una instrucción de datos lanza `CS_ERR_SKIPDATA` | Filtrar `ins.id == 0` al desensamblar |
| Inmediatos con signo | Capstone devuelve los inmediatos en 32 bits **con signo**; `0x80000010` aparece como negativo | Enmascarar con `& 0xFFFFFFFF` |
| `b.cond` sin condición en `op_str` | `op_str` sólo trae el destino; la condición está en `ins.cc` | Usar `ins.cc != ARM64_CC_INVALID/AL` |
| `movz` alias de `mov` | Capstone renombra `movz` sin shift a `mov` | Reconstruir constantes por el inmediato de 16 bits + `movk` |
| `movk` separado del `movz` | El compilador puede separarlos (caso real: 0x10be4 / 0x10bf4) | Barrido de ventana de 20 instrucciones, parando si el registro se reescribe |
| Bias de switch ≠ vendor tag | `0xCFFFFD3F` parece vendor pero es el bias de la tabla de saltos | Detectar el patrón de dispatch completo y etiquetarlo |
| `get_function_address` | Devuelve `lief.lief_errors.not_found`, no `None` | Comprobar `isinstance(x, int)` y usar el fallback de `binary.symbols` |
| `Section.flags` vs `Section.FLAGS` | `flags` es `int`, `FLAGS.*` es enum | `int(sec.flags) & int(lief.ELF.Section.FLAGS.EXECINSTR)` |
| Doble coma en fstab | El stock trae `check,,fileencryption=` | El tokenizador descarta tokens vacíos |
| `inlinecrypt` en dos campos | Está en `mnt_flags` (4) y en `fs_mgr_flags` (5) | Limpiar ambos campos |
| `.rc` sin llaves | El bloque de un servicio puede terminar en la siguiente directiva de nivel superior | El script detecta ambos formatos |
| Rango de líneas tras parchear | Al insertar líneas, las referencias numéricas dejan de ser válidas | Recalcular el rango del bloque tras el parche |
| Fichero a medio copiar | `lz4` falla con error 26 y `lpunpack` no encuentra el geometry LP | Verificar el tamaño antes de extraer; esperar a que termine la copia |
