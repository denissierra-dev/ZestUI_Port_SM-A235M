# Resumen Ejecutivo del Puerto ZestUI (One UI 8.5) → SM-A235M

## 1. El Problema General

Portar la ROM **ZestUI 4.2.9** (basada en Samsung One UI 8.5 / Android 16) desde su compilación base en **SM-A235F** hacia el **SM-A235M** (Snapdragon 680 / SM6225).

A pesar de que ambos dispositivos comparten procesador, existen divergencias críticas de arquitectura:
- El modelo M utiliza almacenamiento **UFS 2.2** (`soc/4804000.ufshc`, `/dev/block/sda`), mientras que la base F utilizaba **eMMC 5.1** (`4744000.sdhci`, `/dev/block/mmcblk0`).
- El bootloader (ABL) de Samsung rechaza imágenes de arranque (`boot.img`) reconstruidas sin los metadatos exactos de SEAndroid y alineaciones DTB.
- La ROM portada incluye llamadas directas al entorno seguro de TrustZone/Knox (`proca`, `vaultkeeper`, `skeymaster`), que colapsan al encontrarse el bootloader desbloqueado.
- La cadena de herramientas de Android 16 (`netbpfload`) exige kernel ≥ 5.4, cuando el dispositivo monta el kernel Qualcomm 4.19.151-perf.

Cada uno de estos obstáculos fue aislado y resuelto de forma sistemática a través de vectores independientes.

---

## 2. Mapa de Vectores de Ataque y Soluciones

### Vector 0 — Superación del Bootloader ABL (Corte a los 3 s) ✅
- **Síntoma**: Pantalla negra o reinicio fulminante a los 3 segundos en el primer splash screen de Samsung; registros de pstore completamente vacíos.
- **Causa Raíz**: El ABL verifica la firma `SignerVer02`, la tabla de compatibilidad DTB de `qcom,sm6225` y el bloque `AVB0`. Al alterar el ramdisk manualmente, el cambio en el tamaño de compresión gzip invalidaba los offsets esperados por el bootloader.
- **Solución**: Empleo del pipeline nativo de `magiskboot` (`KEEPVERITY=false`, `dtb patch`, `PATCHVBMETAFLAG=true repack`) preservando las cabeceras `SRPUL29A015` de Samsung y generando una imagen `vbmeta` con flags `0x3` (`AVB_DISABLED`).
- **Detalle**: Ver [`09_Vector_0_Bootloader_ABL/`](../09_Vector_0_Bootloader_ABL/).

### Vector Storage — Mapeo de Almacenamiento UFS 2.2 ✅
- **Síntoma**: Reinicios en bucle temprano en `early-init` con errores de `[libfs_mgr] Failed to mount /metadata: No such file or directory` y fallos al ubicar `/data` y `/cache`.
- **Causa Raíz**: ZestUI intentaba montar sobre nodos eMMC `/dev/block/bootdevice/by-name/...` que no existían porque el hardware monta sobre SCSI `/dev/block/sda` (`soc/4804000.ufshc`).
- **Solución**:
  - Sustitución de rutas en `fstab.default`, `fstab.emmc` y `charger_fstab.qti` apuntando directamente a `soc/4804000.ufshc`.
  - Inyección de symlink `soc/4804000.ufshc -> /dev/block/bootdevice` en la sección `on early-init` de `init.target.rc`.
  - Redirección de enlaces simbólicos de telemetría Samsung (`param`, `steady`, `persistent`) en `init.samsung.bsp.rc` e `init.samsung.rc`.
- **Detalle**: Ver [`10_Vector_Storage_UFS/`](../10_Vector_Storage_UFS/).

### Vector Vendor — Parcheo F2FS y Neutralización de Knox ✅
- **Síntoma**: Colapso o bloqueo de `init` al arrancar los daemons de seguridad de TrustZone (`proca`, `vaultkeeper`) y fallo del servicio HAL `keymaster@4.0`.
- **Causa Raíz**:
  - `vendor.img` está formateado en F2FS solo lectura con sumas de comprobación de inodos (`F2FS_FEATURE_INODE_CHKSUM`), impidiendo montajes loop convencionales.
  - El HAL `android.hardware.keymaster@4.0-service` dependía de `libskeymaster4device.so` (propietario de Knox).
- **Solución**:
  - Creación de `patch_vendor.py` para modificar inodos F2FS directamente sin montar ni requerir permisos root.
  - Desactivación de `proca` en `pa_daemon_qsee.rc` y vaciado de manifiestos VINTF para `vaultkeeper` y `fkeymaster`.
  - Parcheo binario ELF del HAL de Keymaster para redirigir `DT_NEEDED` a `libkeymaster4.so` (AOSP puro) y NOP de Control Flow Integrity (`bl __cfi_slowpath`).
- **Detalle**: Ver [`11_Vector_Vendor_Knox_HAL/`](../11_Vector_Vendor_Knox_HAL/).

### Vector Packaging — Pipeline de Actualización In-Place ✅
- **Síntoma**: Flashing lento (5-10 minutos por prueba) y desgaste excesivo de la unidad flash USB al regenerar el zip completo de 5.4 GB.
- **Solución**:
  - Herramientas `br_sdat.py` e `img2br.py` para conversión bidireccional entre imágenes crudas y Sparse Data Brotli `.new.dat.br`.
  - Script `update_rom_zip.py` que realiza actualización in-place de entradas `STORED` (`boot.img`, `vbmeta.img`, `updater-script`) y truncado/apéndice de `vendor.new.dat.br` en menos de 10 segundos.
- **Detalle**: Ver [`12_Packaging_Sideload_ZIP/`](../12_Packaging_Sideload_ZIP/).

### Vector A — FBE / Keymaster (Crash @ 39 s) ✅
- **Síntoma**: `keystore2/km_compat: !@ convertKeyParametersToLegacy : KM_TAG_SAMSUNG_ROT_REQUIRED = 1` y posterior colapso de `SecondStageMain`.
- **Causa Raíz**: `/data` declaraba opciones de cifrado hardware (`inlinecrypt`, `fileencryption`, `keydirectory=/metadata/vold/metadata_encryption`). Al fallar el TEE de Knox, `vold` aborta al solicitar la clave de metadatos.
- **Solución**: Eliminación de banderas de cifrado en los archivos fstab (vendor y first-stage) mediante `fstab_patcher.py`.
- **Detalle**: Ver [`02_Vector_A_fstab/`](../02_Vector_A_fstab/).

### Vector C — `netbpfload` (Crash @ 55 s) ⏳
- **Síntoma**: Reinicio forzado al bootloader con pantalla verde de `sec_debug` y razón `bootloader-failed`.
- **Causa Raíz**: `/system/bin/netbpfload` aborta con status 1 porque el kernel del A23 es 4.19 y el binario de Android 16 exige kernel ≥ 5.4. Como el `.rc` tiene la directiva `reboot_on_failure`, `init` mata el sistema.
- **Solución en Curso**: Neutralización de `reboot_on_failure` en el `.rc` o sustitución de `netbpfload` por un stub.
- **Detalle**: Ver [`04_Vector_C_netbpfload/`](../04_Vector_C_netbpfload/).
