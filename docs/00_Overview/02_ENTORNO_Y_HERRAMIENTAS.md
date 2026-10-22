# Entorno de trabajo

## Hardware de referencia

| Rol | Dispositivo | Detalles |
|---|---|---|
| **Origen** | Samsung Galaxy A23 **SM-A235F** | SoC Exynos 1280 (o el homólogo de la ROM ZestUI) |
| **Destino** | Samsung Galaxy A23 **SM-A235M** | Snapdragon 680 (SM6225), UFS 2.2 |
| **Kernel** | `SRPUL29A015` | 4.19.151-perf, rama 4.19 |
| **Bootloader** | `BL_A235MUBSFEZB1_...REV00_user_low_ship_MULTI_CERT` | Vencido con `magiskboot` |
| **Base de la ROM** | ZestUI 4.2.9 `SM-A235F-S911BXXSAFZH3` | One UI 8.5 / Android 16 |

## Host de trabajo

| Elemento | Valor |
|---|---|
| SO | Fedora 44 (kernel 7.2.10) |
| Python | 3.14.8 |
| pip | 26.0.1 |
| Plataforma | x86_64 (análisis de binarios ARM64 vía emulación de herramientas, no de CPU) |

## Almacenamiento de trabajo

| Ruta | Contenido |
|---|---|
| `~/Port_A23/` | Scripts de reversing, staging de la documentación |
| `~/pstore_logs/` | `pmsg-ramoops-0` (crash @ 39 s) |
| `~/pstore_logs2/` | `console-ramoops-0` (crash @ 55 s) |
| `/tmp/opencode/` | Scratch: extracción de imágenes, tests sintéticos |
| USB `128GB` | Firmware stock A235M, ROM ZestUI, `rom_sideload.zip` |

## Cómo extraer pstore del dispositivo

El buffer de pstore vive en `/sys/fs/pstore/` tras un panic o reinicio:

```bash
adb pull /sys/fs/pstore/pmsg-ramoops-0 .
adb pull /sys/fs/pstore/console-ramoops-0 .
```

> **Advertencia**: el buffer de consola de pstore se lee con **bits
> invertidos intercalados** (artefacto del buffer de ring de la consola en
> esta plataforma). Las cadenas legibles se recuperan con `strings` y hay que
> reconstruir mentalmente el intercalado. Los ficheros de pstore son
> **binarios**, no texto: hay que forzar `-a` con `grep` o usar `strings`.

## Almacenamiento en la USB

La USB (`/dev/sdb1`, 117 GB, NTFS, etiqueta `128GB`) se monta en:

```
/run/media/denissierra/128GB
```

Contiene el firmware stock A235M, la ROM ZestUI y el árbol documental de este
proyecto.

> ⚠️ **NTFS + `fuseblk`**: el montaje puede perdererse si hay un reset del bus
> USB (por ejemplo, al conectar el móvil en modo fastboot/Odin). Rebuild
> siempre en local y sincroniza después con `build_documentacion.sh`.

## Dispositivo en modo fastboot

```bash
fastboot devices
fastboot flash boot boot_patched.img
fastboot flash vbmeta vbmeta_patched.img
fastboot reboot
```
