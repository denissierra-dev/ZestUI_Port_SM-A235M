# ZestUI → SM-A235M (Snapdragon 680) — Documentación del puerto

Puerto de la ROM **ZestUI 4.2.9** (basada en One UI 8.5 / Android 16) del
Samsung Galaxy **A23 SM-A235F** a la variante **SM-A235M** (SoC Snapdragon 680
/ SM6225, UFS 2.2).

> **Objetivo de este repositorio**: documentar de forma reproducible cada
> diagnóstico y cada parche aplicado al ROM, con el razonamiento técnico, la
> evidencia extraída del dispositivo y el código fuente de las herramientas
> usadas, para que el trabajo pueda continuar o ser replicado por terceros.

---

## Índice

| Carpeta | Contenido |
|---|---|
| [`00_Overview/`](00_Overview/) | Resumen ejecutivo, estado del puerto, entorno de trabajo |
| [`01_Logs_Boot/`](01_Logs_Boot/) | Volcados de pstore/console y su análisis cronológico |
| [`02_Vector_A_fstab/`](02_Vector_A_fstab/) | Neutralización de FBE en los fstab (vendor y first-stage) |
| [`03_Vector_B_ELF/`](03_Vector_B_ELF/) | Parcheador ELF/LIEF para Keymaster |
| [`04_Vector_C_netbpfload/`](04_Vector_C_netbpfload/) | Neutralización del guardián `reboot_on_failure` |
| [`05_Assembly_ARM64/`](05_Assembly_ARM64/) | Desensamblado ARM64 anotado + notas de ABI y tags |
| [`06_Herramientas/`](06_Herramientas/) | Dependencias y entorno de reversing |
| [`07_Extraidos_STOCK_A235M/`](07_Extraidos_STOCK_A235M/) | Artefactos extraídos del firmware stock A235M |
| [`08_Bitacora/`](08_Bitacora/) | Registro cronológico de acciones y pendientes |

---

## Resumen del estado

| # | Hito | Estado | Evidencia |
|---|---|---|---|
| 0 | Bootloader (ABL) vencido con `magiskboot` nativo (`PATCHVBMETAFLAG=true`, preservando `SignerVer02` y `SRPUL29A015`) | ✅ | kernel arranca |
| 1 | Ramdisk parcheado: montaje de UFS (`sda`) y MicroSD (`mmcblk0`) OK | ✅ | `01_Logs_Boot/raw/pmsg-ramoops-0` |
| 2 | **Crash #1 @ 39 s** — `keystore2/km_compat`: `convertKeyParametersToLegacy : KM_TAG_SAMSUNG_ROT_REQUIRED` aborta `SecondStageMain` | ✅ resuelto | Vector A |
| 3 | **Crash #2 @ 55 s** — `init` reinicia a bootloader con razón `bootloader-failed` | ⏳ **pendiente** | Vector C |
| 4 | Display: `vendor_sys_qti_display` falla (`Permission denied`), HAL `ILights` no encontrado | ⏳ pendiente | §2.4 del análisis 02 |
| 5 | FBE residual: `security.fbe.fail_cause = K00B`, `inlinecrypt` sigue en las opciones de montaje | ⏳ pendiente | Vector A (fstab first-stage) |

---

## Cronología de los dos crashes

```
   t=0s          t=39s                              t=55s
    |-------------|----------------------------------|
    |  BOOT OK    |  CRASH #1                        |  CRASH #2
    |             |                                  |
    |  init/vold  |  vold pide a Keymaster la clave  |  netbpfload sale con status 1
    |  monta /data|  de cifrado por hardware         |  (kernel 4.19 < 5.4 requerido)
    |  con FBE    |  -> KM_TAG_SAMSUNG_ROT_REQUIRED  |  init: "reboot_on_failure"
    |             |  -> abort de SecondStageMain     |  -> reboot a bootloader
    |             |                                  |  -> SEC_DEBUG pantalla verde
    |             |  VECTOR A: quitar fileencryption |
    |             |  metadata_encryption keydirectory|
    |             |  inlinecrypt wrappedkey          |
```

---

## Principios de trabajo aplicados

1. **Evidencia antes que hipótesis.** Cada conclusión de este repositorio
   está respaldada por una línea literal del volcado de pstore. Cuando el log
   está corrupto (bits invertidos por el buffer de consola), se documenta
   explícitamente qué se pudo y qué no se pudo leer.
2. **Parche mínimo y localizado.** Se interviene el archivo más pequeño que
   explica el síntoma. No se sustituyen librerías completas de `vendor` sin
   evidencia de que la incompatibilidad sea de binario.
3. **Reproducibilidad.** Cada parche va acompañado del script que lo genera, de
   los ficheros original/parcheado y de sus hashes SHA-256.
4. **No se destruye el original.** Todos los ficheros se guardan con sufijo
   `_ORIGINAL` / `_PATCHED`.

---

## Regenerar el árbol documental

```bash
SRC_LOGS_DIR=/ruta/a/logs \
SRC_FSTAB=/ruta/a/fstab_vendor.txt \
SRC_KM_COMPAT=/ruta/a/libkm_compat.so \
SRC_STOCK=/ruta/a/stock_a235m \
./build_documentacion.sh --checksums
```

---

## Licencia y aviso

Trabajo de ingeniería inversa sobre dispositivos de la propia autoría del
autor, con fines personales. Los binarios analizados (`libkm_compat.so`,
`boot.img`) pertenecen a distribuciones AOSP/Samsung bajo sus respectivas
licencias (Apache-2.0 para AOSP, GPL para componentes Samsung).
