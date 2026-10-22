# Vector C — Neutralizar el guardián `reboot_on_failure` de `netbpfload`

**Objetivo**: evitar que un fallo no esencial de `netbpfload` (exigencia de
kernel 5.4 en un kernel 4.19) provoque el reinicio al bootloader.

**Estado**: diagnóstico **completo y verificado**; parche **pendiente de
aplicar** (falta extraer el `.rc` del `super.img`, ver §4).

---

## 1. Diagnóstico

Ver el análisis completo en `../01_Logs_Boot/ANIMALES_02_netbpfload_55s.md`.

Resumen:

```
8.788  netbpfload: ... requires kernel 5.4.                    <-- ERROR
8.781  init: Service 'netbpfload' (pid 960) exited with status 1
8.790  init: Service netbpfload has 'reboot_on_failure' option and failed, shutting down system.
8.790  init: Got shutdown_command 'reboot,bootloader,failed'
8.790  init: [PDK] S_D_Z_B_TGT= bootload-failed
8.790  init: ####Reject start. reason: reboot,bootloader-failed, reboot target: bootload-failed
```

| Dato | Valor |
|---|---|
| Kernel | `4.19.151-perf` (rama 4.19) |
| Requisito de `netbpfload` | kernel ≥ **5.4** |
| Binario | `/system/bin/netbpfload` (Qualcomm, eBPF para *tethering offload*) |
| Acción que lo dispara | `load-bpf_programs` en `/system/etc/init/hw/init.rc:1403` |
| Consecuencia | `init` → shutdown completo → `reboot,bootloader,failed` |

`netbpfload` **no es esencial para el arranque**: sólo implementa el offload de
tethering USB/Wi-Fi.

---

## 2. Dónde está la declaración del servicio

La definición del servicio `netbpfload` con `reboot_on_failure` debe estar en
alguno de estos ficheros del ROM:

| Prioridad | Ruta | Nota |
|---|---|---|
| 1 | `/system/etc/init/hw/init.rc` | Referenciado por el log (acción `load-bpf_programs` en la línea 1403) |
| 2 | `/vendor/etc/init/init.qcom.rc` | Donde QTI suele declarar los servicios de red |
| 3 | `/system/etc/init/*.rc`, `/vendor/etc/init/*.rc` | Búsqueda global |

Buscar en el ROM extraído:

```bash
grep -rn "netbpfload" system/etc/init/ vendor/etc/init/ product/etc/init/ 2>/dev/null
grep -rn "reboot_on_failure" system/etc/init/ vendor/etc/init/ 2>/dev/null
```

El resultado típico (QTI) es:

```
service netbpfload /system/bin/netbpfload
    class core
    user system
    group system
    oneshot
    onrestart restart apexd
    reboot_on_failure
    shutdown_command reboot,bootloader,failed
```

---

## 3. Opciones de parche

### Opción A — Comentar el guardián (recomendada)

```bash
./patch_init_rc_netbpfload.sh /ruta/a/system/etc/init/hw/init.rc
```

El script:
1. hace backup (`<rc>.bak`);
2. comenta `reboot_on_failure` y `shutdown_command reboot,bootloader,failed`
   **sólo dentro del bloque `service netbpfload`**;
3. **verifica** que el resto de servicios con `reboot_on_failure` quedan
   intactos;
4. muestra el diff resultante.

Ventaja: mínima superficie de cambio; el servicio sigue fallando (con un
`status 1` en el log) pero ya no tumba el arranque.

El script soporta **los dos formatos** de bloque que se dan en la práctica:
(a) terminado en `}` y (b) terminado en la siguiente directiva de nivel
superior, sin llaves.

### Opción B — Sustituir el binario por un stub

```bash
# stub: sale con 0, no hace nada
printf '#!/system/bin/sh\nexit 0\n' > netbpfload_stub
```

El servicio arrancará "correctamente" y no habrá ni un error en el log.
Desventaja: hay que reemplazar un ELF en la imagen (más complejo de empaquetar
que editar un `.rc`).

### Opción C — Kernel correcto (fuera de alcance)

Si la ROM ZestUI está pensada para un kernel 5.4, portar ese kernel al A235M
es el camino "correcto" a largo plazo, pero es un proyecto mayor.

---

## 4. Bloqueo actual: el `super.img` estaba incompleto

Al intentar extraer la partición `vendor` del firmware stock A235M:

```
$ lz4 -d super.img.lz4 super.img
Decompressed : 2117 MiB   Error 26 : LZ4F frame decoding could not complete: invalid frame
$ lpunpack super.img lp/
E lpunpack: reader.cpp:81 [liblp] Logical partition metadata has invalid geometry magic signature.
Could not read metadata from the super image file 'super.img'.
```

**Motivo**: el fichero `super.img.lz4` estaba **a medio copiar** a la USB
(1 944 113 152 bytes y creciendo durante la comprobación). Sin el bloque de
*geometry* LP al final del sparse image, `lpunpack` no puede localizar las
particiones lógicas.

**Acción pendiente**: repetir la extracción cuando la copia haya terminado.

```bash
USB=/run/media/denissierra/128GB/SM-A235M_3_20260214092611_3n72f3q1fl_fac
lz4 -d -f "$USB/super.img.lz4" super.img && \
lpunpack super.img lp/ && \
ls -la lp/
# -> system.img, system_ext.img, product.img, vendor.img, odm.img, ...
```

Una vez extraído `vendor.img` (erofs o ext4), montar y buscar:

```bash
# erofs (AOSP 14 usa erofs para vendor en algunos dispositivos)
erofsmount lp/vendor.img /mnt/vendor
grep -rn "netbpfload" /mnt/vendor/etc/init/

# o con debugfs si es ext4
debugfs -R "cat /etc/init/init.qcom.rc" lp/vendor.img 2>/dev/null | grep -A12 netbpfload
```

También el `super.img` de la **ROM ZestUI** (dentro de
`ZestUI-4.2.9-SM-A235F-S911BXXSAFZH3.zip`) es una fuente equivalente para
obtener el `.rc` tal y como queda en la ROM que se está flasheando.

---

## 5. Nota sobre `/system/etc/init/hw/init.rc`

Ese fichero (referenciado por el log en las líneas 75, 699, 702, 1403) es la
"capa hw" de init: acciones de bajo nivel que corren **antes** de que el
sistema de archivos completo esté disponible. Su contenido incluye acciones
que escriben en `sysfs` (`/sys/block/sda/queue/scheduler`) y que ejecutan
`chown`/`chmod` sobre ficheros de `/vendor` — operaciones que en un `/vendor`
de sólo lectura fallan con `Read-only file system` (ver §2.4.4 del análisis 02).
