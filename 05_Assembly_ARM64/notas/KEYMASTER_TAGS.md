# Tags de Keymaster / KeyMint — tabla de referencia

Referencia para interpretar las comparaciones de tags que aparecen en el
desensamblado de `libkm_compat.so` y para saber si un valor corresponde a un
tag **estándar** o a un **vendor tag** de Samsung.

## 1. Codificación

Un tag de Keymaster es un `uint32_t` con la estructura:

```
 31      28 27                    0
+--------+-----------------------+
|  tipo  |        id del tag      |
+--------+-----------------------+
```

El **nibble superior** codifica el tipo del valor associated al parámetro
(`keymaster_tag_type_t`):

| Nibble | Tipo | Significado |
|---|---|---|
| 0x0 | `KM_INVALID` | Sin tipo |
| 0x1 | `KM_ENUM` | `enum` |
| 0x2 | `KM_ENUM_REP` | `enum[]` |
| 0x3 | `KM_UINT` | `uint32_t` |
| 0x4 | `KM_UINT_REP` | `uint32_t[]` |
| 0x5 | `KM_ULONG` | `uint64_t` |
| 0x6 | `KM_DATE` | fecha (días desde 1970) |
| 0x7 | `KM_BOOL` | `bool` |
| 0x8 | `KM_BIGNUM` | `KM_BIGNUM` (bignum) |
| 0x9 | `KM_BYTES` | `blob` |
| 0xA | `KM_ULONG_REP` | `uint64_t[]` |
| 0xB | *reservado* | |
| 0xC | *reservado* | **rango vendor** |
| 0xD | *reservado* | **rango vendor** |
| 0xE | *reservado* | **rango vendor** |
| 0xF | *reservado* | **rango vendor** |

## 2. Rango vendor

> En KeyMint (AIDL) los tipos de tag **≥ 0xC0000000** están reservados para uso
> específico del fabricante (*vendor specific*). Ahí es donde Samsung define sus
> `KM_TAG_SAMSUNG_*`: `ROT_REQUIRED`, `RKP`, `KNOX_VER`, `KNOX_API_LEVEL`, etc.

### Trampa habitual

`0x8xxxxxxx`–`0xAxxxxxxx` **NO** son vendor: son los tipos estándar
`KM_BIGNUM`, `KM_BYTES` y `KM_ULONG_REP`. Confundirlos produce falsos
positivos. Ejemplo real encontrado en el análisis:

```
0x900003e8 = KM_BYTES | 0x3e8 = APPLICATION_ID   <-- tag ESTANDAR
0xcffffd3f                                       <-- bias de switch, no un tag
```

## 3. Tags estándar frecuentes

| ID | Nombre | Tipo | Valor completo |
|---|---|---|---|
| 0x01 | `PURPOSE` | `KM_ENUM_REP` | `0x20000001` |
| 0x02 | `ALGORITHM` | `KM_ENUM` | `0x10000002` |
| 0x03 | `KEY_SIZE` | `KM_UINT` | `0x30000003` |
| 0x04 | `BLOCK_MODE` | `KM_ENUM_REP` | `0x20000004` |
| 0x05 | `DIGEST` | `KM_ENUM_REP` | `0x20000005` |
| 0x06 | `PADDING` | `KM_ENUM_REP` | `0x20000006` |
| 0x07 | `CALLER_NONCE` | `KM_BOOL` | `0x70000007` |
| 0x08 | `MIN_MAC_LENGTH` | `KM_UINT` | `0x30000008` |
| 0x0A | `EC_CURVE` | `KM_ENUM` | `0x1000000A` |
| 0x0B | `MAC_LENGTH` | `KM_UINT` | `0x3000000B` |
| 0x0C | `ROLLBACK_RESISTANCE` | `KM_BOOL` | `0x7000000C` |
| 0x0D | `EARLY_BOOT_ONLY` | `KM_BOOL` | `0x7000000D` |
| 0x0E | `ACTIVE_DATETIME` | `KM_DATE` | `0x6000000E` |
| 0x0F | `ORIGINATION_EXPIRE_DATE` | `KM_DATE` | `0x6000000F` |
| 0x10 | `USAGE_EXPIRE_DATE` | `KM_DATE` | `0x60000010` |
| 0x11 | `ACTIVE_TIMESTAMP` | `KM_ULONG` | `0x50000011` |
| 0x12 | `ORIGINATION_EXPIRES` | `KM_ULONG` | `0x50000012` |
| 0x13 | `USABLE_EXPIRE_DATE` | `KM_ULONG` | `0x50000013` |
| 0x14 | `DEFAULT_DH_PARAMS` | `KM_BIGNUM` | `0x80000014` |
| 0x15 | `IV` | `KM_BYTES` | `0x90000015` |
| 0x16 | `KEY_GENERATION_EXPIRATION` | `KM_DATE` | `0x60000016` |
| 0x17 | `BOOT_ONLY` | `KM_BOOL` | `0x70000017` |
| 0x18 | `DEVICE_UNIQUE_ATTESTATION` | `KM_BOOL` | `0x70000018` |
| 0x19 | `IDENTITY_CREDENTIAL` | `KM_BOOL` | `0x70000019` |
| 0x1A | `STORAGE_KEY` | `KM_BOOL` | `0x7000001A` |
| 0xC8 | `RSA_PUBLIC_EXPONENT` | `KM_ULONG` | `0x500000C8` |
| 0x1F4 | `RSA_OAEP_MGF_DIGEST` | `KM_ENUM_REP` | `0x200001F4` |
| 0x3E8 | `APPLICATION_ID` | `KM_BYTES` | `0x900003E8` |
| 0x3E9 | `APPLICATION_DATA` | `KM_BYTES` | `0x900003E9` |

