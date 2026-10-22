# Pendientes y Tareas Accionables

Lista accionable de las tareas restantes para completar el puerto de ZestUI (One UI 8.5) en SM-A235M.

---

## P0 — Bloqueantes (impiden que el sistema continúe el arranque)

### P0.1 · Vector C: Neutralizar `netbpfload` (Crash @ 55 s) ⏳

**Estado**: Diagnóstico completado, script de parcheo listo, falta aplicar sobre `/system`.

- [ ] Montar o extraer `/system` (`system.new.dat.br` mediante `br_sdat.py`).
- [ ] Localizar la declaración del servicio `netbpfload` en `/system/etc/init/hw/init.rc` (o en su `.rc` correspondiente).
- [ ] Aplicar el script de neutralización:
      ```bash
      ./04_Vector_C_netbpfload/patch_init_rc_netbpfload.sh <ruta_a_init.rc>
      ```
      *Acción*: Remueve `reboot_on_failure` y `shutdown_command reboot,bootloader,failed`.
- [ ] Alternativa directa: Sustituir `/system/bin/netbpfload` por un script/stub ELF que retorne `exit 0`.
- [ ] Reempaquetar y verificar en dispositivo que el reinicio forzado a los 55 s con pantalla verde ha desaparecido.

---

### P0.2 · Vector A: Aplicar fstab sin FBE en First-Stage (Ramdisk) ⏳

**Estado**: Parche de fstab generado (`fstab_first_stage_PATCHED.txt`).

> ⚠️ **ADVERTENCIA CRÍTICA**: No reempaquetar el ramdisk manualmente con `gzip` y `mkbootimg` genérico. El bootloader (ABL) de Samsung detectará la alteración en el offset del DTB o el padding SEAndroid y provocará el corte de 3 segundos (ver [`09_Vector_0_Bootloader_ABL/`](../09_Vector_0_Bootloader_ABL/)).

- [ ] Utilizar el pipeline nativo de `magiskboot` para inyectar el fstab sin cifrado:
      ```bash
      ./09_Vector_0_Bootloader_ABL/build_boot_magisk.sh boot.img fstab_first_stage_PATCHED.txt boot_port_A235M.img vbmeta_disabled_A235M.img
      ```
- [ ] Flashear en el dispositivo y realizar `Format Data` (Wipe -> Format Data -> 'yes') en TWRP para asegurar que `/data` quede sin estructuras FBE residuales.
- [ ] Verificar que desaparecen:
      - `init: FBE will be enabled!`
      - `voldUtils: PROP : security.fbe.fail_cause : ... K00B`
      - El flag `inlinecrypt` en el montaje de `/data`.

---

## P1 — Alta Prioridad (Subida del Framework y Gráficos)

### P1.1 · Display: `vendor_sys_qti_display` ⏳

```text
init: Command 'start vendor_sys_qti_display' action=post-fs-data
    (/product/etc/init/init.qti.display.rc:17) took 0ms and failed:
    could not start service: Cannot find '/product/bin/init.qti.display.sh' Permission denied
```

- [ ] Verificar si `/product/bin/init.qti.display.sh` existe físicamente o si `/product` está montado como symlink en `/system/product`.
- [ ] Comprobar contexto SELinux y permisos de ejecución:
      ```bash
      ls -lZ /product/bin/init.qti.display.sh
      ```
- [ ] Si falta el script, portar la versión correspondiente de la variante Qualcomm SM6225.

### P1.2 · SELinux: Dominio `vendor-qti-testscripts` ⏳

```text
init: cannot setexeccon('u:r:vendor-qti-testscripts:s0') ... Invalid argument
```

- [ ] Confirmar qué archivo `.te` define el dominio en `vendor/etc/selinux/` o `system/etc/selinux/`.
- [ ] Si falta en la política de la ROM portada, añadir la regla o retirar la directiva `setexeccon` del script `.rc` involucrado.
- [ ] Probar arranque con `androidboot.selinux=permissive` en el cmdline del kernel para aislar bloqueos de políticas.

### P1.3 · HAL de Luces (`android.hardware.light.ILights`) ⏳

- [ ] Verificar el registro del HAL en `/vendor/etc/vintf/manifest.xml`.
- [ ] Confirmar que el binario `/vendor/bin/hw/android.hardware.lights-service.qti` arranque y responda por Binder/HwBinder.

---

## P2 — Calidad y Verificación

- [ ] Probar la instalación completa de la ROM mediante TWRP y validar que `rom_sideload.zip` se instale limpiamente sin errores de partición.
- [ ] Verificar que SurfaceFlinger inicie y muestre la animación de arranque de One UI 8.5.
- [ ] Registrar en `08_Bitacora/BITACORA.md` los logs y tiempos de booteo de cada prueba subsiguiente.
