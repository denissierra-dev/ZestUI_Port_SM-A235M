# Vector Storage — Conflicto de Almacenamiento UFS vs eMMC

## 1. El Conflicto de Hardware entre Variantes A23

La ROM portada **ZestUI 4.2.9** fue compilada originalmente para el modelo **Samsung Galaxy A23 SM-A235F**, mientras que el hardware de destino es el **SM-A235M** (ambos basados en la plataforma Qualcomm Snapdragon 680 / SM6225).

A pesar de compartir SoC, Samsung utilizó dos arquitecturas de almacenamiento distintas según la región y variante:

| Característica | Base ZestUI (SM-A235F) | Destino (SM-A235M) |
|---|---|---|
| **Tipo de memoria** | **eMMC 5.1** | **UFS 2.2 (Universal Flash Storage)** |
| **Controlador del bus** | `sdhci` (`4744000.sdhci` / `4784000.sdhci`) | `ufshc` (`4804000.ufshc`) |
| **Dispositivo de bloque** | `/dev/block/mmcblk0` | `/dev/block/sda` (LUNs `sda`, `sdb`, `sdc`...) |
| **Ruta sysfs** | `/sys/devices/platform/soc/4744000.sdhci` | `/sys/devices/platform/soc/4804000.ufshc` |
| **Ruta por nombre** | `/dev/block/bootdevice/by-name/` | `/dev/block/platform/soc/4804000.ufshc/by-name/` |

---

## 2. Síntomas del Conflicto en el Primer Intento de Booteo

Al flashear la ROM ZestUI original en el SM-A235M, el sistema entraba en un **bucle infinito de reinicios tempranos**:

```text
init: [libfs_mgr]Failed to mount /metadata: No such file or directory
init: Failed to mount /metadata: No such file or directory
init: [libfs_mgr]Failed to mount /cache: No such file or directory
io_stats: !@ device sda(8,0) added
io_stats: !@ device mmcblk0(179,0) added
Failed to write to /sys/kernel/debug/kmemleak (No such file or directory)
```

### Causa Raíz
1. **Inexistencia de `/dev/block/bootdevice` en `early-init`**:
   Android utiliza un enlace simbólico `/dev/block/bootdevice` que apunta al controlador de almacenamiento primario. En la ROM de A235F, el script `init.target.rc` esperaba la variable de entorno `${ro.boot.bootdevice}`, que el bootloader del modelo M reportaba como `4804000.ufshc`, pero la regla de `wait` y `symlink` fallaba antes de que ueventd creara los nodos de UFS.
2. **Hardcoding de eMMC en los archivos FSTAB**:
   Varios archivos de configuración montaban particiones asumiendo nombres de nodo eMMC o rutas fijas `/dev/block/by-name/`, ignorando la jerarquía SCSI de UFS (`/dev/block/sdaX`).
3. **Mapeo de `/data` (`userdata`)**:
   La entrada de `userdata` en el `fstab` requiere la opción `sysfs_path=` para que `vold` y `fs_mgr` puedan interactuar con la cola de peticiones de E/S del almacenamiento. Al faltar la ruta de UFS, el gestor de archivos no podía configurar el escalado de reloj ni las colas del disco.

---

## 3. Matriz de Correcciones Aplicadas

Para solucionar integralmente el almacenamiento, fue necesario intervenir tres capas:
1. **El Ramdisk First-Stage** (`boot.img` -> `fstab.default`).
2. **Las tablas de montaje de Vendor** (`/vendor/etc/fstab.default`, `fstab.emmc`, `charger_fstab.qti`).
3. **Los scripts de inicialización de Vendor** (`init.target.rc`, `init.samsung.bsp.rc`, `init.samsung.rc`).

### 3.1. Corrección de los FSTAB (`fstab.default` y `fstab.emmc`)

Se sustituyeron todas las rutas ambiguas o de eMMC por la ruta absoluta al bus UFS:

