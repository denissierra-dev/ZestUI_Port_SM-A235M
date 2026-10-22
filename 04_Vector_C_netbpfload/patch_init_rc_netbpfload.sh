#!/usr/bin/env bash
#
# patch_init_rc_netbpfload.sh
# =============================
#
# Vector C: neutraliza el guardian `reboot_on_failure` del servicio
# `netbpfload` en un fichero .rc de init.
#
# CONTEXTO
# --------
# El kernel del Samsung Galaxy A23 (SM-A235M) es de la rama 4.19
# (4.19.151-perf). El binario /system/bin/netbpfload (cargador de eBPF para
# el "tethering offload" de Qualcomm) EXIGE kernel >= 5.4 y aborta con
# status 1 si no lo encuentra.
#
# El servicio esta declarado en el .rc con:
#
#     service netbpfload /system/bin/netbpfload
#         ...
#         reboot_on_failure
#         shutdown_command reboot,bootloader,failed
#
# Al fallar, `init` dispara el shutdown_command y reinicia al bootloader con
# la razon "bootloader-failed" (pantalla verde de Samsung / modo descarga).
#
# `netbpfload` NO es esencial para el arranque: solo implementa el offload de
# trafico USB/Wi-Fi. Por lo tanto, neutralizar el guardian es seguro.
#
# QUE HACE ESTE SCRIPT
# --------------------
#   1. Localiza el bloque `service netbpfload ... }` dentro del .rc.
#   2. Comenta SOLO dentro de ese bloque:
#        - la linea `reboot_on_failure`
#        - la linea `shutdown_command reboot,bootloader,failed`
#   3. Deja intactos el resto de servicios (incluidos otros que usen
#      `reboot_on_failure`, que pueden ser criticos de verdad).
#   4. Genera un backup `<fichero>.bak` y muestra el diff.
#   5. Verifica el resultado: el bloque ya no debe contener esas directivas.
#
# Formatos de bloque soportados (el parser de init de Android admite ambos):
#   (a) el bloque termina con una llave de cierre '}'
#   (b) el bloque termina en la siguiente directiva de nivel superior
#       (service/on/import/setprop en la columna 0), sin llaves
#
# USO
# ---
#     ./patch_init_rc_netbpfload.sh /ruta/a/system/etc/init/hw/init.rc
#     ./patch_init_rc_netbpfload.sh --check /ruta/a/init.rc     # solo diagnostico
#
# EXIT CODES
# -----------
#     0  ok (parcheado, o --check sin incidencias)
#     1  error de uso o verificacion fallida
#     2  no se encontro el servicio `netbpfload`
#     3  fallo al escribir
#
set -euo pipefail

CHECK_ONLY=0
RC_FILE=""

for arg in "$@"; do
    case "$arg" in
        --check) CHECK_ONLY=1 ;;
        -h|--help) sed -n '2,50p' "$0"; exit 0 ;;
        *) RC_FILE="$arg" ;;
    esac
done

if [[ -z "$RC_FILE" ]]; then
    echo "uso: $0 [--check] <fichero .rc de init>" >&2
    exit 1
fi

if [[ ! -f "$RC_FILE" ]]; then
    echo "[!] no existe: $RC_FILE" >&2
    exit 1
fi

# --- 1. localizar el servicio ---------------------------------------------
echo "==> Analizando: $RC_FILE"

if ! grep -qE '^[[:space:]]*service[[:space:]]+netbpfload([[:space:]]|$)' "$RC_FILE"; then
    echo "[!] No se encontro un servicio 'netbpfload' en este fichero." >&2
    echo "    Busca en otros ficheros con:" >&2
    echo "    grep -rln 'service netbpfload' system/etc/init vendor/etc/init product/etc/init" >&2
    exit 2
fi

