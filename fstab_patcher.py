#!/usr/bin/env python3
"""
Vector de Ataque A - Fstab Patcher
===================================

Elimina de la linea de /data (o userdata) todas las banderas que disparan
Keymaster / cifrado por hardware o metadatos. Pensado para neutralizar el
panic de vold/keystore2 en un entorno custom con Knox TZ desactivado.

Objetivos (flags del 5to campo <fs_mgr_flags>):
    fileencryption=...          -> borrado
    metadata_encryption=...     -> borrado
    keydirectory=...            -> borrado
    inlinecrypt                 -> borrado (token exacto)
    wrappedkey                  -> borrado (token exacto)
    inlinecrypt_fileencryption  -> borrado (variante de AOSP 12+)

Uso:
    python3 fstab_patcher.py <fstab.default> [-o salida] [--dry-run]

    o como modulo:
    from fstab_patcher import patch_fstab
    parcheado = patch_fstab(texto_del_fstab)
"""

import re
import sys
import argparse

# Flags a eliminar. Dos categorias:
#   1) key=value : se elimina el token completo que empieza con ese prefijo
#   2) token     : se elimina solo si coincide exactamente con el token
PREFIX_FLAGS = (
    "fileencryption=",
    "metadata_encryption=",
    "keydirectory=",
)

TOKEN_FLAGS = {
    "inlinecrypt",
    "wrappedkey",
    "inlinecrypt_fileencryption",
    "inlinecrypt_optimized",
}

# Montajes objetivo: /data o userdata
DATA_MOUNT_RE = re.compile(
    r"^(?P<src>\S+)"             # dispositivo fuente
    r"(?P<w1>\s+)"               # separador (espacios/tabs)
    r"(?P<mount>/data|userdata)" # punto de montaje
    r"(?P<w2>\s+)"
    r"(?P<type>\S+)"             # fs type (f2fs/ext4)
    r"(?P<w3>\s+)"
    r"(?P<mnt_flags>\S+)"        # flags de montaje (4to campo)
    r"(?P<w4>\s+)"
    r"(?P<fs_mgr_flags>\S+)"     # flags fs_mgr (5to campo)
    r"\s*$",
    re.MULTILINE,
)


def clean_flags(flags: str) -> str:
    """Reconstruye un campo de flags sin los de cifrado/keymaster.

    Se aplica tanto a <mnt_flags> (4to campo) como a <fs_mgr_flags> (5to),
    para eliminar inlinecrypt/wrappedkey donde sea que aparezcan.
    """
    tokens = flags.split(",")
    kept = []
    for tok in tokens:
        tok = tok.strip()
        if not tok:
            continue
        if tok in TOKEN_FLAGS:
            continue
        if tok.startswith(PREFIX_FLAGS):
            continue
        kept.append(tok)
    return ",".join(kept)


def patch_fstab(text: str) -> str:
    """Devuelve el contenido del fstab con la linea /data saneada."""

    def repl(match):
        new_mnt = clean_flags(match.group("mnt_flags"))
        new_fsmgr = clean_flags(match.group("fs_mgr_flags"))
        if new_mnt == match.group("mnt_flags") and new_fsmgr == match.group("fs_mgr_flags"):
            return match.group(0)  # sin cambios
        # Reconstruir la linea preservando el whitespace original
        return (
            f"{match.group('src')}{match.group('w1')}{match.group('mount')}"
            f"{match.group('w2')}{match.group('type')}{match.group('w3')}"
            f"{new_mnt}{match.group('w4')}{new_fsmgr}"
        )

    return DATA_MOUNT_RE.sub(repl, text)


def patch_fstab_file(path: str) -> str:
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        return patch_fstab(f.read())


def main():
    ap = argparse.ArgumentParser(
        description="Fstab Patcher: neutraliza flags de cifrado/keymaster en /data"
    )
    ap.add_argument("input", help="ruta al fstab (vendor/etc/fstab.* o ramdisk)")
    ap.add_argument("-o", "--output", help="archivo de salida (por defecto stdout)")
    ap.add_argument(
        "--dry-run", action="store_true", help="solo mostrar el diff, no escribir"
    )
    args = ap.parse_args()

    original = open(args.input, "r", encoding="utf-8", errors="replace").read()
    patched = patch_fstab(original)

    if patched == original:
        print("[!] No se encontro linea /data con flags a eliminar.", file=sys.stderr)
        return 2

    if args.dry_run:
        import difflib
        diff = difflib.unified_diff(
            original.splitlines(), patched.splitlines(),
            fromfile=args.input, tofile="patched", lineterm=""
        )
        sys.stdout.write("\n".join(diff) + "\n")
        return 0

    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(patched)
        print(f"[+] fstab parcheado escrito en {args.output}")
    else:
        sys.stdout.write(patched)
    return 0


if __name__ == "__main__":
    sys.exit(main())
