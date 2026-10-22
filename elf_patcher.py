#!/usr/bin/env python3
"""
Vector de Ataque B - ELF Patcher (Keymaster)
=============================================

Base de parcheo con LIEF + Capstone + Keystone para neutralizar la
comprobacion de KM_TAG_SAMSUNG_ROT_REQUIRED en libkm_compat.so (o
libpuresoftkeymasterdevice.so).

Racional: KM_TAG_SAMSUNG_ROT_REQUIRED es un vendor tag Samsung de 32 bits
(0x8000xxxx). En ARM64 una constante asi NO se materializa con un solo
'mov'; se almacena en .rodata y se carga por:
    (a) LDR literal      -> ldr wN, [pc, #imm]
    (b) ADRP + ADD/LDR   -> adrp xN, #page ; ldr wN, [xN, #off]
Por eso, en vez de buscar inmediatos, buscamos la CONSTANTE en los bytes
del binario (little-endian uint32) y luego localizamos las referencias a
esa direccion (xrefs) y el salto condicional que sigue al 'cmp'.

Modos de uso:
    # 1) Enumerar todas las constantes vendor Samsung presentes en el .so
    python3 elf_patcher.py libkm_compat.so --scan

    # 2) Diagnosticar (sin escribir) el sitio del tag y su branch
    python3 elf_patcher.py libkm_compat.so --tag 0x80000010

    # 3) Aplicar: NOP sobre el branch condicional asociado al tag
    python3 elf_patcher.py libkm_compat.so --tag 0x80000010 --apply \
        -o libkm_compat_patched.so

    # 4) Alternativa: forzar return 0 de la funcion completa
    python3 elf_patcher.py libkm_compat.so \
        --patch-func convertKeyParametersToLegacy --apply -o out.so
"""

import argparse
import sys
import struct
from dataclasses import dataclass

import lief
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM
from capstone.arm64_const import (
    ARM64_INS_CMP,
    ARM64_INS_CBNZ,
    ARM64_INS_CBZ,
    ARM64_INS_TBNZ,
    ARM64_INS_TBZ,
    ARM64_INS_B,
    ARM64_INS_LDR,
    ARM64_INS_ADRP,
    ARM64_INS_ADD,
    ARM64_INS_MOV,
    ARM64_INS_MOVZ,
    ARM64_INS_MOVK,
    ARM64_OP_IMM,
    ARM64_OP_MEM,
    ARM64_OP_REG,
    ARM64_CC_INVALID,
    ARM64_CC_AL,
    ARM64_CC_EQ,
    ARM64_CC_NE,
)
from keystone import Ks, KS_ARCH_ARM64, KS_MODE_LITTLE_ENDIAN

SAMSUNG_VENDOR_MIN = 0x80000000
SAMSUNG_VENDOR_MAX = 0x8000FFFF

_ks = Ks(KS_ARCH_ARM64, KS_MODE_LITTLE_ENDIAN)


def asm(instruction: str, addr: int = 0) -> bytes:
    """Ensambla una o varias instrucciones ARM64 a bytes.

    addr es la direccion de la primera instruccion (para calcular offsets de
    saltos relativos con keystone).
    """
    encoding, count = _ks.asm(instruction, addr=addr)
    assert count >= 1, f"fallo al ensamblar: {instruction}"
    return bytes(encoding)


@dataclass
class Xref:
    vaddr: int
    mnemonic: str
    op_str: str


def segments_bytes(binary):
    """Yield (vaddr, bytes) de todos los segmentos con contenido."""
    for seg in binary.segments:
        content = bytes(seg.content)
        if content:
            yield seg.virtual_address, content


def executable_sections(binary):
    """Yield (vaddr, bytes) de cada segmento PT_LOAD ejecutable (RX)."""
    for seg in binary.segments:
        if not (seg.flags & lief.ELF.Segment.FLAGS.X):
            continue
        content = bytes(seg.content)
        if content:
            yield seg.virtual_address, content


