#!/usr/bin/env bash
# ==============================================================================
# build_boot_magisk.sh - Pipeline reproducible de reempaquetado boot para SM-A235M
# Licencia: MIT
# ==============================================================================
set -euo pipefail

BOOT_STOCK="${1:-boot.img}"
FSTAB_UFS="${2:-fstab.default.ufs}"
OUTPUT_BOOT="${3:-boot_port_A235M.img}"
OUTPUT_VBMETA="${4:-vbmeta_disabled_A235M.img}"

if [ ! -f "$BOOT_STOCK" ]; then
    echo "[-] Error: No se encontro el boot.img original ($BOOT_STOCK)"
    exit 1
fi

if ! command -v ./magiskboot &>/dev/null && ! command -v magiskboot &>/dev/null; then
    echo "[-] Error: Se requiere el binario magiskboot"
    exit 1
fi
MAGISKBOOT=$(command -v ./magiskboot 2>/dev/null || command -v magiskboot)

echo "[*] Paso 1: Desempaquetando boot.img stock..."
$MAGISKBOOT unpack "$BOOT_STOCK"

echo "[*] Paso 2: Aplicando parche verity/encrypt al ramdisk..."
KEEPVERITY=false KEEPFORCEENCRYPT=true $MAGISKBOOT cpio ramdisk.cpio patch

if [ -f "$FSTAB_UFS" ]; then
    echo "[*] Paso 3: Inyectando fstab UFS en ramdisk.cpio..."
    $MAGISKBOOT cpio ramdisk.cpio "add 0644 fstab.default $FSTAB_UFS"
fi

echo "[*] Paso 4: Parcheando nodos de verity en la tabla DTB..."
KEEPVERITY=false $MAGISKBOOT dtb dtb patch

echo "[*] Paso 5: Reempaquetando con preservacion de cabeceras de Samsung..."
PATCHVBMETAFLAG=true $MAGISKBOOT repack "$BOOT_STOCK" "$OUTPUT_BOOT"

if [ -f "vbmeta.img" ]; then
    echo "[*] Paso 6: Generando vbmeta con flags 0x3 (AVB Disabled)..."
    python3 -c '
import struct, sys
with open(sys.argv[1], "rb") as f:
    b = bytearray(f.read(65536))
struct.pack_into(">I", b, 120, 0x00000003)
with open(sys.argv[2], "wb") as f:
    f.write(b)
' "vbmeta.img" "$OUTPUT_VBMETA"
fi

echo "[+] Proceso completado con exito:"
echo "    - Boot:   $OUTPUT_BOOT"
echo "    - VBMeta: $OUTPUT_VBMETA"
