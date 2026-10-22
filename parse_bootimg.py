#!/usr/bin/env python3
"""Parser de Android boot image v0-v3 -> extraccion de kernel/ramdisk."""
import struct, sys, os

def parse(path, outdir):
    d = open(path,'rb').read()
    magic = d[:8]
    assert magic == b'ANDROID!', f'magic invalido: {magic!r}'
    (k_size,k_addr,r_size,r_addr,s_size,s_addr,tags,page_sz) = struct.unpack_from('<8I', d, 8)
    hdr_ver = struct.unpack_from('<I', d, 40)[0] if hdr_ver_ok(d) else 0
    name = d[48:64].rstrip(b'\x00').decode('utf-8','replace')
    cmdline = d[64:576].rstrip(b'\x00').decode('utf-8','replace')
    print(f'magic        : {magic!r}')
    print(f'header_ver   : {hdr_ver}')
    print(f'kernel_size  : 0x{k_size:x} ({k_size})')
    print(f'ramdisk_size : 0x{r_size:x} ({r_size})')
    print(f'second_size  : 0x{s_size:x}')
    print(f'page_size    : {page_sz}')
    print(f'name         : {name!r}')
    print(f'cmdline      : {cmdline!r}')
    off = page_sz
    os.makedirs(outdir, exist_ok=True)
    if k_size:
        open(os.path.join(outdir,'kernel.img'),'wb').write(d[off:off+k_size]); off += (k_size+page_sz-1)//page_sz*page_sz
        print(f'  -> kernel.img')
    if r_size:
        open(os.path.join(outdir,'ramdisk.img'),'wb').write(d[off:off+r_size]); off += (r_size+page_sz-1)//page_sz*page_sz
        print(f'  -> ramdisk.img')
    if s_size:
        open(os.path.join(outdir,'second.img'),'wb').write(d[off:off+s_size]); off += (s_size+page_sz-1)//page_sz*page_sz
        print(f'  -> second.img')
    return cmdline

def hdr_ver_ok(d):
    return len(d) > 40

if __name__ == '__main__':
    parse(sys.argv[1], sys.argv[2])