BLOCK_START=$(grep -nE '^[[:space:]]*service[[:space:]]+netbpfload([[:space:]]|$)' "$RC_FILE" | head -1 | cut -d: -f1)
BLOCK_END=$(awk -v s="$BLOCK_START" '
    NR == s { next }
    NR > s {
        if ($0 ~ /^[ \t]*}/) { found=1; print NR; exit }                      # formato (a)
        if ($0 ~ /^[^ \t#]/ && $0 !~ /^[ \t]*$/) { found=1; print NR-1; exit }   # formato (b)
        last = NR
    }
    END { if (!found && last != "") print last }   # el bloque es el ultimo del fichero
' "$RC_FILE")

if [[ -z "$BLOCK_END" ]]; then
    echo "[!] No se pudo determinar el fin del bloque del servicio (linea $BLOCK_START)." >&2
    exit 2
fi

echo "    bloque 'service netbpfload' = lineas $BLOCK_START..$BLOCK_END"
echo "--- bloque actual ---"
sed -n "${BLOCK_START},${BLOCK_END}p" "$RC_FILE"
echo "---------------------"

# --- 2. diagnostico --------------------------------------------------------
echo
echo "==> Directivas del guardian dentro del bloque:"
if sed -n "${BLOCK_START},${BLOCK_END}p" "$RC_FILE" \
     | grep -nE '^[[:space:]]*(reboot_on_failure|shutdown_command[[:space:]]+reboot,bootloader,failed)[[:space:]]*$'; then
    GUARD_PRESENT=1
else
    echo "    (ninguna: el guardian ya esta neutralizado)"
    GUARD_PRESENT=0
fi

if [[ "$CHECK_ONLY" -eq 1 ]]; then
    echo
    echo "==> modo --check: no se escribe nada."
    exit 0
fi

if [[ "$GUARD_PRESENT" -eq 0 ]]; then
    echo
    echo "[i] No hay nada que parchear."
    exit 0
fi

# --- 3. backup -------------------------------------------------------------
BACKUP="${RC_FILE}.bak"
if [[ ! -f "$BACKUP" ]]; then
    cp -p "$RC_FILE" "$BACKUP"
    echo
    echo "==> Backup creado: $BACKUP"
else
    echo
    echo "==> Ya existe backup previo: $BACKUP (no se sobrescribe)"
fi

# --- 4. parchear -----------------------------------------------------------
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

awk -v s="$BLOCK_START" -v e="$BLOCK_END" '
    NR >= s && NR <= e {
        if ($0 ~ /^[[:space:]]*reboot_on_failure[[:space:]]*$/) {
            match($0, /^[[:space:]]*/)
            indent = substr($0, 1, RLENGTH)
            print indent "# PATCH-VECTOR-C: reboot_on_failure desactivado."
            print indent "# " substr($0, RLENGTH+1)
            next
        }
        if ($0 ~ /^[[:space:]]*shutdown_command[[:space:]]+reboot,bootloader,failed[[:space:]]*$/) {
            match($0, /^[[:space:]]*/)
            indent = substr($0, 1, RLENGTH)
            print indent "# PATCH-VECTOR-C: shutdown_command desactivado."
            print indent "# " substr($0, RLENGTH+1)
            next
        }
    }
    { print }
' "$RC_FILE" > "$TMPFILE"

if ! mv "$TMPFILE" "$RC_FILE"; then
    echo "[!] no se pudo escribir $RC_FILE" >&2
    exit 3
fi
trap - EXIT

# --- 5. verificar ----------------------------------------------------------
# IMPORTANTE: hay que RECALCULAR el rango del bloque, porque el parche ha
# insertado lineas y las referencias numericas originales ya no valen.
NEW_START=$(grep -nE '^[[:space:]]*service[[:space:]]+netbpfload([[:space:]]|$)' "$RC_FILE" | head -1 | cut -d: -f1)
NEW_END=$(awk -v s="$NEW_START" '
    NR == s { next }
    NR > s {
        if ($0 ~ /^[ \t]*}/) { found=1; print NR; exit }
        if ($0 ~ /^[^ \t#]/ && $0 !~ /^[ \t]*$/) { found=1; print NR-1; exit }
        last = NR
    }
    END { if (!found && last != "") print last }
' "$RC_FILE")

echo
echo "==> Bloque parcheado (lineas $NEW_START..$NEW_END):"
sed -n "${NEW_START},${NEW_END}p" "$RC_FILE" | sed 's/^/    /'
echo

if sed -n "${NEW_START},${NEW_END}p" "$RC_FILE" \
     | grep -qE '^[[:space:]]*(reboot_on_failure|shutdown_command[[:space:]]+reboot,bootloader,failed)[[:space:]]*$'; then
    echo "[!] VERIFICACION FALLIDA: el guardian sigue activo." >&2
    exit 1
fi

echo "[+] Parche OK: el servicio 'netbpfload' ya no puede reiniciar el sistema."
echo
echo "    Diff:"
diff -u "${BACKUP}" "$RC_FILE" | sed 's/^/    /' || true
