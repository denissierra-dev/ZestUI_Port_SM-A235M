#!/usr/bin/env bash
#
# sync_to_usb.sh
# ==============
#
# Espera a que la USB (etiqueta 128GB) aparezca y sincroniza el arbol
# documental a su raiz. Se puede dejar en segundo plano:
#
#     nohup ./sync_to_usb.sh > /tmp/sync_usb.log 2>&1 &
#
# Reconstruye el arbol con build_documentacion.sh y lo copia a
# <USB>/ZestUI_Port_SM-A235M
#
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ART="${ARTIFACTS_DIR:-$(dirname "$REPO")/_artefactos}"
LABEL="${USB_LABEL:-128GB}"
INTERVAL="${POLL_SECONDS:-10}"
MAX_WAIT="${MAX_WAIT_SECONDS:-7200}"

echo "[$(date '+%H:%M:%S')] vigilando USB con etiqueta '$LABEL' (timeout ${MAX_WAIT}s)"

waited=0
USB=""
while [[ $waited -lt $MAX_WAIT ]]; do
    # busca el punto de montaje por etiqueta
    for mnt in /run/media/*/"$LABEL" /media/*/"$LABEL"; do
        if [[ -d "$mnt" ]] && mountpoint -q "$mnt" 2>/dev/null; then
            USB="$mnt"; break 2
        fi
    done
    sleep "$INTERVAL"
    waited=$((waited + INTERVAL))
    if (( waited % 60 == 0 )); then
        echo "[$(date '+%H:%M:%S')] ... esperando USB ($waited s)"
    fi
done

if [[ -z "$USB" ]]; then
    echo "[$(date '+%H:%M:%S')] timeout: la USB no apareció."
    exit 1
fi

echo "[$(date '+%H:%M:%S')] USB detectada en: $USB"
sleep 3   # deja que se estabilice el montaje

cd "$REPO" && SRC_LOGS_DIR="$ART/logs" \
             SRC_FSTAB="$ART/fstab/fstab_vendor_ORIGINAL.txt" \
             SRC_KM_COMPAT="$ART/elf/libkm_compat.so" \
             SRC_STOCK="$ART/stock_a235m" \
             ./build_documentacion.sh --dest "$USB" --checksums

RC=$?
if [[ $RC -eq 0 ]]; then
    echo "[$(date '+%H:%M:%S')] sincronización completada en $USB/ZestUI_Port_SM-A235M"
    du -sh "$USB/ZestUI_Port_SM-A235M" 2>/dev/null
else
    echo "[$(date '+%H:%M:%S')] la sincronización falló (rc=$RC)"
fi
exit $RC