def disassemble(binary):
    md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
    md.detail = True
    md.skipdata = True
    out = []
    # 1) Preferir secciones ejecutables (binarios .so reales)
    sources = []
    if binary.header.numberof_sections > 0:
        # OJO: LIEF 1.x -> `Section.flags` es int plano, `Section.FLAGS` es enum.
        execinstr = int(lief.ELF.Section.FLAGS.EXECINSTR)
        for sec in binary.sections:
            if not sec.size:
                continue
            if int(sec.flags) & execinstr:
                content = bytes(sec.content)
                if content:
                    sources.append((sec.virtual_address, content))
    # 2) Fallback: segmentos ejecutables (o binarios sin section headers)
    if not sources:
        sources = list(executable_sections(binary))
    for vaddr, content in sources:
        for ins in md.disasm(content, vaddr):
            if ins.id == 0:  # skipdata (bytes no decodificados)
                continue
            out.append(ins)
    return out


def search_le_uint32(binary, value):
    """Busca la constante value (uint32 LE) en TODOS los segmentos."""
    needle = struct.pack("<I", value & 0xFFFFFFFF)
    hits = []
    for vaddr, data in segments_bytes(binary):
        start = 0
        while True:
            idx = data.find(needle, start)
            if idx == -1:
                break
            hits.append(vaddr + idx)
            start = idx + 1
    return hits


def scan_vendor_constants(binary):
    """Enumera todo uint32 LE en rango vendor Samsung, con sus vaddrs."""
    from collections import defaultdict
    found = defaultdict(list)
    for vaddr, data in segments_bytes(binary):
        for i in range(0, len(data) - 3, 4):
            val = struct.unpack_from("<I", data, i)[0]
            if SAMSUNG_VENDOR_MIN <= val <= SAMSUNG_VENDOR_MAX:
                found[val].append(vaddr + i)
    return found


def find_immediate_sites(instructions, value):
    """Instrucciones que materializan/comparan el valor 0x8000xxxx.

    capstone reporta inmediatos como signed; enmascaramos a 32 bits.
    Captura: (a) 'mov w1, #0x8000xxxx' alias de movz con shift, (b) 'cmp',
    (c) pares movz+movk que reconstruyen el valor en dos pasos.
    """
    mask = value & 0xFFFFFFFF
    hits = []
    for i, ins in enumerate(instructions):
        # (a)/(b) inmediato directo de 32 bits
        if any(op.type == ARM64_OP_IMM and (op.imm & 0xFFFFFFFF) == mask
               for op in ins.operands):
            hits.append(Xref(ins.address, ins.mnemonic, ins.op_str))
            continue
        # (c) movz/movk de 16 bits que reconstruyen el valor
        if ins.id in (ARM64_INS_MOV, ARM64_INS_MOVZ):
            if len(ins.operands) < 2 or ins.operands[0].type != ARM64_OP_REG \
                    or ins.operands[1].type != ARM64_OP_IMM:
                continue
            reg = ins.operands[0].reg
            shift = ins.operands[1].shift.value if ins.operands[1].shift else 0
            acc = (ins.operands[1].imm & 0xFFFF) << shift
            j = i + 1
            while j < len(instructions) and j < i + 3:
                nxt = instructions[j]
                if nxt.id == ARM64_INS_MOVK and len(nxt.operands) >= 2 \
                        and nxt.operands[0].type == ARM64_OP_REG \
                        and nxt.operands[0].reg == reg \
                        and nxt.operands[1].type == ARM64_OP_IMM:
                    s = nxt.operands[1].shift.value if nxt.operands[1].shift else 0
                    acc |= (nxt.operands[1].imm & 0xFFFF) << s
                    j += 1
                    continue
                break
            if acc & 0xFFFFFFFF == mask:
                hits.append(Xref(ins.address, ins.mnemonic, ins.op_str))
    return hits


def is_conditional_branch(ins) -> bool:
    if ins.id in (ARM64_INS_CBNZ, ARM64_INS_CBZ, ARM64_INS_TBNZ, ARM64_INS_TBZ):
        return True
    if ins.id == ARM64_INS_B:
        # b.cond : cc es un condicional real (no AL=15 ni INVALID=0)
        return ins.cc not in (ARM64_CC_INVALID, ARM64_CC_AL)
    return False


