#!/usr/bin/env python3
"""
anotate_asm.py - Generador de desensamblado ARM64 anotado para documentación
=============================================================================

Produce un fichero `.asm` legible a partir de un binario ELF AArch64, con:

  * Código y bytes en hexadecimal en cada instrucción.
  * Anotaciones de ABI AAPCS64 (registros de argumento, resultado indirecto,
    registros callee-saved, frame pointer).
  * Resolución de destinos `bl`/`b` a nombres de símbolo cuando existen.
  * Decodificación de constantes de tipo Keymaster (top nibble = keymaster_tag_type_t).
  * Detección de patrones ARM64 de construcción de constantes de 32 bits
    (`movz` + `movk`), que es como el compilador materializa los vendor tags
    Samsung (0x8000xxxx).
  * Marcado de bloques básicos, bucles y saltos condicionales.

Uso:
    python3 annotate_asm.py <binario.so> --func convertKeyParametersToLegacy -o out.asm
    python3 annotate_asm.py <binario.so> --start 0x10b78 --end 0x12bec -o out.asm
    python3 annotate_asm.py <binario.so> --list-syms | head -50

Notas de implementación:
  - LIEF 1.x: `lief.ELF.parse()` devuelve un objeto con `.sections`, `.symbols`
    y `.dynamic_symbols`. La API de errores devuelve `lief.lief_errors` en
    lugar de `None`, por lo que se normaliza con `isinstance(x, int)`.
  - Capstone 5.x aliasa `movz` sin shift a `mov`, y devuelve los inmediatos
    con signo: para comparar un tag de 32 bits hay que enmascarar con 0xFFFFFFFF.
  - `ins.cc` es el código de condición de un `b.cond`; `ins.op_str` NO lo
    incluye (solo el destino), así que el polling de polaridad debe usar `cc`.
"""

import argparse
import struct
import sys

import lief
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM
from capstone.arm64_const import (
    ARM64_INS_B,
    ARM64_INS_BL,
    ARM64_INS_CMP,
    ARM64_INS_CBZ,
    ARM64_INS_CBNZ,
    ARM64_INS_TBZ,
    ARM64_INS_TBNZ,
    ARM64_INS_MOV,
    ARM64_INS_MOVZ,
    ARM64_INS_MOVK,
    ARM64_INS_ADRP,
    ARM64_INS_LDR,
    ARM64_INS_ADD,
    ARM64_INS_RET,
    ARM64_INS_BLR,
    ARM64_INS_BR,
    ARM64_OP_IMM,
    ARM64_OP_MEM,
    ARM64_OP_REG,
    ARM64_CC_INVALID,
    ARM64_CC_AL,
)

# ---------------------------------------------------------------------------
# Tabla de tipos de tag de Keymaster 4.0 (system/core/libkeymaster)
# El nibble superior (bits 31..28) codifica el tipo del valor del parametro.
# ---------------------------------------------------------------------------
KEYMASTER_TAG_TYPES = {
    0x0: "KM_INVALID",
    0x1: "KM_ENUM",
    0x2: "KM_ENUM_REP",
    0x3: "KM_UINT",
    0x4: "KM_UINT_REP",
    0x5: "KM_ULONG",
    0x6: "KM_DATE",
    0x7: "KM_BOOL",
    0x8: "KM_BIGNUM",
    0x9: "KM_BYTES",
    0xA: "KM_ULONG_REP",
    0xB: "KM_RESERVED_B",
    0xC: "KM_RESERVED_C",
    0xD: "KM_RESERVED_D",
    0xE: "KM_RESERVED_E",
    0xF: "KM_RESERVED_F",
}

