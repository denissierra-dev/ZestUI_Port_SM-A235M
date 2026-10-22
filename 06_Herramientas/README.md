# Entorno de herramientas y Scripts

## 1. Inventario de Scripts y Herramientas del Proyecto

Todos los scripts desarrollados para este proyecto son de código abierto (Licencia MIT) y no contienen código propietario ni binarios cerrados:

| Script | Ubicación | Descripción |
|---|---|---|
| `patch_vendor.py` | [`11_Vector_Vendor_Knox_HAL/`](../11_Vector_Vendor_Knox_HAL/) | Parcheador de inodos F2FS in-place (modifica tablas fstab, `.rc` y binarios ELF dentro de `vendor.img` sin root). |
| `build_boot_magisk.sh` | [`09_Vector_0_Bootloader_ABL/`](../09_Vector_0_Bootloader_ABL/) | Pipeline automatizado de `magiskboot` para saltar el corte de 3 segundos del ABL y desactivar AVB en `vbmeta`. |
| `fstab_patcher.py` | [`02_Vector_A_fstab/`](../02_Vector_A_fstab/) | Tokenizador y neutralizador de banderas de cifrado FBE (`inlinecrypt`, `fileencryption`, `keydirectory`). |
| `img2br.py` | [`12_Packaging_Sideload_ZIP/`](../12_Packaging_Sideload_ZIP/) | Compresor streaming de imagen de disco a formato Sparse Data Brotli (`.new.dat.br`). |
| `br_sdat.py` | [`12_Packaging_Sideload_ZIP/`](../12_Packaging_Sideload_ZIP/) | Descompresor y extractor de paquetes sdat v4 / Brotli hacia imagen cruda (`.img`). |
| `update_rom_zip.py` | [`12_Packaging_Sideload_ZIP/`](../12_Packaging_Sideload_ZIP/) | Actualizador in-place a nivel de cabecera ZIP para flasheos rápidos sin recomprimir 5.4 GB. |
| `parse_bootimg.py` | Raíz del repo | Parser e inspector de cabeceras Android Boot v2 (`SRPUL29A015`). |
| `annotate_asm.py` | [`05_Assembly_ARM64/`](../05_Assembly_ARM64/) | Desensamblador ARM64 anotado para análisis de saltos y tags de Keymaster. |
| `elf_patcher.py` | [`03_Vector_B_ELF/`](../03_Vector_B_ELF/) | Parcheador de constantes y saltos condicionales ELF mediante LIEF y Capstone. |
| `patch_init_rc_netbpfload.sh` | [`04_Vector_C_netbpfload/`](../04_Vector_C_netbpfload/) | Parcheador del guardián `reboot_on_failure` en scripts de inicialización. |

---

## 2. Dependencias Python

```bash
pip3 install lief capstone keystone-engine hexdump
```

| Paquete | Versión verificada | Uso |
|---|---|---|
| `lief` | 1.0.0 | Parsing y parcheo de binarios ELF |
| `capstone` | 5.0.7 | Desensamblado y decodificación ARM64 |
| `keystone-engine` | 0.9.2 | Ensamblado ARM64 (instrucciones y stubs) |
| `hexdump` | 3.3 | Inspección visual de bloques binarios |

Verificación rápida del entorno:
```bash
python3 -c "import lief, capstone, keystone, hexdump; \
print('LIEF:', lief.__version__, '| Capstone:', capstone.__version__, '| Keystone:', keystone.__version__)"
```

---

## 3. Bibliotecas Compartidas del Sistema (Linux / Fedora)

Para la compresión y descompresión de streams Brotli a alta velocidad en `img2br.py` y `br_sdat.py`, se utilizan las bibliotecas compartidas nativas del sistema operativo a través de `ctypes`:
- `/usr/lib64/libbrotlidec.so.1`
- `/usr/lib64/libbrotlienc.so.1`

Instalación en Fedora si no están presentes:
```bash
sudo dnf install libbrotli brotli
```

---

## 4. Herramientas de Sistema

| Herramienta | Uso en el puerto |
|---|---|
| `magiskboot` | Desempaquetado y reensamblado nativo de boot.img (SEAndroid, SignerVer02) |
| `lz4` | Descompresión de archivos de firmware oficial (`boot.img.lz4`, etc.) |
| `cpio` | Manipulación de archivos de ramdisk (`ramdisk.cpio`) |
| `simg2img` | Conversión de imágenes Android sparse a imágenes raw |
| `lpunpack` | Desempaquetado de particiones dinámicas dentro de `super.img` |

---

## 5. Notas de Compatibilidad de LIEF 1.x

Diferencias críticas respecto a LIEF 0.x aplicadas en los scripts:

| Comportamiento | En LIEF 1.x | Cómo se resolvió |
|---|---|---|
| `get_function_address()` si no existe | Devuelve `lief.lief_errors.not_found` (no `None`) | Comprobar `isinstance(x, int)` y usar fallback a `binary.symbols` |
| `Section.flags` | `int` plano | `int(sec.flags) & int(lief.ELF.Section.FLAGS.EXECINSTR)` |
| `Segment.flags` | Objeto `FLAGS` | `seg.flags & lief.ELF.Segment.FLAGS.X` (funciona directo) |
| `Section.FLAGS.EXECINSTR` | Enum → `int(...)` = 4 | Normalizar siempre con `int()` |
| `binary.write()` | Escribe el binario parcheado | Verificado con round-trip |

---

## 6. Notas de Compatibilidad de Capstone 5.x y Keystone

| Comportamiento | Detalle |
|---|---|
| Inmediatos con signo | `op.imm` es de 32 bits **con signo**: enmascarar con `& 0xFFFFFFFF` |
| `movz` → `mov` | Capstone renombra `movz` sin shift a `mov` (pero `movk` conserva su ID) |
| `b.cond` | La condición **no** está en `op_str`; se extrae de `ins.cc` |
| `skipdata` | Las instrucciones de datos tienen `id == 0` y lanzan `CS_ERR_SKIPDATA` al acceder a `.operands` |
| Keystone saltos relativos | Pasar `addr=` a `ks.asm()` para que calcule el offset relativo correcto |
| Inmediatos grandes | `mov w1, #0x80000010` no compila directo: usar combinación `movz` + `movk` |
