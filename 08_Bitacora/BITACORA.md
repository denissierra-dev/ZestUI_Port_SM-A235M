# Bitácora del Puerto ZestUI → SM-A235M

Registro cronológico exhaustivo de las acciones realizadas, con el razonamiento técnico y el resultado de cada una. Para el estado y mapa de tareas, ver [`../00_Overview/01_ESTADO_Y_PLAN.md`](../00_Overview/01_ESTADO_Y_PLAN.md).

---

## Fase 0 — Preparación del Entorno

| # | Acción | Resultado |
|---|---|---|
| 0.1 | Inventario de herramientas disponibles | `lz4`, `cpio`, `simg2img`, `lpunpack` presentes en Fedora |
| 0.2 | Instalación de librerías de reversing | `lief 1.0.0`, `capstone 5.0.7`, `keystone-engine 0.9.2`, `hexdump 3.3` vía `pip` |
| 0.3 | Verificación de APIs críticas de LIEF 1.0 | `parse`, `patch_address`, `write`, `get_function_address`, `Section.FLAGS` — OK |

---

## Fase 1 — Vector A: fstab (Crash @ 39 s)

| # | Acción | Resultado |
|---|---|---|
| 1.1 | Recepción de `fstab_vendor.txt` | fstab de `vendor/etc/` del A235M stock |
| 1.2 | Escritura de `fstab_patcher.py` | Filtro por token, limpia campos 4 y 5, preserva tabs |
| 1.3 | Prueba con fstab sintético | OK, salvo el doble `check,,fileencryption` del stock |
| 1.4 | Aplicación sobre el fstab real | 3 banderas eliminadas: `inlinecrypt`, `fileencryption=...`, `keydirectory=...` |
| 1.5 | **Verificación en dispositivo** | ✅ **El crash de los 39 s desaparece** |

---

## Fase 2 — Vector B: Análisis de `libkm_compat.so`

| # | Acción | Resultado |
|---|---|---|
| 2.1 | Recepción de `libkm_compat.so` | 182 976 bytes, AArch64, ET_DYN, 25 secciones |
| 2.2 | Búsqueda de strings | 154 strings; **ninguno** con `ROT`, `SAMSUNG` ni formato `!@` |
| 2.3 | Búsqueda de símbolos | `convertKeyParametersToLegacy` **no aparece** (es `static`) |
| 2.4 | Escaneo de constantes vendor | 1 sola constante `0x80000300` (estándar, en datos). **Ninguna ≥ 0xC0000000** |
| 2.5 | **Conclusión** | Es la build **AOSP stock**. El parche de Samsung **no está en este binario** |
| 2.6 | Mapeo por desensamblado | `convertKeyParametersToLegacy` → `0x10b78` (fin `0x12bec`, 8 312 bytes) |
| 2.7 | Verificación de firma | entrada 0x28 (40 B) = `KeyParameter`; salida 0x20 (32 B) = `V4_0::KeyParameter` |

---

## Fase 3 — Vector C: Análisis del Crash @ 55 s

| # | Acción | Resultado |
|---|---|---|
| 3.1 | Recepción de `console-ramoops-0` | 261 620 bytes, con secciones de bits invertidos |
| 3.2 | Búsqueda de `Kernel panic` | **0 resultados** → no es un kernel panic |
| 3.3 | Identificación del servicio fallido | **`netbpfload`** (cargador eBPF tethering) |
| 3.4 | Mensaje de error clave | `netbpfload: ... requires kernel 5.4.` |
| 3.5 | Versión de kernel del A23 | `4.19.151-perf` → requisito imposible para el binario de Android 16 |
| 3.6 | Rastro del reinicio | `Got shutdown_command 'reboot,bootloader,failed'` → `S_D_Z_B_TGT= bootload-failed` |

---

## Fase 4 — Extracción del Firmware Stock A235M

| # | Acción | Resultado |
|---|---|---|
| 4.1 | Localización de la unidad USB | `/run/media/denissierra/128GB` |
| 4.2 | Extracción de `boot.img.lz4` | Descomprimido (100 663 296 B). Build: **`SRPUL29A015`** |
| 4.3 | Parseo de cabecera | header v2, kernel 18 180 606 B, ramdisk 810 683 B, page 4096 |
| 4.4 | Desempaquetado del ramdisk | `fstab.default`, `init`, `dpolicy` |
| 4.5 | Lectura del fstab first-stage | Contiene las mismas 3 banderas de cifrado que vendor |

---

## Fase 5 — Vector 0: Superación del Corte de 3 Segundos del ABL

