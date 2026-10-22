# Análisis 01 — Crash @ 39 s: Keymaster / `KM_TAG_SAMSUNG_ROT_REQUIRED`

**Fuente**: `raw/pmsg-ramoops-0` (8 898 bytes, pstore ramoops)
**Etapa**: `SecondStageMain` (init, PID 1)
**Vector**: A (fstab)

---

## 1.1 Reconstrucción del mensaje

El buffer de pstore se lee con bits invertidos de forma intercalada (el
`console-ramoops-0` presenta el mismo fenómeno, mucho peor). La cadena
recuperada por `strings` es:

```
keystorE2+km_cclPad
!@ CmntertK%qPaBAmeterSToLegacy : KM_TAGMR
@SUJG^ROTWRAQUIBED = 10
```

Reconstrucción por intercalado de bytes (los caracteres originales y los
"basura" se alternan):

| Texto reconstruido | Fuente |
|---|---|
| `keystore2` | `keystorE2+` |
| `km_compat` | `km_cclPad` |
| `convertKeyParametersToLegacy` | `CmntertK%qPaBAmeterSToLegacy` |
| `KM_TAG_SAMSUNG_ROT_REQUIRED` | `KM_TAGMR` + `@SUJG^ROTWRAQUIBED` |
| `= 1` | `= 10` (el `0` final es basura) |

El prefijo **`!@`** es el formato de log propio de Samsung
(`ALOGE("!@ ...")`), y confirma que el binario que lo emite es una build
**parcheada por Samsung**, no el AOSP stock.

---

## 1.2 Por qué aborta

Cadena de eventos:

```
1. init lee el fstab y monta /data
2. fs_mgr ve las banderas:
       inlinecrypt
       fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized
       keydirectory=/metadata/vold/metadata_encryption
   -> exige cifrado por hardware + metadatos
3. vold (proceso 214) arranca y llama a KeyMint/Keymaster
4. keystore2 pide a libkm_compat que convierta los parámetros a los legacy
5. convertKeyParametersToLegacy() encuentra el vendor tag
   KM_TAG_SAMSUNG_ROT_REQUIRED y lo LOGUEA
6. El backend de software de Keymaster no puede satisfacer el requisito
   ROT (Rotation of Keys, ligado a Knox/TZ) -> la conversion falla
7. keystore2 aborta; init mata el proceso -> SecondStageMain muere
```

El vendor tag `KM_TAG_SAMSUNG_ROT_REQUIRED` sólo tiene sentido cuando el
TrustZone de Knox está operativo. En un ROM custom con TZ desactivado, la
exigencia es imposible de satisfacer ⇒ abort obligatorio.

---

## 1.3 Vector A — qué se parcheó

`02_Vector_A_fstab/fstab_patcher.py` elimina de la línea de `/data`:

| Bandera | Dónde aparece | Efecto de quitarla |
|---|---|---|
| `fileencryption=...` | campo 5 (`fs_mgr_flags`) | Desactiva el cifrado del contenido de `/data` |
| `metadata_encryption=...` | campo 5 | Desactiva el cifrado de metadatos |
| `keydirectory=...` | campo 5 | **Quita la dependencia de Keymaster** ← la clave del arreglo |
| `inlinecrypt` | campo 4 (`mnt_flags`) **y** 5 | Desactiva el cifrado inline de F2FS |
| `wrappedkey` | campo 5 | Desactiva el envolvimiento de claves |
| `inlinecrypt_fileencryption` | cualquiera | Variante de AOSP 12+ |
| `inlinecrypt_optimized` | cualquiera | Variante Samsung/QTI |

### Detalle de implementación relevante

La bandera `inlinecrypt` del A23 aparece en el **campo 4** (`mnt_flags`),
mientras que `fileencryption` y `keydirectory` están en el **campo 5**
(`fs_mgr_flags`). Un parche que sólo limpie el campo 5 se queda corto: por eso
la herramienta limpia **ambos** campos.

La limpieza se hace **por token** (dividiendo por comas y filtrando), no con un
regex ingenuo, para no generar comas dobles ni comas colgantes. El whitespace
original (tabs) se preserva porque se captura en el regex de sustitución.

---

## 1.4 Resultado

El crash de los 39 s desaparece. El sistema alcanza la siguiente etapa (display,
APEX, servicios de framework) y falla en un punto distinto a los ~55 s
(ver `ANIMALES_02_netbpfload_55s.md`).

---

## 1.5 Pendiente derivado de este análisis

Al revisar el `console-ramoops-0` completo aparece que **FBE sigue activo**
después del parche:

```
init: FBE will be enabled!
exec 10 (/system/bin/vdc --wait cryptfs enablefilecrypto)   -> exit status 0
voldUtils: PROP : security.fbe.fail_cause : , value K00B
```

y las opciones de montaje de `/data` siguen incluyendo `inlinecrypt`, con
`/data` sobre un dispositivo **device-mapper** (`dm-49`).

**Motivo**: existe un **segundo fstab**, el del **ramdisk first-stage**
(`fstab.default` dentro de `boot.img`), que también lleva
`inlinecrypt` + `fileencryption` + `keydirectory`. Ese es el que monta `/data`
antes de que arranque `vold`.

→ **Aplicar el Vector A también al fstab first-stage** (ver
`02_Vector_A_fstab/fstab_first_stage_PATCHED.txt`).
