#!/usr/bin/env python3
# ==============================================================================
# img2br.py - Compresor streaming de imagen a nuevo formato .new.dat.br
# Licencia: MIT
# ==============================================================================

import ctypes
import time
import sys
import os
from br_sdat import parse_transfer_list

BLOCK_SIZE = 4096

libenc = ctypes.CDLL("/usr/lib64/libbrotlienc.so.1")
libenc.BrotliEncoderCreateInstance.restype = ctypes.c_void_p
libenc.BrotliEncoderCreateInstance.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
libenc.BrotliEncoderSetParameter.restype = ctypes.c_int
libenc.BrotliEncoderSetParameter.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_uint32]
libenc.BrotliEncoderCompressStream.restype = ctypes.c_int
libenc.BrotliEncoderCompressStream.argtypes = [
    ctypes.c_void_p, ctypes.c_int,
    ctypes.POINTER(ctypes.c_size_t), ctypes.POINTER(ctypes.c_char_p),
    ctypes.POINTER(ctypes.c_size_t), ctypes.POINTER(ctypes.c_char_p),
    ctypes.POINTER(ctypes.c_size_t)
]
libenc.BrotliEncoderIsFinished.restype = ctypes.c_int
libenc.BrotliEncoderIsFinished.argtypes = [ctypes.c_void_p]
libenc.BrotliEncoderDestroyInstance.argtypes = [ctypes.c_void_p]

BROTLI_OPERATION_PROCESS = 0
BROTLI_OPERATION_FINISH = 2
BROTLI_PARAM_QUALITY = 1
BROTLI_PARAM_LGWIN = 2

def img2br(transfer_list_path, img_path, out_br_path, quality=5):
    t0 = time.time()
    commands, _ = parse_transfer_list(transfer_list_path)
    new_ranges = []
    total_bytes = 0
    for cmd, pairs in commands:
        if cmd == "new":
            for b0, b1 in pairs:
                sz = (b1 - b0) * BLOCK_SIZE
                new_ranges.append((b0 * BLOCK_SIZE, sz))
                total_bytes += sz

    print(f"[*] Total bytes utiles a comprimir: {total_bytes:,} ({len(new_ranges)} rangos)")
    state = libenc.BrotliEncoderCreateInstance(None, None, None)
    libenc.BrotliEncoderSetParameter(state, BROTLI_PARAM_QUALITY, quality)
    libenc.BrotliEncoderSetParameter(state, BROTLI_PARAM_LGWIN, 24)

    OUT_CHUNK = 4 * 1024 * 1024
    out_buf = ctypes.create_string_buffer(OUT_CHUNK)
    written_br = 0

    with open(img_path, "rb") as fimg, open(out_br_path, "wb") as fbr:
        for off, sz in new_ranges:
            fimg.seek(off)
            rem = sz
            while rem > 0:
                chunk = fimg.read(min(rem, 4 * 1024 * 1024))
                rem -= len(chunk)
                in_buf = ctypes.create_string_buffer(chunk)
                avail_in = ctypes.c_size_t(len(chunk))
                next_in = ctypes.cast(in_buf, ctypes.c_char_p)
                while avail_in.value > 0:
                    avail_out = ctypes.c_size_t(OUT_CHUNK)
                    next_out = ctypes.cast(out_buf, ctypes.c_char_p)
                    ok = libenc.BrotliEncoderCompressStream(
                        state, BROTLI_OPERATION_PROCESS,
                        ctypes.byref(avail_in), ctypes.byref(next_in),
                        ctypes.byref(avail_out), ctypes.byref(next_out),
                        None
                    )
                    if not ok:
                        raise RuntimeError("Fallo en BrotliEncoderCompressStream PROCESS")
                    produced = OUT_CHUNK - avail_out.value
                    if produced > 0:
                        fbr.write(out_buf.raw[:produced])
                        written_br += produced

        avail_in = ctypes.c_size_t(0)
        next_in = ctypes.c_char_p(None)
        while not libenc.BrotliEncoderIsFinished(state):
            avail_out = ctypes.c_size_t(OUT_CHUNK)
            next_out = ctypes.cast(out_buf, ctypes.c_char_p)
            ok = libenc.BrotliEncoderCompressStream(
                state, BROTLI_OPERATION_FINISH,
                ctypes.byref(avail_in), ctypes.byref(next_in),
                ctypes.byref(avail_out), ctypes.byref(next_out),
                None
            )
            if not ok:
                raise RuntimeError("Fallo en BrotliEncoderCompressStream FINISH")
            produced = OUT_CHUNK - avail_out.value
            if produced > 0:
                fbr.write(out_buf.raw[:produced])
                written_br += produced

    libenc.BrotliEncoderDestroyInstance(state)
    dt = time.time() - t0
    print(f"[+] Generado {out_br_path}: {written_br:,} bytes en {dt:.2f}s")

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print(f"Uso: python3 {sys.argv[0]} <transfer.list> <imagen.img> <salida.new.dat.br> [calidad]")
        sys.exit(1)
    q = int(sys.argv[4]) if len(sys.argv) > 4 else 5
    img2br(sys.argv[1], sys.argv[2], sys.argv[3], quality=q)
