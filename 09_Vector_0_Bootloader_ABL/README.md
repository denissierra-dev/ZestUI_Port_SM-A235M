# Vector 0 — Superación del Bloqueo del Bootloader (ABL) de Samsung

## 1. El Problema: El Reinicio Prematuro a los 3 Segundos

Al flashear los primeros reempaquetados de la partición de arranque (`boot.img`) sobre el **Samsung Galaxy A23 (SM-A235M)**, el teléfono presentaba un síntoma desconcertante:
- Encendido de pantalla con el primer splash screen de Samsung.
- **Corte brusco de energía y reinicio a los 3 segundos exactos**.
- Al reiniciar en TWRP para inspeccionar los registros en `/sys/fs/pstore/` (`console-ramoops-0` o `pmsg-ramoops-0`), el directorio estaba **completamente vacío**.
- La propiedad `ro.boot.bootreason` no registraba ningún panic de Linux ni volcado de memoria.

### Diagnóstico de Aislamiento
El hecho de que el pstore estuviera vacío y el corte ocurriera a los 3 segundos indicaba que **el kernel de Linux ni siquiera llegaba a inicializarse**. El apagado era ejecutado de forma prematura por el propio gestor de arranque de Samsung (**ABL - Android Bootloader**).

Para confirmar esta hipótesis, se flasheó el `boot.img` 100% stock extraído del firmware oficial del `SM-A235M` (`A235MUBSFEZB1`, nombre de compilación `SRPUL29A015`). El resultado fue contundente:
- Con el boot stock, el teléfono superó la marca de los 3 segundos y permaneció en el splash screen por más de 40 segundos hasta alcanzar los procesos de espacio de usuario.
- Esto demostró que el hardware y el bootloader estaban intactos: el ABL rechazaba de manera activa la cabecera o la estructura del `boot.img` modificado.

---

## 2. Anatomía de la Verificación del ABL de Samsung

Los dispositivos Samsung con procesador Qualcomm Snapdragon 680 (SM6225) y cabecera de arranque Android Boot v2 poseen capas adicionales de verificación de integridad en el ABL, incluso con el bootloader desbloqueado (`androidboot.verifiedbootstate=orange`):

```
+-------------------------------------------------------------+
| Header v2 (PAGESIZE=4096, MAGIC='ANDROID!', NAME='SRPU...') |
+-------------------------------------------------------------+
| Kernel (gzip compressed stream, ~18.1 MB)                  |
+-------------------------------------------------------------+
| Ramdisk (gzip compressed stream, ~810 KB)                  |
+-------------------------------------------------------------+
| DTB (Device Tree Blob table, 332,550 bytes)                 |
+-------------------------------------------------------------+
| SEAndroid Header: 'SEANDROIDENFORCE'                        |
+-------------------------------------------------------------+
| Bloque SignerVer02 (Metadatos de compilación Samsung)        |
+-------------------------------------------------------------+
| Bloque AVB0 (Android Verified Boot Footer, 4096 bytes)      |
+-------------------------------------------------------------+
```

### Por qué fallaban los reempaquetadores manuales
Al reconstruir el `boot.img` mediante scripts en Python o herramientas genéricas (`mkbootimg` estándar):
1. **Compresión Gzip / Offsets de DTB**: Alterar un solo archivo en el ramdisk varía el tamaño del flujo comprimido gzip. El ABL de Samsung verifica la alineación de página exacta de los saltos entre Kernel, Ramdisk y la tabla DTB (`qcom,sm6225`). Si el offset o el padding a 4096 bytes difiere de la tabla de descriptores de Samsung, el ABL asume corrupción del bloque de arranque y dispara el watchdog de 3 segundos.
2. **El Bloque `SignerVer02`**:
   Samsung añade inmediatamente después del DTB una cabecera de firma propietaria:
   - Cadena mágica: `SignerVer02`
   - Parámetros de clave: `SM-A235M_LA_TPA_QKEY2`
   - Identificador de compilación: `A235MUBSFEZB1`
   - Timestamp de firma: `20260207012819`
   - Flags del proyecto: `SRPUL29A015`
3. **Descriptor AVB0 embebido**:
   Al final del archivo de imagen (offset `0x01271000` en la imagen de ~96 MB), existe una estructura `AVB0` con el hash SHA-256 precalculado de la imagen anterior a la firma.

