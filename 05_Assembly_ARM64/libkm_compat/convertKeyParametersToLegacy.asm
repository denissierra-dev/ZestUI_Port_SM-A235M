; ==========================================================================
; Binario      : /home/denissierra/Port_A23/ZestUI_Port_SM-A235M/build/03_Vector_B_ELF/raw/libkm_compat.so
; Arquitectura : AArch64 (ARM64) little-endian
; Rango        : 0x10b78 .. 0x12be8 (2077 instrucciones)
; Generado por : annotate_asm.py (LIEF + Capstone)
; ==========================================================================

  00010b78:  ff 83 02 d1  sub      sp, sp, #0xa0
  00010b7c:  fd 7b 04 a9  stp      x29, x30, [sp, #0x40]
  00010b80:  fc 6f 05 a9  stp      x28, x27, [sp, #0x50]
  00010b84:  fa 67 06 a9  stp      x26, x25, [sp, #0x60]
  00010b88:  f8 5f 07 a9  stp      x24, x23, [sp, #0x70]
  00010b8c:  f6 57 08 a9  stp      x22, x21, [sp, #0x80]
  00010b90:  f4 4f 09 a9  stp      x20, x19, [sp, #0x90]
  00010b94:  fd 03 01 91  add      x29, sp, #0x40
  00010b98:  f3 03 08 aa  mov      x19, x8
                ; x19: callee-saved
                ; x8: resultado indirecto (sret) + registro temporal
  00010b9c:  48 d0 3b d5  mrs      x8, tpidr_el0
  00010ba0:  e8 07 00 f9  str      x8, [sp, #8]
                ; x8: resultado indirecto (sret) + registro temporal
  00010ba4:  08 15 40 f9  ldr      x8, [x8, #0x28]
                ; x8: resultado indirecto (sret) + registro temporal
  00010ba8:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00010bac:  a8 83 1f f8  stur     x8, [x29, #-8]
  00010bb0:  7f 7e 00 a9  stp      xzr, xzr, [x19]
  00010bb4:  7f 0a 00 f9  str      xzr, [x19, #0x10]
  00010bb8:  09 20 40 a9  ldp      x9, x8, [x0]
  00010bbc:  e0 03 13 aa  mov      x0, x19
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x19: callee-saved
  00010bc0:  08 01 09 cb  sub      x8, x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  00010bc4:  e9 e7 02 b2  mov      x9, #-0x3333333333333334
                ; x9: temporal (platform register)
                ; construye la constante 0x0000cccd  [tipo=KM_INVALID, id=0xcccd]
                ;   (completa en movk @0x10bcc)
  00010bc8:  08 fd 43 93  asr      x8, x8, #3
  00010bcc:  a9 99 99 f2  movk     x9, #0xcccd
  00010bd0:  01 7d 09 9b  mul      x1, x8, x9
  00010bd4:  63 5c 00 94  bl       #0x27d60
                ; llama a funcion local/statica @0x27d60
  00010bd8:  97 62 40 a9  ldp      x23, x24, [x20]
  00010bdc:  ff 02 18 eb  cmp      x23, x24
                ; x23: callee-saved
                ; x24: callee-saved
  00010be0:  c0 fe 00 54  b.eq     #0x12bb8
                ; salto condicional: se toma si la comparacion es CIERTA
  00010be4:  5c 32 80 52  mov      w28, #0x192
                ; construye la constante 0x30000192  [tipo=KM_UINT, id=0x192]
                ;   (completa en movk @0x10bf4)
  00010be8:  19 7d 80 52  mov      w25, #0x3e8
                ; construye la constante 0x900003e8 = APPLICATION_ID  [tipo=KM_BYTES, id=0x3e8]
                ;   (completa en movk @0x10bf8)
  00010bec:  da 00 80 52  mov      w26, #6
                ; construye la constante 0x70000006 = PADDING  [tipo=KM_BOOL, id=0x6]
                ;   (completa en movk @0x10bfc)
  00010bf0:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00010bf4:  1c 00 a6 72  movk     w28, #0x3000, lsl #16
  00010bf8:  19 00 b2 72  movk     w25, #0x9000, lsl #16
  00010bfc:  1a 00 ae 72  movk     w26, #0x7000, lsl #16
  00010c00:  14 00 00 14  b        #0x10c50

.L_10c04:
  00010c04:  e0 07 c0 3d  ldr      q0, [sp, #0x10]
  00010c08:  1f 09 00 f9  str      xzr, [x8, #0x10]
  00010c0c:  1f 19 00 b9  str      wzr, [x8, #0x18]
  00010c10:  1f 71 00 39  strb     wzr, [x8, #0x1c]
  00010c14:  1f d1 01 78  sturh    wzr, [x8, #0x1d]
  00010c18:  00 01 80 3d  str      q0, [x8]
  00010c1c:  1f 7d 00 39  strb     wzr, [x8, #0x1f]
  00010c20:  e9 13 40 f9  ldr      x9, [sp, #0x20]
                ; x9: temporal (platform register)
  00010c24:  09 09 00 f9  str      x9, [x8, #0x10]
                ; x9: temporal (platform register)
  00010c28:  e9 2b 40 b9  ldr      w9, [sp, #0x28]
  00010c2c:  09 19 00 b9  str      w9, [x8, #0x18]
  00010c30:  e9 b3 40 39  ldrb     w9, [sp, #0x2c]
  00010c34:  09 71 00 39  strb     w9, [x8, #0x1c]
  00010c38:  68 06 40 f9  ldr      x8, [x19, #8]
                ; x8: resultado indirecto (sret) + registro temporal
  00010c3c:  08 81 00 91  add      x8, x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
  00010c40:  68 06 00 f9  str      x8, [x19, #8]
                ; x8: resultado indirecto (sret) + registro temporal

.L_10c44:
  00010c44:  f7 a2 00 91  add      x23, x23, #0x28
                ; x23: callee-saved
  00010c48:  ff 02 18 eb  cmp      x23, x24
                ; x23: callee-saved
                ; x24: callee-saved
  00010c4c:  60 fb 00 54  b.eq     #0x12bb8
                ; salto condicional: se toma si la comparacion es CIERTA

.L_10c50:
  00010c50:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00010c54:  e8 02 40 b9  ldr      w8, [x23]
  00010c58:  1f 01 1c 6b  cmp      w8, w28
  00010c5c:  0c 04 00 54  b.gt     #0x10cdc
                ; salto condicional: se toma si la comparacion es CIERTA
  00010c60:  1f 01 19 6b  cmp      w8, w25
  00010c64:  ed 0a 00 54  b.le     #0x10dc0
                ; salto condicional: se toma si la comparacion es CIERTA
  00010c68:  a9 57 80 52  mov      w9, #0x2bd
                ; construye la constante 0x100002bd  [tipo=KM_ENUM, id=0x2bd]
                ;   (completa en movk @0x10c6c)
  00010c6c:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  00010c70:  1f 01 09 6b  cmp      w8, w9
  00010c74:  ec 11 00 54  b.gt     #0x10eb0
                ; salto condicional: se toma si la comparacion es CIERTA
  00010c78:  29 00 80 52  mov      w9, #1
                ; construye la constante 0x10000001 = PURPOSE  [tipo=KM_ENUM, id=0x1]
                ;   (completa en movk @0x10c7c)
  00010c7c:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  00010c80:  1f 01 09 6b  cmp      w8, w9
  00010c84:  ed 1f 00 54  b.le     #0x11080
                ; salto condicional: se toma si la comparacion es CIERTA
  00010c88:  e9 25 80 52  mov      w9, #0x12f
                ; construye la constante 0x1000012f  [tipo=KM_ENUM, id=0x12f]
                ;   (completa en movk @0x10c8c)
  00010c8c:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  00010c90:  1f 01 09 6b  cmp      w8, w9
  00010c94:  4c 26 00 54  b.gt     #0x1115c
                ; salto condicional: se toma si la comparacion es CIERTA
  00010c98:  49 00 80 52  mov      w9, #2
                ; construye la constante 0x10000002 = ALGORITHM  [tipo=KM_ENUM, id=0x2]
                ;   (completa en movk @0x10c9c)
  00010c9c:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  00010ca0:  1f 01 09 6b  cmp      w8, w9
  00010ca4:  00 34 00 54  b.eq     #0x11324
                ; salto condicional: se toma si la comparacion es CIERTA
  00010ca8:  49 01 80 52  mov      w9, #0xa
                ; construye la constante 0x1000000a = EC_CURVE  [tipo=KM_ENUM, id=0xa]
                ;   (completa en movk @0x10cac)
  00010cac:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  00010cb0:  1f 01 09 6b  cmp      w8, w9
  00010cb4:  81 fc ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010cb8:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00010cbc:  1f 15 00 71  cmp      w8, #5
                ; compara contra tag 0x00000005 (DIGEST) [tipo=KM_INVALID, id=0x5]
  00010cc0:  21 fc ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010cc4:  e8 0a 40 b9  ldr      w8, [x23, #8]
  00010cc8:  49 00 80 52  mov      w9, #2
                ; construye la constante 0x10000002 = ALGORITHM  [tipo=KM_ENUM, id=0x2]
                ;   (completa en movk @0x10ccc)
  00010ccc:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  00010cd0:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00010cd4:  29 21 00 11  add      w9, w9, #8
  00010cd8:  9a 01 00 14  b        #0x11340

.L_10cdc:
  00010cdc:  1f 01 1a 6b  cmp      w8, w26
  00010ce0:  ac 03 00 54  b.gt     #0x10d54
                ; salto condicional: se toma si la comparacion es CIERTA
  00010ce4:  49 7d 80 52  mov      w9, #0x3ea
                ; construye la constante 0x300003ea  [tipo=KM_UINT, id=0x3ea]
                ;   (completa en movk @0x10ce8)
  00010ce8:  09 00 a6 72  movk     w9, #0x3000, lsl #16
  00010cec:  1f 01 09 6b  cmp      w8, w9
  00010cf0:  cc 11 00 54  b.gt     #0x10f28
                ; salto condicional: se toma si la comparacion es CIERTA
  00010cf4:  09 3f 80 52  mov      w9, #0x1f8
                ; construye la constante 0x300001f8  [tipo=KM_UINT, id=0x1f8]
                ;   (completa en movk @0x10cf8)
  00010cf8:  09 00 a6 72  movk     w9, #0x3000, lsl #16
  00010cfc:  1f 01 09 6b  cmp      w8, w9
  00010d00:  2c 17 00 54  b.gt     #0x10fe4
                ; salto condicional: se toma si la comparacion es CIERTA
  00010d04:  69 32 80 52  mov      w9, #0x193
                ; construye la constante 0x30000193  [tipo=KM_UINT, id=0x193]
                ;   (completa en movk @0x10d08)
  00010d08:  09 00 a6 72  movk     w9, #0x3000, lsl #16
  00010d0c:  1f 01 09 6b  cmp      w8, w9
  00010d10:  c0 28 00 54  b.eq     #0x11228
                ; salto condicional: se toma si la comparacion es CIERTA
  00010d14:  89 32 80 52  mov      w9, #0x194
                ; construye la constante 0x30000194  [tipo=KM_UINT, id=0x194]
                ;   (completa en movk @0x10d18)
  00010d18:  09 00 a6 72  movk     w9, #0x3000, lsl #16
  00010d1c:  1f 01 09 6b  cmp      w8, w9
  00010d20:  40 29 00 54  b.eq     #0x11248
                ; salto condicional: se toma si la comparacion es CIERTA
  00010d24:  a9 3e 80 52  mov      w9, #0x1f5
                ; construye la constante 0x300001f5  [tipo=KM_UINT, id=0x1f5]
                ;   (completa en movk @0x10d28)
  00010d28:  09 00 a6 72  movk     w9, #0x3000, lsl #16
  00010d2c:  1f 01 09 6b  cmp      w8, w9
  00010d30:  a1 f8 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010d34:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00010d38:  1f 2d 00 71  cmp      w8, #0xb
                ; compara contra tag 0x0000000b (MAC_LENGTH) [tipo=KM_INVALID, id=0xb]
  00010d3c:  41 f8 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010d40:  68 00 80 52  mov      w8, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x10d44)
  00010d44:  08 00 a6 72  movk     w8, #0x3000, lsl #16
  00010d48:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00010d4c:  08 c9 07 11  add      w8, w8, #0x1f2
  00010d50:  3c 05 00 14  b        #0x12240

.L_10d54:
  00010d54:  c9 3e 80 52  mov      w9, #0x1f6
                ; construye la constante 0x700001f6  [tipo=KM_BOOL, id=0x1f6]
                ;   (completa en movk @0x10d58)
  00010d58:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  00010d5c:  1f 01 09 6b  cmp      w8, w9
  00010d60:  2d 11 00 54  b.le     #0x10f84
                ; salto condicional: se toma si la comparacion es CIERTA
  00010d64:  e9 59 80 52  mov      w9, #0x2cf
                ; construye la constante 0x700002cf  [tipo=KM_BOOL, id=0x2cf]
                ;   (completa en movk @0x10d68)
  00010d68:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  00010d6c:  1f 01 09 6b  cmp      w8, w9
  00010d70:  0c 16 00 54  b.gt     #0x11030
                ; salto condicional: se toma si la comparacion es CIERTA
  00010d74:  29 c1 9f 52  mov      w9, #0xfe09
                ; construye la constante 0x8ffffe09  [tipo=KM_BIGNUM, id=0xffffe09]  <-- BIAS de tabla de switch (NO es un tag de Keymaster)
                ;   (completa en movk @0x10d78)
  00010d78:  e9 ff b1 72  movk     w9, #0x8fff, lsl #16
  00010d7c:  08 01 09 0b  add      w8, w8, w9
                ; aplica el bias del switch en w9 (index = tag + bias)
  00010d80:  1f 19 00 71  cmp      w8, #6
                ; compara el INDICE del switch (no es un tag de Keymaster)
  00010d84:  08 f6 ff 54  b.hi     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010d88:  cb ff ff b0  adrp     x11, #0x9000
  00010d8c:  6b 11 2c 91  add      x11, x11, #0xb04
                ; x11: temporal (platform register)
  00010d90:  a9 f5 ff 10  adr      x9, #0x10c44
  00010d94:  6a 79 68 78  ldrh     w10, [x11, x8, lsl #1]
  00010d98:  29 09 0a 8b  add      x9, x9, x10, lsl #2
                ; x9: temporal (platform register)
                ; x10: temporal (platform register)
  00010d9c:  20 01 1f d6  br       x9
                ; salto indirecto a la tabla de casos del switch
  00010da0:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00010da4:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  00010da8:  e1 f4 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010dac:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x10db0)
  00010db0:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  00010db4:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00010db8:  08 c1 07 11  add      w8, w8, #0x1f0
  00010dbc:  6d 02 00 14  b        #0x11770

.L_10dc0:
  00010dc0:  e9 b4 9f 52  mov      w9, #0xfda7
                ; construye la constante 0x6ffffda7  [tipo=KM_DATE, id=0xffffda7]  <-- BIAS de tabla de switch (NO es un tag de Keymaster)
                ;   (completa en movk @0x10dc4)
  00010dc4:  e9 ff ad 72  movk     w9, #0x6fff, lsl #16
  00010dc8:  09 01 09 0b  add      w9, w8, w9
                ; aplica el bias del switch en w9 (index = tag + bias)
  00010dcc:  3f d1 01 71  cmp      w9, #0x74
                ; compara el INDICE del switch (no es un tag de Keymaster)
  00010dd0:  88 39 00 54  b.hi     #0x11500
                ; salto condicional: se toma si la comparacion es CIERTA
  00010dd4:  cb ff ff b0  adrp     x11, #0x9000
  00010dd8:  6b c1 27 91  add      x11, x11, #0x9f0
                ; x11: temporal (platform register)
  00010ddc:  48 f3 ff 10  adr      x8, #0x10c44
  00010de0:  6a 79 69 78  ldrh     w10, [x11, x9, lsl #1]
  00010de4:  08 09 0a 8b  add      x8, x8, x10, lsl #2
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
  00010de8:  00 01 1f d6  br       x8
                ; salto indirecto a la tabla de casos del switch
  00010dec:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00010df0:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00010df4:  81 f2 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010df8:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x10dfc)
  00010dfc:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00010e00:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00010e04:  e8 13 00 b9  str      w8, [sp, #0x10]
  00010e08:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00010e0c:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00010e10:  28 00 80 52  mov      w8, #1
  00010e14:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00010e18:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00010e1c:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00010e20:  75 9c 00 34  cbz      w21, #0x121ac
  00010e24:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00010e28:  aa 5b 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00010e2c:  e1 03 1f 2a  mov      w1, wzr
  00010e30:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00010e34:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00010e38:  aa 5b 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00010e3c:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00010e40:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00010e44:  75 a0 00 b4  cbz      x21, #0x12250
  00010e48:  c8 02 40 39  ldrb     w8, [x22]
  00010e4c:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00010e50:  88 02 00 39  strb     w8, [x20]
  00010e54:  e0 9f 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00010e58:  c9 06 40 39  ldrb     w9, [x22, #1]
  00010e5c:  a8 0a 00 f1  subs     x8, x21, #2
  00010e60:  89 06 00 39  strb     w9, [x20, #1]
  00010e64:  60 9f 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00010e68:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00010e6c:  03 01 00 54  b.lo     #0x10e8c
                ; salto condicional: se toma si la comparacion es CIERTA
  00010e70:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00010e74:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00010e78:  c2 a2 00 54  b.hs     #0x122d0
                ; salto condicional: se toma si la comparacion es CIERTA
  00010e7c:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  00010e80:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00010e84:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00010e88:  42 a2 00 54  b.hs     #0x122d0
                ; salto condicional: se toma si la comparacion es CIERTA

.L_10e8c:
  00010e8c:  4a 00 80 52  mov      w10, #2

.L_10e90:
  00010e90:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00010e94:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00010e98:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_10e9c:
  00010e9c:  0b 15 40 38  ldrb     w11, [x8], #1
  00010ea0:  29 05 00 b1  adds     x9, x9, #1
  00010ea4:  4b 15 00 38  strb     w11, [x10], #1
  00010ea8:  a3 ff ff 54  b.lo     #0x10e9c
                ; salto condicional: se toma si la comparacion es CIERTA
  00010eac:  e9 04 00 14  b        #0x12250

.L_10eb0:
  00010eb0:  49 00 80 52  mov      w9, #2
                ; construye la constante 0x30000002 = ALGORITHM  [tipo=KM_UINT, id=0x2]  <-- BIAS de tabla de switch (NO es un tag de Keymaster)
                ;   (completa en movk @0x10eb4)
  00010eb4:  09 00 a6 72  movk     w9, #0x3000, lsl #16
  00010eb8:  1f 01 09 6b  cmp      w8, w9
  00010ebc:  0c 13 00 54  b.gt     #0x1111c
                ; salto condicional: se toma si la comparacion es CIERTA
  00010ec0:  09 00 a4 12  mov      w9, #-0x20000001
  00010ec4:  09 01 09 0b  add      w9, w8, w9
                ; aplica el bias del switch en w9 (index = tag + bias)
  00010ec8:  3f 15 00 71  cmp      w9, #5
                ; compara el INDICE del switch (no es un tag de Keymaster)
  00010ecc:  e8 1c 00 54  b.hi     #0x11268
                ; salto condicional: se toma si la comparacion es CIERTA
  00010ed0:  cb ff ff b0  adrp     x11, #0x9000
  00010ed4:  6b 69 2b 91  add      x11, x11, #0xada
                ; x11: temporal (platform register)
  00010ed8:  68 eb ff 10  adr      x8, #0x10c44
  00010edc:  6a 79 69 78  ldrh     w10, [x11, x9, lsl #1]
  00010ee0:  08 09 0a 8b  add      x8, x8, x10, lsl #2
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
  00010ee4:  00 01 1f d6  br       x8
                ; salto indirecto a la tabla de casos del switch
  00010ee8:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00010eec:  1f 1d 00 71  cmp      w8, #7
                ; compara contra tag 0x00000007 (CALLER_NONCE) [tipo=KM_INVALID, id=0x7]
  00010ef0:  a1 ea ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010ef4:  e8 0a 80 b9  ldrsw    x8, [x23, #8]
  00010ef8:  1f 15 00 71  cmp      w8, #5
                ; compara contra tag 0x00000005 (DIGEST) [tipo=KM_INVALID, id=0x5]
  00010efc:  48 ea ff 54  b.hi     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010f00:  e9 05 80 52  mov      w9, #0x2f
  00010f04:  29 25 c8 1a  lsr      w9, w9, w8
  00010f08:  e9 e9 07 36  tbz      w9, #0, #0x10c44
  00010f0c:  c9 ff ff d0  adrp     x9, #0xa000
  00010f10:  29 b1 34 91  add      x9, x9, #0xd2c
                ; x9: temporal (platform register)
  00010f14:  28 79 68 b8  ldr      w8, [x9, x8, lsl #2]
  00010f18:  29 00 80 52  mov      w9, #1
                ; construye la constante 0x20000001 = PURPOSE  [tipo=KM_ENUM_REP, id=0x1]
                ;   (completa en movk @0x10f20)
  00010f1c:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00010f20:  09 00 a4 72  movk     w9, #0x2000, lsl #16
  00010f24:  07 01 00 14  b        #0x11340

.L_10f28:
  00010f28:  09 32 80 52  mov      w9, #0x190
                ; construye la constante 0x60000190  [tipo=KM_DATE, id=0x190]
                ;   (completa en movk @0x10f2c)
  00010f2c:  09 00 ac 72  movk     w9, #0x6000, lsl #16
  00010f30:  1f 01 09 6b  cmp      w8, w9
  00010f34:  cc 0c 00 54  b.gt     #0x110cc
                ; salto condicional: se toma si la comparacion es CIERTA
  00010f38:  69 7d 80 52  mov      w9, #0x3eb
                ; construye la constante 0x300003eb  [tipo=KM_UINT, id=0x3eb]
                ;   (completa en movk @0x10f3c)
  00010f3c:  09 00 a6 72  movk     w9, #0x3000, lsl #16
  00010f40:  1f 01 09 6b  cmp      w8, w9
  00010f44:  40 3b 00 54  b.eq     #0x116ac
                ; salto condicional: se toma si la comparacion es CIERTA
  00010f48:  09 19 80 52  mov      w9, #0xc8
                ; construye la constante 0x500000c8 = RSA_PUBLIC_EXPONENT  [tipo=KM_ULONG, id=0xc8]
                ;   (completa en movk @0x10f4c)
  00010f4c:  09 00 aa 72  movk     w9, #0x5000, lsl #16
  00010f50:  1f 01 09 6b  cmp      w8, w9
  00010f54:  c0 3c 00 54  b.eq     #0x116ec
                ; salto condicional: se toma si la comparacion es CIERTA
  00010f58:  09 32 80 52  mov      w9, #0x190
                ; construye la constante 0x60000190  [tipo=KM_DATE, id=0x190]
                ;   (completa en movk @0x10f5c)
  00010f5c:  09 00 ac 72  movk     w9, #0x6000, lsl #16
  00010f60:  1f 01 09 6b  cmp      w8, w9
  00010f64:  01 e7 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010f68:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00010f6c:  1f 35 00 71  cmp      w8, #0xd
                ; compara contra tag 0x0000000d (EARLY_BOOT_ONLY) [tipo=KM_INVALID, id=0xd]
  00010f70:  a1 e6 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010f74:  08 32 80 52  mov      w8, #0x190
                ; construye la constante 0x60000190  [tipo=KM_DATE, id=0x190]
                ;   (completa en movk @0x10f7c)
  00010f78:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00010f7c:  08 00 ac 72  movk     w8, #0x6000, lsl #16
  00010f80:  e9 01 00 14  b        #0x11724

.L_10f84:
  00010f84:  a9 25 80 52  mov      w9, #0x12d
                ; construye la constante 0x7000012d  [tipo=KM_BOOL, id=0x12d]
                ;   (completa en movk @0x10f88)
  00010f88:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  00010f8c:  1f 01 09 6b  cmp      w8, w9
  00010f90:  cd 10 00 54  b.le     #0x111a8
                ; salto condicional: se toma si la comparacion es CIERTA
  00010f94:  c9 25 80 52  mov      w9, #0x12e
                ; construye la constante 0x7000012e  [tipo=KM_BOOL, id=0x12e]
                ;   (completa en movk @0x10f98)
  00010f98:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  00010f9c:  1f 01 09 6b  cmp      w8, w9
  00010fa0:  60 36 00 54  b.eq     #0x1166c
                ; salto condicional: se toma si la comparacion es CIERTA
  00010fa4:  e9 25 80 52  mov      w9, #0x12f
                ; construye la constante 0x7000012f  [tipo=KM_BOOL, id=0x12f]
                ;   (completa en movk @0x10fa8)
  00010fa8:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  00010fac:  1f 01 09 6b  cmp      w8, w9
  00010fb0:  e0 36 00 54  b.eq     #0x1168c
                ; salto condicional: se toma si la comparacion es CIERTA
  00010fb4:  29 26 80 52  mov      w9, #0x131
                ; construye la constante 0x70000131  [tipo=KM_BOOL, id=0x131]
                ;   (completa en movk @0x10fb8)
  00010fb8:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  00010fbc:  1f 01 09 6b  cmp      w8, w9
  00010fc0:  21 e4 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010fc4:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00010fc8:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  00010fcc:  c1 e3 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00010fd0:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x10fd4)
  00010fd4:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  00010fd8:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00010fdc:  08 a9 04 11  add      w8, w8, #0x12a
  00010fe0:  e4 01 00 14  b        #0x11770

.L_10fe4:
  00010fe4:  e9 a7 9f 52  mov      w9, #0xfd3f
                ; construye la constante 0xcffffd3f  [tipo=KM_RESERVED_C, id=0xffffd3f]  <-- BIAS de tabla de switch (NO es un tag de Keymaster)
                ;   (completa en movk @0x10fe8)
  00010fe8:  e9 ff b9 72  movk     w9, #0xcfff, lsl #16
  00010fec:  09 01 09 0b  add      w9, w8, w9
                ; aplica el bias del switch en w9 (index = tag + bias)
  00010ff0:  3f 39 00 71  cmp      w9, #0xe
                ; compara el INDICE del switch (no es un tag de Keymaster)
  00010ff4:  08 8e 00 54  b.hi     #0x121b4
                ; salto condicional: se toma si la comparacion es CIERTA
  00010ff8:  cb ff ff b0  adrp     x11, #0x9000
  00010ffc:  6b 99 2b 91  add      x11, x11, #0xae6
                ; x11: temporal (platform register)
  00011000:  28 e2 ff 10  adr      x8, #0x10c44
  00011004:  6a 79 69 78  ldrh     w10, [x11, x9, lsl #1]
  00011008:  08 09 0a 8b  add      x8, x8, x10, lsl #2
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
  0001100c:  00 01 1f d6  br       x8
                ; salto indirecto a la tabla de casos del switch
  00011010:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011014:  1f 2d 00 71  cmp      w8, #0xb
                ; compara contra tag 0x0000000b (MAC_LENGTH) [tipo=KM_INVALID, id=0xb]
  00011018:  61 e1 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  0001101c:  68 00 80 52  mov      w8, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x11020)
  00011020:  08 00 a6 72  movk     w8, #0x3000, lsl #16
  00011024:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011028:  08 f9 0a 11  add      w8, w8, #0x2be
  0001102c:  85 04 00 14  b        #0x12240

.L_11030:
  00011030:  29 5a 80 52  mov      w9, #0x2d1
                ; construye la constante 0x700002d1  [tipo=KM_BOOL, id=0x2d1]
                ;   (completa en movk @0x11034)
  00011034:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  00011038:  1f 01 09 6b  cmp      w8, w9
  0001103c:  6c 0d 00 54  b.gt     #0x111e8
                ; salto condicional: se toma si la comparacion es CIERTA
  00011040:  09 5a 80 52  mov      w9, #0x2d0
                ; construye la constante 0x700002d0  [tipo=KM_BOOL, id=0x2d0]
                ;   (completa en movk @0x11044)
  00011044:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  00011048:  1f 01 09 6b  cmp      w8, w9
  0001104c:  40 37 00 54  b.eq     #0x11734
                ; salto condicional: se toma si la comparacion es CIERTA
  00011050:  29 5a 80 52  mov      w9, #0x2d1
                ; construye la constante 0x700002d1  [tipo=KM_BOOL, id=0x2d1]
                ;   (completa en movk @0x11054)
  00011054:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  00011058:  1f 01 09 6b  cmp      w8, w9
  0001105c:  41 df ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011060:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011064:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  00011068:  e1 de ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  0001106c:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x11070)
  00011070:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  00011074:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011078:  08 29 0b 11  add      w8, w8, #0x2ca
  0001107c:  bd 01 00 14  b        #0x11770

.L_11080:
  00011080:  29 7d 80 52  mov      w9, #0x3e9
                ; construye la constante 0x900003e9 = APPLICATION_DATA  [tipo=KM_BYTES, id=0x3e9]
                ;   (completa en movk @0x11084)
  00011084:  09 00 b2 72  movk     w9, #0x9000, lsl #16
  00011088:  1f 01 09 6b  cmp      w8, w9
  0001108c:  20 17 00 54  b.eq     #0x11370
                ; salto condicional: se toma si la comparacion es CIERTA
  00011090:  a9 7d 80 52  mov      w9, #0x3ed
                ; construye la constante 0x900003ed  [tipo=KM_BYTES, id=0x3ed]
                ;   (completa en movk @0x11094)
  00011094:  09 00 b2 72  movk     w9, #0x9000, lsl #16
  00011098:  1f 01 09 6b  cmp      w8, w9
  0001109c:  e0 1c 00 54  b.eq     #0x11438
                ; salto condicional: se toma si la comparacion es CIERTA
  000110a0:  c9 3e 80 52  mov      w9, #0x1f6
                ; construye la constante 0xa00001f6  [tipo=KM_ULONG_REP, id=0x1f6]
                ;   (completa en movk @0x110a4)
  000110a4:  09 00 b4 72  movk     w9, #0xa000, lsl #16
  000110a8:  1f 01 09 6b  cmp      w8, w9
  000110ac:  c1 dc ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000110b0:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000110b4:  1f 31 00 71  cmp      w8, #0xc
                ; compara contra tag 0x0000000c (ROLLBACK_RESISTANCE) [tipo=KM_INVALID, id=0xc]
  000110b8:  61 dc ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000110bc:  c8 3e 80 52  mov      w8, #0x1f6
                ; construye la constante 0xa00001f6  [tipo=KM_ULONG_REP, id=0x1f6]
                ;   (completa en movk @0x110c4)
  000110c0:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000110c4:  08 00 b4 72  movk     w8, #0xa000, lsl #16
  000110c8:  97 01 00 14  b        #0x11724

.L_110cc:
  000110cc:  29 32 80 52  mov      w9, #0x191
                ; construye la constante 0x60000191  [tipo=KM_DATE, id=0x191]
                ;   (completa en movk @0x110d0)
  000110d0:  09 00 ac 72  movk     w9, #0x6000, lsl #16
  000110d4:  1f 01 09 6b  cmp      w8, w9
  000110d8:  a0 2f 00 54  b.eq     #0x116cc
                ; salto condicional: se toma si la comparacion es CIERTA
  000110dc:  49 32 80 52  mov      w9, #0x192
                ; construye la constante 0x60000192  [tipo=KM_DATE, id=0x192]
                ;   (completa en movk @0x110e0)
  000110e0:  09 00 ac 72  movk     w9, #0x6000, lsl #16
  000110e4:  1f 01 09 6b  cmp      w8, w9
  000110e8:  00 31 00 54  b.eq     #0x11708
                ; salto condicional: se toma si la comparacion es CIERTA
  000110ec:  a9 57 80 52  mov      w9, #0x2bd
                ; construye la constante 0x600002bd  [tipo=KM_DATE, id=0x2bd]
                ;   (completa en movk @0x110f0)
  000110f0:  09 00 ac 72  movk     w9, #0x6000, lsl #16
  000110f4:  1f 01 09 6b  cmp      w8, w9
  000110f8:  61 da ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000110fc:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011100:  1f 35 00 71  cmp      w8, #0xd
                ; compara contra tag 0x0000000d (EARLY_BOOT_ONLY) [tipo=KM_INVALID, id=0xd]
  00011104:  01 da ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011108:  08 32 80 52  mov      w8, #0x190
                ; construye la constante 0x60000190  [tipo=KM_DATE, id=0x190]
                ;   (completa en movk @0x1110c)
  0001110c:  08 00 ac 72  movk     w8, #0x6000, lsl #16
  00011110:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011114:  08 b5 04 11  add      w8, w8, #0x12d
  00011118:  83 01 00 14  b        #0x11724

.L_1111c:
  0001111c:  69 00 80 52  mov      w9, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x11120)
  00011120:  09 00 a6 72  movk     w9, #0x3000, lsl #16
  00011124:  1f 01 09 6b  cmp      w8, w9
  00011128:  00 0f 00 54  b.eq     #0x11308
                ; salto condicional: se toma si la comparacion es CIERTA
  0001112c:  09 01 80 52  mov      w9, #8
                ; construye la constante 0x30000008 = MIN_MAC_LENGTH  [tipo=KM_UINT, id=0x8]
                ;   (completa en movk @0x11130)
  00011130:  09 00 a6 72  movk     w9, #0x3000, lsl #16
  00011134:  1f 01 09 6b  cmp      w8, w9
  00011138:  61 d8 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  0001113c:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011140:  1f 2d 00 71  cmp      w8, #0xb
                ; compara contra tag 0x0000000b (MAC_LENGTH) [tipo=KM_INVALID, id=0xb]
  00011144:  01 d8 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011148:  68 00 80 52  mov      w8, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x1114c)
  0001114c:  08 00 a6 72  movk     w8, #0x3000, lsl #16
  00011150:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011154:  08 15 00 11  add      w8, w8, #5
  00011158:  3a 04 00 14  b        #0x12240

.L_1115c:
  0001115c:  09 26 80 52  mov      w9, #0x130
                ; construye la constante 0x10000130  [tipo=KM_ENUM, id=0x130]
                ;   (completa en movk @0x11160)
  00011160:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  00011164:  1f 01 09 6b  cmp      w8, w9
  00011168:  20 0f 00 54  b.eq     #0x1134c
                ; salto condicional: se toma si la comparacion es CIERTA
  0001116c:  09 3f 80 52  mov      w9, #0x1f8
                ; construye la constante 0x100001f8  [tipo=KM_ENUM, id=0x1f8]
                ;   (completa en movk @0x11170)
  00011170:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  00011174:  1f 01 09 6b  cmp      w8, w9
  00011178:  61 d6 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  0001117c:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011180:  1f 21 00 71  cmp      w8, #8
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00011184:  01 d6 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011188:  e8 0a 40 b9  ldr      w8, [x23, #8]
  0001118c:  49 00 80 52  mov      w9, #2
                ; construye la constante 0x10000002 = ALGORITHM  [tipo=KM_ENUM, id=0x2]
                ;   (completa en movk @0x11190)
  00011190:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  00011194:  29 d9 07 11  add      w9, w9, #0x1f6
  00011198:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  0001119c:  e9 13 00 b9  str      w9, [sp, #0x10]
  000111a0:  08 05 00 12  and      w8, w8, #3
  000111a4:  68 00 00 14  b        #0x11344

.L_111a8:
  000111a8:  e9 00 80 52  mov      w9, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x111ac)
  000111ac:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  000111b0:  1f 01 09 6b  cmp      w8, w9
  000111b4:  e0 24 00 54  b.eq     #0x11650
                ; salto condicional: se toma si la comparacion es CIERTA
  000111b8:  49 19 80 52  mov      w9, #0xca
                ; construye la constante 0x700000ca  [tipo=KM_BOOL, id=0xca]
                ;   (completa en movk @0x111bc)
  000111bc:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  000111c0:  1f 01 09 6b  cmp      w8, w9
  000111c4:  01 d4 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000111c8:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000111cc:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  000111d0:  a1 d3 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000111d4:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x111d8)
  000111d8:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  000111dc:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000111e0:  08 0d 03 11  add      w8, w8, #0xc3
  000111e4:  63 01 00 14  b        #0x11770

.L_111e8:
  000111e8:  49 5a 80 52  mov      w9, #0x2d2
                ; construye la constante 0x700002d2  [tipo=KM_BOOL, id=0x2d2]
                ;   (completa en movk @0x111ec)
  000111ec:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  000111f0:  1f 01 09 6b  cmp      w8, w9
  000111f4:  00 2b 00 54  b.eq     #0x11754
                ; salto condicional: se toma si la comparacion es CIERTA
  000111f8:  89 7d 80 52  mov      w9, #0x3ec
                ; construye la constante 0x700003ec  [tipo=KM_BOOL, id=0x3ec]
                ;   (completa en movk @0x111fc)
  000111fc:  09 00 ae 72  movk     w9, #0x7000, lsl #16
  00011200:  1f 01 09 6b  cmp      w8, w9
  00011204:  01 d2 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011208:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  0001120c:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  00011210:  a1 d1 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011214:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x11218)
  00011218:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  0001121c:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011220:  08 95 0f 11  add      w8, w8, #0x3e5
  00011224:  53 01 00 14  b        #0x11770

.L_11228:
  00011228:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  0001122c:  1f 2d 00 71  cmp      w8, #0xb
                ; compara contra tag 0x0000000b (MAC_LENGTH) [tipo=KM_INVALID, id=0xb]
  00011230:  a1 d0 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011234:  68 00 80 52  mov      w8, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x11238)
  00011238:  08 00 a6 72  movk     w8, #0x3000, lsl #16
  0001123c:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011240:  08 41 06 11  add      w8, w8, #0x190
  00011244:  ff 03 00 14  b        #0x12240

.L_11248:
  00011248:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  0001124c:  1f 2d 00 71  cmp      w8, #0xb
                ; compara contra tag 0x0000000b (MAC_LENGTH) [tipo=KM_INVALID, id=0xb]
  00011250:  a1 cf ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011254:  68 00 80 52  mov      w8, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x11258)
  00011258:  08 00 a6 72  movk     w8, #0x3000, lsl #16
  0001125c:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011260:  08 45 06 11  add      w8, w8, #0x191
  00011264:  f7 03 00 14  b        #0x12240

.L_11268:
  00011268:  c9 57 80 52  mov      w9, #0x2be
                ; construye la constante 0x100002be  [tipo=KM_ENUM, id=0x2be]
                ;   (completa en movk @0x1126c)
  0001126c:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  00011270:  1f 01 09 6b  cmp      w8, w9
  00011274:  81 ce ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011278:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  0001127c:  1f 19 00 71  cmp      w8, #6
                ; compara contra tag 0x00000006 (PADDING) [tipo=KM_INVALID, id=0x6]
  00011280:  21 ce ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011284:  e8 0a 40 b9  ldr      w8, [x23, #8]
  00011288:  49 00 80 52  mov      w9, #2
                ; construye la constante 0x10000002 = ALGORITHM  [tipo=KM_ENUM, id=0x2]
                ;   (completa en movk @0x1128c)
  0001128c:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  00011290:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011294:  29 f1 0a 11  add      w9, w9, #0x2bc
  00011298:  2a 00 00 14  b        #0x11340
  0001129c:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000112a0:  1f 0d 00 71  cmp      w8, #3
                ; compara contra tag 0x00000003 (KEY_SIZE) [tipo=KM_INVALID, id=0x3]
  000112a4:  01 cd ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000112a8:  e8 0a 40 b9  ldr      w8, [x23, #8]
  000112ac:  29 00 80 52  mov      w9, #1
                ; construye la constante 0x20000001 = PURPOSE  [tipo=KM_ENUM_REP, id=0x1]
                ;   (completa en movk @0x112b0)
  000112b0:  09 00 a4 72  movk     w9, #0x2000, lsl #16
  000112b4:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000112b8:  29 15 00 11  add      w9, w9, #5
  000112bc:  21 00 00 14  b        #0x11340
  000112c0:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000112c4:  1f 09 00 71  cmp      w8, #2
                ; compara contra tag 0x00000002 (ALGORITHM) [tipo=KM_INVALID, id=0x2]
  000112c8:  e1 cb ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000112cc:  e8 0a 40 b9  ldr      w8, [x23, #8]
  000112d0:  29 00 80 52  mov      w9, #1
                ; construye la constante 0x20000001 = PURPOSE  [tipo=KM_ENUM_REP, id=0x1]
                ;   (completa en movk @0x112d4)
  000112d4:  09 00 a4 72  movk     w9, #0x2000, lsl #16
  000112d8:  29 0d 00 11  add      w9, w9, #3
  000112dc:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000112e0:  18 00 00 14  b        #0x11340
  000112e4:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000112e8:  1f 11 00 71  cmp      w8, #4
                ; compara contra tag 0x00000004 (BLOCK_MODE) [tipo=KM_INVALID, id=0x4]
  000112ec:  c1 ca ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000112f0:  e8 0a 40 b9  ldr      w8, [x23, #8]
  000112f4:  29 00 80 52  mov      w9, #1
                ; construye la constante 0x20000001 = PURPOSE  [tipo=KM_ENUM_REP, id=0x1]
                ;   (completa en movk @0x112f8)
  000112f8:  09 00 a4 72  movk     w9, #0x2000, lsl #16
  000112fc:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011300:  29 01 1e 32  orr      w9, w9, #4
  00011304:  0f 00 00 14  b        #0x11340

.L_11308:
  00011308:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  0001130c:  1f 2d 00 71  cmp      w8, #0xb
                ; compara contra tag 0x0000000b (MAC_LENGTH) [tipo=KM_INVALID, id=0xb]
  00011310:  a1 c9 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011314:  68 00 80 52  mov      w8, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x11318)
  00011318:  08 00 a6 72  movk     w8, #0x3000, lsl #16
  0001131c:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011320:  c8 03 00 14  b        #0x12240

.L_11324:
  00011324:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011328:  1f 05 00 71  cmp      w8, #1
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  0001132c:  c1 c8 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011330:  e8 0a 40 b9  ldr      w8, [x23, #8]
  00011334:  49 00 80 52  mov      w9, #2
                ; construye la constante 0x10000002 = ALGORITHM  [tipo=KM_ENUM, id=0x2]
                ;   (completa en movk @0x1133c)
  00011338:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  0001133c:  09 00 a2 72  movk     w9, #0x1000, lsl #16

.L_11340:
  00011340:  e9 13 00 b9  str      w9, [sp, #0x10]

.L_11344:
  00011344:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011348:  c1 03 00 14  b        #0x1224c

.L_1134c:
  0001134c:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011350:  1f 25 00 71  cmp      w8, #9
                ; compara contra tag 0x00000009 [tipo=KM_INVALID, id=0x9]
  00011354:  81 c7 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011358:  e9 0a 40 b9  ldr      w9, [x23, #8]
  0001135c:  e8 03 1f 2a  mov      w8, wzr
  00011360:  3f 05 00 71  cmp      w9, #1
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00011364:  2c 79 00 54  b.gt     #0x12288
                ; salto condicional: se toma si la comparacion es CIERTA
  00011368:  49 79 00 35  cbnz     w9, #0x12290
  0001136c:  ca 03 00 14  b        #0x12294

.L_11370:
  00011370:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011374:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00011378:  61 c6 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  0001137c:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11380)
  00011380:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00011384:  08 41 06 11  add      w8, w8, #0x190
  00011388:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  0001138c:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011390:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011394:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011398:  28 00 80 52  mov      w8, #1
  0001139c:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  000113a0:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  000113a4:  f5 2b 00 b9  str      w21, [sp, #0x28]
  000113a8:  35 70 00 34  cbz      w21, #0x121ac
  000113ac:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  000113b0:  48 5a 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  000113b4:  e1 03 1f 2a  mov      w1, wzr
  000113b8:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  000113bc:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  000113c0:  48 5a 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  000113c4:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  000113c8:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  000113cc:  35 74 00 b4  cbz      x21, #0x12250
  000113d0:  c8 02 40 39  ldrb     w8, [x22]
  000113d4:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  000113d8:  88 02 00 39  strb     w8, [x20]
  000113dc:  a0 73 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000113e0:  c9 06 40 39  ldrb     w9, [x22, #1]
  000113e4:  a8 0a 00 f1  subs     x8, x21, #2
  000113e8:  89 06 00 39  strb     w9, [x20, #1]
  000113ec:  20 73 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000113f0:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  000113f4:  03 01 00 54  b.lo     #0x11414
                ; salto condicional: se toma si la comparacion es CIERTA
  000113f8:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  000113fc:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00011400:  82 75 00 54  b.hs     #0x122b0
                ; salto condicional: se toma si la comparacion es CIERTA
  00011404:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  00011408:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  0001140c:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00011410:  02 75 00 54  b.hs     #0x122b0
                ; salto condicional: se toma si la comparacion es CIERTA

.L_11414:
  00011414:  4a 00 80 52  mov      w10, #2

.L_11418:
  00011418:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  0001141c:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00011420:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_11424:
  00011424:  0b 15 40 38  ldrb     w11, [x8], #1
  00011428:  29 05 00 b1  adds     x9, x9, #1
  0001142c:  4b 15 00 38  strb     w11, [x10], #1
  00011430:  a3 ff ff 54  b.lo     #0x11424
                ; salto condicional: se toma si la comparacion es CIERTA
  00011434:  87 03 00 14  b        #0x12250

.L_11438:
  00011438:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  0001143c:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00011440:  21 c0 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011444:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11448)
  00011448:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  0001144c:  08 51 06 11  add      w8, w8, #0x194
  00011450:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011454:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011458:  e8 13 00 b9  str      w8, [sp, #0x10]
  0001145c:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011460:  28 00 80 52  mov      w8, #1
  00011464:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00011468:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  0001146c:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00011470:  f5 69 00 34  cbz      w21, #0x121ac
  00011474:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00011478:  16 5a 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  0001147c:  e1 03 1f 2a  mov      w1, wzr
  00011480:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011484:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00011488:  16 5a 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  0001148c:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00011490:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00011494:  f5 6d 00 b4  cbz      x21, #0x12250
  00011498:  c8 02 40 39  ldrb     w8, [x22]
  0001149c:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  000114a0:  88 02 00 39  strb     w8, [x20]
  000114a4:  60 6d 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000114a8:  c9 06 40 39  ldrb     w9, [x22, #1]
  000114ac:  a8 0a 00 f1  subs     x8, x21, #2
  000114b0:  89 06 00 39  strb     w9, [x20, #1]
  000114b4:  e0 6c 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000114b8:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  000114bc:  03 01 00 54  b.lo     #0x114dc
                ; salto condicional: se toma si la comparacion es CIERTA
  000114c0:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  000114c4:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  000114c8:  c2 6f 00 54  b.hs     #0x122c0
                ; salto condicional: se toma si la comparacion es CIERTA
  000114cc:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  000114d0:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000114d4:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  000114d8:  42 6f 00 54  b.hs     #0x122c0
                ; salto condicional: se toma si la comparacion es CIERTA

.L_114dc:
  000114dc:  4a 00 80 52  mov      w10, #2

.L_114e0:
  000114e0:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000114e4:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  000114e8:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_114ec:
  000114ec:  0b 15 40 38  ldrb     w11, [x8], #1
  000114f0:  29 05 00 b1  adds     x9, x9, #1
  000114f4:  4b 15 00 38  strb     w11, [x10], #1
  000114f8:  a3 ff ff 54  b.lo     #0x114ec
                ; salto condicional: se toma si la comparacion es CIERTA
  000114fc:  55 03 00 14  b        #0x12250

.L_11500:
  00011500:  1f 01 19 6b  cmp      w8, w25
  00011504:  01 ba ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011508:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  0001150c:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00011510:  a1 b9 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011514:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11518)
  00011518:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  0001151c:  08 3d 06 11  add      w8, w8, #0x18f
  00011520:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011524:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011528:  e8 13 00 b9  str      w8, [sp, #0x10]
  0001152c:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011530:  28 00 80 52  mov      w8, #1
  00011534:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00011538:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  0001153c:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00011540:  75 63 00 34  cbz      w21, #0x121ac
  00011544:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00011548:  e2 59 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  0001154c:  e1 03 1f 2a  mov      w1, wzr
  00011550:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011554:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00011558:  e2 59 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  0001155c:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00011560:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00011564:  75 67 00 b4  cbz      x21, #0x12250
  00011568:  c8 02 40 39  ldrb     w8, [x22]
  0001156c:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00011570:  88 02 00 39  strb     w8, [x20]
  00011574:  e0 66 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011578:  c9 06 40 39  ldrb     w9, [x22, #1]
  0001157c:  a8 0a 00 f1  subs     x8, x21, #2
  00011580:  89 06 00 39  strb     w9, [x20, #1]
  00011584:  60 66 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011588:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  0001158c:  03 01 00 54  b.lo     #0x115ac
                ; salto condicional: se toma si la comparacion es CIERTA
  00011590:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00011594:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00011598:  c2 70 00 54  b.hs     #0x123b0
                ; salto condicional: se toma si la comparacion es CIERTA
  0001159c:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  000115a0:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000115a4:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  000115a8:  42 70 00 54  b.hs     #0x123b0
                ; salto condicional: se toma si la comparacion es CIERTA

.L_115ac:
  000115ac:  4a 00 80 52  mov      w10, #2

.L_115b0:
  000115b0:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000115b4:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  000115b8:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_115bc:
  000115bc:  0b 15 40 38  ldrb     w11, [x8], #1
  000115c0:  29 05 00 b1  adds     x9, x9, #1
  000115c4:  4b 15 00 38  strb     w11, [x10], #1
  000115c8:  a3 ff ff 54  b.lo     #0x115bc
                ; salto condicional: se toma si la comparacion es CIERTA
  000115cc:  21 03 00 14  b        #0x12250
  000115d0:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000115d4:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  000115d8:  61 b3 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000115dc:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x115e0)
  000115e0:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  000115e4:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000115e8:  08 d1 07 11  add      w8, w8, #0x1f4
  000115ec:  61 00 00 14  b        #0x11770
  000115f0:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000115f4:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  000115f8:  61 b2 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000115fc:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x11600)
  00011600:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  00011604:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011608:  08 d5 07 11  add      w8, w8, #0x1f5
  0001160c:  59 00 00 14  b        #0x11770
  00011610:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011614:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  00011618:  61 b1 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  0001161c:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x11620)
  00011620:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  00011624:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011628:  08 cd 07 11  add      w8, w8, #0x1f3
  0001162c:  51 00 00 14  b        #0x11770
  00011630:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011634:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  00011638:  61 b0 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  0001163c:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x11640)
  00011640:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  00011644:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011648:  08 d9 07 11  add      w8, w8, #0x1f6
  0001164c:  49 00 00 14  b        #0x11770

.L_11650:
  00011650:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011654:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  00011658:  61 af ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  0001165c:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x11660)
  00011660:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  00011664:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011668:  42 00 00 14  b        #0x11770

.L_1166c:
  0001166c:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011670:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  00011674:  81 ae ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011678:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x1167c)
  0001167c:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  00011680:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011684:  08 9d 04 11  add      w8, w8, #0x127
  00011688:  3a 00 00 14  b        #0x11770

.L_1168c:
  0001168c:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011690:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  00011694:  81 ad ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011698:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x1169c)
  0001169c:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  000116a0:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000116a4:  08 a1 04 11  add      w8, w8, #0x128
  000116a8:  32 00 00 14  b        #0x11770

.L_116ac:
  000116ac:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000116b0:  1f 2d 00 71  cmp      w8, #0xb
                ; compara contra tag 0x0000000b (MAC_LENGTH) [tipo=KM_INVALID, id=0xb]
  000116b4:  81 ac ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000116b8:  68 00 80 52  mov      w8, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x116bc)
  000116bc:  08 00 a6 72  movk     w8, #0x3000, lsl #16
  000116c0:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000116c4:  08 a1 0f 11  add      w8, w8, #0x3e8
  000116c8:  de 02 00 14  b        #0x12240

.L_116cc:
  000116cc:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000116d0:  1f 35 00 71  cmp      w8, #0xd
                ; compara contra tag 0x0000000d (EARLY_BOOT_ONLY) [tipo=KM_INVALID, id=0xd]
  000116d4:  81 ab ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000116d8:  08 32 80 52  mov      w8, #0x190
                ; construye la constante 0x60000190  [tipo=KM_DATE, id=0x190]
                ;   (completa en movk @0x116dc)
  000116dc:  08 00 ac 72  movk     w8, #0x6000, lsl #16
  000116e0:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000116e4:  08 05 00 11  add      w8, w8, #1
  000116e8:  0f 00 00 14  b        #0x11724

.L_116ec:
  000116ec:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000116f0:  1f 31 00 71  cmp      w8, #0xc
                ; compara contra tag 0x0000000c (ROLLBACK_RESISTANCE) [tipo=KM_INVALID, id=0xc]
  000116f4:  81 aa ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000116f8:  08 19 80 52  mov      w8, #0xc8
                ; construye la constante 0x500000c8 = RSA_PUBLIC_EXPONENT  [tipo=KM_ULONG, id=0xc8]
                ;   (completa en movk @0x116fc)
  000116fc:  08 00 aa 72  movk     w8, #0x5000, lsl #16
  00011700:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011704:  08 00 00 14  b        #0x11724

.L_11708:
  00011708:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  0001170c:  1f 35 00 71  cmp      w8, #0xd
                ; compara contra tag 0x0000000d (EARLY_BOOT_ONLY) [tipo=KM_INVALID, id=0xd]
  00011710:  a1 a9 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011714:  08 32 80 52  mov      w8, #0x190
                ; construye la constante 0x60000190  [tipo=KM_DATE, id=0x190]
                ;   (completa en movk @0x11718)
  00011718:  08 00 ac 72  movk     w8, #0x6000, lsl #16
  0001171c:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011720:  08 09 00 11  add      w8, w8, #2

.L_11724:
  00011724:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011728:  e8 06 40 f9  ldr      x8, [x23, #8]
                ; x8: resultado indirecto (sret) + registro temporal
  0001172c:  e8 0f 00 f9  str      x8, [sp, #0x18]
                ; x8: resultado indirecto (sret) + registro temporal
  00011730:  c8 02 00 14  b        #0x12250

.L_11734:
  00011734:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011738:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  0001173c:  41 a8 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011740:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x11744)
  00011744:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  00011748:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  0001174c:  08 25 0b 11  add      w8, w8, #0x2c9
  00011750:  08 00 00 14  b        #0x11770

.L_11754:
  00011754:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011758:  1f 29 00 71  cmp      w8, #0xa
                ; compara contra tag 0x0000000a (EC_CURVE) [tipo=KM_INVALID, id=0xa]
  0001175c:  41 a7 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011760:  e8 00 80 52  mov      w8, #7
                ; construye la constante 0x70000007 = CALLER_NONCE  [tipo=KM_BOOL, id=0x7]
                ;   (completa en movk @0x11764)
  00011764:  08 00 ae 72  movk     w8, #0x7000, lsl #16
  00011768:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  0001176c:  08 2d 0b 11  add      w8, w8, #0x2cb

.L_11770:
  00011770:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011774:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011778:  e8 22 40 39  ldrb     w8, [x23, #8]
  0001177c:  e8 63 00 39  strb     w8, [sp, #0x18]
  00011780:  b4 02 00 14  b        #0x12250
  00011784:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011788:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  0001178c:  c1 a5 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011790:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11794)
  00011794:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00011798:  08 b1 01 11  add      w8, w8, #0x6c
  0001179c:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000117a0:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  000117a4:  e8 13 00 b9  str      w8, [sp, #0x10]
  000117a8:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  000117ac:  28 00 80 52  mov      w8, #1
  000117b0:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  000117b4:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  000117b8:  f5 2b 00 b9  str      w21, [sp, #0x28]
  000117bc:  95 4f 00 34  cbz      w21, #0x121ac
  000117c0:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  000117c4:  43 59 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  000117c8:  e1 03 1f 2a  mov      w1, wzr
  000117cc:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  000117d0:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  000117d4:  43 59 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  000117d8:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  000117dc:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  000117e0:  95 53 00 b4  cbz      x21, #0x12250
  000117e4:  c8 02 40 39  ldrb     w8, [x22]
  000117e8:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  000117ec:  88 02 00 39  strb     w8, [x20]
  000117f0:  00 53 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000117f4:  c9 06 40 39  ldrb     w9, [x22, #1]
  000117f8:  a8 0a 00 f1  subs     x8, x21, #2
  000117fc:  89 06 00 39  strb     w9, [x20, #1]
  00011800:  80 52 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011804:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00011808:  03 01 00 54  b.lo     #0x11828
                ; salto condicional: se toma si la comparacion es CIERTA
  0001180c:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00011810:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00011814:  62 56 00 54  b.hs     #0x122e0
                ; salto condicional: se toma si la comparacion es CIERTA
  00011818:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  0001181c:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011820:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00011824:  e2 55 00 54  b.hs     #0x122e0
                ; salto condicional: se toma si la comparacion es CIERTA

.L_11828:
  00011828:  4a 00 80 52  mov      w10, #2

.L_1182c:
  0001182c:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011830:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00011834:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_11838:
  00011838:  0b 15 40 38  ldrb     w11, [x8], #1
  0001183c:  29 05 00 b1  adds     x9, x9, #1
  00011840:  4b 15 00 38  strb     w11, [x10], #1
  00011844:  a3 ff ff 54  b.lo     #0x11838
                ; salto condicional: se toma si la comparacion es CIERTA
  00011848:  82 02 00 14  b        #0x12250
  0001184c:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011850:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00011854:  81 9f ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011858:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x1185c)
  0001185c:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00011860:  08 ad 01 11  add      w8, w8, #0x6b
  00011864:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011868:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  0001186c:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011870:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011874:  28 00 80 52  mov      w8, #1
  00011878:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  0001187c:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00011880:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00011884:  55 49 00 34  cbz      w21, #0x121ac
  00011888:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  0001188c:  11 59 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00011890:  e1 03 1f 2a  mov      w1, wzr
  00011894:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011898:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  0001189c:  11 59 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  000118a0:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  000118a4:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  000118a8:  55 4d 00 b4  cbz      x21, #0x12250
  000118ac:  c8 02 40 39  ldrb     w8, [x22]
  000118b0:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  000118b4:  88 02 00 39  strb     w8, [x20]
  000118b8:  c0 4c 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000118bc:  c9 06 40 39  ldrb     w9, [x22, #1]
  000118c0:  a8 0a 00 f1  subs     x8, x21, #2
  000118c4:  89 06 00 39  strb     w9, [x20, #1]
  000118c8:  40 4c 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000118cc:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  000118d0:  03 01 00 54  b.lo     #0x118f0
                ; salto condicional: se toma si la comparacion es CIERTA
  000118d4:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  000118d8:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  000118dc:  a2 50 00 54  b.hs     #0x122f0
                ; salto condicional: se toma si la comparacion es CIERTA
  000118e0:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  000118e4:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000118e8:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  000118ec:  22 50 00 54  b.hs     #0x122f0
                ; salto condicional: se toma si la comparacion es CIERTA

.L_118f0:
  000118f0:  4a 00 80 52  mov      w10, #2

.L_118f4:
  000118f4:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000118f8:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  000118fc:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_11900:
  00011900:  0b 15 40 38  ldrb     w11, [x8], #1
  00011904:  29 05 00 b1  adds     x9, x9, #1
  00011908:  4b 15 00 38  strb     w11, [x10], #1
  0001190c:  a3 ff ff 54  b.lo     #0x11900
                ; salto condicional: se toma si la comparacion es CIERTA
  00011910:  50 02 00 14  b        #0x12250
  00011914:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011918:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  0001191c:  41 99 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011920:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11924)
  00011924:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00011928:  08 9d 01 11  add      w8, w8, #0x67
  0001192c:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011930:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011934:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011938:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  0001193c:  28 00 80 52  mov      w8, #1
  00011940:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00011944:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00011948:  f5 2b 00 b9  str      w21, [sp, #0x28]
  0001194c:  15 43 00 34  cbz      w21, #0x121ac
  00011950:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00011954:  df 58 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00011958:  e1 03 1f 2a  mov      w1, wzr
  0001195c:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011960:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00011964:  df 58 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00011968:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  0001196c:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00011970:  15 47 00 b4  cbz      x21, #0x12250
  00011974:  c8 02 40 39  ldrb     w8, [x22]
  00011978:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  0001197c:  88 02 00 39  strb     w8, [x20]
  00011980:  80 46 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011984:  c9 06 40 39  ldrb     w9, [x22, #1]
  00011988:  a8 0a 00 f1  subs     x8, x21, #2
  0001198c:  89 06 00 39  strb     w9, [x20, #1]
  00011990:  00 46 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011994:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00011998:  03 01 00 54  b.lo     #0x119b8
                ; salto condicional: se toma si la comparacion es CIERTA
  0001199c:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  000119a0:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  000119a4:  e2 4a 00 54  b.hs     #0x12300
                ; salto condicional: se toma si la comparacion es CIERTA
  000119a8:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  000119ac:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000119b0:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  000119b4:  62 4a 00 54  b.hs     #0x12300
                ; salto condicional: se toma si la comparacion es CIERTA

.L_119b8:
  000119b8:  4a 00 80 52  mov      w10, #2

.L_119bc:
  000119bc:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000119c0:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  000119c4:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_119c8:
  000119c8:  0b 15 40 38  ldrb     w11, [x8], #1
  000119cc:  29 05 00 b1  adds     x9, x9, #1
  000119d0:  4b 15 00 38  strb     w11, [x10], #1
  000119d4:  a3 ff ff 54  b.lo     #0x119c8
                ; salto condicional: se toma si la comparacion es CIERTA
  000119d8:  1e 02 00 14  b        #0x12250
  000119dc:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000119e0:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  000119e4:  01 93 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000119e8:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x119ec)
  000119ec:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  000119f0:  08 8d 01 11  add      w8, w8, #0x63
  000119f4:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000119f8:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  000119fc:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011a00:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011a04:  28 00 80 52  mov      w8, #1
  00011a08:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00011a0c:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00011a10:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00011a14:  d5 3c 00 34  cbz      w21, #0x121ac
  00011a18:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00011a1c:  ad 58 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00011a20:  e1 03 1f 2a  mov      w1, wzr
  00011a24:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011a28:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00011a2c:  ad 58 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00011a30:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00011a34:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00011a38:  d5 40 00 b4  cbz      x21, #0x12250
  00011a3c:  c8 02 40 39  ldrb     w8, [x22]
  00011a40:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00011a44:  88 02 00 39  strb     w8, [x20]
  00011a48:  40 40 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011a4c:  c9 06 40 39  ldrb     w9, [x22, #1]
  00011a50:  a8 0a 00 f1  subs     x8, x21, #2
  00011a54:  89 06 00 39  strb     w9, [x20, #1]
  00011a58:  c0 3f 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011a5c:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00011a60:  03 01 00 54  b.lo     #0x11a80
                ; salto condicional: se toma si la comparacion es CIERTA
  00011a64:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00011a68:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00011a6c:  22 45 00 54  b.hs     #0x12310
                ; salto condicional: se toma si la comparacion es CIERTA
  00011a70:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  00011a74:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011a78:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00011a7c:  a2 44 00 54  b.hs     #0x12310
                ; salto condicional: se toma si la comparacion es CIERTA

.L_11a80:
  00011a80:  4a 00 80 52  mov      w10, #2

.L_11a84:
  00011a84:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011a88:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00011a8c:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_11a90:
  00011a90:  0b 15 40 38  ldrb     w11, [x8], #1
  00011a94:  29 05 00 b1  adds     x9, x9, #1
  00011a98:  4b 15 00 38  strb     w11, [x10], #1
  00011a9c:  a3 ff ff 54  b.lo     #0x11a90
                ; salto condicional: se toma si la comparacion es CIERTA
  00011aa0:  ec 01 00 14  b        #0x12250
  00011aa4:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011aa8:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00011aac:  c1 8c ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011ab0:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11ab4)
  00011ab4:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00011ab8:  08 b9 01 11  add      w8, w8, #0x6e
  00011abc:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011ac0:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011ac4:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011ac8:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011acc:  28 00 80 52  mov      w8, #1
  00011ad0:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00011ad4:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00011ad8:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00011adc:  95 36 00 34  cbz      w21, #0x121ac
  00011ae0:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00011ae4:  7b 58 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00011ae8:  e1 03 1f 2a  mov      w1, wzr
  00011aec:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011af0:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00011af4:  7b 58 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00011af8:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00011afc:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00011b00:  95 3a 00 b4  cbz      x21, #0x12250
  00011b04:  c8 02 40 39  ldrb     w8, [x22]
  00011b08:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00011b0c:  88 02 00 39  strb     w8, [x20]
  00011b10:  00 3a 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011b14:  c9 06 40 39  ldrb     w9, [x22, #1]
  00011b18:  a8 0a 00 f1  subs     x8, x21, #2
  00011b1c:  89 06 00 39  strb     w9, [x20, #1]
  00011b20:  80 39 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011b24:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00011b28:  03 01 00 54  b.lo     #0x11b48
                ; salto condicional: se toma si la comparacion es CIERTA
  00011b2c:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00011b30:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00011b34:  62 3f 00 54  b.hs     #0x12320
                ; salto condicional: se toma si la comparacion es CIERTA
  00011b38:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  00011b3c:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011b40:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00011b44:  e2 3e 00 54  b.hs     #0x12320
                ; salto condicional: se toma si la comparacion es CIERTA

.L_11b48:
  00011b48:  4a 00 80 52  mov      w10, #2

.L_11b4c:
  00011b4c:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011b50:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00011b54:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_11b58:
  00011b58:  0b 15 40 38  ldrb     w11, [x8], #1
  00011b5c:  29 05 00 b1  adds     x9, x9, #1
  00011b60:  4b 15 00 38  strb     w11, [x10], #1
  00011b64:  a3 ff ff 54  b.lo     #0x11b58
                ; salto condicional: se toma si la comparacion es CIERTA
  00011b68:  ba 01 00 14  b        #0x12250
  00011b6c:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011b70:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00011b74:  81 86 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011b78:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11b7c)
  00011b7c:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00011b80:  08 c5 01 11  add      w8, w8, #0x71
  00011b84:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011b88:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011b8c:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011b90:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011b94:  28 00 80 52  mov      w8, #1
  00011b98:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00011b9c:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00011ba0:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00011ba4:  55 30 00 34  cbz      w21, #0x121ac
  00011ba8:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00011bac:  49 58 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00011bb0:  e1 03 1f 2a  mov      w1, wzr
  00011bb4:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011bb8:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00011bbc:  49 58 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00011bc0:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00011bc4:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00011bc8:  55 34 00 b4  cbz      x21, #0x12250
  00011bcc:  c8 02 40 39  ldrb     w8, [x22]
  00011bd0:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00011bd4:  88 02 00 39  strb     w8, [x20]
  00011bd8:  c0 33 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011bdc:  c9 06 40 39  ldrb     w9, [x22, #1]
  00011be0:  a8 0a 00 f1  subs     x8, x21, #2
  00011be4:  89 06 00 39  strb     w9, [x20, #1]
  00011be8:  40 33 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011bec:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00011bf0:  03 01 00 54  b.lo     #0x11c10
                ; salto condicional: se toma si la comparacion es CIERTA
  00011bf4:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00011bf8:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00011bfc:  a2 39 00 54  b.hs     #0x12330
                ; salto condicional: se toma si la comparacion es CIERTA
  00011c00:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  00011c04:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011c08:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00011c0c:  22 39 00 54  b.hs     #0x12330
                ; salto condicional: se toma si la comparacion es CIERTA

.L_11c10:
  00011c10:  4a 00 80 52  mov      w10, #2

.L_11c14:
  00011c14:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011c18:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00011c1c:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_11c20:
  00011c20:  0b 15 40 38  ldrb     w11, [x8], #1
  00011c24:  29 05 00 b1  adds     x9, x9, #1
  00011c28:  4b 15 00 38  strb     w11, [x10], #1
  00011c2c:  a3 ff ff 54  b.lo     #0x11c20
                ; salto condicional: se toma si la comparacion es CIERTA
  00011c30:  88 01 00 14  b        #0x12250
  00011c34:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011c38:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00011c3c:  41 80 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011c40:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11c44)
  00011c44:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00011c48:  08 a9 01 11  add      w8, w8, #0x6a
  00011c4c:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011c50:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011c54:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011c58:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011c5c:  28 00 80 52  mov      w8, #1
  00011c60:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00011c64:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00011c68:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00011c6c:  15 2a 00 34  cbz      w21, #0x121ac
  00011c70:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00011c74:  17 58 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00011c78:  e1 03 1f 2a  mov      w1, wzr
  00011c7c:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011c80:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00011c84:  17 58 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00011c88:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00011c8c:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00011c90:  15 2e 00 b4  cbz      x21, #0x12250
  00011c94:  c8 02 40 39  ldrb     w8, [x22]
  00011c98:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00011c9c:  88 02 00 39  strb     w8, [x20]
  00011ca0:  80 2d 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011ca4:  c9 06 40 39  ldrb     w9, [x22, #1]
  00011ca8:  a8 0a 00 f1  subs     x8, x21, #2
  00011cac:  89 06 00 39  strb     w9, [x20, #1]
  00011cb0:  00 2d 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011cb4:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00011cb8:  03 01 00 54  b.lo     #0x11cd8
                ; salto condicional: se toma si la comparacion es CIERTA
  00011cbc:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00011cc0:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00011cc4:  e2 33 00 54  b.hs     #0x12340
                ; salto condicional: se toma si la comparacion es CIERTA
  00011cc8:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  00011ccc:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011cd0:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00011cd4:  62 33 00 54  b.hs     #0x12340
                ; salto condicional: se toma si la comparacion es CIERTA

.L_11cd8:
  00011cd8:  4a 00 80 52  mov      w10, #2

.L_11cdc:
  00011cdc:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011ce0:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00011ce4:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_11ce8:
  00011ce8:  0b 15 40 38  ldrb     w11, [x8], #1
  00011cec:  29 05 00 b1  adds     x9, x9, #1
  00011cf0:  4b 15 00 38  strb     w11, [x10], #1
  00011cf4:  a3 ff ff 54  b.lo     #0x11ce8
                ; salto condicional: se toma si la comparacion es CIERTA
  00011cf8:  56 01 00 14  b        #0x12250
  00011cfc:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011d00:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00011d04:  01 7a ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011d08:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11d0c)
  00011d0c:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00011d10:  08 b5 01 11  add      w8, w8, #0x6d
  00011d14:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011d18:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011d1c:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011d20:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011d24:  28 00 80 52  mov      w8, #1
  00011d28:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00011d2c:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00011d30:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00011d34:  d5 23 00 34  cbz      w21, #0x121ac
  00011d38:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00011d3c:  e5 57 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00011d40:  e1 03 1f 2a  mov      w1, wzr
  00011d44:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011d48:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00011d4c:  e5 57 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00011d50:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00011d54:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00011d58:  d5 27 00 b4  cbz      x21, #0x12250
  00011d5c:  c8 02 40 39  ldrb     w8, [x22]
  00011d60:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00011d64:  88 02 00 39  strb     w8, [x20]
  00011d68:  40 27 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011d6c:  c9 06 40 39  ldrb     w9, [x22, #1]
  00011d70:  a8 0a 00 f1  subs     x8, x21, #2
  00011d74:  89 06 00 39  strb     w9, [x20, #1]
  00011d78:  c0 26 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011d7c:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00011d80:  03 01 00 54  b.lo     #0x11da0
                ; salto condicional: se toma si la comparacion es CIERTA
  00011d84:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00011d88:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00011d8c:  22 2e 00 54  b.hs     #0x12350
                ; salto condicional: se toma si la comparacion es CIERTA
  00011d90:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  00011d94:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011d98:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00011d9c:  a2 2d 00 54  b.hs     #0x12350
                ; salto condicional: se toma si la comparacion es CIERTA

.L_11da0:
  00011da0:  4a 00 80 52  mov      w10, #2

.L_11da4:
  00011da4:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011da8:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00011dac:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_11db0:
  00011db0:  0b 15 40 38  ldrb     w11, [x8], #1
  00011db4:  29 05 00 b1  adds     x9, x9, #1
  00011db8:  4b 15 00 38  strb     w11, [x10], #1
  00011dbc:  a3 ff ff 54  b.lo     #0x11db0
                ; salto condicional: se toma si la comparacion es CIERTA
  00011dc0:  24 01 00 14  b        #0x12250
  00011dc4:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011dc8:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00011dcc:  c1 73 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011dd0:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11dd4)
  00011dd4:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00011dd8:  08 c9 01 11  add      w8, w8, #0x72
  00011ddc:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011de0:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011de4:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011de8:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011dec:  28 00 80 52  mov      w8, #1
  00011df0:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00011df4:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00011df8:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00011dfc:  95 1d 00 34  cbz      w21, #0x121ac
  00011e00:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00011e04:  b3 57 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00011e08:  e1 03 1f 2a  mov      w1, wzr
  00011e0c:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011e10:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00011e14:  b3 57 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00011e18:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00011e1c:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00011e20:  95 21 00 b4  cbz      x21, #0x12250
  00011e24:  c8 02 40 39  ldrb     w8, [x22]
  00011e28:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00011e2c:  88 02 00 39  strb     w8, [x20]
  00011e30:  00 21 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011e34:  c9 06 40 39  ldrb     w9, [x22, #1]
  00011e38:  a8 0a 00 f1  subs     x8, x21, #2
  00011e3c:  89 06 00 39  strb     w9, [x20, #1]
  00011e40:  80 20 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011e44:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00011e48:  03 01 00 54  b.lo     #0x11e68
                ; salto condicional: se toma si la comparacion es CIERTA
  00011e4c:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00011e50:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00011e54:  62 28 00 54  b.hs     #0x12360
                ; salto condicional: se toma si la comparacion es CIERTA
  00011e58:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  00011e5c:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011e60:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00011e64:  e2 27 00 54  b.hs     #0x12360
                ; salto condicional: se toma si la comparacion es CIERTA

.L_11e68:
  00011e68:  4a 00 80 52  mov      w10, #2

.L_11e6c:
  00011e6c:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011e70:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00011e74:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_11e78:
  00011e78:  0b 15 40 38  ldrb     w11, [x8], #1
  00011e7c:  29 05 00 b1  adds     x9, x9, #1
  00011e80:  4b 15 00 38  strb     w11, [x10], #1
  00011e84:  a3 ff ff 54  b.lo     #0x11e78
                ; salto condicional: se toma si la comparacion es CIERTA
  00011e88:  f2 00 00 14  b        #0x12250
  00011e8c:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011e90:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00011e94:  81 6d ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011e98:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11e9c)
  00011e9c:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00011ea0:  08 cd 01 11  add      w8, w8, #0x73
  00011ea4:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011ea8:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011eac:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011eb0:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011eb4:  28 00 80 52  mov      w8, #1
  00011eb8:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00011ebc:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00011ec0:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00011ec4:  55 17 00 34  cbz      w21, #0x121ac
  00011ec8:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00011ecc:  81 57 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00011ed0:  e1 03 1f 2a  mov      w1, wzr
  00011ed4:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011ed8:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00011edc:  81 57 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00011ee0:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00011ee4:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00011ee8:  55 1b 00 b4  cbz      x21, #0x12250
  00011eec:  c8 02 40 39  ldrb     w8, [x22]
  00011ef0:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00011ef4:  88 02 00 39  strb     w8, [x20]
  00011ef8:  c0 1a 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011efc:  c9 06 40 39  ldrb     w9, [x22, #1]
  00011f00:  a8 0a 00 f1  subs     x8, x21, #2
  00011f04:  89 06 00 39  strb     w9, [x20, #1]
  00011f08:  40 1a 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011f0c:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00011f10:  03 01 00 54  b.lo     #0x11f30
                ; salto condicional: se toma si la comparacion es CIERTA
  00011f14:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00011f18:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00011f1c:  a2 22 00 54  b.hs     #0x12370
                ; salto condicional: se toma si la comparacion es CIERTA
  00011f20:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  00011f24:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011f28:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00011f2c:  22 22 00 54  b.hs     #0x12370
                ; salto condicional: se toma si la comparacion es CIERTA

.L_11f30:
  00011f30:  4a 00 80 52  mov      w10, #2

.L_11f34:
  00011f34:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011f38:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00011f3c:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_11f40:
  00011f40:  0b 15 40 38  ldrb     w11, [x8], #1
  00011f44:  29 05 00 b1  adds     x9, x9, #1
  00011f48:  4b 15 00 38  strb     w11, [x10], #1
  00011f4c:  a3 ff ff 54  b.lo     #0x11f40
                ; salto condicional: se toma si la comparacion es CIERTA
  00011f50:  c0 00 00 14  b        #0x12250
  00011f54:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00011f58:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00011f5c:  41 67 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00011f60:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x11f64)
  00011f64:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00011f68:  08 bd 01 11  add      w8, w8, #0x6f
  00011f6c:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00011f70:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00011f74:  e8 13 00 b9  str      w8, [sp, #0x10]
  00011f78:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00011f7c:  28 00 80 52  mov      w8, #1
  00011f80:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00011f84:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00011f88:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00011f8c:  15 11 00 34  cbz      w21, #0x121ac
  00011f90:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00011f94:  4f 57 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00011f98:  e1 03 1f 2a  mov      w1, wzr
  00011f9c:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00011fa0:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00011fa4:  4f 57 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00011fa8:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00011fac:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00011fb0:  15 15 00 b4  cbz      x21, #0x12250
  00011fb4:  c8 02 40 39  ldrb     w8, [x22]
  00011fb8:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00011fbc:  88 02 00 39  strb     w8, [x20]
  00011fc0:  80 14 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011fc4:  c9 06 40 39  ldrb     w9, [x22, #1]
  00011fc8:  a8 0a 00 f1  subs     x8, x21, #2
  00011fcc:  89 06 00 39  strb     w9, [x20, #1]
  00011fd0:  00 14 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00011fd4:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00011fd8:  03 01 00 54  b.lo     #0x11ff8
                ; salto condicional: se toma si la comparacion es CIERTA
  00011fdc:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00011fe0:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00011fe4:  e2 1c 00 54  b.hs     #0x12380
                ; salto condicional: se toma si la comparacion es CIERTA
  00011fe8:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  00011fec:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00011ff0:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00011ff4:  62 1c 00 54  b.hs     #0x12380
                ; salto condicional: se toma si la comparacion es CIERTA

.L_11ff8:
  00011ff8:  4a 00 80 52  mov      w10, #2

.L_11ffc:
  00011ffc:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012000:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00012004:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_12008:
  00012008:  0b 15 40 38  ldrb     w11, [x8], #1
  0001200c:  29 05 00 b1  adds     x9, x9, #1
  00012010:  4b 15 00 38  strb     w11, [x10], #1
  00012014:  a3 ff ff 54  b.lo     #0x12008
                ; salto condicional: se toma si la comparacion es CIERTA
  00012018:  8e 00 00 14  b        #0x12250
  0001201c:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00012020:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  00012024:  01 61 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00012028:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x1202c)
  0001202c:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  00012030:  08 c1 01 11  add      w8, w8, #0x70
  00012034:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00012038:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  0001203c:  e8 13 00 b9  str      w8, [sp, #0x10]
  00012040:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  00012044:  28 00 80 52  mov      w8, #1
  00012048:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  0001204c:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00012050:  f5 2b 00 b9  str      w21, [sp, #0x28]
  00012054:  d5 0a 00 34  cbz      w21, #0x121ac
  00012058:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  0001205c:  1d 57 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00012060:  e1 03 1f 2a  mov      w1, wzr
  00012064:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00012068:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  0001206c:  1d 57 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00012070:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00012074:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00012078:  d5 0e 00 b4  cbz      x21, #0x12250
  0001207c:  c8 02 40 39  ldrb     w8, [x22]
  00012080:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  00012084:  88 02 00 39  strb     w8, [x20]
  00012088:  40 0e 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  0001208c:  c9 06 40 39  ldrb     w9, [x22, #1]
  00012090:  a8 0a 00 f1  subs     x8, x21, #2
  00012094:  89 06 00 39  strb     w9, [x20, #1]
  00012098:  c0 0d 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  0001209c:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  000120a0:  03 01 00 54  b.lo     #0x120c0
                ; salto condicional: se toma si la comparacion es CIERTA
  000120a4:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  000120a8:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  000120ac:  22 17 00 54  b.hs     #0x12390
                ; salto condicional: se toma si la comparacion es CIERTA
  000120b0:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  000120b4:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000120b8:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  000120bc:  a2 16 00 54  b.hs     #0x12390
                ; salto condicional: se toma si la comparacion es CIERTA

.L_120c0:
  000120c0:  4a 00 80 52  mov      w10, #2

.L_120c4:
  000120c4:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000120c8:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  000120cc:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_120d0:
  000120d0:  0b 15 40 38  ldrb     w11, [x8], #1
  000120d4:  29 05 00 b1  adds     x9, x9, #1
  000120d8:  4b 15 00 38  strb     w11, [x10], #1
  000120dc:  a3 ff ff 54  b.lo     #0x120d0
                ; salto condicional: se toma si la comparacion es CIERTA
  000120e0:  5c 00 00 14  b        #0x12250
  000120e4:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000120e8:  1f 39 00 71  cmp      w8, #0xe
                ; compara contra tag 0x0000000e (ACTIVE_DATETIME) [tipo=KM_INVALID, id=0xe]
  000120ec:  c1 5a ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000120f0:  28 4b 80 52  mov      w8, #0x259
                ; construye la constante 0x90000259  [tipo=KM_BYTES, id=0x259]
                ;   (completa en movk @0x120f4)
  000120f4:  08 00 b2 72  movk     w8, #0x9000, lsl #16
  000120f8:  08 d1 01 11  add      w8, w8, #0x74
  000120fc:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  00012100:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00012104:  e8 13 00 b9  str      w8, [sp, #0x10]
  00012108:  f6 ee 40 a9  ldp      x22, x27, [x23, #8]
  0001210c:  28 00 80 52  mov      w8, #1
  00012110:  e8 b3 00 39  strb     w8, [sp, #0x2c]
  00012114:  75 03 16 cb  sub      x21, x27, x22
                ; x21: callee-saved
                ; x27: callee-saved
                ; x22: callee-saved
  00012118:  f5 2b 00 b9  str      w21, [sp, #0x28]
  0001211c:  95 04 00 34  cbz      w21, #0x121ac
  00012120:  e0 03 15 aa  mov      x0, x21
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x21: callee-saved
  00012124:  eb 56 00 94  bl       #0x27cd0
                ; llama a funcion local/statica @0x27cd0
  00012128:  e1 03 1f 2a  mov      w1, wzr
  0001212c:  e2 03 15 aa  mov      x2, x21
                ; x2: arg2
                ; x21: callee-saved
  00012130:  f4 03 00 aa  mov      x20, x0
                ; x20: callee-saved
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00012134:  eb 56 00 94  bl       #0x27ce0
                ; llama a funcion local/statica @0x27ce0
  00012138:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  0001213c:  f4 13 00 f9  str      x20, [sp, #0x20]
                ; x20: callee-saved
  00012140:  95 08 00 b4  cbz      x21, #0x12250
  00012144:  c8 02 40 39  ldrb     w8, [x22]
  00012148:  bf 06 00 f1  cmp      x21, #1
                ; x21: callee-saved
                ; compara contra tag 0x00000001 (PURPOSE) [tipo=KM_INVALID, id=0x1]
  0001214c:  88 02 00 39  strb     w8, [x20]
  00012150:  00 08 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012154:  c9 06 40 39  ldrb     w9, [x22, #1]
  00012158:  a8 0a 00 f1  subs     x8, x21, #2
  0001215c:  89 06 00 39  strb     w9, [x20, #1]
  00012160:  80 07 00 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012164:  1f 21 00 f1  cmp      x8, #8
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000008 (MIN_MAC_LENGTH) [tipo=KM_INVALID, id=0x8]
  00012168:  03 01 00 54  b.lo     #0x12188
                ; salto condicional: se toma si la comparacion es CIERTA
  0001216c:  89 0a 00 91  add      x9, x20, #2
                ; x9: temporal (platform register)
                ; x20: callee-saved
  00012170:  3f 01 1b eb  cmp      x9, x27
                ; x9: temporal (platform register)
                ; x27: callee-saved
  00012174:  62 11 00 54  b.hs     #0x123a0
                ; salto condicional: se toma si la comparacion es CIERTA
  00012178:  89 02 15 8b  add      x9, x20, x21
                ; x9: temporal (platform register)
                ; x20: callee-saved
                ; x21: callee-saved
  0001217c:  ca 0a 00 91  add      x10, x22, #2
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012180:  5f 01 09 eb  cmp      x10, x9
                ; x10: temporal (platform register)
                ; x9: temporal (platform register)
  00012184:  e2 10 00 54  b.hs     #0x123a0
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12188:
  00012188:  4a 00 80 52  mov      w10, #2

.L_1218c:
  0001218c:  48 01 16 8b  add      x8, x10, x22
                ; x8: resultado indirecto (sret) + registro temporal
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012190:  09 01 1b cb  sub      x9, x8, x27
                ; x9: temporal (platform register)
                ; x8: resultado indirecto (sret) + registro temporal
                ; x27: callee-saved
  00012194:  8a 02 0a 8b  add      x10, x20, x10
                ; x10: temporal (platform register)
                ; x20: callee-saved

.L_12198:
  00012198:  0b 15 40 38  ldrb     w11, [x8], #1
  0001219c:  29 05 00 b1  adds     x9, x9, #1
  000121a0:  4b 15 00 38  strb     w11, [x10], #1
  000121a4:  a3 ff ff 54  b.lo     #0x12198
                ; salto condicional: se toma si la comparacion es CIERTA
  000121a8:  2a 00 00 14  b        #0x12250

.L_121ac:
  000121ac:  ff 13 00 f9  str      xzr, [sp, #0x20]
  000121b0:  28 00 00 14  b        #0x12250

.L_121b4:
  000121b4:  29 3f 80 52  mov      w9, #0x1f9
                ; construye la constante 0x300001f9  [tipo=KM_UINT, id=0x1f9]
                ;   (completa en movk @0x121b8)
  000121b8:  09 00 a6 72  movk     w9, #0x3000, lsl #16
  000121bc:  1f 01 09 6b  cmp      w8, w9
  000121c0:  21 54 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000121c4:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000121c8:  1f 2d 00 71  cmp      w8, #0xb
                ; compara contra tag 0x0000000b (MAC_LENGTH) [tipo=KM_INVALID, id=0xb]
  000121cc:  c1 53 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000121d0:  68 00 80 52  mov      w8, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x121d4)
  000121d4:  08 00 a6 72  movk     w8, #0x3000, lsl #16
  000121d8:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000121dc:  08 d9 07 11  add      w8, w8, #0x1f6
  000121e0:  18 00 00 14  b        #0x12240
  000121e4:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  000121e8:  1f 2d 00 71  cmp      w8, #0xb
                ; compara contra tag 0x0000000b (MAC_LENGTH) [tipo=KM_INVALID, id=0xb]
  000121ec:  c1 52 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  000121f0:  68 00 80 52  mov      w8, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x121f4)
  000121f4:  08 00 a6 72  movk     w8, #0x3000, lsl #16
  000121f8:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000121fc:  08 31 0b 11  add      w8, w8, #0x2cc
  00012200:  10 00 00 14  b        #0x12240
  00012204:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00012208:  1f 2d 00 71  cmp      w8, #0xb
                ; compara contra tag 0x0000000b (MAC_LENGTH) [tipo=KM_INVALID, id=0xb]
  0001220c:  c1 51 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00012210:  68 00 80 52  mov      w8, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x12214)
  00012214:  08 00 a6 72  movk     w8, #0x3000, lsl #16
  00012218:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  0001221c:  08 fd 0a 11  add      w8, w8, #0x2bf
  00012220:  08 00 00 14  b        #0x12240
  00012224:  e8 22 40 b9  ldr      w8, [x23, #0x20]
  00012228:  1f 2d 00 71  cmp      w8, #0xb
                ; compara contra tag 0x0000000b (MAC_LENGTH) [tipo=KM_INVALID, id=0xb]
  0001222c:  c1 50 ff 54  b.ne     #0x10c44
                ; salto condicional: se toma si la comparacion es CIERTA
  00012230:  68 00 80 52  mov      w8, #3
                ; construye la constante 0x30000003 = KEY_SIZE  [tipo=KM_UINT, id=0x3]
                ;   (completa en movk @0x12234)
  00012234:  08 00 a6 72  movk     w8, #0x3000, lsl #16
  00012238:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  0001223c:  08 2d 0b 11  add      w8, w8, #0x2cb

.L_12240:
  00012240:  e8 13 00 b9  str      w8, [sp, #0x10]
  00012244:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  00012248:  e8 0a 40 b9  ldr      w8, [x23, #8]

.L_1224c:
  0001224c:  e8 1b 00 b9  str      w8, [sp, #0x18]

.L_12250:
  00012250:  68 a6 40 a9  ldp      x8, x9, [x19, #8]
  00012254:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  00012258:  63 4d ff 54  b.lo     #0x10c04
                ; salto condicional: se toma si la comparacion es CIERTA
  0001225c:  e1 43 00 91  add      x1, sp, #0x10
                ; x1: arg1
  00012260:  e0 03 13 aa  mov      x0, x19
                ; x0: arg0 / puntero de retorno indirecto (x8)
                ; x19: callee-saved
  00012264:  c3 56 00 94  bl       #0x27d70
                ; llama a funcion local/statica @0x27d70
  00012268:  e8 b3 40 39  ldrb     w8, [sp, #0x2c]
  0001226c:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00012270:  a8 4e ff 34  cbz      w8, #0x10c44
  00012274:  e0 13 40 f9  ldr      x0, [sp, #0x20]
                ; x0: arg0 / puntero de retorno indirecto (x8)
  00012278:  60 4e ff b4  cbz      x0, #0x10c44
  0001227c:  69 56 00 94  bl       #0x27c20
                ; llama a funcion local/statica @0x27c20
  00012280:  02 e4 00 6f  movi     v2.2d, #0000000000000000
  00012284:  70 fa ff 17  b        #0x10c44

.L_12288:
  00012288:  3f 09 00 71  cmp      w9, #2
                ; compara contra tag 0x00000002 (ALGORITHM) [tipo=KM_INVALID, id=0x2]
  0001228c:  41 00 00 54  b.ne     #0x12294
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12290:
  00012290:  e8 03 09 2a  mov      w8, w9

.L_12294:
  00012294:  49 00 80 52  mov      w9, #2
                ; construye la constante 0x10000002 = ALGORITHM  [tipo=KM_ENUM, id=0x2]
                ;   (completa en movk @0x12298)
  00012298:  09 00 a2 72  movk     w9, #0x1000, lsl #16
  0001229c:  29 b9 04 11  add      w9, w9, #0x12e
  000122a0:  e2 8b 00 ad  stp      q2, q2, [sp, #0x10]
  000122a4:  ff 0f 00 f9  str      xzr, [sp, #0x18]
  000122a8:  e9 13 00 b9  str      w9, [sp, #0x10]
  000122ac:  e8 ff ff 17  b        #0x1224c

.L_122b0:
  000122b0:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  000122b4:  62 08 00 54  b.hs     #0x123c0
                ; salto condicional: se toma si la comparacion es CIERTA
  000122b8:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  000122bc:  4f 00 00 14  b        #0x123f8

.L_122c0:
  000122c0:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  000122c4:  62 0b 00 54  b.hs     #0x12430
                ; salto condicional: se toma si la comparacion es CIERTA
  000122c8:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  000122cc:  67 00 00 14  b        #0x12468

.L_122d0:
  000122d0:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  000122d4:  62 0e 00 54  b.hs     #0x124a0
                ; salto condicional: se toma si la comparacion es CIERTA
  000122d8:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  000122dc:  7f 00 00 14  b        #0x124d8

.L_122e0:
  000122e0:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  000122e4:  62 11 00 54  b.hs     #0x12510
                ; salto condicional: se toma si la comparacion es CIERTA
  000122e8:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  000122ec:  97 00 00 14  b        #0x12548

.L_122f0:
  000122f0:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  000122f4:  62 14 00 54  b.hs     #0x12580
                ; salto condicional: se toma si la comparacion es CIERTA
  000122f8:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  000122fc:  af 00 00 14  b        #0x125b8

.L_12300:
  00012300:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  00012304:  62 17 00 54  b.hs     #0x125f0
                ; salto condicional: se toma si la comparacion es CIERTA
  00012308:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  0001230c:  c7 00 00 14  b        #0x12628

.L_12310:
  00012310:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  00012314:  62 1a 00 54  b.hs     #0x12660
                ; salto condicional: se toma si la comparacion es CIERTA
  00012318:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  0001231c:  df 00 00 14  b        #0x12698

.L_12320:
  00012320:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  00012324:  62 1d 00 54  b.hs     #0x126d0
                ; salto condicional: se toma si la comparacion es CIERTA
  00012328:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  0001232c:  f7 00 00 14  b        #0x12708

.L_12330:
  00012330:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  00012334:  62 20 00 54  b.hs     #0x12740
                ; salto condicional: se toma si la comparacion es CIERTA
  00012338:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  0001233c:  0f 01 00 14  b        #0x12778

.L_12340:
  00012340:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  00012344:  62 23 00 54  b.hs     #0x127b0
                ; salto condicional: se toma si la comparacion es CIERTA
  00012348:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  0001234c:  27 01 00 14  b        #0x127e8

.L_12350:
  00012350:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  00012354:  62 26 00 54  b.hs     #0x12820
                ; salto condicional: se toma si la comparacion es CIERTA
  00012358:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  0001235c:  3f 01 00 14  b        #0x12858

.L_12360:
  00012360:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  00012364:  62 29 00 54  b.hs     #0x12890
                ; salto condicional: se toma si la comparacion es CIERTA
  00012368:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  0001236c:  57 01 00 14  b        #0x128c8

.L_12370:
  00012370:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  00012374:  62 2c 00 54  b.hs     #0x12900
                ; salto condicional: se toma si la comparacion es CIERTA
  00012378:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  0001237c:  6f 01 00 14  b        #0x12938

.L_12380:
  00012380:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  00012384:  62 2f 00 54  b.hs     #0x12970
                ; salto condicional: se toma si la comparacion es CIERTA
  00012388:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  0001238c:  87 01 00 14  b        #0x129a8

.L_12390:
  00012390:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  00012394:  62 32 00 54  b.hs     #0x129e0
                ; salto condicional: se toma si la comparacion es CIERTA
  00012398:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  0001239c:  9f 01 00 14  b        #0x12a18

.L_123a0:
  000123a0:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  000123a4:  62 35 00 54  b.hs     #0x12a50
                ; salto condicional: se toma si la comparacion es CIERTA
  000123a8:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  000123ac:  b7 01 00 14  b        #0x12a88

.L_123b0:
  000123b0:  1f 81 00 f1  cmp      x8, #0x20
                ; x8: resultado indirecto (sret) + registro temporal
                ; compara contra tag 0x00000020 [tipo=KM_INVALID, id=0x20]
  000123b4:  62 38 00 54  b.hs     #0x12ac0
                ; salto condicional: se toma si la comparacion es CIERTA
  000123b8:  e9 03 1f aa  mov      x9, xzr
                ; x9: temporal (platform register)
  000123bc:  cf 01 00 14  b        #0x12af8

.L_123c0:
  000123c0:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  000123c4:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000123c8:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  000123cc:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_123d0:
  000123d0:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  000123d4:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  000123d8:  8c 81 00 f1  subs     x12, x12, #0x20
  000123dc:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  000123e0:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  000123e4:  61 ff ff 54  b.ne     #0x123d0
                ; salto condicional: se toma si la comparacion es CIERTA
  000123e8:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  000123ec:  20 f3 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000123f0:  1f 05 7d f2  tst      x8, #0x18
  000123f4:  e0 39 00 54  b.eq     #0x12b30
                ; salto condicional: se toma si la comparacion es CIERTA

.L_123f8:
  000123f8:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  000123fc:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  00012400:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  00012404:  6a 01 7f b2  orr      x10, x11, #2
  00012408:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  0001240c:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012410:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12414:
  00012414:  80 85 40 fc  ldr      d0, [x12], #8
  00012418:  29 21 00 b1  adds     x9, x9, #8
  0001241c:  a0 85 00 fc  str      d0, [x13], #8
  00012420:  a1 ff ff 54  b.ne     #0x12414
                ; salto condicional: se toma si la comparacion es CIERTA
  00012424:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012428:  40 f1 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  0001242c:  fb fb ff 17  b        #0x11418

.L_12430:
  00012430:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  00012434:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012438:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  0001243c:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_12440:
  00012440:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  00012444:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  00012448:  8c 81 00 f1  subs     x12, x12, #0x20
  0001244c:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  00012450:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  00012454:  61 ff ff 54  b.ne     #0x12440
                ; salto condicional: se toma si la comparacion es CIERTA
  00012458:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  0001245c:  a0 ef ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012460:  1f 05 7d f2  tst      x8, #0x18
  00012464:  a0 36 00 54  b.eq     #0x12b38
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12468:
  00012468:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  0001246c:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  00012470:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  00012474:  6a 01 7f b2  orr      x10, x11, #2
  00012478:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  0001247c:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012480:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12484:
  00012484:  80 85 40 fc  ldr      d0, [x12], #8
  00012488:  29 21 00 b1  adds     x9, x9, #8
  0001248c:  a0 85 00 fc  str      d0, [x13], #8
  00012490:  a1 ff ff 54  b.ne     #0x12484
                ; salto condicional: se toma si la comparacion es CIERTA
  00012494:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012498:  c0 ed ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  0001249c:  11 fc ff 17  b        #0x114e0

.L_124a0:
  000124a0:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  000124a4:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000124a8:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  000124ac:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_124b0:
  000124b0:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  000124b4:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  000124b8:  8c 81 00 f1  subs     x12, x12, #0x20
  000124bc:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  000124c0:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  000124c4:  61 ff ff 54  b.ne     #0x124b0
                ; salto condicional: se toma si la comparacion es CIERTA
  000124c8:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  000124cc:  20 ec ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000124d0:  1f 05 7d f2  tst      x8, #0x18
  000124d4:  a0 33 00 54  b.eq     #0x12b48
                ; salto condicional: se toma si la comparacion es CIERTA

.L_124d8:
  000124d8:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  000124dc:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  000124e0:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  000124e4:  6a 01 7f b2  orr      x10, x11, #2
  000124e8:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  000124ec:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  000124f0:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_124f4:
  000124f4:  80 85 40 fc  ldr      d0, [x12], #8
  000124f8:  29 21 00 b1  adds     x9, x9, #8
  000124fc:  a0 85 00 fc  str      d0, [x13], #8
  00012500:  a1 ff ff 54  b.ne     #0x124f4
                ; salto condicional: se toma si la comparacion es CIERTA
  00012504:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012508:  40 ea ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  0001250c:  61 fa ff 17  b        #0x10e90

.L_12510:
  00012510:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  00012514:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012518:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  0001251c:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_12520:
  00012520:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  00012524:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  00012528:  8c 81 00 f1  subs     x12, x12, #0x20
  0001252c:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  00012530:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  00012534:  61 ff ff 54  b.ne     #0x12520
                ; salto condicional: se toma si la comparacion es CIERTA
  00012538:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  0001253c:  a0 e8 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012540:  1f 05 7d f2  tst      x8, #0x18
  00012544:  e0 2f 00 54  b.eq     #0x12b40
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12548:
  00012548:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  0001254c:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  00012550:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  00012554:  6a 01 7f b2  orr      x10, x11, #2
  00012558:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  0001255c:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012560:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12564:
  00012564:  80 85 40 fc  ldr      d0, [x12], #8
  00012568:  29 21 00 b1  adds     x9, x9, #8
  0001256c:  a0 85 00 fc  str      d0, [x13], #8
  00012570:  a1 ff ff 54  b.ne     #0x12564
                ; salto condicional: se toma si la comparacion es CIERTA
  00012574:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012578:  c0 e6 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  0001257c:  ac fc ff 17  b        #0x1182c

.L_12580:
  00012580:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  00012584:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012588:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  0001258c:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_12590:
  00012590:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  00012594:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  00012598:  8c 81 00 f1  subs     x12, x12, #0x20
  0001259c:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  000125a0:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  000125a4:  61 ff ff 54  b.ne     #0x12590
                ; salto condicional: se toma si la comparacion es CIERTA
  000125a8:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  000125ac:  20 e5 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000125b0:  1f 05 7d f2  tst      x8, #0x18
  000125b4:  e0 2c 00 54  b.eq     #0x12b50
                ; salto condicional: se toma si la comparacion es CIERTA

.L_125b8:
  000125b8:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  000125bc:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  000125c0:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  000125c4:  6a 01 7f b2  orr      x10, x11, #2
  000125c8:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  000125cc:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  000125d0:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_125d4:
  000125d4:  80 85 40 fc  ldr      d0, [x12], #8
  000125d8:  29 21 00 b1  adds     x9, x9, #8
  000125dc:  a0 85 00 fc  str      d0, [x13], #8
  000125e0:  a1 ff ff 54  b.ne     #0x125d4
                ; salto condicional: se toma si la comparacion es CIERTA
  000125e4:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  000125e8:  40 e3 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000125ec:  c2 fc ff 17  b        #0x118f4

.L_125f0:
  000125f0:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  000125f4:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000125f8:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  000125fc:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_12600:
  00012600:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  00012604:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  00012608:  8c 81 00 f1  subs     x12, x12, #0x20
  0001260c:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  00012610:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  00012614:  61 ff ff 54  b.ne     #0x12600
                ; salto condicional: se toma si la comparacion es CIERTA
  00012618:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  0001261c:  a0 e1 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012620:  1f 05 7d f2  tst      x8, #0x18
  00012624:  a0 29 00 54  b.eq     #0x12b58
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12628:
  00012628:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  0001262c:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  00012630:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  00012634:  6a 01 7f b2  orr      x10, x11, #2
  00012638:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  0001263c:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012640:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12644:
  00012644:  80 85 40 fc  ldr      d0, [x12], #8
  00012648:  29 21 00 b1  adds     x9, x9, #8
  0001264c:  a0 85 00 fc  str      d0, [x13], #8
  00012650:  a1 ff ff 54  b.ne     #0x12644
                ; salto condicional: se toma si la comparacion es CIERTA
  00012654:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012658:  c0 df ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  0001265c:  d8 fc ff 17  b        #0x119bc

.L_12660:
  00012660:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  00012664:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012668:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  0001266c:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_12670:
  00012670:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  00012674:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  00012678:  8c 81 00 f1  subs     x12, x12, #0x20
  0001267c:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  00012680:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  00012684:  61 ff ff 54  b.ne     #0x12670
                ; salto condicional: se toma si la comparacion es CIERTA
  00012688:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  0001268c:  20 de ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012690:  1f 05 7d f2  tst      x8, #0x18
  00012694:  60 26 00 54  b.eq     #0x12b60
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12698:
  00012698:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  0001269c:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  000126a0:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  000126a4:  6a 01 7f b2  orr      x10, x11, #2
  000126a8:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  000126ac:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  000126b0:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_126b4:
  000126b4:  80 85 40 fc  ldr      d0, [x12], #8
  000126b8:  29 21 00 b1  adds     x9, x9, #8
  000126bc:  a0 85 00 fc  str      d0, [x13], #8
  000126c0:  a1 ff ff 54  b.ne     #0x126b4
                ; salto condicional: se toma si la comparacion es CIERTA
  000126c4:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  000126c8:  40 dc ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000126cc:  ee fc ff 17  b        #0x11a84

.L_126d0:
  000126d0:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  000126d4:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000126d8:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  000126dc:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_126e0:
  000126e0:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  000126e4:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  000126e8:  8c 81 00 f1  subs     x12, x12, #0x20
  000126ec:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  000126f0:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  000126f4:  61 ff ff 54  b.ne     #0x126e0
                ; salto condicional: se toma si la comparacion es CIERTA
  000126f8:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  000126fc:  a0 da ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012700:  1f 05 7d f2  tst      x8, #0x18
  00012704:  20 23 00 54  b.eq     #0x12b68
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12708:
  00012708:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  0001270c:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  00012710:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  00012714:  6a 01 7f b2  orr      x10, x11, #2
  00012718:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  0001271c:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012720:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12724:
  00012724:  80 85 40 fc  ldr      d0, [x12], #8
  00012728:  29 21 00 b1  adds     x9, x9, #8
  0001272c:  a0 85 00 fc  str      d0, [x13], #8
  00012730:  a1 ff ff 54  b.ne     #0x12724
                ; salto condicional: se toma si la comparacion es CIERTA
  00012734:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012738:  c0 d8 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  0001273c:  04 fd ff 17  b        #0x11b4c

.L_12740:
  00012740:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  00012744:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012748:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  0001274c:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_12750:
  00012750:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  00012754:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  00012758:  8c 81 00 f1  subs     x12, x12, #0x20
  0001275c:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  00012760:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  00012764:  61 ff ff 54  b.ne     #0x12750
                ; salto condicional: se toma si la comparacion es CIERTA
  00012768:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  0001276c:  20 d7 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012770:  1f 05 7d f2  tst      x8, #0x18
  00012774:  e0 1f 00 54  b.eq     #0x12b70
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12778:
  00012778:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  0001277c:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  00012780:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  00012784:  6a 01 7f b2  orr      x10, x11, #2
  00012788:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  0001278c:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012790:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12794:
  00012794:  80 85 40 fc  ldr      d0, [x12], #8
  00012798:  29 21 00 b1  adds     x9, x9, #8
  0001279c:  a0 85 00 fc  str      d0, [x13], #8
  000127a0:  a1 ff ff 54  b.ne     #0x12794
                ; salto condicional: se toma si la comparacion es CIERTA
  000127a4:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  000127a8:  40 d5 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000127ac:  1a fd ff 17  b        #0x11c14

.L_127b0:
  000127b0:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  000127b4:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000127b8:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  000127bc:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_127c0:
  000127c0:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  000127c4:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  000127c8:  8c 81 00 f1  subs     x12, x12, #0x20
  000127cc:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  000127d0:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  000127d4:  61 ff ff 54  b.ne     #0x127c0
                ; salto condicional: se toma si la comparacion es CIERTA
  000127d8:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  000127dc:  a0 d3 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000127e0:  1f 05 7d f2  tst      x8, #0x18
  000127e4:  a0 1c 00 54  b.eq     #0x12b78
                ; salto condicional: se toma si la comparacion es CIERTA

.L_127e8:
  000127e8:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  000127ec:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  000127f0:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  000127f4:  6a 01 7f b2  orr      x10, x11, #2
  000127f8:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  000127fc:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012800:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12804:
  00012804:  80 85 40 fc  ldr      d0, [x12], #8
  00012808:  29 21 00 b1  adds     x9, x9, #8
  0001280c:  a0 85 00 fc  str      d0, [x13], #8
  00012810:  a1 ff ff 54  b.ne     #0x12804
                ; salto condicional: se toma si la comparacion es CIERTA
  00012814:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012818:  c0 d1 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  0001281c:  30 fd ff 17  b        #0x11cdc

.L_12820:
  00012820:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  00012824:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012828:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  0001282c:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_12830:
  00012830:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  00012834:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  00012838:  8c 81 00 f1  subs     x12, x12, #0x20
  0001283c:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  00012840:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  00012844:  61 ff ff 54  b.ne     #0x12830
                ; salto condicional: se toma si la comparacion es CIERTA
  00012848:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  0001284c:  20 d0 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012850:  1f 05 7d f2  tst      x8, #0x18
  00012854:  60 19 00 54  b.eq     #0x12b80
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12858:
  00012858:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  0001285c:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  00012860:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  00012864:  6a 01 7f b2  orr      x10, x11, #2
  00012868:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  0001286c:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012870:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12874:
  00012874:  80 85 40 fc  ldr      d0, [x12], #8
  00012878:  29 21 00 b1  adds     x9, x9, #8
  0001287c:  a0 85 00 fc  str      d0, [x13], #8
  00012880:  a1 ff ff 54  b.ne     #0x12874
                ; salto condicional: se toma si la comparacion es CIERTA
  00012884:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012888:  40 ce ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  0001288c:  46 fd ff 17  b        #0x11da4

.L_12890:
  00012890:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  00012894:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012898:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  0001289c:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_128a0:
  000128a0:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  000128a4:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  000128a8:  8c 81 00 f1  subs     x12, x12, #0x20
  000128ac:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  000128b0:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  000128b4:  61 ff ff 54  b.ne     #0x128a0
                ; salto condicional: se toma si la comparacion es CIERTA
  000128b8:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  000128bc:  a0 cc ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000128c0:  1f 05 7d f2  tst      x8, #0x18
  000128c4:  20 16 00 54  b.eq     #0x12b88
                ; salto condicional: se toma si la comparacion es CIERTA

.L_128c8:
  000128c8:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  000128cc:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  000128d0:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  000128d4:  6a 01 7f b2  orr      x10, x11, #2
  000128d8:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  000128dc:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  000128e0:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_128e4:
  000128e4:  80 85 40 fc  ldr      d0, [x12], #8
  000128e8:  29 21 00 b1  adds     x9, x9, #8
  000128ec:  a0 85 00 fc  str      d0, [x13], #8
  000128f0:  a1 ff ff 54  b.ne     #0x128e4
                ; salto condicional: se toma si la comparacion es CIERTA
  000128f4:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  000128f8:  c0 ca ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000128fc:  5c fd ff 17  b        #0x11e6c

.L_12900:
  00012900:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  00012904:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012908:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  0001290c:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_12910:
  00012910:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  00012914:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  00012918:  8c 81 00 f1  subs     x12, x12, #0x20
  0001291c:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  00012920:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  00012924:  61 ff ff 54  b.ne     #0x12910
                ; salto condicional: se toma si la comparacion es CIERTA
  00012928:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  0001292c:  20 c9 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012930:  1f 05 7d f2  tst      x8, #0x18
  00012934:  e0 12 00 54  b.eq     #0x12b90
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12938:
  00012938:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  0001293c:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  00012940:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  00012944:  6a 01 7f b2  orr      x10, x11, #2
  00012948:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  0001294c:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012950:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12954:
  00012954:  80 85 40 fc  ldr      d0, [x12], #8
  00012958:  29 21 00 b1  adds     x9, x9, #8
  0001295c:  a0 85 00 fc  str      d0, [x13], #8
  00012960:  a1 ff ff 54  b.ne     #0x12954
                ; salto condicional: se toma si la comparacion es CIERTA
  00012964:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012968:  40 c7 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  0001296c:  72 fd ff 17  b        #0x11f34

.L_12970:
  00012970:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  00012974:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012978:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  0001297c:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_12980:
  00012980:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  00012984:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  00012988:  8c 81 00 f1  subs     x12, x12, #0x20
  0001298c:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  00012990:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  00012994:  61 ff ff 54  b.ne     #0x12980
                ; salto condicional: se toma si la comparacion es CIERTA
  00012998:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  0001299c:  a0 c5 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000129a0:  1f 05 7d f2  tst      x8, #0x18
  000129a4:  a0 0f 00 54  b.eq     #0x12b98
                ; salto condicional: se toma si la comparacion es CIERTA

.L_129a8:
  000129a8:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  000129ac:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  000129b0:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  000129b4:  6a 01 7f b2  orr      x10, x11, #2
  000129b8:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  000129bc:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  000129c0:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_129c4:
  000129c4:  80 85 40 fc  ldr      d0, [x12], #8
  000129c8:  29 21 00 b1  adds     x9, x9, #8
  000129cc:  a0 85 00 fc  str      d0, [x13], #8
  000129d0:  a1 ff ff 54  b.ne     #0x129c4
                ; salto condicional: se toma si la comparacion es CIERTA
  000129d4:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  000129d8:  c0 c3 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  000129dc:  88 fd ff 17  b        #0x11ffc

.L_129e0:
  000129e0:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  000129e4:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  000129e8:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  000129ec:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_129f0:
  000129f0:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  000129f4:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  000129f8:  8c 81 00 f1  subs     x12, x12, #0x20
  000129fc:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  00012a00:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  00012a04:  61 ff ff 54  b.ne     #0x129f0
                ; salto condicional: se toma si la comparacion es CIERTA
  00012a08:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  00012a0c:  20 c2 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012a10:  1f 05 7d f2  tst      x8, #0x18
  00012a14:  60 0c 00 54  b.eq     #0x12ba0
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12a18:
  00012a18:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  00012a1c:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  00012a20:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  00012a24:  6a 01 7f b2  orr      x10, x11, #2
  00012a28:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  00012a2c:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012a30:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12a34:
  00012a34:  80 85 40 fc  ldr      d0, [x12], #8
  00012a38:  29 21 00 b1  adds     x9, x9, #8
  00012a3c:  a0 85 00 fc  str      d0, [x13], #8
  00012a40:  a1 ff ff 54  b.ne     #0x12a34
                ; salto condicional: se toma si la comparacion es CIERTA
  00012a44:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012a48:  40 c0 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012a4c:  9e fd ff 17  b        #0x120c4

.L_12a50:
  00012a50:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  00012a54:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012a58:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  00012a5c:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_12a60:
  00012a60:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  00012a64:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  00012a68:  8c 81 00 f1  subs     x12, x12, #0x20
  00012a6c:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  00012a70:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  00012a74:  61 ff ff 54  b.ne     #0x12a60
                ; salto condicional: se toma si la comparacion es CIERTA
  00012a78:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  00012a7c:  a0 be ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012a80:  1f 05 7d f2  tst      x8, #0x18
  00012a84:  20 09 00 54  b.eq     #0x12ba8
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12a88:
  00012a88:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  00012a8c:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  00012a90:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  00012a94:  6a 01 7f b2  orr      x10, x11, #2
  00012a98:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  00012a9c:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012aa0:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12aa4:
  00012aa4:  80 85 40 fc  ldr      d0, [x12], #8
  00012aa8:  29 21 00 b1  adds     x9, x9, #8
  00012aac:  a0 85 00 fc  str      d0, [x13], #8
  00012ab0:  a1 ff ff 54  b.ne     #0x12aa4
                ; salto condicional: se toma si la comparacion es CIERTA
  00012ab4:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012ab8:  c0 bc ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012abc:  b4 fd ff 17  b        #0x1218c

.L_12ac0:
  00012ac0:  09 e9 7b 92  and      x9, x8, #0xffffffffffffffe0
  00012ac4:  ca 4a 00 91  add      x10, x22, #0x12
                ; x10: temporal (platform register)
                ; x22: callee-saved
  00012ac8:  8b 4a 00 91  add      x11, x20, #0x12
                ; x11: temporal (platform register)
                ; x20: callee-saved
  00012acc:  ec 03 09 aa  mov      x12, x9
                ; x12: temporal (platform register)
                ; x9: temporal (platform register)

.L_12ad0:
  00012ad0:  40 85 7f ad  ldp      q0, q1, [x10, #-0x10]
  00012ad4:  4a 81 00 91  add      x10, x10, #0x20
                ; x10: temporal (platform register)
  00012ad8:  8c 81 00 f1  subs     x12, x12, #0x20
  00012adc:  60 85 3f ad  stp      q0, q1, [x11, #-0x10]
  00012ae0:  6b 81 00 91  add      x11, x11, #0x20
                ; x11: temporal (platform register)
  00012ae4:  61 ff ff 54  b.ne     #0x12ad0
                ; salto condicional: se toma si la comparacion es CIERTA
  00012ae8:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  00012aec:  20 bb ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012af0:  1f 05 7d f2  tst      x8, #0x18
  00012af4:  e0 05 00 54  b.eq     #0x12bb0
                ; salto condicional: se toma si la comparacion es CIERTA

.L_12af8:
  00012af8:  0b f1 7d 92  and      x11, x8, #0xfffffffffffffff8
  00012afc:  cc 02 09 8b  add      x12, x22, x9
                ; x12: temporal (platform register)
                ; x22: callee-saved
                ; x9: temporal (platform register)
  00012b00:  8d 02 09 8b  add      x13, x20, x9
                ; x13: temporal (platform register)
                ; x20: callee-saved
                ; x9: temporal (platform register)
  00012b04:  6a 01 7f b2  orr      x10, x11, #2
  00012b08:  8c 09 00 91  add      x12, x12, #2
                ; x12: temporal (platform register)
  00012b0c:  ad 09 00 91  add      x13, x13, #2
                ; x13: temporal (platform register)
  00012b10:  29 01 0b cb  sub      x9, x9, x11
                ; x9: temporal (platform register)
                ; x11: temporal (platform register)

.L_12b14:
  00012b14:  80 85 40 fc  ldr      d0, [x12], #8
  00012b18:  29 21 00 b1  adds     x9, x9, #8
  00012b1c:  a0 85 00 fc  str      d0, [x13], #8
  00012b20:  a1 ff ff 54  b.ne     #0x12b14
                ; salto condicional: se toma si la comparacion es CIERTA
  00012b24:  1f 01 0b eb  cmp      x8, x11
                ; x8: resultado indirecto (sret) + registro temporal
                ; x11: temporal (platform register)
  00012b28:  40 b9 ff 54  b.eq     #0x12250
                ; salto condicional: se toma si la comparacion es CIERTA
  00012b2c:  a1 fa ff 17  b        #0x115b0

.L_12b30:
  00012b30:  2a 01 7f b2  orr      x10, x9, #2
  00012b34:  39 fa ff 17  b        #0x11418

.L_12b38:
  00012b38:  2a 01 7f b2  orr      x10, x9, #2
  00012b3c:  69 fa ff 17  b        #0x114e0

.L_12b40:
  00012b40:  2a 01 7f b2  orr      x10, x9, #2
  00012b44:  3a fb ff 17  b        #0x1182c

.L_12b48:
  00012b48:  2a 01 7f b2  orr      x10, x9, #2
  00012b4c:  d1 f8 ff 17  b        #0x10e90

.L_12b50:
  00012b50:  2a 01 7f b2  orr      x10, x9, #2
  00012b54:  68 fb ff 17  b        #0x118f4

.L_12b58:
  00012b58:  2a 01 7f b2  orr      x10, x9, #2
  00012b5c:  98 fb ff 17  b        #0x119bc

.L_12b60:
  00012b60:  2a 01 7f b2  orr      x10, x9, #2
  00012b64:  c8 fb ff 17  b        #0x11a84

.L_12b68:
  00012b68:  2a 01 7f b2  orr      x10, x9, #2
  00012b6c:  f8 fb ff 17  b        #0x11b4c

.L_12b70:
  00012b70:  2a 01 7f b2  orr      x10, x9, #2
  00012b74:  28 fc ff 17  b        #0x11c14

.L_12b78:
  00012b78:  2a 01 7f b2  orr      x10, x9, #2
  00012b7c:  58 fc ff 17  b        #0x11cdc

.L_12b80:
  00012b80:  2a 01 7f b2  orr      x10, x9, #2
  00012b84:  88 fc ff 17  b        #0x11da4

.L_12b88:
  00012b88:  2a 01 7f b2  orr      x10, x9, #2
  00012b8c:  b8 fc ff 17  b        #0x11e6c

.L_12b90:
  00012b90:  2a 01 7f b2  orr      x10, x9, #2
  00012b94:  e8 fc ff 17  b        #0x11f34

.L_12b98:
  00012b98:  2a 01 7f b2  orr      x10, x9, #2
  00012b9c:  18 fd ff 17  b        #0x11ffc

.L_12ba0:
  00012ba0:  2a 01 7f b2  orr      x10, x9, #2
  00012ba4:  48 fd ff 17  b        #0x120c4

.L_12ba8:
  00012ba8:  2a 01 7f b2  orr      x10, x9, #2
  00012bac:  78 fd ff 17  b        #0x1218c

.L_12bb0:
  00012bb0:  2a 01 7f b2  orr      x10, x9, #2
  00012bb4:  7f fa ff 17  b        #0x115b0

.L_12bb8:
  00012bb8:  e8 07 40 f9  ldr      x8, [sp, #8]
                ; x8: resultado indirecto (sret) + registro temporal
  00012bbc:  08 15 40 f9  ldr      x8, [x8, #0x28]
                ; x8: resultado indirecto (sret) + registro temporal
  00012bc0:  a9 83 5f f8  ldur     x9, [x29, #-8]
  00012bc4:  1f 01 09 eb  cmp      x8, x9
                ; x8: resultado indirecto (sret) + registro temporal
                ; x9: temporal (platform register)
  00012bc8:  21 01 00 54  b.ne     #0x12bec
                ; salto condicional: se toma si la comparacion es CIERTA
  00012bcc:  f4 4f 49 a9  ldp      x20, x19, [sp, #0x90]
  00012bd0:  f6 57 48 a9  ldp      x22, x21, [sp, #0x80]
  00012bd4:  f8 5f 47 a9  ldp      x24, x23, [sp, #0x70]
  00012bd8:  fa 67 46 a9  ldp      x26, x25, [sp, #0x60]
  00012bdc:  fc 6f 45 a9  ldp      x28, x27, [sp, #0x50]
  00012be0:  fd 7b 44 a9  ldp      x29, x30, [sp, #0x40]
  00012be4:  ff 83 02 91  add      sp, sp, #0xa0
  00012be8:  c0 03 5f d6  ret      
