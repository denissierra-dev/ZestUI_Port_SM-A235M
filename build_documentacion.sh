#!/usr/bin/env bash
#
# build_documentacion.sh
# ======================
#
# Reconstruye el arbol documental completo del puerto ZestUI -> SM-A235M y lo
# sincroniza a un destino (por defecto, la USB montada).
#
# Es idempotente: se puede ejecutar tantas veces como haga falta. Sirve
# tanto para regenerar el arbol tras editar un `.md` como para volcar todo a
# la USB tras reconectarla.
#
# USO
# ---
#     ./build_documentacion.sh                  # construye en ./build y sincroniza a la USB
#     ./build_documentacion.sh --dest /ruta    # otro destino
#     ./build_documentacion.sh --no-sync        # sólo construye, no sincroniza
#     ./build_documentacion.sh --checksums      # regenera SHA256SUMS.txt
#
# ORIGENES
# --------
# Los binarios y logs de origen NO viven en el repo (son grandes y/o con
# licencia de terceros). Se referencian por variable de entorno:
#
#     SRC_LOGS_DIR   directorio con pmsg-ramoops-0 y console-ramoops-0
#     SRC_FSTAB      fstab_vendor.txt original
#     SRC_KM_COMPAT  libkm_compat.so
#     SRC_STOCK      directorio con boot.img.lz4 / super.img.lz4 del A235M
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
DEST=""
SYNC=1
CHECKSUMS=0

for arg in "$@"; do
    case "$arg" in
        --dest=*)   DEST="${arg#*=}" ;;
        --dest)     shift; DEST="$1" ;;
        --no-sync)  SYNC=0 ;;
        --checksums) CHECKSUMS=1 ;;
        -h|--help)  sed -n '2,25p' "$0"; exit 0 ;;
    esac
done

# Destino por defecto: la USB montada con etiqueta 128GB
if [[ -z "$DEST" ]]; then
    for cand in /run/media/"$USER"/128GB /media/"$USER"/128GB; do
        [[ -d "$cand" ]] && { DEST="$cand"; break; }
    done
fi

echo "==> origen del build : $SCRIPT_DIR"
echo "==> build dir        : $BUILD_DIR"
echo "==> destino          : ${DEST:-<ninguno>}"

# ---------------------------------------------------------------------------
# Estructura
# ---------------------------------------------------------------------------
DIRS=(
    "00_Overview"
    "01_Logs_Boot/raw"
    "02_Vector_A_fstab/raw"
    "03_Vector_B_ELF/raw"
    "04_Vector_C_netbpfload"
    "05_Assembly_ARM64/libkm_compat"
    "05_Assembly_ARM64/netbpfload"
    "05_Assembly_ARM64/notas"
    "06_Herramientas"
    "07_Extraidos_STOCK_A235M/boot_ramdisk"
    "07_Extraidos_STOCK_A235M/super_vendor"
    "08_Bitacora"
)

echo
echo "==> 1/5 creando estructura"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
for d in "${DIRS[@]}"; do
    mkdir -p "$BUILD_DIR/$d"
done

# ---------------------------------------------------------------------------
# Documentacion estatica (versionada en el repo, junto al script)
# ---------------------------------------------------------------------------
echo "==> 2/5 copiando documentacion"
if [[ -d "$SCRIPT_DIR/docs" ]]; then
    cp -r "$SCRIPT_DIR/docs/." "$BUILD_DIR/"
else
    echo "    [!] no existe $SCRIPT_DIR/docs (documentacion no copiada)" >&2
fi

# ---------------------------------------------------------------------------
# Herramientas
# ---------------------------------------------------------------------------
echo "==> 3/5 copiando herramientas"
for t in fstab_patcher.py elf_patcher.py annotate_asm.py parse_bootimg.py requirements.txt; do
    [[ -f "$SCRIPT_DIR/$t" ]] && cp "$t" "$BUILD_DIR/" || echo "    [!] falta $t" >&2
done

# Cada herramienta se copia TAMBIEN junto a la documentacion de su vector,
# para que el arbol sea autocontenido y legible sin conocer el repo.
[[ -f "$SCRIPT_DIR/fstab_patcher.py" ]] && cp "$SCRIPT_DIR/fstab_patcher.py" \
    "$BUILD_DIR/02_Vector_A_fstab/"
[[ -f "$SCRIPT_DIR/elf_patcher.py" ]] && cp "$SCRIPT_DIR/elf_patcher.py" \
    "$BUILD_DIR/03_Vector_B_ELF/"
[[ -f "$SCRIPT_DIR/annotate_asm.py" ]] && cp "$SCRIPT_DIR/annotate_asm.py" \
    "$BUILD_DIR/05_Assembly_ARM64/"
[[ -f "$SCRIPT_DIR/patch_init_rc_netbpfload.sh" ]] && \
    cp "$SCRIPT_DIR/patch_init_rc_netbpfload.sh" "$BUILD_DIR/04_Vector_C_netbpfload/"

# ---------------------------------------------------------------------------
# Artefactos externos
# ---------------------------------------------------------------------------
echo "==> 4/5 copiando artefactos externos"

copy_if() {  # copy_if <origen> <destino>
    if [[ -f "$1" ]]; then
        cp "$1" "$2"; echo "    + $(basename "$2")"
    else
        echo "    - falta origen: $1" >&2
    fi
}