# Tags de Keymaster 4.0 mas usados, con su ID (parte baja de 32 bits).
# Solo se listan los que se pueden afirmar con certeza; el resto se muestra
# como "ID=0xNNN" sin nombre para no inducir a error.
KEYMASTER_TAG_NAMES = {
    0x00000001: "PURPOSE",
    0x00000002: "ALGORITHM",
    0x00000003: "KEY_SIZE",
    0x00000004: "BLOCK_MODE",
    0x00000005: "DIGEST",
    0x00000006: "PADDING",
    0x00000007: "CALLER_NONCE",
    0x00000008: "MIN_MAC_LENGTH",
    0x0000000A: "EC_CURVE",
    0x0000000B: "MAC_LENGTH",
    0x0000000C: "ROLLBACK_RESISTANCE",
    0x0000000D: "EARLY_BOOT_ONLY",
    0x0000000E: "ACTIVE_DATETIME",
    0x0000000F: "ORIGINATION_EXPIRE_DATE",
    0x00000010: "USAGE_EXPIRE_DATE",
    0x00000011: "ACTIVE_TIMESTAMP",
    0x00000012: "ORIGINATION_EXPIRES",
    0x00000013: "USABLE_EXPIRE_DATE",
    0x00000014: "DEFAULT_DH_PARAMS",
    0x00000015: "IV",
    0x00000016: "KEY_GENERATION_EXPIRATION",
    0x00000017: "BOOT_ONLY",
    0x00000018: "DEVICE_UNIQUE_ATTESTATION",
    0x00000019: "IDENTITY_CREDENTIAL",
    0x0000001A: "STORAGE_KEY",
    0x000000C8: "RSA_PUBLIC_EXPONENT",
    0x000001F4: "RSA_OAEP_MGF_DIGEST",
    0x000003E8: "APPLICATION_ID",
    0x000003E9: "APPLICATION_DATA",
}

# ---------------------------------------------------------------------------
# AAPCS64: registros de uso general
# ---------------------------------------------------------------------------
AAPCS64_ARGS = {
    "x0": "arg0 / puntero de retorno indirecto (x8)",
    "x1": "arg1",
    "x2": "arg2",
    "x3": "arg3",
    "x4": "arg4",
    "x5": "arg5",
    "x6": "arg6",
    "x7": "arg7",
    "x8": "resultado indirecto (sret) + registro temporal",
    "x9": "temporal (platform register)",
    "x10": "temporal (platform register)",
    "x11": "temporal (platform register)",
    "x12": "temporal (platform register)",
    "x13": "temporal (platform register)",
    "x14": "temporal (platform register)",
    "x15": "temporal (platform register)",
    "x16": "temporal / IP0",
    "x17": "temporal / IP1",
    "x18": "temporal (platform register)",
    "x19": "callee-saved",
    "x20": "callee-saved",
    "x21": "callee-saved",
    "x22": "callee-saved",
    "x23": "callee-saved",
    "x24": "callee-saved",
    "x25": "callee-saved",
    "x26": "callee-saved",
    "x27": "callee-saved",
    "x28": "callee-saved",
    "x29": "frame pointer (callee-saved)",
    "x30": "link register / return address (callee-saved)",
}


def decode_tag(value):
    """Devuelve (tipo_keymaster, id_tag, nombre_known) para un tag de 32 bits.

    Rango de tipos segun keymaster_tag_type_t (system/core/libkeymaster):
        0x0..0xA  -> KM_INVALID, KM_ENUM, KM_ENUM_REP, KM_UINT, KM_UINT_REP,
                     KM_ULONG, KM_DATE, KM_BOOL, KM_BIGNUM, KM_BYTES, KM_ULONG_REP
        0xB..0xF  -> RESERVADOS. En KeyMint (AIDL) los tipos >= 0xC0000000 son
                     "vendor specific": es donde Samsung define sus
                     KM_TAG_SAMSUNG_* (ROT_REQUIRED, RKP, KNOX, ...).

    OJO: 0x8xxxxxxx-0xAxxxxxxx NO son vendor, son los tipos estandar
    KM_BIGNUM / KM_BYTES / KM_ULONG_REP. Confundirlos daria falsos positivos.
    """
    v = value & 0xFFFFFFFF
    ttype = (v >> 28) & 0xF
    tag_id = v & 0x0FFFFFFF
    tname = KEYMASTER_TAG_TYPES.get(ttype, "KM_UNKNOWN")
    name = KEYMASTER_TAG_NAMES.get(tag_id)
    return tname, tag_id, name


def is_vendor_tag(value):
    """True si el tag usa un tipo reservado para vendor (>= 0xC0000000)."""
    return (value & 0xFFFFFFFF) >= 0xC0000000


def build_symbol_map(binary):
    """Mapa vaddr -> nombre de simbolo, usando .symtab y .dynsym."""
    syms = {}
    for table in (binary.symbols, binary.dynamic_symbols):
        for s in table:
            if s.value and s.type == lief.ELF.Symbol.TYPE.FUNC and s.name:
                syms.setdefault(s.value, s.name)
    return syms


def resolve_function(binary, name, syms):
    """Busca la vaddr de una funcion por nombre exacto o por prefijo."""
    for table in (binary.symbols, binary.dynamic_symbols):
        for s in table:
            if s.name == name and s.value:
                return s.value
    # busqueda por subcadena sobre nombres mangled
    for table in (binary.symbols, binary.dynamic_symbols):
        for s in table:
            if s.value and name in s.name:
                return s.value
    return None


