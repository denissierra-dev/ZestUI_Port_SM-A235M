# Resumen ejecutivo

## El problema

Portar ZestUI 4.2.9 (One UI 8.5 / Android 16) de **SM-A235F** a **SM-A235M**
(Snapdragon 680, UFS 2.2). El bootloader está vencido y el kernel arranca, pero
el sistema **colapsa dos veces** durante el arranque:

- **39 s** — colapso de Keymaster en `SecondStageMain`.
- **55 s** — reinicio forzado a modo bootloader.

Cada colapso está documentado y aislado en un vector de ataque independiente.

---

## Vector A — FBE / Keymaster (crash @ 39 s) ✅

### Síntoma

```
keystore2/km_compat: !@ convertKeyParametersToLegacy : KM_TAG_SAMSUNG_ROT_REQUIRED = 1
```

`vold` intenta montar `/data` exigiendo cifrado por hardware/metadatos. Como el
entorno es custom y el TrustZone de Knox está desactivado, el backend de
software de Keymaster (`libkm_compat.so`) recibe el vendor tag
`KM_TAG_SAMSUNG_ROT_REQUIRED` y aborta todo el proceso `init`.

### Causa raíz

La partición `/data` se monta con el juego completo de banderas de cifrado:

```
inlinecrypt
fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized
metadata_encryption=...
keydirectory=/metadata/vold/metadata_encryption
```

`keydirectory` es lo que obliga a `vold` a pedirle a Keymaster la clave de
cifrado de metadatos; y con Knox/TZ desactivado, ese camino aborta.

### Solución

Eliminar esas banderas del fstab. La herramienta `fstab_patcher.py` lo hace de
forma quirúrgica preservando tabs, comas y el resto de opciones.

> **Importante — hay DOS fstabs**, no uno:
> - `vendor/etc/fstab.*` → montajes tardíos. **Ya parcheado.**
> - **ramdisk first-stage** (`fstab.default` dentro de `boot.img`) → es el que
>   monta `/data` en la primera etapa. **También hay que parchearlo**, o FBE
>   seguirá activo (ver §1.5 del análisis 01).

---

## Vector C — `netbpfload` (crash @ 55 s) ⏳

### Síntoma

Pantalla verde de Samsung (modo descarga / `sec_debug`) y reinicio con razón
`bootloader-failed`.

### Causa raíz

**No es un kernel panic.** No existe cadena `Kernel panic - not syncing` en los
261 KB del volcado. Lo que ocurre es:

```
8.788  netbpfload: ... requires kernel 5.4.                    <-- ERROR
8.781  init: Service 'netbpfload' (pid 960) exited with status 1
8.789  init: Sending SIGKILL to service 'netbpfload' (pid 960)
8.790  init: Service netbpfload has 'reboot_on_failure' option and failed, shutting down system.
8.790  init: Got shutdown_command 'reboot,bootloader,failed'
8.790  init: [PDK] S_D_Z_B_TGT= bootload-failed
```

El kernel del A23 es **4.19.151-perf**. `/system/bin/netbpfload` (el cargador
de eBPF para *tethering offload* de Qualcomm) **exige kernel ≥ 5.4** y aborta
con status 1. Como el servicio está declarado en el `.rc` con la opción
`reboot_on_failure` y `shutdown_command reboot,bootloader,failed`, `init`
interpreta el fallo como crítico, ejecuta el shutdown completo y reinicia al
bootloader.

`netbpfload` sólo sirve para la descarga de tráfico USB/Wi-Fi. **Es
completamente no esencial para el arranque.**

### Solución propuesta

Quitar `reboot_on_failure` (y `shutdown_command`) de la declaración del
servicio en el `.rc`, o sustituir `/system/bin/netbpfload` por un stub que salga
con 0. Detalle y script en `04_Vector_C_netbpfload/`.

---

## Vector B — Parcheador ELF (herramienta, no aplicado) 🔧

`elf_patcher.py` localiza y neutraliza de forma quirúrgica la comprobación de
`KM_TAG_SAMSUNG_ROT_REQUIRED` en un binario ELF, resolviendo:

- constantes de 32 bits materializadas como `movz` + `movk` (el patrón con el
  que el compilador construye los vendor tags 0x8xxxxxxx);
- constantes almacenadas en `.rodata` referenciadas por `ldr` literal o
  `adrp` + `ldr`;
- neutralización del salto condicional **según su polaridad** (`b.ne` → `b`
  incondicional; `b.eq` → NOP).

**Estado**: la herramienta está validada end-to-end contra un ELF ARM64 sintético
con ambos patrones. **No se aplicó a producción** porque el análisis del
`libkm_compat.so` subido demuestra que es la versión **stock AOSP** y **no
contiene** el check de Samsung. Ver `03_Vector_B_ELF/README.md`.

---

## Hallazgo clave del Vector B

`libkm_compat.so` (182 976 bytes, AArch64, ET_DYN, 287 símbolos dinámicos):

| Búsqueda | Resultado |
|---|---|
| String `KM_TAG_SAMSUNG_ROT_REQUIRED` | ❌ no presente |
| String `ROT` / `SAMSUNG` de Samsung | ❌ ninguno |
| Formato de log `!@` de Samsung | ❌ ninguno |
| Constantes en rango vendor (≥ 0xC0000000) | ❌ ninguna en el código |
| Símbolo `convertKeyParametersToLegacy` | ⚠️ **estática**, no exportada |

Es la versión **AOSP sin modificar** de
`system/security/keystore2/src/km_compat/km_compat.cpp`. El check de Samsung
vive en **otro binario** de la ROM ZestUI. Localizarlo es el siguiente paso
crítico antes de que cualquier parche de Vector B tenga efecto.
