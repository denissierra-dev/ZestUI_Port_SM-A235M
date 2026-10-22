#!/usr/bin/env python3
# ==============================================================================
# patch_vendor.py - Parcheador in-place de inodos F2FS para vendor.img
# Permite modificar fstab, scripts rc y binarios ELF dentro de F2FS sin root.
# Licencia: MIT
# ==============================================================================

import struct
import math
import sys
import os

BLOCK_SIZE = 4096

def read_f2fs_inode(f, ino_blk):
    f.seek(ino_blk * BLOCK_SIZE)
    blk = bytearray(f.read(BLOCK_SIZE))
    i_mode, i_advise, i_inline = struct.unpack("<HBB", blk[0:4])
    i_size = struct.unpack("<Q", blk[16:24])[0]
    i_namelen = struct.unpack("<I", blk[88:92])[0]
    name = blk[92:92+i_namelen].decode("utf-8", errors="replace")
    extra_isize = struct.unpack("<H", blk[360:362])[0] if (i_inline & 0x20) else 0
    data_start = 360 + extra_isize
    if i_inline & 0x02:
        data = bytes(blk[data_start+4 : data_start+4+i_size])
        return name, i_inline, i_size, data_start, None, data
    else:
        assert not (i_inline & 0x04), f"Inodo {name} ({ino_blk}) esta comprimido!"
        nblocks = math.ceil(i_size / BLOCK_SIZE)
        addrs = list(struct.unpack(f"<{nblocks}I", blk[data_start : data_start + 4*nblocks]))
        out = bytearray()
        for a in addrs:
            assert a not in (0, 0xffffffff, 0xfffffffe), f"Bloque invalido {a} en {name}"
            f.seek(a * BLOCK_SIZE)
            out.extend(f.read(BLOCK_SIZE))
        return name, i_inline, i_size, data_start, addrs, bytes(out[:i_size])

def write_f2fs_inode(f, ino_blk, new_data):
    name, i_inline, old_size, data_start, addrs, old_data = read_f2fs_inode(f, ino_blk)
    new_size = len(new_data)
    f.seek(ino_blk * BLOCK_SIZE)
    blk = bytearray(f.read(BLOCK_SIZE))

    if i_inline & 0x02:
        max_inline = (BLOCK_SIZE - 24) - (data_start + 4)
        assert new_size <= max_inline, f"Desbordamiento inline para {name}: {new_size} > {max_inline}"
        clear_len = max(old_size, new_size)
        blk[data_start+4 : data_start+4+clear_len] = b"\x00" * clear_len
        blk[data_start+4 : data_start+4+new_size] = new_data
    else:
        old_nblocks = math.ceil(old_size / BLOCK_SIZE)
        new_nblocks = math.ceil(new_size / BLOCK_SIZE)
        assert new_nblocks == old_nblocks, f"Discrepancia de bloques para {name}: {new_nblocks} != {old_nblocks}"
        padded = new_data + b"\x00" * (new_nblocks * BLOCK_SIZE - new_size)
        for idx, a in enumerate(addrs):
            f.seek(a * BLOCK_SIZE)
            f.write(padded[idx*BLOCK_SIZE : (idx+1)*BLOCK_SIZE])

    struct.pack_into("<Q", blk, 16, new_size)
    f.seek(ino_blk * BLOCK_SIZE)
    f.write(blk)
    print(f"[OK] Actualizado inodo {name} (bloque {ino_blk}): {old_size} -> {new_size} bytes")

