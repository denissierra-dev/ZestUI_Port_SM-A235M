# ZestUI → SM-A235M — repo de trabajo

Este repositorio contiene las **herramientas** y el **generador** del árbol
documental del puerto.

## Estructura

```
.
├── docs/                  # Documentación markdown (fuente)
│   ├── README.md
│   ├── 00_Overview/
│   ├── 01_Logs_Boot/
│   ├── 02_Vector_A_fstab/
│   ├── 03_Vector_B_ELF/
│   ├── 04_Vector_C_netbpfload/
│   ├── 05_Assembly_ARM64/notas/
│   ├── 06_Herramientas/
│   ├── 07_Extraidos_STOCK_A235M/
│   └── 08_Bitacora/
├── fstab_patcher.py       # Vector A
├── elf_patcher.py         # Vector B
├── annotate_asm.py        # Generador de .asm anotado
├── patch_init_rc_netbpfload.sh   # Vector C
├── parse_bootimg.py       # Parser de Android boot image
├── build_documentacion.sh # Reconstruye el árbol y lo sincroniza a la USB
└── requirements.txt
```

## Licencia

| Capa | Licencia |
|---|---|
| Scripts y herramientas (`*.py`, `*.sh`) | **MIT** — ver [`LICENSE`](LICENSE) |
| Documentación (`docs/**/*.md`) | **CC BY-SA 4.0** |
| Material de terceros (AOSP, Samsung, ZestUI) | **sus licencias originales** — ver [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) |

> Los binarios propietarios (boot/kernel/vendor/odm de Samsung y el room
> ZestUI) están **excluidos del repositorio** por `.gitignore` y no se
> relicencian. El port del room es una obra derivada GPL-2.0.

## Uso

```bash
pip3 install -r requirements.txt

SRC_LOGS_DIR=/ruta/a/logs \
SRC_FSTAB=/ruta/a/fstab_vendor.txt \
SRC_KM_COMPAT=/ruta/a/libkm_compat.so \
SRC_STOCK=/ruta/a/stock_a235m \
./build_documentacion.sh --checksums
```

La documentación completa está en `docs/README.md`.