```diff
- /dev/block/bootdevice/by-name/metadata  /metadata  ext4  ...
+ /dev/block/platform/soc/4804000.ufshc/by-name/metadata  /metadata  ext4  ...

- /dev/block/bootdevice/by-name/cache     /cache     ext4  ...
+ /dev/block/platform/soc/4804000.ufshc/by-name/cache     /cache     ext4  ...

- /dev/block/bootdevice/by-name/userdata  /data      f2fs  ...
+ /dev/block/platform/soc/4804000.ufshc/by-name/userdata  /data      f2fs  ...,sysfs_path=/sys/devices/platform/soc/4804000.ufshc

- /dev/block/bootdevice/by-name/persist   /mnt/vendor/persist  ext4  ...
+ /dev/block/platform/soc/4804000.ufshc/by-name/persist   /mnt/vendor/persist  ext4  ...

- /dev/block/bootdevice/by-name/efs       /mnt/vendor/efs      ext4  ...
+ /dev/block/platform/soc/4804000.ufshc/by-name/efs       /mnt/vendor/efs      ext4  ...

- /dev/block/bootdevice/by-name/sec_efs   /efs                 ext4  ...
+ /dev/block/platform/soc/4804000.ufshc/by-name/sec_efs   /efs                 ext4  ...
```

### 3.2. Corrección de `charger_fstab.qti`
Utilizado durante el modo de carga apagada (off-mode charging):
```diff
- /dev/block/bootdevice/by-name/persist  /mnt/vendor/persist  ext4  ...
+ /dev/block/platform/soc/4804000.ufshc/by-name/persist  /mnt/vendor/persist  ext4  ...
```

### 3.3. Inyección del Symlink en `init.target.rc`

Para que cualquier binario o script legacy que consulte `/dev/block/bootdevice` funcione de forma transparente, se forzó la creación inmediata del symlink en la sección `on early-init`:

```text
on early-init
    symlink /dev/block/platform/soc/4804000.ufshc /dev/block/bootdevice
```

Y en la sección `on init`:
```diff
-    wait /dev/block/platform/soc/${ro.boot.bootdevice}
-    symlink /dev/block/platform/soc/${ro.boot.bootdevice} /dev/block/bootdevice
+    wait /dev/block/platform/soc/4804000.ufshc
+    symlink /dev/block/platform/soc/4804000.ufshc /dev/block/bootdevice
```

### 3.4. Corrección de Enlaces Simbólicos Propietarios de Samsung

Samsung incluye particiones propietarias de calibración y telemetría en nodos dedicados:
- **`init.samsung.bsp.rc`**:
  ```diff
  - symlink /dev/block/bootdevice/by-name/param /dev/block/param
  + symlink /dev/block/platform/soc/4804000.ufshc/by-name/param /dev/block/param
  ```
- **`init.samsung.rc`**:
  ```diff
  - symlink /dev/block/by-name/steady /dev/block/steady
  - symlink /dev/block/by-name/persistent /dev/block/persistent
  + symlink /dev/block/platform/soc/4804000.ufshc/by-name/steady /dev/block/steady
  + symlink /dev/block/platform/soc/4804000.ufshc/by-name/persistent /dev/block/persistent
  ```

---

## 4. Resultado y Verificación

Tras aplicar estos parches (tanto en el ramdisk como en la partición vendor F2FS), los logs de `pstore` confirmaron el éxito total de la inicialización de almacenamiento:

```text
Check SDcardSlot : 1
device sda(8,0) added
io_stats: write 128 to /sys/block/sda/queue/read_ahead_kb
device mmcblk0(179,0) added
```

- El kernel y `init` reconocieron inmediatamente la unidad **UFS en `/dev/block/sda`**.
- La tarjeta MicroSD fue detectada en `/dev/block/mmcblk0` sin entrar en colisión con la memoria interna.
- Las particiones `/metadata`, `/cache`, `/efs` y `/persist` se montaron limpiamente en `early-init` sin errores de I/O.
