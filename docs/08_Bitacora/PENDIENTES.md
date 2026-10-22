# Pendientes

Lista accionable de lo que falta para completar el puerto. Ordenada por
bloqueante → secundario.

---

## P0 — Bloqueantes (impiden que el sistema arranque)

### P0.1 · Vector C: neutralizar `netbpfload` ⏳

**Estado**: diagnóstico completo, script listo, **falta el fichero `.rc`**.

- [ ] Reintentar la extracción de `super.img.lz4` **cuando la copia a la USB
      haya terminado** (el fichero estaba a medio copiar: crecía de 801 MB a
      1.94 GB durante la comprobación).
- [ ] `lpunpack super.img lp/` → extraer `vendor.img`
- [ ] Montar `vendor.img` y localizar el `.rc`:
      ```bash
      grep -rn "netbpfload" /mnt/vendor/etc/init/
      ```
      Candidatos: `/system/etc/init/hw/init.rc`,
      `/vendor/etc/init/init.qcom.rc`
- [ ] Aplicar:
      ```bash
      ./04_Vector_C_netbpfload/patch_init_rc_netbpfload.sh <rc>
      ```
- [ ] Reempaquetar y flashear. **Verificar que el reinicio a bootloader ha
      desaparecido.**

**Alternativa si no se localiza el `.rc`**: sustituir
`/system/bin/netbpfload` por un stub que salga con 0.

---

### P0.2 · Vector A: parchar el fstab first-stage ⏳

**Estado**: parche generado (`02_Vector_A_fstab/fstab_first_stage_PATCHED.txt`),
**falta aplicarlo y reempaquetar el ramdisk**.

- [ ] Reconstruir el ramdisk del `boot.img`:
      ```bash
      lz4 -d boot.img.lz4 boot.img
      # extraer ramdisk (offset = page_size + kernel_size redondeado a page_size)
      zcat ramdisk.img | cpio -idmv
      cp fstab_first_stage_PATCHED.txt fstab.default
      # reempaquetar
      find . | cpio -o -H newc | gzip > ../ramdisk_new.img
      # reempaquetar el boot.img (header v2)
      ```
- [ ] Reflashear `boot.img`.
- [ ] **Verificar** que desaparecen:
      - `init: FBE will be enabled!`
      - `voldUtils: PROP : security.fbe.fail_cause : ... K00B`
      - el `inlinecrypt` en las opciones de montaje de `/data`
      - el dispositivo device-mapper `dm-49` para `/data`

---

## P1 — Alta prioridad (el sistema arranca pero algo falla)

### P1.1 · Display: `vendor_sys_qti_display` ⏳

```
init: Command 'start vendor_sys_qti_display' action=post-fs-data
    (/product/etc/init/init.qti.display.rc:17) took 0ms and failed:
    could not start service: Cannot find '/product/bin/init.qti.display.sh' Permission denied
```

- [ ] Verificar si `/product/bin/init.qti.display.sh` existe en la ROM ZestUI
- [ ] Comparar con el `/product` del A235M stock
- [ ] Comprobar contexto SELinux y permisos:
      ```bash
      ls -lZ /product/bin/init.qti.display.sh
      ```
- [ ] Si falta, extraerlo del `/product` de la A235F

### P1.2 · SELinux: dominio `vendor-qti-testscripts` inexistente ⏳

```
init: cannot setexeccon('u:r:vendor-qti-testscripts:s0') ... Invalid argument
```

- [ ] Confirmar en qué `sepolicy` está el dominio:
      ```bash
      grep -rn "vendor-qti-testscripts" system/etc/selinux/ vendor/etc/selinux/
      ```
- [ ] Si falta en la policy, portar el tipo o eliminar el `setexeccon` del `.rc`

### P1.3 · HAL de luces `ILights` ausente ⏳

- [ ] Verificar el registro del servicio en `vendor/etc/vintf/`
      (`android.hardware.light.ILights/default`)
- [ ] Comprobar que el binario del HAL existe y arranca

### P1.4 · `/vendor` de sólo lectura con `chmod` en runtime ⏳

- [ ] Localizar la acción en el `.rc` y decidir: sellar `/vendor` con el
      contenido correcto, o quitar la acción

---

## P2 — Vector B: obtener el binario correcto ⏳

**El `libkm_compat.so` analizado es AOSP stock.** Para que el Vector B sea
aplicable hace falta el de la ROM ZestUI.

- [ ] Extraer `system.img` de `ZestUI-4.2.9-SM-A235F-S911BXXSAFZH3.zip`
- [ ] Extraer `libkm_compat.so` de ahí
- [ ] Ejecutar:
      ```bash
      python3 elf_patcher.py libkm_compat_ZestUI.so --scan
      ```
- [ ] Identificar el valor de `KM_TAG_SAMSUNG_ROT_REQUIRED`
- [ ] Diagnóstico y parche:
      ```bash
      python3 elf_patcher.py libkm_compat_ZestUI.so --tag 0x<VALOR>
      python3 elf_patcher.py libkm_compat_ZestUI.so --tag 0x<VALOR> --apply -o out.so
      ```

> Si la ROM ZestUI **no** lleva el parche en `km_compat` sino en otro
> binario (p.ej. `libpuresoftkeymasterdevice.so`), hay que buscar en toda la
> partición `system`:
> ```bash
> grep -rl "ROT_REQUIRED" <system_extraido>/
> ```

---

## P3 — Calidad / documentación

- [ ] Reextraer `super.img` completo y archivar `vendor.img` / `system.img`
      en `07_Extraidos_STOCK_A235M/`
- [ ] Añadir el `.rc` parcheado real a `04_Vector_C_netbpfload/`
- [ ] Desensamblado anotado de `netbpfload` (requiere el binario)
- [ ] Desensamblado de la función de Samsung que realmente emite el log
      `!@ convertKeyParametersToLegacy : KM_TAG_SAMSUNG_ROT_REQUIRED`
- [ ] Registrar en la bitácora el resultado de cada prueba en dispositivo
- [ ] Considerar `selinux=permissive` como prueba diagnóstica temporal
      (cmdline del kernel: `androidboot.selinux=permissive`) para confirmar
      si los fallos "Permission denied" son de policy o de binario