def disassemble_range(binary, start, end):
    """Desensambla [start, end) usando las secciones ejecutables del ELF."""
    md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
    md.detail = True
    md.skipdata = True

    sources = []
    if binary.header.numberof_sections > 0:
        # OJO: en LIEF 1.x `Section.flags` es un int plano, mientras que
        # `Section.FLAGS.EXECINSTR` es un enum -> hay que normalizar con int().
        execinstr = int(lief.ELF.Section.FLAGS.EXECINSTR)
        for sec in binary.sections:
            if not sec.size:
                continue
            if int(sec.flags) & execinstr:
                content = bytes(sec.content)
                if content:
                    sources.append((sec.virtual_address, content))
    if not sources:
        for seg in binary.segments:
            if seg.flags & lief.ELF.Segment.FLAGS.X:
                content = bytes(seg.content)
                if content:
                    sources.append((seg.virtual_address, content))

    out = []
    for vaddr, content in sources:
        for ins in md.disasm(content, vaddr):
            if ins.id == 0:      # skipdata: bytes no decodificables
                continue
            if end is not None and ins.address >= end:
                return out
            if ins.address >= start:
                out.append(ins)
    return out


def reconstruct_constants(instrs, window=20):
    """Detecta secuencias movz(+movk*) que construyen una constante de 32 bits.

    El compilador NO siempre deja el `movz` y su `movk` adyacentes: puede
    intercalar otras instrucciones o separar el `movk` hasta el final del
    bloque basico (ver caso real: 0x10be4 `mov w28,#0x192` + 0x10bf4
    `movk w28,#0x3000,lsl#16`). Por eso se barre una ventana de instrucciones
    y se detiene en cuanto el registro destino vuelve a escribirse.

    Devuelve dict {addr_movz: (valor_32bit, [instrucciones_movk], reg_destino)}.
    """
    consts = {}
    for i, ins in enumerate(instrs):
        if ins.id not in (ARM64_INS_MOV, ARM64_INS_MOVZ):
            continue
        if len(ins.operands) < 2:
            continue
        if ins.operands[0].type != ARM64_OP_REG or ins.operands[1].type != ARM64_OP_IMM:
            continue
        reg = ins.operands[0].reg
        shift = ins.operands[1].shift.value if ins.operands[1].shift else 0
        acc = (ins.operands[1].imm & 0xFFFF) << shift
        movks = []
        for j in range(i + 1, min(i + 1 + window, len(instrs))):
            nxt = instrs[j]
            if nxt.id == ARM64_INS_MOVK and len(nxt.operands) >= 2 \
                    and nxt.operands[0].type == ARM64_OP_REG \
                    and nxt.operands[0].reg == reg \
                    and nxt.operands[1].type == ARM64_OP_IMM:
                s = nxt.operands[1].shift.value if nxt.operands[1].shift else 0
                acc |= (nxt.operands[1].imm & 0xFFFF) << s
                movks.append(nxt)
                continue
            # el registro vuelve a escribirse -> la construccion se rompe
            if writes_register(nxt, reg):
                break
        if movks:
            consts[ins.address] = (acc & 0xFFFFFFFF, movks, reg)
    return consts


def writes_register(ins, reg):
    """True si la instruccion escribe (destino) el registro `reg`."""
    if ins.id in (ARM64_INS_CMP,):
        return False
    if not ins.operands:
        return False
    first = ins.operands[0]
    if first.type == ARM64_OP_REG:
        return first.reg == reg
    return False


def find_switch_dispatches(instrs):
    """Detecta bloques de dispatch de switch (tablas de saltos).

    Patron tipico generado por clang para un `switch` sobre tags:

        movz w9, #<bias_lo>
        movk w9, #<bias_hi>, lsl #16     ; w9 = bias
        add  w9, w8, w9                  ; w9 = tag + bias
        cmp  w9, #<N>                   ; limite del indice
        b.hi <default>
        adrp x11, <tabla>
        add  x11, x11, #<off>
        adr  x8, <base>
        ldrh w10, [x11, w9, lsl #1]      ; offset de 16 bits
        add  x8, x8, w10, lsl #2
        br   x8                          ; salto indirecto

    Devuelve lista de tuplas (addr_br, addr_bias_add, addr_cmp, bias_reg).
    """
    dispatches = []
    for i, ins in enumerate(instrs):
        if ins.id != ARM64_INS_BR:
            continue
        # El 'add' que aplica el BIAS es el que va inmediatamente seguido de un
        # 'cmp' con inmediato (la comprobacion de rango del indice).
        # NO es el 'add' que calcula el offset de la tabla (va seguido del 'br').
        for j in range(i - 1, max(i - 16, -1), -1):
            prev = instrs[j]
            if prev.id != ARM64_INS_ADD or len(prev.operands) < 3:
                continue
            # ¿el siguiente par de instrucciones es un cmp con inmediato?
            cmp_addr = None
            for k in range(j + 1, min(j + 3, len(instrs))):
                if instrs[k].id == ARM64_INS_CMP:
                    if any(o.type == ARM64_OP_IMM for o in instrs[k].operands):
                        cmp_addr = instrs[k].address
                    break
            if cmp_addr is None:
                continue
            bias_reg = prev.operands[2].reg
            dispatches.append((ins.address, prev.address, cmp_addr, bias_reg))
            break
    return dispatches