def transform_fstab_to_ufs(text):
    lines = []
    for line in text.splitlines():
        s = line.strip()
        if not s or s.startswith("#"):
            lines.append(line)
            continue
        # Mapeo a ruta absoluta del controlador UFS en Snapdragon 680
        line = line.replace("/dev/block/bootdevice/by-name/", "/dev/block/platform/soc/4804000.ufshc/by-name/")
        line = line.replace("/dev/block/by-name/", "/dev/block/platform/soc/4804000.ufshc/by-name/")
        # Remocion de descriptores de AVB
        line = line.replace(",avb=vbmeta_system", "").replace("avb=vbmeta_system,", "")
        line = line.replace(",avb_keys=/avb/q-gsi.avbpubkey:/avb/r-gsi.avbpubkey:/avb/s-gsi.avbpubkey", "")
        line = line.replace(",avb,", ",").replace(",avb", "")
        # Ajuste de doble coma y adición de sysfs_path para UFS
        if "/data\tf2fs" in line or "/data " in line:
            line = line.replace("check,,fileencryption", "check,fileencryption")
            if "sysfs_path=" not in line:
                line = line + ",sysfs_path=/sys/devices/platform/soc/4804000.ufshc"
        lines.append(line)
    return "\n".join(lines) + "\n"

def patch_vendor_image(vendor_img_path):
    print(f"[*] Abriendo particion vendor: {vendor_img_path}")
    with open(vendor_img_path, "r+b") as f:
        # 1. Parche binario del HAL android.hardware.keymaster@4.0-service (inodo 3930)
        name, _, sz, _, _, km_data = read_f2fs_inode(f, 3930)
        assert name == "android.hardware.keymaster@4.0-service" and sz == 15992
        km = bytearray(km_data)
        
        # Redireccionar DT_NEEDED dyn[8] a libkeymaster4.so (offset 0x450)
        struct.pack_into("<Q", km, 0x30b8, 0x450)
        # Reubicar "__cfi_slowpath\0" a dynstr+0x483 (offset de archivo 0xa9f)
        km[0xa9f:0xa9f+24] = b"__cfi_slowpath\x00".ljust(24, b"\x00")
        # Actualizar dynsym[8].st_name a 0x483
        struct.pack_into("<I", km, 0x3b8, 0x483)
        # Inyectar simbolo CreateKeymasterDevice de AOSP en dynstr+0xef (offset 0x70b)
        target_sym = b"_ZN9keymaster4V4_02ng21CreateKeymasterDeviceEN7android8hardware9keymaster4V4_013SecurityLevelE\x00"
        km[0x70b:0x70b+105] = target_sym.ljust(105, b"\x00")
        # NOP de la comprobación CFI (bl __cfi_slowpath) en offset 0x10fc
        km[0x10fc:0x1100] = bytes.fromhex("1f2003d5")
        write_f2fs_inode(f, 3930, bytes(km))

        # 2. Parchear tablas fstab (inodos 4022 y 4023)
        _, _, _, _, _, fstab_raw = read_f2fs_inode(f, 4022)
        fixed_fstab = transform_fstab_to_ufs(fstab_raw.decode("utf-8")).encode("utf-8")
        write_f2fs_inode(f, 4022, fixed_fstab)
        write_f2fs_inode(f, 4023, fixed_fstab)

        # 3. Parchear charger_fstab.qti (inodo 4008)
        _, _, _, _, _, chg_raw = read_f2fs_inode(f, 4008)
        chg_fixed = chg_raw.decode("utf-8").replace(
            "/dev/block/bootdevice/by-name/persist",
            "/dev/block/platform/soc/4804000.ufshc/by-name/persist"
        ).encode("utf-8")
        write_f2fs_inode(f, 4008, chg_fixed)

        # 4. Parchear init.target.rc (inodo 9426) - symlink temprano de bootdevice
        _, _, _, _, _, trc_raw = read_f2fs_inode(f, 9426)
        trc = trc_raw.decode("utf-8")
        if "symlink /dev/block/platform/soc/4804000.ufshc /dev/block/bootdevice" not in trc:
            trc = trc.replace(
                "on early-init\n",
                "on early-init\n    symlink /dev/block/platform/soc/4804000.ufshc /dev/block/bootdevice\n"
            )
        trc = trc.replace(
            "    wait /dev/block/platform/soc/${ro.boot.bootdevice}\n    symlink /dev/block/platform/soc/${ro.boot.bootdevice} /dev/block/bootdevice",
            "    wait /dev/block/platform/soc/4804000.ufshc\n    symlink /dev/block/platform/soc/4804000.ufshc /dev/block/bootdevice"
        )
        write_f2fs_inode(f, 9426, trc.encode("utf-8"))

        # 5. Parchear init.samsung.bsp.rc e init.samsung.rc (inodos 9422 y 9425)
        _, _, _, _, _, bsp_raw = read_f2fs_inode(f, 9422)
        bsp = bsp_raw.decode("utf-8")
        if "symlink /dev/block/platform/soc/4804000.ufshc /dev/block/bootdevice" not in bsp:
            bsp = bsp.replace(
                "on early-init\n",
                "on early-init\n    symlink /dev/block/platform/soc/4804000.ufshc /dev/block/bootdevice\n"
            )
        bsp = bsp.replace(
            "symlink /dev/block/bootdevice/by-name/param /dev/block/param",
            "symlink /dev/block/platform/soc/4804000.ufshc/by-name/param /dev/block/param"
        )
        write_f2fs_inode(f, 9422, bsp.encode("utf-8"))

        _, _, _, _, _, sam_raw = read_f2fs_inode(f, 9425)
        sam = sam_raw.decode("utf-8").replace(
            "symlink /dev/block/by-name/steady /dev/block/steady\n    symlink /dev/block/by-name/persistent /dev/block/persistent",
            "symlink /dev/block/platform/soc/4804000.ufshc/by-name/steady /dev/block/steady\n    symlink /dev/block/platform/soc/4804000.ufshc/by-name/persistent /dev/block/persistent"
        )
        write_f2fs_inode(f, 9425, sam.encode("utf-8"))

        # 6. Neutralizacion de servicios Knox / TrustZone
        # pa_daemon_qsee.rc (proca, inodo 9365)
        _, _, _, _, _, pa_raw = read_f2fs_inode(f, 9365)
        write_f2fs_inode(f, 9365, pa_raw.decode("utf-8").replace("    start proca", "    #start proca").encode("utf-8"))

        # vaultkeeper_common.rc (inodo 9371) y manifest (inodo 9605)
        _, _, _, _, _, vk_raw = read_f2fs_inode(f, 9371)
        write_f2fs_inode(f, 9371, vk_raw.decode("utf-8").replace("    start vaultkeeper\n    start vaultkeeper_hal", "    #start vaultkeeper\n    #start vaultkeeper_hal").encode("utf-8"))
        write_f2fs_inode(f, 9605, b'<manifest version="1.0" type="device">\n</manifest>\n')

        # fkeymaster-service.rc (inodo 9396) y manifest (inodo 9612)
        _, _, _, _, _, fkm_raw = read_f2fs_inode(f, 9396)
        fkm_rc = fkm_raw.decode("utf-8")
        if "disabled" not in fkm_rc:
            fkm_rc = fkm_rc.rstrip() + "\n    disabled\n"
        write_f2fs_inode(f, 9396, fkm_rc.encode("utf-8"))
        write_f2fs_inode(f, 9612, b'<manifest version="1.0" type="device">\n</manifest>\n')

        # 7. Sanitizacion de vendor/build.prop (inodo 3590)
        _, _, _, _, _, bp_raw = read_f2fs_inode(f, 3590)
        bp = bp_raw.decode("utf-8").replace("ro.security.keystore.keytype=sakv2,gak,", "ro.security.keystore.keytype=")
        write_f2fs_inode(f, 3590, bp.encode("utf-8"))

    print("[+] Particion vendor parcheada exitosamente!")

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "vendor.img"
    if not os.path.isfile(target):
        print(f"Uso: python3 {sys.argv[0]} <ruta_a_vendor.img>")
        sys.exit(1)
    patch_vendor_image(target)
