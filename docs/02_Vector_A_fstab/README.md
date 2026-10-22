# Vector A — Parcheador de fstab (FBE / Keymaster)

**Objetivo**: eliminar de la partición `/data` toda bandera que obligue a
`vold` a pedirle a Keymaster una clave de cifrado por hardware, que es lo que
provoca el crash `KM_TAG_SAMSUNG_ROT_REQUIRED` a los 39 s.

## Ficheros

| Fichero | Descripción |
|---|---|
| `fstab_patcher.py` | La herramienta (Python, sin dependencias externas) |
| `raw/fstab_vendor_ORIGINAL.txt` | fstab de `vendor/etc/` sin modificar |
| `fstab_vendor_PATCHED.txt` | Resultado aplicado al fstab de vendor |
| `raw/fstab_first_stage_ORIGINAL.txt` | fstab del **ramdisk first-stage** (extraído del `boot.img` stock A235M) |
| `fstab_first_stage_PATCHED.txt` | Resultado aplicado al fstab first-stage |

## Uso

```bash
# diagnóstico (diff en stdout, no escribe nada)
python3 fstab_patcher.py fstab_vendor.txt --dry-run

# aplicar
python3 fstab_patcher.py fstab_vendor.txt -o fstab_vendor_PATCHED.txt
```

Como módulo:

```python
from fstab_patcher import patch_fstab
texto_parcheado = patch_fstab(texto_original)
```

## Banderas eliminadas

| Bandera | Forma | Campo del fstab |
|---|---|---|
| `fileencryption` | `fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized` | 5 (`fs_mgr_flags`) |
| `metadata_encryption` | `metadata_encryption=...` | 5 |
| `keydirectory` | `keydirectory=/metadata/vold/metadata_encryption` | 5 |
| `inlinecrypt` | token exacto | **4 y 5** |
| `wrappedkey` | token exacto | 5 |
| `inlinecrypt_fileencryption` | token exacto | 4 y 5 |
| `inlinecrypt_optimized` | token exacto | 4 y 5 |

## Detalles de implementación

1. **Filtro por token, no por regex ingenuo.** Se divide el campo por comas y
   se descartan los tokens problemáticos. Un regex tipo
   `s/,?fileencryption=[^,]*,?//` puede dejar comas dobles o comas colgantes
   si el flag está al principio o al final del campo.
2. **Se limpian los DOS campos de flags.** En el A23, `inlinecrypt` está en el
   campo 4 (`mnt_flags`) mientras que `fileencryption`/`keydirectory` están en
   el 5 (`fs_mgr_flags`). Limpiar sólo el 5 se queda corto.
3. **Se preserva el whitespace.** El regex captura los separadores (tabs en los
   fstab reales) y los reinyecta, en lugar de normalizar a espacios.
4. **Token vacío ignorado.** El fstab first-stage del A23 trae un
   `check,,fileencryption=` con doble coma heredado del stock; el parcheador
   lo normaliza a `check,fileencryption=` → `check,quota,...` al quitar el
   flag.

## Los dos fstabs (punto crítico)

| Fichero | Partición | Momento | Estado |
|---|---|---|---|
| `fstab.default` (ramdisk) | `boot` (ramdisk) | **primera etapa** | ✅ **parcheado** |

> **Corrección (verificada)**: el fichero `fstab_vendor.txt` que se subió para
> este vector **es** el `ramdisk_F/fstab.default` del port — el fstab de
> **primera etapa**, el que realmente monta `/data`. Se confirmó byte a byte
> (mismo contenido, el fichero subido usa tabuladores y el del dispositivo
> espacios). No hace falta un fstab adicional en `vendor/etc` para este ROM.

El fstab first-stage es el que monta `/data` antes de que arranque `vold`, y
también lleva `inlinecrypt` + `fileencryption` + `keydirectory`. Si no se
parchea, FBE sigue activo (ver `security.fbe.fail_cause = K00B` y el
`dm-49` en el log).

Para **referencia**, el fstab first-stage del **A235M stock** (extraído de su
`boot.img`, build `SRPUL29A015`) es equivalente salvo por la ruta del
dispositivo (`/dev/block/bootdevice/...` en vez de
`/dev/block/platform/soc/4804000.ufshc/...`) y por un `check,,fileencryption=`
con doble coma heredado del stock. Está en
`../07_Extraidos_STOCK_A235M/boot_ramdisk/fstab.default`.

### Cómo reconstruir el ramdisk

```bash
lz4 -d boot.img.lz4 boot.img
# parsear la cabecera Android boot v2 y extraer el ramdisk
#   (offset = page_size + kernel_size redondeado a page_size)
zcat ramdisk.img | cpio -idmv          # -> fstab.default, init, dpolicy
```

El `boot.img` del A235M stock es el build **`SRPUL29A015`** (nombre en la
cabecera del boot image), con cmdline:

```
console=null androidboot.hardware=qcom androidboot.memcg=1
lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000
msm_rtb.filter=0x237 service_locator.enable=1
androidboot.usbcontroller=4e00000.dwc3 swiotlb=2048 loop.max_part=7
cgroup.memory=nokmem,nosocket
firmware_class.path=/vendor/firmware_mnt/image printk.devkmsg=on
```

> `printk.devkmsg=on` explica el volumen de log en el `console-ramoops-0`.
