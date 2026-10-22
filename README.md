# ZestUI → SM-A235M (Snapdragon 680) — Documentación del puerto

Puerto de la ROM **ZestUI 4.2.9** (basada en One UI 8.5 / Android 16) del
Samsung Galaxy **A23 SM-A235F** a la variante **SM-A235M** (SoC Snapdragon 680
/ SM6225, almacenamiento UFS 2.2).

> **Objetivo de este repositorio**: documentar de forma reproducible cada
> diagnóstico y cada parche aplicado al ROM, con el razonamiento técnico, la
> evidencia extraída del dispositivo y el código fuente de las herramientas
> usadas, para que el trabajo pueda continuar o ser replicado por terceros.
> **Sin código propietario**: este repositorio sólo contiene scripts de herramientas,
> notas de ingeniería inversa, diffs y documentación técnica libre.

---

## Índice General

| Carpeta | Contenido |
|---|---|
| [`00_Overview/`](00_Overview/) | Resumen ejecutivo, estado del puerto, entorno de trabajo y estructura de particiones |
| [`01_Logs_Boot/`](01_Logs_Boot/) | Volcados de pstore/console y su análisis cronológico |
| [`02_Vector_A_fstab/`](02_Vector_A_fstab/) | Neutralización de FBE en los fstab (vendor y first-stage) |
| [`03_Vector_B_ELF/`](03_Vector_B_ELF/) | Parcheador ELF/LIEF para Keymaster |
| [`04_Vector_C_netbpfload/`](04_Vector_C_netbpfload/) | Neutralización del guardián `reboot_on_failure` |
| [`05_Assembly_ARM64/`](05_Assembly_ARM64/) | Desensamblado ARM64 anotado + notas de ABI y tags |
| [`06_Herramientas/`](06_Herramientas/) | Dependencias, entorno de reversing y catálogo de utilidades |
| [`07_Extraidos_STOCK_A235M/`](07_Extraidos_STOCK_A235M/) | Artefactos y metadatos extraídos del firmware stock A235M |
| [`08_Bitacora/`](08_Bitacora/) | Registro cronológico detallado de acciones y pendientes |
| [`09_Vector_0_Bootloader_ABL/`](09_Vector_0_Bootloader_ABL/) | Bypass del corte de 3 s del bootloader (ABL), preservación SEAndroid/SignerVer02 y VBMeta |
| [`10_Vector_Storage_UFS/`](10_Vector_Storage_UFS/) | Adaptación del bus de almacenamiento UFS 2.2 (`sda`) vs eMMC (`mmcblk0`) en FSTAB e init |
| [`11_Vector_Vendor_Knox_HAL/`](11_Vector_Vendor_Knox_HAL/) | Parcheador de inodos F2FS in-place, desactivación de Knox (proca, vaultkeeper) y parche HAL Keymaster |
| [`12_Packaging_Sideload_ZIP/`](12_Packaging_Sideload_ZIP/) | Pipeline sdat v4 / Brotli y actualizador in-place ultra-rápido de la ROM sideload (5.4 GB) |

---

## Resumen del Estado de Hitos

| # | Hito | Estado | Evidencia y Solución |
|---|---|---|---|
| 0 | **Corte ABL a los 3 s**: Bootloader rechazaba imágenes manuales | ✅ **Resuelto** | Pipeline nativo `magiskboot` con cabeceras Samsung (`SignerVer02`, `SRPUL29A015`) + `vbmeta` flags `0x3` ([Vector 0](09_Vector_0_Bootloader_ABL/)) |
| 1 | **Conflicto UFS vs eMMC**: Bucle temprano de reinicio por `mmcblk0` | ✅ **Resuelto** | Mapeo absoluto a `soc/4804000.ufshc`, symlinks en `init.target.rc` y `sysfs_path` UFS ([Vector Storage](10_Vector_Storage_UFS/)) |
| 2 | **Servicios Propietarios Knox en Vendor**: Bloqueos por TEE cerrado | ✅ **Resuelto** | Neutralización in-place en F2FS de `proca`, `vaultkeeper`, `fkeymaster` y HAL Keymaster 4.0 ([Vector Vendor](11_Vector_Vendor_Knox_HAL/)) |
| 3 | **Flujo de Empaquetado Sideload**: Desgaste de USB y lentitud | ✅ **Resuelto** | Herramientas `img2br.py` y actualización in-place con `update_rom_zip.py` en < 10 s ([Vector Packaging](12_Packaging_Sideload_ZIP/)) |
| 4 | **Crash #1 @ 39 s**: `keystore2/km_compat` aborta `SecondStageMain` por FBE | ✅ **Resuelto** | Neutralización de `inlinecrypt`, `fileencryption` y `keydirectory` ([Vector A](02_Vector_A_fstab/)) |
| 5 | **Crash #2 @ 55 s**: `netbpfload` falla (requiere kernel 5.4, tenemos 4.19) | ⏳ **En progreso** | Neutralización de `reboot_on_failure` en `.rc` de `/system` ([Vector C](04_Vector_C_netbpfload/)) |
| 6 | **Stack Gráfico y Display**: `vendor_sys_qti_display` y HAL `ILights` | ⏳ Pendiente | Adaptación de políticas SELinux y scripts de pantalla |

---

## Arquitectura de los Crashes del Arranque

```
  t=0s (ABL)          t=3s              t=7.1s            t=39s               t=55s
   |-------------------|-----------------|-----------------|-------------------|
   | CORTE ABL 3s      | STORAGE INIT    | CRASH METADATA  | CRASH #1          | CRASH #2
   | ABL rechaza firmas| UFS vs eMMC     | vold pide ROT   | SecondStageMain   | netbpfload status 1
   | o alineacion DTB  | No such file:   | de metadatos    | aborta por fallo  | kernel 4.19 < 5.4
   |                   | /metadata, etc. | Samsung ROT = 1 | de FBE/Keystore    | init reboot_on_failure
   |                   |                 |                 |                   | -> pantalla verde
   | SOLUCION:         | SOLUCION:       |                 | SOLUCION:         | SOLUCION:
   | magiskboot repack | soc/4804000     |                 | Vector A: fstab   | Vector C: quitar
   | + vbmeta flags 0x3| ufshc symlinks  |                 | sin flags FBE     | reboot_on_failure
   | (Vector 0)        | (Vector Storage)|                 | (Vector A)        | (Vector C)
```

---

## Principios de Trabajo Aplicados

1. **Cero código propietario.** No se distribuyen binarios ni código protegido de Samsung; todo el repositorio consiste en herramientas de ingeniería inversa, diffs, esquemas y scripts de automatización.
2. **Evidencia antes que hipótesis.** Cada conclusión técnica está respaldada por una línea literal del volcado de pstore o un desensamblado verificado.
3. **Parche mínimo y localizado.** Se interviene el componente más acotado que resuelve el síntoma sin alterar dependencias no involucradas.
4. **Reproducibilidad.** Cada intervención cuenta con su script en Python o Bash ejecutable en cualquier distribución Linux estándar.

---

## Licencia

| Componente | Licencia |
|---|---|
| Scripts y herramientas (`*.py`, `*.sh`) | **MIT** |
| Documentación técnica (`*.md`) | **CC BY-SA 4.0** |
| Referencias a especificaciones AOSP | **Apache-2.0** |

Ver `THIRD_PARTY_NOTICES.md` para detalles de atribución de componentes externos.