def find_xrefs(instructions, target_addrs):
    """Localiza instrucciones que referencian una direccion .rodata.

    Cubre:
      (a) LDR literal:  target = align(pc,4) + disp
      (b) ADRP xN, page  seguido (ventana corta) de ADD/LDR con el offset
    """
    targets = set(target_addrs)
    xrefs = []

    for i, ins in enumerate(instructions):
        if ins.id == ARM64_INS_LDR and len(ins.operands) >= 2:
            # LDR literal: el operando inmediato puede ser el desplazamiento
            # pc-relativo O la direccion absoluta ya resuelta (segun version
            # de capstone). Comprobamos ambas interpretaciones.
            if ins.operands[1].type == ARM64_OP_IMM:
                imm = ins.operands[1].imm & 0xFFFFFFFFFFFFFFFF
                as_disp = (ins.address & ~0x3) + imm
                if as_disp in targets or imm in targets:
                    xrefs.append(Xref(ins.address, ins.mnemonic, ins.op_str))
                    continue
        if ins.id == ARM64_INS_ADRP and ins.operands and \
                ins.operands[1].type == ARM64_OP_IMM:
            page = ins.operands[1].imm  # capstone ya resuelve la pagina
            reg = ins.operands[0].reg
            # buscar en ventana siguiente el ADD/LDR que completa la direccion
            for j in range(i + 1, min(i + 4, len(instructions))):
                cand = instructions[j]
                if cand.id in (ARM64_INS_ADD, ARM64_INS_LDR) and len(cand.operands) >= 2:
                    disp = None
                    if cand.operands[-1].type == ARM64_OP_IMM:
                        disp = cand.operands[-1].imm
                    elif cand.operands[-1].type == ARM64_OP_MEM:
                        disp = cand.operands[-1].mem.disp
                    if disp is not None and (page + disp) in targets:
                        xrefs.append(Xref(cand.address, cand.mnemonic, cand.op_str))
                        break
    return xrefs


def find_cmp_and_branch(instructions, xref_addr, window=6):
    """Dado un xref (ldr de la constante), halla el cmp y el branch condicional."""
    by_addr = {ins.address: i for i, ins in enumerate(instructions)}
    i = by_addr.get(xref_addr)
    if i is None:
        return None, None
    for j in range(i + 1, min(i + 1 + window, len(instructions))):
        ins = instructions[j]
        if ins.id == ARM64_INS_CMP:
            for k in range(j + 1, min(j + 1 + window, len(instructions))):
                if is_conditional_branch(instructions[k]):
                    return ins, instructions[k]
            return ins, None
    return None, None


def patch_branch(binary, branch):
    """Neutraliza un branch condicional segun su polaridad y devuelve descripcion.

    Suposicion estandar: el path del tag ROT es el "malo".
      * b.ne (salta cuando NO es el tag): el fall-through es el path malo
        -> lo convertimos en 'b' incondicional (siempre salta a la rama segura).
      * b.eq (salta cuando SI es el tag): el destino es el path malo
        -> NOP para que siempre caiga a la rama segura.
      * resto (cbz/cbnz/tbz/tbnz): NOP por defecto (verificar manualmente).
    """
    if branch is None:
        return "sin branch"
    cc = getattr(branch, "cc", ARM64_CC_INVALID)
    if branch.id == ARM64_INS_B and cc == ARM64_CC_NE:
        target = branch.operands[0].imm
        code = asm(f"b {target:#x}", addr=branch.address)
        binary.patch_address(branch.address, list(code))
        return "b.ne -> b (incondicional a la rama segura)"
    code = asm("nop")
    binary.patch_address(branch.address, list(code))
    if branch.id == ARM64_INS_B and cc == ARM64_CC_EQ:
        return "b.eq -> NOP"
    return f"{branch.mnemonic} (cc={cc}) -> NOP [verificar polaridad]"