| # | Acción | Resultado |
|---|---|---|
| 5.1 | Flasheo de `boot.img` reconstruido artesanalmente | ❌ **Corte de energía / reinicio inmediato a los 3 s en logo Samsung** |
| 5.2 | Prueba de aislamiento con `boot.img` 100% stock | ✅ **Supera los 3 s con éxito** (mantiene logo por >40 s) |
| 5.3 | Análisis de cabeceras propietarias de Samsung | Detección del bloque `SignerVer02`, metadatos `SRPUL29A015`, hash AVB0 y alineación de DTB |
| 5.4 | Intento de reempaquetador Python (`build_perfect_boot.py`) | ❌ ABL detecta variación en offsets o stream gzip del ramdisk y aborta |
| 5.5 | **Implementación del pipeline nativo `magiskboot`** | `KEEPVERITY=false`, `dtb patch`, `PATCHVBMETAFLAG=true repack` |
| 5.6 | Generación de `vbmeta_disabled_A235M.img` | 65,536 bytes, flags cambiados a `0x3` (`AVB_DISABLED`) |
| 5.7 | **Verificación en hardware** | ✅ **Corte de 3 segundos eliminado al 100%**. Kernel carga completamente |

---

## Fase 6 — Vector Storage: Mapeo UFS 2.2 (`soc/4804000.ufshc`)

| # | Acción | Resultado |
|---|---|---|
| 6.1 | Detección de bucle infinito en early-init | Errores `Failed to mount /metadata: No such file or directory` |
| 6.2 | Análisis de bus de almacenamiento | SM-A235F usa eMMC (`4744000.sdhci`, `mmcblk0`); SM-A235M usa UFS (`4804000.ufshc`, `sda`) |
| 6.3 | Adaptación de rutas FSTAB | Corrección en `fstab.default`, `fstab.emmc` y `charger_fstab.qti` apuntando a `soc/4804000.ufshc` |
| 6.4 | Adición de parámetro sysfs | Inyección de `,sysfs_path=/sys/devices/platform/soc/4804000.ufshc` en entrada `/data` |
| 6.5 | Inyección de symlink en `init.target.rc` | Creación forzada en `early-init` de `soc/4804000.ufshc -> /dev/block/bootdevice` |
| 6.6 | Corrección de enlaces propietarios | Redirección de symlinks `param`, `steady` y `persistent` hacia UFS |
| 6.7 | **Verificación por pstore** | ✅ `device sda(8,0) added` y `device mmcblk0(179,0) added`. Montaje UFS exitoso |

---

## Fase 7 — Vector Vendor: Parcheo F2FS y Neutralización de Knox

| # | Acción | Resultado |
|---|---|---|
| 7.1 | Análisis de la partición `vendor.img` | F2FS con flags `RO` e `INODE_CHKSUM`. Montaje loop convencional riesgoso |
| 7.2 | Creación de `patch_vendor.py` | Motor en Python para leer y escribir inodos F2FS inline y directos sin root |
| 7.3 | Desactivación de `proca` | Invocación comentada en `pa_daemon_qsee.rc` (`#start proca`) |
| 7.4 | Neutralización de `vaultkeeper` | Daemons desactivados en `vaultkeeper_common.rc` y manifiesto VINTF vaciado |
| 7.5 | Neutralización de `fkeymaster` | Servicio forzado a `disabled` y manifiesto VINTF vaciado |
| 7.6 | Sanitización de `build.prop` | Supresión de tokens propietarios `sakv2,gak,` en `ro.security.keystore.keytype=` |
| 7.7 | Parcheo binario de `keymaster@4.0-service` | Redirección de `DT_NEEDED` a `libkeymaster4.so` AOSP y reemplazo de `CreateSKeymasterDevice` |
| 7.8 | Neutralización de CFI | NOP de `bl __cfi_slowpath` en offset `0x10fc` |

---

## Fase 8 — Vector Packaging: Actualizador In-Place de la ROM

| # | Acción | Resultado |
|---|---|---|
| 8.1 | Desarrollo de `br_sdat.py` | Descompresor y extractor de paquetes Brotli sdat v4 a imagen cruda vía `ctypes` |
| 8.2 | Desarrollo de `img2br.py` | Compresor streaming de imagen modificada a Sparse Data Brotli `.new.dat.br` (calidad 5) |
| 8.3 | Desarrollo de `update_rom_zip.py` | Actualización in-place en `rom_sideload.zip` (5.4 GB): actualiza `boot.img`, `vbmeta.img`, `updater-script` y `vendor.new.dat.br` en <10 s |

---

## Resumen de Trampas Superadas

| Trampa | Causa | Solución |
|---|---|---|
| Corte de 3 segundos en logo | ABL rechaza hashes o alineaciones de imágenes reconstruidas con Python | Usar pipeline nativo de `magiskboot` con cabeceras stock |
| `No such file or directory` en `/metadata` | FSTAB buscaba `/dev/block/bootdevice/by-name/` antes de que existiera el enlace eMMC | Symlink temprano a `soc/4804000.ufshc` en `on early-init` |
| Corrupción de `vendor.img` en montajes loop | El kernel anfitrión altera marcas de tiempo en F2FS con checksums de inodo | Modificar inodos directamente con `patch_vendor.py` |
| Aborto CFI en Keymaster HAL | Clang aborta por llamada indirecta no autorizada tras redirigir `DT_NEEDED` | NOP (`1f 20 03 d5`) sobre `bl __cfi_slowpath` |
| Lentitud extrema de reempaquetado ZIP | Recomprimir 5.4 GB toma 8-10 minutos por prueba | Reemplazo in-place de entradas `STORED` y truncado de cola |
