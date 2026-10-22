#!/usr/bin/env python3
# ==============================================================================
# br_sdat.py - Utilidad de descompresion y conversion sdat / brotli para ROMs Android
# Licencia: MIT
# ==============================================================================

import ctypes
import sys
import os

libdec = ctypes.CDLL("/usr/lib64/libbrotlidec.so.1")
libenc = ctypes.CDLL("/usr/lib64/libbrotlienc.so.1")

libdec.BrotliDecoderCreateInstance.restype = ctypes.c_void_p
libdec.BrotliDecoderCreateInstance.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
libdec.BrotliDecoderDestroyInstance.argtypes = [ctypes.c_void_p]
libdec.BrotliDecoderDecompressStream.restype = ctypes.c_int
libdec.BrotliDecoderDecompressStream.argtypes = [
    ctypes.c_void_p,
    ctypes.POINTER(ctypes.c_size_t),
    ctypes.POINTER(ctypes.c_char_p),
    ctypes.POINTER(ctypes.c_size_t),
    ctypes.POINTER(ctypes.c_char_p),
    ctypes.POINTER(ctypes.c_size_t),
]

def decompress_br(in_path, out_path):
    state = libdec.BrotliDecoderCreateInstance(None, None, None)
    CHUNK = 4 * 1024 * 1024
    out_buf = ctypes.create_string_buffer(CHUNK)
    with open(in_path, "rb") as fin, open(out_path, "wb") as fout:
        while True:
            data = fin.read(CHUNK)
            if not data:
                break
            in_buf = ctypes.create_string_buffer(data)
            avail_in = ctypes.c_size_t(len(data))
            next_in = ctypes.cast(in_buf, ctypes.c_char_p)
            while True:
                avail_out = ctypes.c_size_t(CHUNK)
                next_out = ctypes.cast(out_buf, ctypes.c_char_p)
                res = libdec.BrotliDecoderDecompressStream(
                    state,
                    ctypes.byref(avail_in),
                    ctypes.byref(next_in),
                    ctypes.byref(avail_out),
                    ctypes.byref(next_out),
                    None
                )
                produced = CHUNK - avail_out.value
                if produced > 0:
                    fout.write(out_buf.raw[:produced])
                if res == 0:
                    raise RuntimeError("Error en descompresion Brotli")
                if res == 1 or (res == 2 and avail_in.value == 0):
                    break
    libdec.BrotliDecoderDestroyInstance(state)

def parse_transfer_list(transfer_list_path):
    with open(transfer_list_path, "r") as f:
        lines = [l.strip() for l in f.readlines() if l.strip()]
    version = int(lines[0])
    start_idx = 4 if version >= 2 else 2
    commands = []
    max_block = 0
    for line in lines[start_idx:]:
        parts = line.split(" ")
        cmd = parts[0]
        if cmd in ("new", "zero", "erase"):
            nums = [int(x) for x in parts[1].split(",")]
            pairs = list(zip(nums[1::2], nums[2::2]))
            for b0, b1 in pairs:
                if b1 > max_block:
                    max_block = b1
            commands.append((cmd, pairs))
    return commands, max_block

def sdat2img(transfer_list_path, new_dat_path, out_img_path):
    BLOCK_SIZE = 4096
    commands, max_block = parse_transfer_list(transfer_list_path)
    with open(new_dat_path, "rb") as fdat, open(out_img_path, "wb") as fout:
        fout.truncate(max_block * BLOCK_SIZE)
        for cmd, pairs in commands:
            if cmd == "new":
                for b0, b1 in pairs:
                    fout.seek(b0 * BLOCK_SIZE)
                    to_read = (b1 - b0) * BLOCK_SIZE
                    while to_read > 0:
                        chunk = fdat.read(min(to_read, 4 * 1024 * 1024))
                        if not chunk:
                            raise RuntimeError("EOF inesperado en new.dat")
                        fout.write(chunk)
                        to_read -= len(chunk)

def br2img(transfer_list_path, br_path, out_img_path):
    BLOCK_SIZE = 4096
    commands, max_block = parse_transfer_list(transfer_list_path)
    new_ranges = []
    for cmd, pairs in commands:
        if cmd == "new":
            for b0, b1 in pairs:
                new_ranges.append((b0 * BLOCK_SIZE, (b1 - b0) * BLOCK_SIZE))

    state = libdec.BrotliDecoderCreateInstance(None, None, None)
    CHUNK = 8 * 1024 * 1024
    out_buf = ctypes.create_string_buffer(CHUNK)

    with open(br_path, "rb") as fbr, open(out_img_path, "wb") as fimg:
        fimg.truncate(max_block * BLOCK_SIZE)
        cur_range_idx = 0
        cur_range_written = 0

        while cur_range_idx < len(new_ranges):
            data = fbr.read(CHUNK)
            if not data:
                break
            in_buf = ctypes.create_string_buffer(data)
            avail_in = ctypes.c_size_t(len(data))
            next_in = ctypes.cast(in_buf, ctypes.c_char_p)
            while avail_in.value > 0 or cur_range_idx < len(new_ranges):
                avail_out = ctypes.c_size_t(CHUNK)
                next_out = ctypes.cast(out_buf, ctypes.c_char_p)
                res = libdec.BrotliDecoderDecompressStream(
                    state,
                    ctypes.byref(avail_in),
                    ctypes.byref(next_in),
                    ctypes.byref(avail_out),
                    ctypes.byref(next_out),
                    None
                )
                produced = CHUNK - avail_out.value
                if produced > 0:
                    prod_offset = 0
                    while prod_offset < produced and cur_range_idx < len(new_ranges):
                        off, sz = new_ranges[cur_range_idx]
                        rem = sz - cur_range_written
                        chunk_to_write = min(rem, produced - prod_offset)
                        fimg.seek(off + cur_range_written)
                        fimg.write(out_buf.raw[prod_offset : prod_offset + chunk_to_write])
                        cur_range_written += chunk_to_write
                        prod_offset += chunk_to_write
                        if cur_range_written == sz:
                            cur_range_idx += 1
                            cur_range_written = 0
                if res == 0:
                    raise RuntimeError("Fallo en decodificacion Brotli")
                if res == 1 or (res == 2 and avail_in.value == 0):
                    break

    libdec.BrotliDecoderDestroyInstance(state)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(f"Uso: python3 {sys.argv[0]} decompress <archivo.br> <salida>")
        print(f"     python3 {sys.argv[0]} sdat2img <transfer.list> <new.dat> <salida.img>")
        print(f"     python3 {sys.argv[0]} br2img <transfer.list> <new.dat.br> <salida.img>")
        sys.exit(1)
    action = sys.argv[1]
    if action == "decompress":
        decompress_br(sys.argv[2], sys.argv[3])
    elif action == "sdat2img":
        sdat2img(sys.argv[2], sys.argv[3], sys.argv[4])
    elif action == "br2img":
        br2img(sys.argv[2], sys.argv[3], sys.argv[4])