def neutralize_tag(binary, tag_value, apply=False, window=8):
    """Pipeline completo: constante -> xrefs/sitios -> cmp/branch -> NOP."""
    instrs = disassemble(binary)

    # (A) sitios inmediatos (mov/movz/movk/cmp directo con el valor)
    sites = find_immediate_sites(instrs, tag_value)

    # (B) almacenamiento en .rodata + xrefs (ldr literal / adrp)
    storage = search_le_uint32(binary, tag_value)
    xrefs = find_xrefs(instrs, storage)
    sites.extend(xrefs)

    # deduplicar por direccion
    seen = set()
    unique = []
    for s in sites:
        if s.vaddr not in seen:
            seen.add(s.vaddr)
            unique.append(s)

    results = []
    for site in unique:
        cmp_ins, branch = find_cmp_and_branch(instrs, site.vaddr, window)
        action = None
        if branch is not None and apply:
            action = patch_branch(binary, branch)
        results.append((site, cmp_ins, branch, action))
    return results if results else None


def resolve_function_address(binary, func_name):
    """Devuelve la vaddr de una funcion, o 0 si no existe."""
    func = binary.get_function_address(func_name)
    if isinstance(func, int):
        return func
    for sym in binary.symbols:
        if sym.name == func_name and sym.value:
            return sym.value
    for sym in binary.dynamic_symbols:
        if sym.name == func_name and sym.value:
            return sym.value
    return 0


def patch_function_return_zero(binary, func_name, apply=False):
    """Fuerza que <func_name> retorne 0 inmediatamente (mov w0,#0; ret)."""
    func = resolve_function_address(binary, func_name)
    if not func:
        raise RuntimeError(f"no se encontro el simbolo {func_name!r}")
    prologue = asm("mov w0, #0; ret")
    if apply:
        binary.patch_address(func, list(prologue))
    return func


def main():
    ap = argparse.ArgumentParser(
        description="ELF Patcher: neutralizar KM_TAG_SAMSUNG_ROT_REQUIRED"
    )
    ap.add_argument("binary", help="ruta a libkm_compat.so o similar")
    ap.add_argument("-o", "--output", help="archivo de salida parcheado")
    ap.add_argument("--tag", help="constante del tag (hex 0x... o decimal)")
    ap.add_argument("--scan", action="store_true",
                    help="enumerar constantes vendor Samsung (uint32 LE)")
    ap.add_argument("--patch-func", help="forzar return 0 de esta funcion")
    ap.add_argument("--apply", action="store_true",
                    help="aplicar el parche de verdad (escribe con -o)")
    args = ap.parse_args()

    binary = lief.ELF.parse(args.binary)

    if args.scan:
        tags = scan_vendor_constants(binary)
        print(f"[+] {len(tags)} constantes vendor distintas:\n")
        for val in sorted(tags):
            addrs = tags[val]
            print(f"    0x{val:08x}  ({len(addrs)} sitio(s), "
                  f"ej: {', '.join(hex(a) for a in addrs[:4])})")
        return 0

    if args.tag:
        tag = int(args.tag, 0)
        results = neutralize_tag(binary, tag, apply=args.apply)
        if results is None:
            print(f"[!] La constante 0x{tag:08x} no aparece en el binario.",
                  file=sys.stderr)
            print("    Prueba --scan para listar los tags reales.", file=sys.stderr)
            return 2
        if not results:
            print(f"[!] Constante 0x{tag:08x} hallada pero sin xrefs resolubles.",
                  file=sys.stderr)
            return 3
        for site, cmp_ins, branch, action in results:
            print(f"[+] xref  @0x{site.vaddr:x}: {site.mnemonic} {site.op_str}")
            if cmp_ins is not None:
                print(f"    cmp   @0x{cmp_ins.address:x}: {cmp_ins.op_str}")
            if branch is not None:
                print(f"    branch @0x{branch.address:x}: "
                      f"{branch.mnemonic} {branch.op_str}")
            if action:
                print(f"    accion: {action}")

    if args.patch_func:
        addr = patch_function_return_zero(binary, args.patch_func, apply=args.apply)
        print(f"[+] {args.patch_func} @0x{addr:x} -> mov w0,#0; ret "
              f"{'(aplicado)' if args.apply else '(dry-run)'}")

    if args.apply and args.output:
        binary.write(args.output)
        print(f"[+] binario parcheado escrito en {args.output}")
    elif not args.apply:
        print("[i] dry-run: usa --apply y -o salida para escribir cambios")
    return 0


if __name__ == "__main__":
    sys.exit(main())
