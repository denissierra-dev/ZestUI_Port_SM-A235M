# Análisis 02 — Crash @ 55 s: `netbpfload` → `reboot_on_failure`

**Fuente**: `raw/console-ramoops-0` (261 620 bytes, pstore ramoops)
**Vector**: C (init.rc)
**Estado**: pendiente de aplicación

---

## 2.1 No hay kernel panic

Búsqueda exhaustiva sobre el volcado completo:

```bash
strings -a console-ramoops-0 | grep -iE "Kernel panic|not syncing|BUG:|Oops|Unable to handle|Fatal exception"
# -> 0 resultados
```

Lo único que aparece es un **WARN durante el apagado**:

```
WARNING: CPU: 5 PID: 2 at block/blk-core.c:1153 blk_cleanup_queue+0x1f4/0x208
Call trace:
 blk_cleanup_queue+0x1f4/0x208
 mmc_blk_shutdown+0x74/0x88
 mmc_bus_shutdown+0x44/0x88
 device_shutdown+0x2e0/0x1f8
 kernel_restart+0x8/0x18
 arm64_sys_reboot+0x138/0x20
 el0_svc_common
 el0_svc_handler
 el0_svc
```

La traza incluye `kernel_restart` y `arm64_sys_reboot`: este WARN ocurre
**durante** la secuencia de reinicio, no la causa. Es un bug de Samsung en el
teardown de eMMC y es **benigno**.

La "pantalla verde" que ve el usuario **no es un panic**: es el modo descarga /
debug de `sec_debug`, que se arma antes de reiniciar:

```
sec_debug:set_debug_udl_mode()
set_dl_mode()
sec_debug:set_qc_dload_magic()
sec_log_buf:register_tore(...)
reboot: Restarting system with command 'bootloader'
Going down for restart now
sec_debug:update_restart_reason() reboot cid : "bootloader-failed"
```

---

## 2.2 La causa raíz

### El detonante

