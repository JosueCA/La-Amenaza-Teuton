# Formato de ficheros .VQ (Vector Quantization)

Los ficheros **.VQ** son **imágenes comprimidas con Vector Quantization (VQ)**, un método de compresión con pérdida que agrupa píxeles en bloques y los representa mediante índices a un diccionario (codebook).

# Uso del script

Características:

Clustering k-means para generar codebook óptimo
Soporte para codebooks de 256 (índices 1 byte) o 4096 entradas (índices 2 bytes)
Múltiples frames se apilan verticalmente (como las texturas de agua originales)
Opción --reference para copiar parámetros del header del VQ original
Auto-detección de ficheros de frames por patrón *_frameNN.bmp

### Convertir todo assets_pak (por defecto)
python vq_converter.py

### Especificar directorios
python vq_converter.py assets_pak output_dir

### Convertir un solo fichero
python vq_converter.py decode GRASS1024.VQ

### Ver información de un fichero
python vq_converter.py info GRASS1024.VQ

### Codificar un solo BMP a VQ
python vq_converter.py encode imagen.bmp salida.VQ

### Con codebook grande (4096 entradas para alta calidad)
python vq_converter.py encode imagen.bmp salida.VQ --codebook 4096

### Usar fichero VQ de referencia para copiar parámetros del header
python vq_converter.py encode imagen.bmp salida.VQ --reference original.VQ

### Codificar múltiples frames (texturas animadas como agua)
python vq_converter.py encode "agua_frame*.bmp" AGUA.VQ --frames
python vq_converter.py encode agua_frame00.bmp AGUA.VQ --frames  # auto-detecta frames

### Con referencia (recomendado para mantener compatibilidad)
python vq_converter.py encode "SWATER_frame*.bmp" SWATER.VQ --frames --reference original/SWATER.VQ


## Estructura del fichero

| Offset | Tamaño | Campo | Descripción |
|--------|--------|-------|-------------|
| 0 | 4 | Magic | `mbqv` (ASCII) |
| 4 | 4 | Flags | 0 o 1 |
| 8 | 4 | Codebook entries | Número de entradas (64, 256, 4096) |
| 12 | 4 | BPP | 1=índices 1 byte, 2=índices 2 bytes |
| 16 | 4 | Block width | Siempre 2 (ignorar, usar 2) |
| 20 | 4 | Block height | Siempre 4 (ignorar, usar 2) |
| 24 | 4 | Unknown | Siempre 1 |
| 28 | 4 | Width | Ancho de imagen en píxeles |
| 32 | 4 | Height | Alto de imagen en píxeles |
| 36 | 4 | Tile width | Ancho de tile |
| 40 | 4 | Tile height | Alto de tile |
| 44 | ... | Codebook | Entradas RGB555 |
| ... | ... | Indices | Referencias al codebook |

## Formato de datos

### Bloques

Los bloques son de **2x2 píxeles** (nota: el header indica 2x4 pero el formato real usa 2x2).

### Codebook

Cada entrada del codebook contiene 4 píxeles en formato **RGB555** (16 bits little-endian):

```
Bit:  15  14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
      [X] [   RED    ] [  GREEN   ] [   BLUE    ]
```

- Bit 15: No usado
- Bits 10-14: Rojo (5 bits, 0-31)
- Bits 5-9: Verde (5 bits, 0-31)
- Bits 0-4: Azul (5 bits, 0-31)

**Tamaño de cada entrada**: 8 bytes (4 píxeles × 2 bytes)

### Índices

- Si codebook tiene ≤ 256 entradas: **1 byte** por índice
- Si codebook tiene > 256 entradas: **2 bytes** por índice (little-endian)

Los índices están organizados en orden de lectura (izquierda a derecha, arriba a abajo) por bloques de 2x2.

## Cálculo de tamaño

