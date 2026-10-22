# Metadatos del ROM y estructura real del port

## 1. Identidad de la ROM

El room **ZestUI** es una *"room"* (custom ROM) **adaptada al Galaxy A23 4G**
(One UI 8.5 / Android 16). Los metadatos vienen de
`ZestUI-4.2.9-SM-A235F-S911BXXSAFZH3/build_info.txt`:

```
device=a23
version=4.9.2
timestamp=1783783498
security_patch_version=2026-08
incremental=0
ncremental=0
```

> **Ojo con el nombre del fichero**: `S911BXXSAFZH3` es el **codepoint de
> baseband** heredado, **no** la versión de Android. One UI 8.5 es Android 16
> (parche de seguridad 2026-08). Tomarse el nombre del ZIP como indicador de
> la versión de Android lleva a conclusiones equivocadas.

### Por qué esto es la raíz de todos los problemas

El A23 4G monta **kernel 4.19** (rama `4.19.151-perf`, build `SRPUL29A015`), y
la cadena de herramientas de **Android 16** asume **kernel 5.4+**. De ahí
salen, uno detrás de otro:

| Requisito de Android 16 | Kernel 4.19 del A23 | Síntoma |
|---|---|---|
| `netbpfload` (eBPF) exige ≥ 5.4 | no lo cumple | **reinicio a bootloader** (Vector C) |
| `init` con `reboot_on_failure` en servicios no esenciales | el guardián no es opcional | convierte un fallo menor en un brick |
| `sepolicy` de Android 16 | dominios que no existen en el A23 | `Permission denied` en cascada |
| HALs de display/luces de One UI 8.5 | `vendor` de la A235F | `init.qti.display.sh` no arranca |

Es decir: **el problema de fondo no es un bug del port, es un desajuste de
generación de kernel** entre la ROM de origen y el hardware destino. Portar
"de la misma generación de One UI" no daría estos fallos, exactamente como
apuntas.

## 2. `dynamic_partitions_op_list` — el layout que se está flasheando

```
# Remove all existing dynamic partitions and groups before refresh
remove_all_groups

add_group qti_dynamic_partitions 9017753600

add system qti_dynamic_partitions
add vendor qti_dynamic_partitions
add odm   qti_dynamic_partitions

resize system 5874409472     # 5.5 GB
resize vendor  922710016     # 880 MB
resize odm     21389312      # 20 MB
```

El `resize` de `vendor` coincide **byte a byte** con el `vendor.img` del
directorio de trabajo → confirma que el `vendor.img` que se está montando es
el de ZestUI, no uno del stock.

## 3. Directorio de trabajo del port

Ruta en la USB:

```
CustomRoom_85_forGalaxiA23/
├── SM-A235M_3_20260214092611_3n72f3q1fl_fac/   # firmware stock A235M
├── Sona de trabajo/                               # (variante previa)
├── Sona de trabajo F/                             # <-- PORT ACTUAL
│   ├── boot.img                 100 663 296      # boot original A235F
│   ├── boot_port_A235M.img      100 663 296      # boot parcheado (SRPUL29A015)
│   ├── dtb                          332 550
│   ├── kernel                   45 142 528
│   ├── magiskboot                4 017 496
│   ├── odm.img                    21 389 312      # F2FS
│   ├── odm.new.dat                2 015 232
│   ├── ramdisk.cpio               1 819 648
│   ├── ramdisk_F/                                 # ramdisk desempaquetado
│   │   ├── fstab.default              5 740      # <-- el fstab parcheado
│   │   ├── init                    1 803 584
│   │   ├── dpolicy                      9 108
│   │   └── {dev,mnt,proc,sys,debug_ramdisk}/
│   ├── vendor.img                 922 710 016      # F2FS
│   ├── vendor.new.dat             661 655 552
│   └── vbmeta_disabled_A235M.img     65 536
└── ZestUI-4.2.9-SM-A235F-S911BXXSAFZH3/            # paquete original ZestUI
    ├── build_info.txt
    ├── dynamic_partitions_op_list
    ├── system.new.dat.br          4 887 007 103      # system comprimido
    ├── system.transfer.list           57 361
    ├── vendor.new.dat.br            433 641 383
    ├── vendor.transfer.list             7 645
    ├── odm.new.dat.br                  594 275
    └── vbmeta.img / META-INF/ ...
```

### El `fstab.default` del ramdisk ES el fichero "fstab_vendor.txt"

Verificado byte a byte: el fichero que se subió para el Vector A **es**
`Sona de trabajo F/ramdisk_F/fstab.default`. La única diferencia es que la
versión subida usa **tabuladores** como separadores de campo y la del
dispositivo usa espacios.

**Consecuencia**: el Vector A se aplicó al fichero **correcto** (el
first-stage, que es el que monta `/data` en la primera etapa). No hace falta
un segundo fstab de `vendor/etc` para este ROM.

## 4. `netbpfload` está en `system`, no en `vendor`

Búsqueda directa sobre el `vendor.img` porteado (F2FS, 922 MB):

| Patrón | Hits en `vendor.img` |
|---|---|
| `netbpfload` | **0** |
| `reboot_on_failure` | 2 → ambos de `boringssl_self_test{32,64}_vendor` |

```
service boringssl_self_test64_vendor /vendor/bin/boringssl_self_test64
    setenv BORINGSSL_SELF_TEST_CREATE_FLAG true
    reboot_on_failure reboot,boringssl-self-check-failed
    stdio_to_kmsg
```

Es decir: el guardián `reboot_on_failure` **sí** existe en el `vendor` de
ZestUI, pero para otro servicio. El `netbpfload` que aborta está en la
partición **`system`**, en `/system/etc/init/hw/init.rc` — exactamente lo que
indica el log del arranque:

```
init: processing action (load-bpf_programs) from (/system/etc/init/hw/init.rc:1403)
init: starting service 'netbpfload'...
```

### Implicación práctica

El `init.rc` a parchear **no está en `vendor.img` sino en `system.new.dat.br`**
(4.8 GB, brotli + sparse, con `system.transfer.list` de 57 KB). Para extraerlo
hay que:

```bash
# 1) descomprimir brotli -> sparse
brotli -d system.new.dat.br -o system.new.dat

# 2) sparse -> raw (sdat2img, o parsear el transfer.list a mano)
# 3) montar la imagen y copiar /system/etc/init/hw/init.rc
```

Alternativa más ligera: `grep` directo sobre el `system.new.dat.br` descomprimido
para buscar `netbpfload` y `reboot_on_failure`, como se hizo con `vendor.img`.

## 5. Artifacts del boot

| Fichero | Qué es |
|---|---|
| `boot.img` | boot original de la A235F (ZestUI) |
| `boot_port_A235M.img` | boot ya parcheado para el A235M (`SRPUL29A015`) |
| `vbmeta_disabled_A235M.img` | vbmeta con AVB desactivado (65 536 bytes) |
| `magiskboot` | herramienta usada para el parcheo |
| `dtb` | Device Tree Blob (332 KB) |

## 6. Pendiente de verificación

- [ ] Confirmar la versión exacta de One UI desde el `build.prop` de `system`
      (el `build_info.txt` da `version=4.9.2` del *room*, no de One UI).
- [ ] Extraer `/system/etc/init/hw/init.rc` de `system.new.dat.br` y localizar
      la declaración de `netbpfload` → aplicar el Vector C.
- [ ] Comprobar el `init` del ramdisk (`ramdisk_F/init`, 1.8 MB): es el
      `init` first-stage de **Android 16**, no el del A235M stock. Incluye la
      lógica de `fs_mgr` con soporte de eBPF/FEATURE.