def is_conditional_branch(ins) -> bool:
    if ins.id in (ARM64_INS_CBZ, ARM64_INS_CBNZ, ARM64_INS_TBZ, ARM64_INS_TBNZ):
        return True
    if ins.id == ARM64_INS_B:
        return getattr(ins, "cc", ARM64_CC_INVALID) not in (ARM64_CC_INVALID, ARM64_CC_AL)
    return False


def annotate(instrs, syms, consts, out):
    """Emite el .asm anotado."""
    # Mapa de destinos de saltos, para marcar etiquetas
    targets = set()
    for ins in instrs:
        if ins.id in (ARM64_INS_B, ARM64_INS_BL, ARM64_INS_CBZ,
                      ARM64_INS_CBNZ, ARM64_INS_TBZ, ARM64_INS_TBNZ):
            for op in ins.operands:
                if op.type == ARM64_OP_IMM:
                    targets.add(op.imm)

    # Localiza los bloques de dispatch de switch: dentro de ellos los 'cmp'
    # comparan el INDICE de la tabla, no un tag de Keymaster.
    dispatches = find_switch_dispatches(instrs)
    dispatch_cmp_addrs = {c for (_br, _add, c, _reg) in dispatches if c is not None}
    dispatch_br_addrs = {br for (br, _add, _c, _reg) in dispatches}
    dispatch_bias_addrs = {a for (_br, a, _c, _reg) in dispatches}
    bias_reg_by_add = {a: reg for (_br, a, _c, reg) in dispatches}

    # El registro del bias (w9 ttypically) se REUTILIZA en el compilador para
    # cargar los tags que luego se comparan. Por eso no vale con saber que
    # un registro es "el del bias": hay que identificar la construccion
    # movz/movk CONCRETA que alimenta el 'add' del bias, es decir, la mas
    # cercana por debajo de ese 'add'.
    bias_const_addrs = set()
    for (_br, bias_add, _c, bias_reg) in dispatches:
        best = None
        best_movk = -1
        for addr, (value, movks, creg) in consts.items():
            if creg != bias_reg:
                continue
            for mk in movks:
                if mk.address < bias_add and mk.address > best_movk:
                    best_movk = mk.address
                    best = addr
        if best is not None:
            bias_const_addrs.add(best)

    for ins in instrs:
        raw = bytes(ins.bytes)
        hexbytes = " ".join(f"{b:02x}" for b in raw)

        # --- etiqueta de destino de salto ---
        if ins.address in targets:
            name = syms.get(ins.address)
            if name:
                out.append(f"\n{name}:")
            else:
                out.append(f"\n.L_{ins.address:x}:")

        out.append(f"  {ins.address:08x}:  {hexbytes:<12} {ins.mnemonic:<8} {ins.op_str}")

        notes = []

        # --- anotaciones de ABI (deduplicadas) ---
        seen_regs = []
        for op in ins.operands:
            if op.type == ARM64_OP_REG:
                rn = ins.reg_name(op.reg)
                if rn in AAPCS64_ARGS and ins.mnemonic in ("mov", "ldr", "str", "add", "sub", "cmp"):
                    if rn not in seen_regs:
                        seen_regs.append(rn)
                        notes.append(f"{rn}: {AAPCS64_ARGS[rn]}")

        # --- constante de 32 bits construida con movz+movk ---
        if ins.address in consts:
            value, movks, creg = consts[ins.address]
            tname, tag_id, tname_known = decode_tag(value)
            desc = f"0x{value:08x}"
            if tname_known:
                desc += f" = {tname_known}"
            desc += f"  [tipo={tname}, id=0x{tag_id:x}]"
            # Si la constante ES el bias del switch, NO es un tag.
            is_bias = ins.address in bias_const_addrs
            if is_bias:
                desc += "  <-- BIAS de tabla de switch (NO es un tag de Keymaster)"
            elif is_vendor_tag(value):
                desc += "  <-- TIPO VENDOR (>= 0xC0000000) = posible KM_TAG_SAMSUNG_*"
            notes.append(f"construye la constante {desc}")
            for mk in movks:
                notes.append(f"  (completa en {mk.mnemonic} @0x{mk.address:x})")

        # --- dispatch de switch ---
        if ins.address in dispatch_bias_addrs:
            reg = bias_reg_by_add.get(ins.address)
            if reg is not None:
                rn = ins.reg_name(reg) if hasattr(ins, "reg_name") else str(reg)
                notes.append(f"aplica el bias del switch en {rn} (index = tag + bias)")

        if ins.address in dispatch_br_addrs:
            notes.append("salto indirecto a la tabla de casos del switch")

        # --- destino de bl resuelto a simbolo ---
        if ins.id == ARM64_INS_BL:
            for op in ins.operands:
                if op.type == ARM64_OP_IMM:
                    tgt = op.imm
                    if tgt in syms:
                        notes.append(f"llama a {syms[tgt]}")
                    else:
                        notes.append(f"llama a funcion local/statica @0x{tgt:x}")

        # --- comentario de comparacion ---
        if ins.id == ARM64_INS_CMP:
            if ins.address in dispatch_cmp_addrs:
                notes.append("compara el INDICE del switch (no es un tag de Keymaster)")
            else:
                for op in ins.operands:
                    if op.type == ARM64_OP_IMM:
                        v = op.imm & 0xFFFFFFFF
                        tname, tag_id, tname_known = decode_tag(v)
                        desc = f"compara contra tag 0x{v:08x}"
                        if tname_known:
                            desc += f" ({tname_known})"
                        desc += f" [tipo={tname}, id=0x{tag_id:x}]"
                        if is_vendor_tag(v):
                            desc += "  <-- VENDOR"
                        notes.append(desc)

        # --- polaridad del salto condicional ---
        if ins.id == ARM64_INS_B:
            cc = getattr(ins, "cc", ARM64_CC_INVALID)
            if cc not in (ARM64_CC_INVALID, ARM64_CC_AL):
                notes.append("salto condicional: se toma si la comparacion es CIERTA")

        for n in notes:
            out.append(f"                ; {n}")


