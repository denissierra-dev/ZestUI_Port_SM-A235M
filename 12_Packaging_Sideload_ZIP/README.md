# Vector Packaging — Generación y Actualización Rápida de la ROM

## 1. Arquitectura del Paquete de Instalación (`rom_sideload.zip`)

La ROM se distribuye como un paquete flasheable por TWRP (o mediante `adb sideload`), estructurado según el estándar de actualización por bloques de Android (AOSP Block Image Update):

```
rom_sideload.zip (5.4 GB)
├── META-INF/com/google/android/
│   ├── update-binary          (Binario ejecutable del instalador TWRP)
│   └── updater-script         (Script Edify con directivas de flasheo)
├── dynamic_partitions_op_list (Instrucciones para el mapeador Device-Mapper Super)
├── unsparse_super_empty.img   (Tabla de particiones lógicas vacía)
├── system.new.dat.br          (Partición /system en formato Brotli sdat v4, EROFS)
├── system.transfer.list       (Mapa de asignación de bloques de system)
├── vendor.new.dat.br          (Partición /vendor en formato Brotli sdat v4, F2FS)
├── vendor.transfer.list       (Mapa de asignación de bloques de vendor)
├── odm.new.dat.br             (Partición /odm en formato Brotli sdat v4, F2FS)
├── odm.transfer.list          (Mapa de asignación de bloques de odm)
├── boot.img                   (Imagen de arranque híbrida SM-A235M, modo STORED)
└── vbmeta.img                 (VBMeta con AVB deshabilitado, modo STORED)
```

---

## 2. El Pipeline Sparse Data (`sdat` v4 y Brotli)

Android utiliza el formato Sparse Data (`.transfer.list` + `.new.dat`) para transferir únicamente los bloques útiles del sistema de archivos, omitiendo los bloques no asignados (bloques vacíos). Posteriormente, el stream se comprime con el algoritmo **Brotli** (`.new.dat.br`).

Se crearon dos herramientas en Python basadas en `ctypes` que enlazan directamente con las bibliotecas compartidas de compresión del sistema (`libbrotlidec.so.1` y `libbrotlienc.so.1`):

### 2.1. `br_sdat.py`
Permite:
- **`decompress_br(in_path, out_path)`**: Descompresión streaming de Brotli a chunks de memoria.
- **`sdat2img(transfer_list, new_dat, out_img)`**: Reconstruye la imagen cruda de disco (F2FS / ext4 / erofs) posicionando cada rango de bloques según los comandos `new` del `transfer.list`.
- **`br2img(transfer_list, br_path, out_img)`**: Pipeline combinado que realiza la descompresión y el desempaquetado en un solo paso hacia disco.

### 2.2. `img2br.py`
Permite tomar una imagen cruda modificada (como `vendor.img` tras el parcheo de inodos) y reconvertirla en el stream comprimido `vendor.new.dat.br`:
- Lee el mapa de bloques desde `vendor.transfer.list`.
- Extrae únicamente los rangos válidos de bloques directos.
- Comprime el flujo utilizando el codificador de Brotli con calidad optimizada (`BROTLI_PARAM_QUALITY = 5`) y tamaño de ventana de 24 bits (`BROTLI_PARAM_LGWIN = 24`), garantizando compatibilidad 100% con el descompresor nativo de TWRP.

---

## 3. Técnica de Actualización Rápida In-Place (`update_rom_zip.py`)

### El Problema del Ciclo de Desarrollo
El archivo `rom_sideload.zip` tiene un tamaño superior a los **5.4 GB** (debido a la gran imagen del sistema One UI 8.5 en `system.new.dat.br`). Si en cada prueba de parcheo fuera necesario descomprimir y volver a comprimir el zip completo:
- Cada ciclo de compilación tomaría entre **5 y 10 minutos**.
- Se produciría un desgaste innecesario en la memoria USB de pruebas.

### La Solución: Modificación In-Place a Nivel de Cabecera ZIP
El estándar PKZIP permite actualizar entradas sin tocar el resto del archivo siempre que cumplan ciertas condiciones geométricas. Se diseñó **`update_rom_zip.py`**:

```
[ Layout de rom_sideload.zip ]
├── Local Header: updater-script  (Modo STORED -> Actualización in-place en offset exacto)
├── Local Header: boot.img        (Modo STORED -> Actualización in-place en offset exacto)
├── Local Header: system.new.dat.br (4.1 GB -> INTACTO, no se lee ni se escribe)
├── Local Header: odm.new.dat.br
├── Local Header: vendor.new.dat.br (OFFSET DE CORTE) ──┐
│   ... datos viejos ...                                │ TRUNCATE() en milisegundos
│                                                       └── APPEND nuevo vendor.new.dat.br
│                                                           + vendor.transfer.list
│                                                           + vbmeta.img
│                                                           + Central Directory nuevo
```

1. **Entradas `ZIP_STORED` (`boot.img`, `vbmeta.img`, `updater-script`)**:
   Al almacenarse sin compresión (`compress_type == 0`), sus tamaños son exactamente predecibles. El script busca el `header_offset` de la entrada, reescribe el payload binario directamente sobre el archivo en disco (`f.seek()`, `f.write()`), y actualiza el campo de checksum CRC-32 en la cabecera local (`PK\x03\x04`).
2. **Entrada de Vendor (`vendor.new.dat.br`)**:
   Como `vendor.new.dat.br` se encuentra ubicado después de `system.new.dat.br`:
   - El script abre el archivo ZIP, localiza el `header_offset` de `vendor.new.dat.br` y ejecuta un `truncate()` a nivel de sistema operativo en esa posición exacta.
   - Escribe el nuevo `vendor.new.dat.br` modificado.
   - Añade `vendor.patch.dat` (0 bytes) y `vendor.transfer.list`.
   - Escribe `vbmeta.img`.
   - Regenera el Central Directory (`PK\x01\x02`) y el End of Central Directory (`PK\x05\x06`).

**Resultado**: La actualización de la ROM completa pasa de demorar 8 minutos a ejecutarse en **menos de 10 segundos**.
