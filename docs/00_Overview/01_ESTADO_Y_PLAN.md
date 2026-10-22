# Estado actual y plan de trabajo

## Dónde estamos

El puerto **arranca el kernel** y **supera el primer crash**. El sistema llega
hasta la inicialización de servicios del framework (APEX, display, HALs) y
falla en un punto distinto, mucho más tarde.

```
[ ✅ ] Bootloader vencido (magiskboot, PATCHVBMETAFLAG=true)
[ ✅ ] Kernel arranca (SRPUL29A015, 4.19.151-perf)
[ ✅ ] Almacenamiento montado (UFS sda + MicroSD mmcblk0)
[ ✅ ] Crash #1 (39 s)  -> resuelto con el Vector A (fstab de vendor)
[ ⏳ ] Crash #2 (55 s)  -> Vector C (netbpfload) - script listo, falta el .rc
[ ⏳ ] Vector A pendiente sobre el fstab first-stage (FBE residual)
[ ⏳ ] Display / SELinux / HAL de luces
```

## Orden de ataque recomendado

```
  ┌─────────────────────────────────────────────────────────────┐
  │ 1. Vector C  (netbpfload)                                  │
  │    -> sin esto el dispositivo reinicia en bucle a los 55 s  │
  ├─────────────────────────────────────────────────────────────┤
  │ 2. Vector A sobre el fstab first-stage                      │
  │    -> sin esto FBE sigue activo (K00B) y el /data va en dm   │
  ├─────────────────────────────────────────────────────────────┤
  │ 3. SELinux: dominio vendor-qti-testscripts                  │
  │    -> desbloquea los "Permission denied" en cascada         │
  ├─────────────────────────────────────────────────────────────┤
  │ 4. Display: init.qti.display.sh + HAL ILights              │
  │    -> sin esto no hay imagen o la pantalla se queda negra   │
  ├─────────────────────────────────────────────────────────────┤
  │ 5. Vector B: extraer el libkm_compat.so de la ROM ZestUI    │
  │    -> requisito para poder neutralizar el check de Samsung  │
  │       si hiciera falta (el fstab puede bastar)              │
  └─────────────────────────────────────────────────────────────┘
```

> **Nota sobre la prioridad**: los pasos 1 y 2 son de una sola línea de
> parche cada uno y desbloquean el arranque. El 3 y el 4 son de política y
> empaquetado. El 5 es de investigación.

## Criterios de aceptación

Para dar el puerto por funcional, el sistema debe:

1. Sobrepasar los 60 s sin reinicio ni kernel panic.
2. Montar `/data` **sin** device-mapper (sin FBE) y sin
   `security.fbe.fail_cause` seteado.
3. Mostrar la interfaz (SurfaceFlinger + bootanim → launcher).
4. Poder instalarse una app de la Play Store y arrancar (prueba de que
   KeyMint/Keystore funciona de verdad, no sólo de arranque).

## Riesgos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| El patch de fstab deja `/data` sin cifrar | Datos del usuario en claro | Es un dispositivo de pruebas; documentado en el README del vector A |
| La `sepolicy` portada no corresponde al hardware | Denegaciones intermitentes | Usar `permissive` temporalmente para acotar, luego portar la policy |
| `netbpfload` stub deja tethering offload roto | Sin-speed USB | Irrelevante para un puerto de ROM; documentado |
| El kernel 4.19 puede no soportar algo que la ROM espera | Fallos crouched más adelante | Aislar con `early_boot` logging |

## Decisiones de diseño

- **No se sustituyen librerías de `vendor` de forma indiscriminada.** Cada
  sustitución se justifica con evidencia concreta (el log apunta a un
  fichero, no a una "familia" de librerías).
- **El `fstab` first-stage se parchea en el `boot.img`, no en el `vendor`.**
  Es donde se decide el cifrado de `/data`.
- **El análisis del ELF se hace sobre el binario exacto que se flashea.**
  El primer análisis (Vector B) demostró que el binario de la A235M es AOSP
  stock; el binario de la ROM ZestUI es el que importa.
