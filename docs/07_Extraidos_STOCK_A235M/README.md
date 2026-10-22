# Artefactos extraídos del firmware stock SM-A235M

Fuente: `SM-A235M_3_20260214092611_3n72f3q1fl_fac` (firmware oficial, fechado
2026-02-14), presente en la USB.

| Fichero en la USB | Tamaño | Contenido |
|---|---|---|
| `boot.img.lz4` | 19 391 928 | Kernel + ramdisk first-stage (**SRPUL29A015**) |
| `recovery.img.lz4` | 30 032 571 | Recovery |
| `super.img.lz4` | ~2 GB | Particiones lógicas (system, vendor, product, odm, system_ext) |
| `BL_...tar.md5` | 68 823 153 | Bootloader (ABL) |
| `AP_...tar.md5` | ~2.5 GB | Paquete de firmware completo |

## Extraído

| Artefacto | Descripción |
|---|---|
| `boot_ramdisk/fstab.default` | **fstab first-stage** — el que monta `/data` en la primera etapa |
| `boot_ramdisk/init` | `init` de primera etapa (ELF AArch64 estático, con `fs_mgr`/`libavb`/`liblp` embebidos) |
| `boot_ramdisk/dpolicy` | Policy de dalvik de Samsung |
| `boot_ramdisk/kernel.img` | Imagen del kernel (sin comprimir) |
| `boot_header.txt` | Cabecera del boot image parseada |
| `parse_bootimg.py` | El parser usado (reproducible) |

## Boot image — cabecera

```
magic        : b'ANDROID!'
header_ver   : 2
kernel_size  : 0x11569fe (18180606)
ramdisk_size : 0xc5ebb (810683)
second_size  : 0x0
page_size    : 4096
name         : 'SRPUL29A015'
```

### Cmdline del kernel

```
console=null androidboot.hardware=qcom androidboot.memcg=1
lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000
msm_rtb.filter=0x237 service_locator.enable=1
androidboot.usbcontroller=4e00000.dwc3 swiotlb=2048 loop.max_part=7
cgroup.memory=nokmem,nosocket
firmware_class.path=/vendor/firmware_mnt/image printk.devkmsg=on
```

Observaciones relevantes para el puerto:

- `androidboot.selinux=permissive` **no está** → la policy se aplica en modo
  enforcing, lo que hace que los "Permission denied" sean duros.
- `printk.devkmsg=on` → explica el volumen de salida en `console-ramoops-0`.
- `androidboot.hardware=qcom` → plataforma Qualcomm (QTI), coherente con
  `netbpfload` y con el stack de display QTI.

## Ramdisk — contenido

Sólo 3 ficheros (ramdisk mínimo de primera etapa):

```
./dpolicy
./fstab.default
./init
```

### `fstab.default` — línea de `/data` relevante

```
/dev/block/bootdevice/by-name/userdata	/data	f2fs	noatime,nosuid,nodev,discard,usrquota,grpquota,fsync_mode=nobarrier,reserve_root=32768,resgid=5678,inlinecrypt	latemount,wait,check,,fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized,quota,reservedsize=128M,checkpoint=fs,keydirectory=/metadata/vold/metadata_encryption
```

Contiene las **mismas tres banderas** de cifrado que el fstab de `vendor`:
`inlinecrypt` (campo 4), `fileencryption=` y `keydirectory=` (campo 5). Además
trae un `check,,fileencryption=` con doble coma heredado del stock.

**Éste es el motivo de que FBE siguiera activo tras el Vector A.**

Parcheado en `../02_Vector_A_fstab/fstab_first_stage_PATCHED.txt`:

```
/dev/block/bootdevice/by-name/userdata	/data	f2fs	noatime,nosuid,nodev,discard,usrquota,grpquota,fsync_mode=nobarrier,reserve_root=32768,resgid=5678	latemount,wait,check,quota,reservedsize=128M,checkpoint=fs
```

## Cómo reproducir la extracción

```bash
lz4 -d boot.img.lz4 boot.img
python3 parse_bootimg.py boot.img unpacked     # -> kernel.img, ramdisk.img
mkdir ramdisk && cd ramdisk
zcat ../unpacked/ramdisk.img | cpio -idmv
```

## Pendiente: `super.img`

La extracción de `super.img.lz4` falló porque el fichero estaba a medio copiar
a la USB (ver `../04_Vector_C_netbpfload/README.md` §4). Cuando la copia esté
completa:

```bash
lz4 -d -f super.img.lz4 super.img
lpunpack super.img lp/
```

`super_vendor/` está preparado para alojar el `vendor.img` resultante y su
`.rc` parcheado.