Reconstrucción cronológica (los nombres del log están corruptos por
intercalado de bits; el servicio `netbpfload` aparece como `bpfloader`,
`b`bloader`, `bpBloaDer`, `netb`floa``):

```
8.744  init: processing action (post-fs-data) from /vendor/etc/init/vendor.samsung.hardware.tlc...
8.746  init: processing action (post-fs-data) from /vendor/etc/init/wifi.rc:2
8.750  init: Command 'chown system:system /vendor/etc/init/...rc' ... failed:
               chmod() failed: Read-only file system
8.762  init: processing action (load-bpf_programs) from (/system/etc/init/hw/init.rc:1403)
8.761  init: starting service 'netbpfload'...
8.764  init: started service 'netbpfload' has pid 960
8.769  init: SVC_EXEC service 'netbpfload' pid 960 (u:r:su:s0, gid 0+6 context default) started
8.780  netbpfload: NetBpfLoad2 NetBpfNoa. v0.47(.../libnetBpfD.so) (64-bit AArch64) libBpf: ...
8.780  netbpfload: ... Tethering offload version 360743300
8.788  netbpfload: ... requires kernel 5.4.                   <<<<< ERROR
8.788  qsecom: qsecom_unload_app: app (10) is unloaded
8.781  init: Service 'netbpfload' (pid 960) exited with status 1
8.789  init: Sending SIGKILL to service 'netbpfload' (pid 960)
8.790  init: Service netbpfload has 'reboot_on_failure' option and failed, shutting down system.
8.790  init: Got shutdown_command 'reboot,bootloader,failed'
8.790  init: [PDK] S_D_Z_B_TGT= bootload-failed
8.790  init: ####Reject start. reason: reboot,bootloader-failed, reboot target: bootload-failed
```

### Por qué el kernel no cumple

| Dato | Valor |
|---|---|
| Kernel del A23 | `4.19.151-perf` (`4.19.157-perf-26940246` en el string de build) |
| Requisito de `netbpfload` | **kernel ≥ 5.4** (soporte eBPF/BTF) |
| Binario | `/system/bin/netbpfload` (Qualcomm, *tethering offload* con eBPF) |

`netbpfload` es un cargador de programas eBPF para el offload de tethering
(USB/Wi-Fi). Requiere un kernel con las funciones eBPF de 5.4. El kernel
stock del A23 es de la rama 4.19 → **el requisito no se puede cumplir**.

### Por qué eso tumba el arranque

El guardián de QTI en el `.rc` es:

```
service netbpfload /system/bin/netbpfload
    ...
    reboot_on_failure
    shutdown_command reboot,bootloader,failed
```

La lógica de `init` es: si un servicio con `reboot_on_failure` termina con
código distinto de 0, se dispara `shutdown_command` → `reboot,bootloader,failed`
→ reinicio al bootloader con la razón `bootloader-failed`.

El guardián asume que un fallo de `netbpfload` implica **kernel incompatible**
y que lo correcto es flashear otro kernel. En un puerto de ROM eso es un
**falso positivo**: el kernel 4.19 es el correcto para el A23, lo que falla es
que el servicio de la ROM asume 5.4.

---

## 2.3 La solución

Tres opciones, de menor a mayor invasividad. Detalle y script en
`../04_Vector_C_netbpfload/`.

| Opción | Qué hace | Riesgo |
|---|---|---|
| **A** (recomendada) | Comentar `reboot_on_failure` y `shutdown_command` en el `.rc` del servicio | Bajo: el servicio sigue fallando, pero no mata el arranque |
| **B** | Sustituir `/system/bin/netbpfload` por un stub que salga con 0 | Bajo: se pierde el offload de tethering (irrelevante para un puerto de ROM) |
| **C** | Usar el kernel que la ROM espera (5.4) | Alto: fuera de alcance del puerto actual |

---

## 2.4 Problemas secundarios detectados en el mismo volcado

Ya visibles y que saltarán en cuanto se resuelva el Vector C. Se documentan
aquí para no perderlos.

### 2.4.1 Display — `vendor_sys_qti_display` falla

```
8.760  init: Command 'start vendor_sys_qti_display' action=post-fs-data
               (/product/etc/init/init.qti.display.rc:17) took 0ms and failed:
               could not start service: Cannot find '/product/bin/init.qti.display.sh' Permission denied
```

Candidato a pantalla negra o bootanim congelado. El error combina "Cannot
find" con "Permission denied": en `init`, el mensaje de fallo de `exec()`
puede ser `ENOENT` **o** `EACCES`. Junto con el siguiente punto, la causa más
probable es **SELinux**.

### 2.4.2 SELinux — dominio inexistente

```
6.60   init: cannot setexeccon('u:r:vendor-qti-testscripts:s0')
               for exec 5 (/vendor/bin/sh -c /vendor/bin/init.qti.ufs.debug.sh): Invalid argument
```

`EINVAL` al hacer `setexeccon` significa que el **dominio no existe en la
policy** cargada. La `sepolicy` portada desde la A235F referencia contextos que
no están en la del A235M, o viceversa. Es el síntoma raíz de varios fallos
"Permission denied" simultáneos.

### 2.4.3 HAL de luces ausente

```
servicemanager: Caller(pid=968,uid=1000,sid=u:r:blank_screen:s0) Tried to start aidl service
    android.hardware.light.ILights/default as a lazy service, but was unable to
    ... or the service is not installed, but if the service is intended to be used as
    a lazy service, then it is misconfigured in android.hardware.light.ILights/default
init: Sending SIGTERM to service 'blank_screen' (pid 868)
```

`blank_screen` (servicio Samsung que mantiene la pantalla en negro durante el
boot) no consigue el HAL de luces. Misma familia de problema que 2.4.1/2.4.2.

### 2.4.4 `/vendor` de sólo lectura

```
8.750  init: Command 'chown system:system /vendor/etc/init/android.hardware.wifi@1.1-service.rc'
               ... failed: chmod() failed: Read-only file system
```

El `.rc` de la ROM intenta modificar `/vendor` en runtime. `/vendor` es de
sólo lectura por diseño (se sella en el flasheo). Bug de empaquetado del
puerto: hay que sellar `/vendor` con el contenido correcto o quitar esa
acción del `.rc`.

### 2.4.5 Escritura en sysfs

```
init: Command 'write /sys/block/sda/queue/scheduler ...' action=early-fs
    (/system/etc/init/hw/init.rc:699) took 0ms and failed:
    Unable to write to file 'sys/block/sda/queue/scheduler': ...
```

Mismo patrón: acción de un `.rc` que escribe en sysfs. Generalmente inocuo.

### 2.4.6 FBE residual (ver §1.5 del análisis 01)

`security.fbe.fail_cause = K00B` + `inlinecrypt` en las opciones de montaje de
`/data` + `/data` sobre `dm-49`. **Causa**: el fstab first-stage no fue
parcheado. Solución en el Vector A.

---

## 2.5 Mapa de responsabilidades por fichero

Del volcado se deduce dónde vive cada cosa:

| Ruta en el ROM | Contenido relevante |
|---|---|
| `/system/etc/init/hw/init.rc` | Acciones `load-bpf_programs` (línea 1403), `early-fs` (699), `post-fs` (75), `perform_apex_config` |
| `/system/etc/init/init.rc` | Referenciado en las acciones de `apex_config` |
| `/product/etc/init/init.qti.display.rc` | Acción `start vendor_sys_qti_display` (línea 17) |
| `/product/bin/init.qti.display.sh` | Script de inicialización de display QTI — **permisos/contexto** |
| `/vendor/etc/init/wifi.rc` | Acción `post-fs-data` (línea 2) |
| `/vendor/etc/init/vendor.samsung.hardware.tlc...rc` | Acción `post-fs-data` (línea 10) |
| `/system/bin/netbpfload` | Servicio que falla (Vector C) |
| `/vendor/bin/init.qti.ufs.debug.sh` | Falla por `setexeccon` (Vector D, pendiente) |
