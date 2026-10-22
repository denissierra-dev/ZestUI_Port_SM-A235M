# Ensamblador ARM64 anotado

Herramientas y salidas de análisis estático de binarios AArch64.

## Contenido

| Fichero | Descripción |
|---|---|
| `annotate_asm.py` | Generador de `.asm` anotado (LIEF + Capstone) |
| `libkm_compat/convertKeyParametersToLegacy.asm` | Desensamblado anotado de la función mapeada (2 077 instrs) |
| `libkm_compat/funciones_exportadas.txt` | Índice de las funciones exportadas del `.so` |
| `notas/ABI_AAPCS64.md` | Referencia de ABI y de los patrones de código generados por clang |
| `notas/KEYMASTER_TAGS.md` | Tabla de tags de Keymaster/KeyMint y del rango vendor |

## Uso de `annotate_asm.py`

```bash
# por nombre de función (soporta nombres mangled, prefijo)
python3 annotate_asm.py libkm_compat.so --func convertKeyParametersToLegacy -o f.asm

# por rango de direcciones
python3 annotate_asm.py libkm_compat.so --start 0x10b78 --end 0x12bec -o f.asm

# listar funciones exportadas
python3 annotate_asm.py libkm_compat.so --list-syms
```

## Qué anota

1. **Bytes en hexadecimal** por instrucción, para poder verificar a mano.
2. **ABI AAPCS64**: papel de cada registro tocado (argumento, `sret`,
   callee-saved, temporal).
3. **Constantes de 32 bits** reconstruidas a partir de secuencias
   `movz` + `movk` (con barrido de ventana, porque el compilador puede separar
   ambas instrucciones).
4. **Decodificación de tags de Keymaster**: tipo (nibble superior) e id.
5. **Rango vendor**: marca los tags con tipo ≥ 0xC0000000 (los `KM_TAG_SAMSUNG_*`).
6. **Tablas de salto (switch)**: detecta el patrón completo
   `bias → add → cmp → b.hi → adrp → ldrh → br` y etiqueta el bias como tal,
   para que no se confunda con un vendor tag.
7. **Destinos de `bl`** resueltos a nombre de símbolo cuando existen.

## Advertencia sobre el rango vendor

El anotador marca como *"VENDOR"* sólo los tags con **tipo ≥ 0xC0000000**.
Los valores `0x8xxxxxxx`–`0xAxxxxxxx` son los tipos **estándar**
`KM_BIGNUM` / `KM_BYTES` / `KM_ULONG_REP`, **no** vendor. Confundir ambos
rangos produce parches sobre sitios equivocados.

## Limitación conocida

`capstone` aliasa `movz` sin desplazamiento a `mov`, de modo que la
distinción entre `movz w1, #0x10` y `mov w1, #0x10` se pierde en el
desensamblado. No afecta a la reconstrucción de constantes (que se basa en el
inmediato de 16 bits y el `movk` posterior), pero sí impide distinguir un
`mov` real de un `movz` en el listado.
