# Third-Party Notices

Este repositorio contiene material de terceros. **Ese material no está
cubierto por la licencia MIT del proyecto** (ver `LICENSE`) y conserva sus
licencias originales, tal y como se detalla a continuación.

Las herramientas de análisis de este repositorio son obra original del autor
y se publican bajo MIT. Los binarios y artefactos que se analizan **no se
re-licencian** y, en general, **no se versionan** en este repositorio (véase
`.gitignore`).

---

## 1. Android Open Source Project (AOSP)

| Elemento | Licencia | Notas |
|---|---|---|
| `libkm_compat.so` (`system/security/keystore2/src/km_compat/km_compat.cpp`) | **Apache-2.0** | Google LLC / Android Open Source Project |
| Referencias a `keymaster` 4.0, `keymint` AIDL, `libavb`, `fs_mgr`, `liblp` | **Apache-2.0** | AOSP |
| Documentación de API citada en `05_Assembly_ARM64/notas/` | **Apache-2.0** | AOSP |

Copyright © The Android Open Source Project.

Licencia: <http://www.apache.org/licenses/LICENSE-2.0>

Si se redistribuye `libkm_compat.so` (o cualquier otro binario de AOSP), debe
incluirse el aviso de copyright de AOSP y una copia de la licencia
Apache-2.0.

---

## 2. Samsung Electronics

| Elemento | Licencia | Notas |
|---|---|---|
| `boot.img`, `kernel.img`, `init` (ramdisk), `dpolicy` | **Propietario** | Samsung Electronics Co., Ltd. |
| `super.img` / `vendor.img` / `odm.img` del A235M | **Propietario** | Samsung Electronics Co., Ltd. |
| Componentes `vendor` con licencia GPL-2.0 (HALs, framework) | **GPL-2.0** | Samsung / AOSP |
| `init.rc` de QTI, servicios `netbpfload`, `boringssl_self_test` | **Propietario / Apache-2.0** | Qualcomm / Samsung |
| Documentación de `keymaster` / `keymint` en las notas | **Apache-2.0 / GPL-2.0** | Samsung / AOSP |

Copyright © Samsung Electronics Co., Ltd.

> ⚠️ **Los binarios propietarios de Samsung no deberían redistribuirse** en un
> repositorio público. Por eso están excluidos por `.gitignore`. Si se
> publican como *Release*, podrían(Clone) a distributions de Samsung
>وت exceder los derechos de redistribución. Mantenerlos únicamente en el
> dispositivo de destino o en un entorno privado.

---

## 3. ZestUI (el room base)

| Elemento | Licencia | Notas |
|---|---|---|
| Room ZestUI 4.9.2 (`system.new.dat.br`, `vendor.new.dat.br`, `odm.new.dat.br`) | **GPL-2.0** (derivado de One UI / AOSP) | Autores del room |

El room es una obra derivada de Samsung One UI, que a su vez deriva de AOSP.
Al ser obra derivada de componentes GPL-2.0, **cualquier distribución del room
modificado (incluido este port) debe mantener la GPL-2.0** y ofrecer el
código fuente correspondiente.

Esto aplica al **port como artefacto**, no a las herramientas de análisis de
este repositorio, que son obras independientes bajo MIT.

---

## 4. Distribuciones base de los tools

Las herramientas de sistema usadas **sólo para analizar**, no se redistribuyen
aquí:

| Herramienta | Licencia |
|---|---|
| `lz4` | GPL-2.0 / BSD-2-Clause (Jean-loup Gailly) |
| `cpio`, `simg2img` | GPL-2.0 (AOSP / GNU) |
| `lpunpack` | Apache-2.0 (AOSP) |
| `magiskboot` | GPL-3.0 (topjohnwu, Magisk) |
| Python 3 | PSF-2.1 |
| LIEF | Apache-2.0 |
| Capstone | BSD-3-Clause |
| Keystone | GPL-3.0 |
| hexdump | MIT |

> **Keystone Engine es GPL-3.0.** `elf_patcher.py` lo usa como *dependencia
> externa* (import), no como código copiado, por lo que el script en sí
> puede distribuirse bajo MIT. Si se distribuya `libkeystone` junto al
> proyecto, hay que cumplir la GPL-3.0 de esa librería.

---

## 5. Documentación

La documentación markdown de `docs/` se publica bajo **CC BY-SA 4.0**
(https://creativecommons.org/licenses/by-sa/4.0/), para que pueda referenciarse
y reutilizarse manteniendo la atribución.

El código fuente de `docs/06_Herramientas/` y `docs/07_Extraidos_STOCK_A235M/`
sigue bajo MIT.

---

## Resumen

| Capa | Licencia |
|---|---|
| Scripts y herramientas (`*.py`, `*.sh`) | MIT (`LICENSE`) |
| Documentación (`docs/**/*.md`) | CC BY-SA 4.0 |
| `libkm_compat.so` y material AOSP | Apache-2.0 |
| Artefactos Samsung (boot/kernel/vendor/odm) | Propietario — **no redistribuir** |
| Room ZestUI y el port derivado | GPL-2.0 (obligación de fuente) |