> **Nota**: los valores de `PURPOSE`/`BLOCK_MODE`/etc. difieren ligeramente
> entre Keymaster 4.0 (HIDL) y KeyMint (AIDL) porque KeyMint renumeró algunos
> tags. `annotate_asm.py` muestra siempre el **tipo** y el **id** por separado
> para que la lectura no dependa de esa equivalencia.

## 4. Tags de Android Keystore (`TAG_*`)

Los que expone Android Keystore hacia arriba (no confundir con los de
Keymaster):

| Tag | Valor |
|---|---|
| `TAG_INCLUDE_UNIQUE_ID` | 0 |
| `TAG_BLOCK_MODE` | 1 |
| `TAG_ENCRYPTION_ALGORITHM` | 2 |
| `TAG_KEY_SIZE` | 3 |
| `TAG_KEY_ALIAS` | 4 |
| `TAG_KEY_PURPOSE` | 5 |
| `TAG_PADDING` | 6 |
| `TAG_DIGEST` | 7 |
| `TAG_USER_AUTH_REQUIRED` | 8 |
| `TAG_USER_AUTH_TYPE` | 9 |
| `TAG_USER_AUTH_VALIDITY_DURATION` | 10 |
| `TAG_KEY_IS_DEFAULT_CREDENTIAL` | 11 |
| `TAG_MIN_MAC_LENGTH` | 12 |

`TAG_IV` e `TAG_RANDOMIZED_ENCRYPTION_REQUIRED` quedaron obsoletos.

## 5. Aplicación a este puerto

El crash de los 39 s implicaba el vendor tag **`KM_TAG_SAMSUNG_ROT_REQUIRED`**.
Su valor numérico **no se pudo determinar** con los artefactos disponibles:

- El `libkm_compat.so` subido es la build **AOSP stock** → no contiene ni el
  tag ni la cadena de log.
- La búsqueda de constantes vendor (≥ 0xC0000000) en ese binario no devuelve
  ninguna dentro del código (sólo `0x80000300` en datos, que es un tag
  estándar `KM_BIGNUM`).

**Para obtenerlo** hay que analizar el `libkm_compat.so` **de la ROM ZestUI**
(no el del A235M), que sí llevará el parche de Samsung. Con ese binario:

```bash
python3 elf_patcher.py libkm_compat_ZestUI.so --scan
# lista todas las constantes vendor presentes con su vaddr
```

y después:

```bash
python3 elf_patcher.py libkm_compat_ZestUI.so --tag 0x<VALOR> --apply -o parcheado.so
```

## 6. Referencias

- `system/core/libkeymaster/include/keymaster/Tag.h` — tipos y tags base
- `hardware/interfaces/security/keymaster/4.0/types.hal` — tags del HAL 4.0
- `hardware/interfaces/security/keymint/aidl/.../Tag.aidl` — tags de KeyMint
- `system/security/keystore2/src/km_compat/km_compat.cpp` — el código analizado