def main():
    ap = argparse.ArgumentParser(description="Desensamblado ARM64 anotado")
    ap.add_argument("binary")
    ap.add_argument("--func", help="nombre (o prefijo) de la funcion")
    ap.add_argument("--start", help="vaddr inicial en hex")
    ap.add_argument("--end", help="vaddr final en hex")
    ap.add_argument("-o", "--output", help="fichero de salida .asm")
    ap.add_argument("--list-syms", action="store_true", help="listar funciones exportadas")
    args = ap.parse_args()

    binary = lief.ELF.parse(args.binary)
    syms = build_symbol_map(binary)

    if args.list_syms:
        for addr in sorted(syms):
            print(f"0x{addr:08x}  {syms[addr]}")
        return 0

    if args.func:
        start = resolve_function(binary, args.func, syms)
        if start is None:
            print(f"[!] no se encontro la funcion {args.func!r}", file=sys.stderr)
            return 2
        # tamanho: hasta el siguiente simbolo conocido
        later = [a for a in sorted(syms) if a > start]
        end = later[0] if later else None
    elif args.start:
        start = int(args.start, 0)
        end = int(args.end, 0) if args.end else None
    else:
        ap.error("usa --func o --start")

    instrs = disassemble_range(binary, start, end)
    if not instrs:
        print("[!] no se desensamblo nada en el rango", file=sys.stderr)
        return 3

    consts = reconstruct_constants(instrs)

    out = []
    out.append("; " + "=" * 74)
    out.append(f"; Binario      : {args.binary}")
    out.append(f"; Arquitectura : AArch64 (ARM64) little-endian")
    out.append(f"; Rango        : 0x{start:x} .. 0x{instrs[-1].address:x} "
               f"({len(instrs)} instrucciones)")
    out.append("; Generado por : annotate_asm.py (LIEF + Capstone)")
    out.append("; " + "=" * 74)
    out.append("")

    annotate(instrs, syms, consts, out)

    text = "\n".join(out) + "\n"
    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(text)
        print(f"[+] asm anotado escrito en {args.output} ({len(instrs)} instrs)")
    else:
        sys.stdout.write(text)
    return 0


if __name__ == "__main__":
    sys.exit(main())
