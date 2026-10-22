# Estado Actual y Plan de Trabajo

## 1. Dónde Estamos

El puerto ha superado los tres bloqueos más críticos de la capa baja del sistema (Bootloader, Almacenamiento y Servicios de Seguridad/Knox) y el primer crash del espacio de usuario:

```
[ ✅ ] Vector 0: Bootloader vencido (magiskboot repack, SEAndroid/SignerVer02 preservado, vbmeta flags 0x3)
[ ✅ ] Kernel arranca estable (SRPUL29A015, 4.19.151-perf)
[ ✅ ] Vector Storage: Almacenamiento UFS 2.2 mapeado (soc/4804000.ufshc -> sda, MicroSD -> mmcblk0)
[ ✅ ] Vector Vendor: Partición F2FS parcheada in-place (proca, vaultkeeper, fkeymaster desactivados)
[ ✅ ] Vector HAL: Keymaster 4.0 parcheado en ELF (enlazado a libkeymaster4.so AOSP, CFI neutralizado)
[ ✅ ] Vector Packaging: Pipeline de actualización rápida in-place de rom_sideload.zip (< 10 s)
[ ✅ ] Crash #1 (39 s): Resuelto con el Vector A (neutralización de banderas FBE en fstab de vendor y ramdisk)
[ ⏳ ] Crash #2 (55 s): Vector C (netbpfload requiere kernel 5.4 vs 4.19) - script de neutralización listo
[ ⏳ ] Vector A pendiente sobre el fstab first-stage (FBE residual / format data en recovery)
[ ⏳ ] Display / SELinux / HAL de luces (vendor_sys_qti_display)
```

---

## 2. Cronología de Hitos de Booteo

```
 t=0s           t=3s             t=7.1s           t=39s            t=55s
  |--------------|----------------|----------------|----------------|
  | [✅ Vector 0]| [✅ Storage]   | [✅ Vendor]    | [✅ Vector A]  | [⏳ Vector C]
  | ABL Acepta   | UFS montado    | HAL Keymaster  | FBE desactivado| netbpfload
  | boot.img     | sda(8,0) OK    | AOSP iniciado  | /data monta    | reboot_on_failure
  | magiskboot   | mmcblk0 OK     | Knox bypass    | sin deadlock   | -> PENDIENTE
```

---

## 3. Orden de Ataque Recomendado

```
  ┌─────────────────────────────────────────────────────────────┐
  │ 1. Vector C (netbpfload)                                    │
  │    -> Neutralizar 'reboot_on_failure' en init.rc de /system │
  │    -> Esto elimina el reinicio forzado a los 55 segundos     │
  ├─────────────────────────────────────────────────────────────┤
  │ 2. Limpieza completa de FBE en First-Stage                  │
  │    -> Asegurar que /data se monte sin cifrado residual      │
  │    -> Ejecutar 'Format Data' en TWRP para tabla limpia      │
  ├─────────────────────────────────────────────────────────────┤
  │ 3. SELinux: Dominio vendor-qti-testscripts                  │
  │    -> Desbloquea denegaciones 'Permission denied' en cascada│
  ├─────────────────────────────────────────────────────────────┤
  │ 4. Stack de Pantalla: init.qti.display.sh + HAL ILights     │
  │    -> Permitir que SurfaceFlinger inicie bootanimation      │
  └─────────────────────────────────────────────────────────────┘
```

---

## 4. Criterios de Aceptación para Éxito Completo

1. **Estabilidad temporal**: Superar los 60 segundos continuos sin reinicio espontáneo ni kernel panic.
2. **Espacio de usuario operativo**: Montaje limpio de `/data` sin device-mapper FBE.
3. **Servicios gráficos**: Arranque de SurfaceFlinger y visualización de la animación de inicio (Bootanimation) o Launcher de One UI 8.5.
4. **Almacenamiento masivo**: Acceso de lectura/escritura a memoria interna y tarjeta SD.

---

## 5. Matriz de Riesgos y Mitigaciones

| Riesgo | Impacto | Mitigación |
|---|---|---|
| `/data` sin cifrar | Datos de usuario en texto plano | Aceptable en fase de porting / testing; documentado |
| Discrepancia de Kernel eBPF (4.19 vs 5.4) | Servicios de red como tethering pueden fallar | Neutralizar guardián para permitir arranque del resto del sistema |
| SELinux Enforcing bloquea nuevos HALs | Servicios mueren en silencio | Usar modo `permissive` durante el diagnóstico inicial |
| Fallo en reempaquetado de boot | Corte de 3 segundos de ABL | Utilizar estrictamente el pipeline de `build_boot_magisk.sh` |
