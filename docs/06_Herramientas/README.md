# Entorno de herramientas

## Dependencias Python

```bash
pip3 install lief capstone keystone-engine hexdump
```

| Paquete | Versión verificada | Uso |
|---|---|---|
| `lief` | 1.0.0 | Parsing y parcheo de ELF |
| `capstone` | 5.0.7 | Desensamblado ARM64 |
| `keystone-engine` | 0.9.2 | Ensamblado ARM64 (parches, stubs) |
| `hexdump` | 3.3 | Inspección de bloques binarios |

Verificación:

```bash
python3 -c "import lief, capstone, keystone, hexdump; \
print(lief.__version__, capstone.__version__, keystone.__version__)"
```

## Herramientas de sistema (Fedora)

| Herramienta | Uso |
|---|---|
| `lz4` | Descomprimir `*.img.lz4` (boot, super, vendor) |
| `cpio` | Desempaquetar/reempaquetar el ramdisk (`-H newc`) |
| `simg2img` | Convertir sparse image → raw |
| `lpunpack` | Desempaquetar las particiones lógicas de `super.img` |
| `erofsmount` | Montar imágenes erofs (AOSP 14) |
| `debugfs` | Leer ficheros de imágenes ext4 |
| `magiskboot` | Parcheado de boot images (vínculo con el bootloader) |

## Notas de compatibilidad de LIEF 1.x

Diferencias respecto a LIEF 0.x que afectaron al desarrollo:

| Comportamiento | En LIEF 1.x | Cómo se resolvió |
|---|---|---|
| `get_function_address()` si no existe | Devuelve `lief.lief_errors.not_found` (no `None`) | Comprobar `isinstance(x, int)` y usar fallback a `binary.symbols` |
| `Section.flags` | `int` plano | `int(sec.flags) & int(lief.ELF.Section.FLAGS.EXECINSTR)` |
| `Segment.flags` | Objeto `FLAGS` | `seg.flags & lief.ELF.Segment.FLAGS.X` (funciona directo) |
| `Section.FLAGS.EXECINSTR` | Enum → `int(...)` = 4 | Normalizar siempre con `int()` |
| `binary.write()` | Escribe el binario parcheado | Verificado con round-trip |

## Notas de compatibilidad de Capstone 5.x

| Comportamiento | Detalle |
|---|---|
| Inmediatos con signo | `op.imm` es de 32 bits **con signo**: enmascarar con `& 0xFFFFFFFF` |
| `movz` → `mov` | Capstone renombra `movz` sin shift a `mov` (pero `movk` conserva su ID) |
| `b.cond` | La condición **no** está en `op_str`; está en `ins.cc` |
| `skipdata` | Las instrucciones de datos tienen `id == 0` y lanzan `CS_ERR_SKIPDATA` al acceder a `.operands` |
| `movk` con shift | `op.shift.value` = 0/16/32/48 |

## Notas de compatibilidad de Keystone

| Comportamiento | Detalle |
|---|---|
| Saltos relativos | Hay que pasar `addr=` a `ks.asm()` para que calcule el offset correcto |
| Inmediatos grandes | `mov w1, #0x80000010` **no** compila (excede 16 bits): usar `movz`+`movk` |
| `ldr` literal | La sintaxis `ldr w1, [pc, #N]` no compila; la forma admitida es `ldr w1, 0x<addr>` |