```
total_blocks = (width / 2) × (height / 2)
index_size = 1 si codebook_entries <= 256, sino 2
codebook_size = codebook_entries × 8

file_size = 44 + codebook_size + (total_blocks × index_size)
```

## Tipos de ficheros

| Tipo | Codebook | Índice | Ejemplos |
|------|----------|--------|----------|
| Texturas estáticas | 4096 | 2 bytes | GRASS1024, GROUND256, ROCKS1024, ROADS |
| Agua animada | 256 | 1 byte | SWATER, DWATER |
| Máscaras/Especiales | 64-256 | 1 byte | WAVES, INVALID |

## Animaciones

Las texturas de agua (SWATER.VQ, DWATER.VQ) contienen **10 frames** de animación apilados verticalmente:

- Dimensión total: 512 × 5120 píxeles
- Cada frame: 512 × 512 píxeles
- El atributo `frames="10"` en TERRAINS.XML indica el número de frames

Para extraer un frame específico:
```
frame_y_start = frame_number × 512
frame_y_end = frame_y_start + 512
```

## Decodificación (pseudocódigo)

```python
def decode_vq(data):
    # Leer header
    header_size = 44
    codebook_entries = read_uint32(data, 8)
    width = read_uint32(data, 28)
    height = read_uint32(data, 32)

    # Determinar tamaño de índice
    index_size = 1 if codebook_entries <= 256 else 2

    # Leer codebook
    codebook = []
    for i in range(codebook_entries):
        offset = header_size + i * 8
        pixels = [rgb555_to_rgb(read_uint16(data, offset + j*2)) for j in range(4)]
        codebook.append(pixels)

    # Leer índices y reconstruir imagen
    indices_offset = header_size + codebook_entries * 8
    image = new_image(width, height)

    block_index = 0
    for by in range(height // 2):
        for bx in range(width // 2):
            if index_size == 1:
                cb_idx = data[indices_offset + block_index]
            else:
                cb_idx = read_uint16(data, indices_offset + block_index * 2)

            pixels = codebook[cb_idx]
            x, y = bx * 2, by * 2
            image[x, y] = pixels[0]
            image[x+1, y] = pixels[1]
            image[x, y+1] = pixels[2]
            image[x+1, y+1] = pixels[3]

            block_index += 1

    return image

def rgb555_to_rgb(val):
    r = ((val >> 10) & 0x1F) * 255 // 31
    g = ((val >> 5) & 0x1F) * 255 // 31
    b = (val & 0x1F) * 255 // 31
    return (r, g, b)
```

## Relación con TERRAINS.XML

El fichero TERRAINS.XML define las capas de terreno y referencia los ficheros .VQ:

```xml
<layer
    z="3" type="1" display="Grass 1"
    image="assets/terrain/%Season%/grass1024.vq"
    minimap="%Season%/grass1024.bmp"
/>
```

- `%Season%` se sustituye por SPRING, AUTUMN o WINTER
- `frames` indica animación (ej: `frames="10"` para agua)
- `minimap` referencia un BMP para el minimapa

## Listado de ficheros

### Por estación (SPRING/AUTUMN/WINTER)
- GRASS1024.VQ - Hierba principal (1024×682)
- GRASS2.VQ - Hierba variante 2
- GRASS3.VQ - Hierba variante 3
- GRASS512.VQ - Hierba 512px
- GROUND1024.VQ - Tierra principal
- GROUND256.VQ - Tierra 256px
- ROADS.VQ - Caminos
- ROCKS1024.VQ - Rocas grandes
- ROCKS256.VQ - Rocas pequeñas
- ROCKS2.VQ - Rocas de costa
- RROADS.VQ - Caminos romanos
- SANDS.VQ - Arena

### Compartidos (raíz TERRAIN/)
- DWATER.VQ - Agua profunda (animada, 10 frames)
- SWATER.VQ - Agua superficial (animada, 10 frames)
- WAVES.VQ - Olas/espuma
- INVALID.VQ - Terreno inválido/bloqueado