# Logs
if [[ -n "${SRC_LOGS_DIR:-}" ]]; then
    copy_if "$SRC_LOGS_DIR/pmsg-ramoops-0"    "$BUILD_DIR/01_Logs_Boot/raw/pmsg-ramoops-0"
    copy_if "$SRC_LOGS_DIR/console-ramoops-0" "$BUILD_DIR/01_Logs_Boot/raw/console-ramoops-0"
else
    echo "    - SRC_LOGS_DIR no definido" >&2
fi

# fstab de vendor
if [[ -n "${SRC_FSTAB:-}" ]]; then
    copy_if "$SRC_FSTAB" "$BUILD_DIR/02_Vector_A_fstab/raw/fstab_vendor_ORIGINAL.txt"
    # el fstab first-stage suele estar junto al de vendor en el staging
    FSTAGE_DIR="$(dirname "$SRC_FSTAB")"
    if [[ -f "$FSTAGE_DIR/fstab_first_stage_ORIGINAL.txt" ]]; then
        copy_if "$FSTAGE_DIR/fstab_first_stage_ORIGINAL.txt" \
                "$BUILD_DIR/02_Vector_A_fstab/raw/fstab_first_stage_ORIGINAL.txt"
    fi
else
    echo "    - SRC_FSTAB no definido" >&2
fi

# libkm_compat.so
if [[ -n "${SRC_KM_COMPAT:-}" ]]; then
    copy_if "$SRC_KM_COMPAT" "$BUILD_DIR/03_Vector_B_ELF/raw/libkm_compat.so"
else
    echo "    - SRC_KM_COMPAT no definido" >&2
fi

# Artefactos del A235M stock ya extraidos
if [[ -n "${SRC_STOCK:-}" ]]; then
    for f in "$SRC_STOCK"/boot_ramdisk/*; do
        [[ -f "$f" ]] && cp "$f" "$BUILD_DIR/07_Extraidos_STOCK_A235M/boot_ramdisk/"
    done
    [[ -f "$SRC_STOCK/boot_header.txt" ]] && \
        cp "$SRC_STOCK/boot_header.txt" "$BUILD_DIR/07_Extraidos_STOCK_A235M/"
    [[ -f "$SRC_STOCK/parse_bootimg.py" ]] && \
        cp "$SRC_STOCK/parse_bootimg.py" "$BUILD_DIR/07_Extraidos_STOCK_A235M/"
else
    echo "    - SRC_STOCK no definido" >&2
fi

# ---------------------------------------------------------------------------
# Regenerar los ficheros derivados
# ---------------------------------------------------------------------------
echo "==> 5/5 regenerando derivados"

# fstab first-stage parcheado
if [[ -f "$BUILD_DIR/02_Vector_A_fstab/raw/fstab_first_stage_ORIGINAL.txt" ]]; then
    python3 "$BUILD_DIR/fstab_patcher.py" \
        "$BUILD_DIR/02_Vector_A_fstab/raw/fstab_first_stage_ORIGINAL.txt" \
        -o "$BUILD_DIR/02_Vector_A_fstab/fstab_first_stage_PATCHED.txt" || true
fi

# fstab de vendor parcheado
if [[ -f "$BUILD_DIR/02_Vector_A_fstab/raw/fstab_vendor_ORIGINAL.txt" ]]; then
    python3 "$BUILD_DIR/fstab_patcher.py" \
        "$BUILD_DIR/02_Vector_A_fstab/raw/fstab_vendor_ORIGINAL.txt" \
        -o "$BUILD_DIR/02_Vector_A_fstab/fstab_vendor_PATCHED.txt" || true
fi

# Desensamblado anotado
if [[ -f "$BUILD_DIR/03_Vector_B_ELF/raw/libkm_compat.so" ]]; then
    python3 "$BUILD_DIR/annotate_asm.py" \
        "$BUILD_DIR/03_Vector_B_ELF/raw/libkm_compat.so" \
        --start 0x10b78 --end 0x12bec \
        -o "$BUILD_DIR/05_Assembly_ARM64/libkm_compat/convertKeyParametersToLegacy.asm" || true
    python3 "$BUILD_DIR/annotate_asm.py" \
        "$BUILD_DIR/03_Vector_B_ELF/raw/libkm_compat.so" --list-syms \
        > "$BUILD_DIR/05_Assembly_ARM64/libkm_compat/funciones_exportadas.txt" || true
fi

# Checksums
if [[ "$CHECKSUMS" -eq 1 ]]; then
    ( cd "$BUILD_DIR" && find . -type f ! -name SHA256SUMS.txt -print0 \
        | sort -z | xargs -0 sha256sum > SHA256SUMS.txt )
    echo "    + SHA256SUMS.txt ($(wc -l < "$BUILD_DIR/SHA256SUMS.txt") entradas)"
fi

# ---------------------------------------------------------------------------
# Sincronizar al destino
# ---------------------------------------------------------------------------
if [[ "$SYNC" -eq 1 && -n "$DEST" ]]; then
    TARGET="$DEST/ZestUI_Port_SM-A235M"
    echo
    echo "==> sincronizando a $TARGET"
    if [[ ! -d "$DEST" ]]; then
        echo "[!] el destino no existe (¿USB desconectada?): $DEST" >&2
        exit 1
    fi
    mkdir -p "$TARGET"
    cp -r "$BUILD_DIR/." "$TARGET/"
    echo "[+] sincronizado."
else
    echo
    echo "[i] no se sincronizó (SYNC=0 o DEST vacío)."
fi

echo
echo "==> build completo."
