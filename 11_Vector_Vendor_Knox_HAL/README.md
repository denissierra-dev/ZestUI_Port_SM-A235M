# Vector Vendor — Parcheo In-Place de F2FS y Neutralización de Knox / HAL

## 1. El Reto: Manipulación de la Partición `vendor.img` en F2FS

En la ROM ZestUI, la partición `vendor.img` está formateada con el sistema de archivos **F2FS** de última generación, incorporando características de integridad avanzadas:
- `F2FS_FEATURE_RO` (Solo lectura estricta).
- `F2FS_FEATURE_INODE_CHKSUM` (Sumas de verificación en cada inodo para detectar manipulaciones).

### El problema de las herramientas convencionales
Montar la imagen con `mount -o loop,rw` en Linux exige permisos de `root` y a menudo el driver de kernel de la máquina anfitriona altera marcas de tiempo o flags del superbloque F2FS, haciendo que el `fs_mgr` de Android rechace el montaje durante el arranque por inconsistencia de metadatos.

Para resolver esto sin necesidad de privilegios elevados ni riesgo de corrupción, se diseñó **`patch_vendor.py`**, una herramienta en Python puro que parsea e interviene los inodos del sistema de archivos F2FS a nivel de byte.

---

## 2. Motor de Parcheo Quirúrgico de Inodos F2FS

La estructura de un inodo F2FS (`struct f2fs_inode`, 4096 bytes por bloque de inodo) se divide en dos tipos de almacenamiento según el tamaño del archivo:

```
[ Bloque de Inodo F2FS: 4096 bytes ]
├── 0x00..0x04 : i_mode, i_advise, i_inline
├── 0x10..0x18 : i_size (tamaño en bytes, uint64_t)
├── 0x58..0x5C : i_namelen (longitud del nombre de archivo)
├── 0x5C..name : i_name (nombre de archivo)
├── 0x168      : extra_isize (si i_inline & 0x20)
└── data_start :
    ├── Si i_inline & 0x02: Datos embebidos directamente en el inodo (hasta ~3.6 KB)
    └── Si i_inline & 0x00: Punteros a bloques de datos addrs[] (bloques directos)
```

`patch_vendor.py` implementa:
- `read_f2fs_inode(f, ino_blk)`: Detecta automáticamente si el archivo es inline o indexado por bloques y reconstruye los bytes exactos.
- `write_f2fs_inode(f, ino_blk, new_data)`: Escribe los nuevos datos respetando la alineación de bloques, actualiza `i_size` y limpia los bytes residuales con ceros para no alterar la estructura del árbol de inodos.

---

## 3. Neutralización de Daemons Propietarios de Samsung Knox

Al correr en un entorno porteado con bootloader abierto, las dependencias de hardware de Samsung Knox / TrustZone (TEE) quedan inoperativas. Si los servicios del framework intentan invocar estos componentes durante el arranque, se producen bloqueos por timeout o kernel panics:

### 3.1. Neutralización de `proca` (Process Authenticator)
- **Fichero**: `/vendor/etc/init/pa_daemon_qsee.rc` (Inodo bloque 9365)
- **Función**: Verifica la integridad y firmas de binarios en memoria a través de Qualcomm QSEE TrustZone.
- **Parche**: Se comenta la invocación para evitar que el demonio bloquee el inicio del framework:
  ```diff
  -    start proca
  +    #start proca
  ```

### 3.2. Neutralización de `vaultkeeper`
- **Ficheros**:
  - `/vendor/etc/init/vaultkeeper_common.rc` (Inodo bloque 9371)
  - `/vendor/etc/vintf/manifest/vaultkeeper_manifest.xml` (Inodo bloque 9605)
- **Función**: Servicio de almacenamiento encriptado respaldado por Knox (`ISehVaultKeeper`).
- **Parche**: Se desactivan los servicios `vaultkeeper` y `vaultkeeper_hal`, y se vacía el XML de registro en el Compatibility Matrix de VINTF para que el Service Manager no espere el HAL.

### 3.3. Neutralización de `fkeymaster`
- **Ficheros**:
  - `/vendor/etc/init/vendor.samsung.hardware.security.fkeymaster-service.rc` (Inodo bloque 9396)
  - `/vendor/etc/vintf/manifest/vendor.samsung.hardware.security.fkeymaster-service.xml` (Inodo bloque 9612)
- **Función**: HAL AIDL propietario de Samsung para gestión rápida de claves.
- **Parche**: Se añade la directiva `disabled` al servicio y se vacía la entrada VINTF.

### 3.4. Sanitización de Keystore en `vendor/build.prop`
- **Fichero**: `/vendor/build.prop` (Inodo bloque 3590)
- **Parche**:
  ```diff
  - ro.security.keystore.keytype=sakv2,gak,
  + ro.security.keystore.keytype=
  ```
  Esto evita que el Keystore de Android busque las claves hardware `SAK` (Samsung Attestation Key) y `GAK`.

---

## 4. Parcheo Binario del HAL `android.hardware.keymaster@4.0-service`

El binario del HAL de Keymaster en `/vendor/bin/hw/android.hardware.keymaster@4.0-service` (Inodo bloque 3930, 15,992 bytes, ARM64) venía compilado originalmente por Samsung para depender de su propia implementación de TrustZone:

```
[ android.hardware.keymaster@4.0-service ]
     │
     └── (DT_NEEDED) -> libskeymaster4device.so
                             │
                             └── invoca CreateSKeymasterDevice()
                                      │
                                      └── busca TEE de Knox -> DEADLOCK
```

Para forzar al HAL a utilizar el backend estándar de código abierto de AOSP (`libkeymaster4.so`) sin necesidad de recompilar la ROM completa desde código fuente, se aplicó ingeniería inversa sobre el binario ELF:

### 4.1. Redirección de la Dependencia Dinámica (`DT_NEEDED`)
- En la tabla de secciones dinámicas (offset `0x30b0`), se modificó la entrada `DT_NEEDED` (índice 8) para que en lugar de cargar `libskeymaster4device.so` apunte al string de `libkeymaster4.so`.

### 4.2. Reemplazo del Símbolo en la Tabla de Símbolos (`dynstr` / `dynsym`)
- Se reescribió el símbolo importado en el offset `0x70b` por el nombre mangled de la función constructora estándar de AOSP:
  ```text
  _ZN9keymaster4V4_02ng21CreateKeymasterDeviceEN7android8hardware9keymaster4V4_013SecurityLevelE\x00
  ```
- Se reubicó la entrada `__cfi_slowpath\0` y se ajustó el índice en `dynsym[8].st_name` (offset `0x3b8`) para mantener la alineación estricta del ELF.

### 4.3. Desactivación de Control Flow Integrity (CFI)
Debido a que el compilador Clang incluye comprobaciones de integridad de flujo de control (CFI) en llamadas a métodos indirectos, la redirección hacia una biblioteca compartida distinta disparaba un aborto inmediato en `__cfi_slowpath`.
- **Offset en el binario**: `0x10fc`
- **Instrucción original**: `bl __cfi_slowpath` (`b0 03 00 94`)
- **Instrucción parcheada**: `nop` (`1f 20 03 d5`)

---

## 5. El Script de Automatización: `patch_vendor.py`

Todo el proceso descrito se ejecuta de manera 100% reproducible y desatendida mediante el script [`patch_vendor.py`](patch_vendor.py), el cual procesa la imagen cruda `vendor.img` en cuestión de milisegundos.
