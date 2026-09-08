# Assets

Imágenes del proyecto. Las presentaciones y el README público tiran de aquí.

| Carpeta | Qué hay | ¿Se edita a mano? |
|---|---|---|
| `photos/` | Fotos reales del quad, ya convertidas a JPG | **Sí** — aquí se añaden fotos nuevas |
| `photos/_originals/` | Los HEIC del iPhone tal cual salieron | No |
| `crops/` | Recortes derivados (bandas 16:9 y verticales) | **No — generado** |
| `figures/` | Diagramas y gráficas generados con matplotlib | **No — generado** |
| `web/` | Imágenes de producto descargadas, con su fuente | No |

`crops/` y `figures/` los regenera el comando de abajo, y **no están en Git**:
son derivados de `photos/`, que sí lo está. En una máquina nueva, ejecutarlo antes
de construir un deck.

```bash
./.venv/Scripts/python.exe 01_plan/presentations/_figures.py
```

## Cómo añadir una foto nueva

1. Copiar el HEIC a `photos/_originals/`.
2. Convertir a JPG en `photos/` (`pillow-heif` ya está en el venv).
3. Si hace falta un recorte para una slide, añadir la entrada en la lista
   `jobs` de `_figures.py::crops()` y volver a ejecutarlo. **Nunca recortar a mano:**
   el recorte tiene que ser reproducible.

## Qué foto es cada una

| Archivo | Qué se ve |
|---|---|
| `IMG_7163` | El quad de frente, en el patio. Librea azul/blanca |
| `IMG_7175` | El pack 13S5P abierto: 65 celdas y el BMS JK |
| `IMG_7239` | Tren trasero: motor "1900 W brushless", cadena, corona 92T |
| `IMG_7300` | Trasera 3/4 en tierra. Motor y transmisión en primer plano |
| `IMG_7301` | El quad entero en el campo. **Foto de portada** |

## Procedencia de `web/`

| Archivo | Fuente | Uso |
|---|---|---|
| `vesc_flipsky_1.jpg` | flipsky.net, ficha del Mini FSESC6.7 PRO 70A | Slide del inversor |
| `vesc_flipsky_2.jpg` | ídem (versión con disipador) | Sin usar |

Son fotos de producto del fabricante, usadas para identificar el componente en una
presentación interna. Si el deck sale del ámbito interno, sustituirlas por una foto
propia del VESC montado en el quad.