---

## 3. La Solución: El Pipeline Nativo de `magiskboot`

En lugar de reconstruir artesanalmente las estructuras de firma y arriesgar inconsistencias de alineación, se utilizó la arquitectura nativa de **`magiskboot`** (el motor de bajo nivel de Magisk). 

`magiskboot` está diseñado específicamente para reconocer, desarmar y reensamblar cabeceras de Samsung SEAndroid, preservando la compatibilidad con el ABL.

### Pipeline de Construcción Paso a Paso

1. **Desempaquetar el `boot.img` Stock del SM-A235M**:
   ```bash
   ./magiskboot unpack boot.img
   ```
   Esto extrae:
   - `kernel`: Binario comprimido del kernel stock 4.19.151-perf.
   - `ramdisk.cpio`: Archivo CPIO de primera etapa (`dpolicy`, `fstab.default`, `init`).
   - `dtb`: Árbol de dispositivos aplanado del hardware SM6225.

2. **Parchear el Ramdisk (CPIO) In-Place**:
   Se configuran las variables de entorno para neutralizar la verificación de particiones conservando el soporte de cifrado forzado según se requiera:
   ```bash
   KEEPVERITY=false KEEPFORCEENCRYPT=true ./magiskboot cpio ramdisk.cpio patch
   ```
   *Efecto*: Remueve quirúrgicamente los atributos `,avb=vbmeta_system`, `,avb_keys=...` y `,avb` dentro de `fstab.default`.

3. **Inyectar el `fstab.default` Corregido para Almacenamiento UFS**:
   Para asegurar que el ramdisk monte el almacenamiento UFS (`soc/4804000.ufshc`), se inyecta el fstab modificado directamente dentro del CPIO:
   ```bash
   ./magiskboot cpio ramdisk.cpio "add 0644 fstab.default fstab.default.ufs"
   ```

4. **Parchear la Tabla DTB**:
   ```bash
   KEEPVERITY=false ./magiskboot dtb dtb patch
   ```
   *Efecto*: Remueve los descriptores de verity embebidos en los nodos del device tree para evitar que el kernel falle al no encontrar vbmeta.

5. **Reempaquetar con Bandera de VBMETA**:
   ```bash
   PATCHVBMETAFLAG=true ./magiskboot repack boot.img boot_port_A235M.img
   ```
   *Efecto*: `magiskboot` recalcula el checksum SHA-1 en la cabecera v2, reubica el ramdisk comprimido, preserva el bloque `SignerVer02`, recalcula el descriptor AVB0 y genera una imagen que **satisface al 100% los requisitos del ABL de Samsung**.

---

## 4. Neutralización de AVB a Nivel de Partición (`vbmeta`)

Para garantizar que el ABL y `init` no rechacen las particiones dinámicas modificadas (`system`, `vendor`, `odm`), se generó una imagen `vbmeta` con la verificación deshabilitada:

- **Tamaño de partición**: Exactamente 65,536 bytes (64 KB).
- **Nombre de compilación**: `SRPUL29A015`.
- **Estructura de Flags AVB (Offset 0x78 / 120 dec)**:
  - Stock: `0x00000000` (Verificación estricta activa).
  - Parcheado: `0x00000003` (`AVB_VBMETA_IMAGE_FLAGS_HASHTREE_DISABLED | AVB_VBMETA_IMAGE_FLAGS_VERIFICATION_DISABLED`).

### Script de Generación de `vbmeta_disabled_A235M.img`
```python
import struct

VBMETA_SIZE = 65536
with open("vbmeta_stock.img", "rb") as f:
    vbmeta = bytearray(f.read(VBMETA_SIZE))

# Modificar flags AVB a 0x3
struct.pack_into(">I", vbmeta, 120, 0x00000003)

with open("vbmeta_disabled_A235M.img", "wb") as f:
    f.write(vbmeta)
```

Ambos archivos (`boot.img` y `vbmeta.img`) se flashean conjuntamente mediante el script instalador de TWRP hacia sus respectivas particiones físicas:
- `/dev/block/bootdevice/by-name/boot`
- `/dev/block/bootdevice/by-name/vbmeta`

Con esta arquitectura, el corte de 3 segundos quedó **definitivamente eliminado**, permitiendo el arranque normal del kernel y la transición exitosa al espacio de usuario (`init`).
