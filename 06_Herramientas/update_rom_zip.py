#!/usr/bin/env python3
# ==============================================================================
# update_rom_zip.py - Actualizador in-place ultra-rapido para rom_sideload.zip
# Actualiza boot.img, vbmeta.img, updater-script y vendor.new.dat.br sin
# reempaquetar los 5.4 GB completos de la ROM.
# Licencia: MIT
# ==============================================================================

import zipfile
import struct
import zlib
import time
import sys
import os

def inplace_replace_entry(z, entry_name, new_bytes):
    """Reemplaza una entrada almacenada en modo STORED (sin compresion)."""
    info = z.NameToInfo[entry_name]
    assert info.compress_type == zipfile.ZIP_STORED, f"{entry_name} esta comprimido!"
    assert info.file_size == len(new_bytes) and info.compress_size == len(new_bytes), (
        f"Discrepancia de tamaño para {entry_name}: {info.file_size} != {len(new_bytes)}"
    )
    new_crc = zlib.crc32(new_bytes) & 0xffffffff
    z.fp.seek(info.header_offset)
    hdr = bytearray(z.fp.read(30))
    magic, ver, flags, comp, mt, md, crc, csz, usz, fnlen, exlen = struct.unpack("<4sHHHHHIIIHH", hdr)
    assert magic == b"PK\x03\x04", f"Firma local invalida en {entry_name}: {magic}"
    
    if (flags & 0x08) == 0:
        struct.pack_into("<I", hdr, 14, new_crc)
        z.fp.seek(info.header_offset)
        z.fp.write(hdr)

    data_offset = info.header_offset + 30 + fnlen + exlen
    z.fp.seek(data_offset)
    z.fp.write(new_bytes)

    if flags & 0x08:
        dd_pos = data_offset + len(new_bytes)
        z.fp.seek(dd_pos)
        dd_sig = z.fp.read(4)
        if dd_sig == b"PK\x07\x08":
            z.fp.seek(dd_pos + 4)
            z.fp.write(struct.pack("<I", new_crc))
        else:
            z.fp.seek(dd_pos)
            z.fp.write(struct.pack("<I", new_crc))

    info.CRC = new_crc
    print(f"[OK] In-place actualizado {entry_name} ({len(new_bytes):,} B, CRC={new_crc:#010x})")

def update_rom_zip(zip_path, boot_path=None, vbmeta_path=None, updater_script_path=None, vendor_br_path=None, vendor_list_path=None):
    t0 = time.time()
    print(f"[*] Abriendo {zip_path}...")
    with zipfile.ZipFile(zip_path, "a", compression=zipfile.ZIP_STORED, allowZip64=True) as z:
        if boot_path and os.path.isfile(boot_path):
            with open(boot_path, "rb") as f:
                inplace_replace_entry(z, "boot.img", f.read())

        if updater_script_path and os.path.isfile(updater_script_path):
            with open(updater_script_path, "rb") as f:
                inplace_replace_entry(z, "META-INF/com/google/android/updater-script", f.read())

        if vendor_br_path and os.path.isfile(vendor_br_path):
            vi = z.NameToInfo["vendor.new.dat.br"]
            cut_offset = vi.header_offset
            print(f"[*] Truncando archivo ZIP en offset {cut_offset:,} (vendor.new.dat.br)...")
            z.filelist = [x for x in z.filelist if x.header_offset < cut_offset]
            z.NameToInfo = {x.filename: x for x in z.filelist}
            z.start_dir = cut_offset
            z.fp.seek(cut_offset)
            z.fp.truncate()
            z._didModify = True

            print("[*] Escribiendo nuevo vendor.new.dat.br...")
            z.write(vendor_br_path, "vendor.new.dat.br", compress_type=zipfile.ZIP_STORED)

            zpi = zipfile.ZipInfo("vendor.patch.dat", date_time=(2026, 1, 1, 0, 0, 0))
            zpi.compress_type = zipfile.ZIP_STORED
            zpi.external_attr = 0o644 << 16
            z.writestr(zpi, b"", compress_type=zipfile.ZIP_STORED)

            if vendor_list_path and os.path.isfile(vendor_list_path):
                z.write(vendor_list_path, "vendor.transfer.list", compress_type=zipfile.ZIP_STORED)

            if vbmeta_path and os.path.isfile(vbmeta_path):
                z.write(vbmeta_path, "vbmeta.img", compress_type=zipfile.ZIP_STORED)

    print(f"[+] Paquete ZIP actualizado en {time.time() - t0:.2f}s!")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"Uso: python3 {sys.argv[0]} <ruta_a_rom.zip> [boot.img] [vbmeta.img] [vendor.new.dat.br] [vendor.transfer.list]")
        sys.exit(1)
    z_path = sys.argv[1]
    b_path = sys.argv[2] if len(sys.argv) > 2 else None
    v_path = sys.argv[3] if len(sys.argv) > 3 else None
    vbr_path = sys.argv[4] if len(sys.argv) > 4 else None
    vl_path = sys.argv[5] if len(sys.argv) > 5 else None
    update_rom_zip(z_path, boot_path=b_path, vbmeta_path=v_path, vendor_br_path=vbr_path, vendor_list_path=vl_path)
