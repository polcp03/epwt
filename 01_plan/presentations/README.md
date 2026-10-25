# Presentaciones

Una por review. **Mismo sistema visual siempre**, para no rediseñar cada dos semanas.

> [!success] Estado: v6 construida y verificada
> `C00-kickoff.pptx` — 14 slides. Verificadas con `_check.py` (cero desbordes) y
> renderizadas una a una con PowerPoint.
>
> **v6, tras la revisión de Pol del 8-sep:** fuera la slide de "objective zero"
> (sus dos columnas se funden en la 02) y fuera la de hallazgos de configuración.
> La relación de transmisión pasa de párrafo a cuatro fórmulas, la envolvente
> gana el techo de tensión y pierde el eje en rad/s, la slide de método pasa a
> chips, y el plan enseña el horizonte 2027.
>
> **Regla de esta v6: es un OVERVIEW.** Si una slide necesita un párrafo para
> entenderse, el problema es el párrafo. Menos texto, más figura.
> v1 (diseño rechazado) queda en `_archive/presentations-v1/` como referencia de qué no hacer.

## El sistema visual

Nace de la plantilla **DYN-09** (Formula Student, UPC Manresa) que Pol usa en el
trabajo: banda de foto arriba, franja azul con el título, cuerpo, franja azul abajo,
chevrón con el logo en la esquina. Se conserva la estructura; cambia la paleta.

| | |
|---|---|
| **Nombre** | OFF-ROAD EV PLATFORM · badge `EV` |
| **Cuerpo** | Blanco (DYN-09 lo tiene negro; el quad es azul/blanco) |
| **Azul primario** | `#1D4E9C` — muestreado de la carrocería real del quad |
| **Azul oscuro** | `#0F2E63` — portada y slide de peticiones |
| **Tipografía** | Arial, como DYN-09 |
| **Formato** | 10 × 5,625 in (16:9), idéntico a la plantilla |

Todo vive en `_brand.py`. Un color no se escribe dos veces.

## Los cinco layouts

| Layout | Cuándo | Ejemplo |
|---|---|---|
| `cover` | Portada. Foto vertical a la izquierda, bloque azul a la derecha | 01 |
| `std` | DYN-09 exacto: banda de foto + franja + cuerpo corto | 02, 14 |
| `split` | Franja arriba + columna de foto a sangre | 03 |
| `tall` | Franja arriba, cuerpo a toda altura. Para figuras y tablas | 04–12 |
| `dark` | Slide azul oscuro entera. Solo para "qué necesito de vosotros" | 13 |

## Archivos

| Archivo | Qué es |
|---|---|
| `_brand.py` | Paleta, tipografía y geometría. Fuente única |
| `_deck.py` | Los cinco layouts y las primitivas (`card`, `chip`, `stat`, `img`) |
| `_figures.py` | Genera badge, diagramas, gráficas y recortes a `assets/` |
| `C00_kickoff.py` | El contenido del deck C00. Solo dice **qué** va, no **dónde** |
| `_check.py` | Verificación geométrica: avisa del texto que desborda su caja |
| `_audit.py` | Auditoría de números: cada cifra de cada slide contra las fuentes de verdad del repo |
| `_render.ps1` | Renderiza el PPTX a PNG con PowerPoint, para revisarlo a ojo |
| `_pdf.ps1` | Exporta el PPTX a PDF (lo que se comparte) |
| `_template-DYN-09.pptx` | La plantilla original de Formula Student. Referencia, no se edita |
| `assets/` | Fotos, imágenes de web, recortes y figuras. `photos/` y `web/` son fuente; `crops/` y `figures/` son generados y no van a Git |
| `C00-kickoff.pptx`, `.pdf` | **Generados.** No editar a mano: se pierde al reconstruir |

Los PNG de verificación van a `_renders/`, que está fuera de Git. Se rehacen en
un comando; no se guardan.

## Reconstruirlo

```bash
./.venv/Scripts/python.exe 01_plan/presentations/_figures.py
./.venv/Scripts/python.exe 01_plan/presentations/C00_kickoff.py
./.venv/Scripts/python.exe 01_plan/presentations/_check.py
powershell -File 01_plan/presentations/_render.ps1 01_plan/presentations/C00-kickoff.pptx _renders
powershell -File 01_plan/presentations/_pdf.ps1 01_plan/presentations/C00-kickoff.pptx
```

## Llevarlo a otro ordenador

No hay conector de Google en este entorno, ni `rclone` ni la API de Drive. El
camino fiable es manual y tarda medio minuto:

1. `_pdf.ps1` genera el PDF.
2. Subir el PDF a Drive. Se presenta desde el navegador en cualquier máquina y
   **no pasa por ningún conversor**, así que se ve exactamente igual que aquí.
3. Si además hace falta editarlo en Google Slides: subir el `.pptx` y abrirlo con
   Slides. Drive lo convierte.

> [!warning] La conversión a Slides puede recolocar texto
> Google Slides recompone los saltos de línea con sus propias métricas, así que
> el mismo fallo que persigue `_check.py` puede reaparecer. Si se convierte,
> revisar las slides con más texto — **02, 07 y 10** — antes de presentar.
> Para presentar sin más, el PDF es la opción sin riesgo.

> [!danger] El paso que no se salta: `_check.py`
> python-pptx **no mide texto**. Escribe una caja de 2 cm y le mete 4 cm de frase
> sin protestar: el archivo abre bien y se ve roto. Ese fue el fallo repetido de
> v1 y v2.
>
> `_check.py` reconstruye el salto de línea con las métricas reales de Arial y
> avisa de las tres cosas que sí están mal:
>
> | Aviso | Qué significa |
> |---|---|
> | `SPILL` | El texto se sale de la tarjeta de color que lo contiene |
> | `COLLIDE` | El texto crece hacia abajo y se mete debajo de la caja siguiente |
> | `FOOTER` / `BOX/FOOT` | Texto o caja invaden la franja azul del pie |
>
> Una caja de texto que crece sobre blanco **no** es un fallo, y por eso no se
> avisa. Debe dar `OK` antes de renderizar.

> [!tip] Y aun así, mirar el render
> No hay LibreOffice en esta máquina, pero sí PowerPoint, y `_render.ps1` lo maneja
> por COM. El checker coge los desbordes; el render coge lo demás (líneas que se
> cruzan en un diagrama, recortes de foto desafortunados, contraste).

## Estructura de contenido (C00)

Una presentación de diseño responde tres preguntas por componente: **qué es**,
**cómo está montado**, **por qué este y no otro**. Las slides 6 y 7 siguen ese
patrón de forma explícita.

| # | Slide | Para qué está |
|---|---|---|
| 01 | Portada | |
| 02 | What this project is | Planta + gemelo digital + ciclo, y qué transfiere de calibración térmica y qué no |
| 03 | The vehicle | Datos básicos + **las cuatro fórmulas de la transmisión** |
| 04 | System architecture — as it is today | Sin VCU, sin log, frenos sin conectar |
| 05 | System architecture — where it is going | El VCU se queda la capa de vehículo. Par por CAN |
| 06 | The powertrain, component by component | Batería / inversor / motor, con el porqué de cada uno |
| 07 | Where the limits actually are | **La envolvente, con sus tres techos: corriente, batería y tensión** |
| 08 | What the model needs | Las tres ecuaciones y los parámetros que piden |
| 09 | How the machine was measured | Osciloscopio, conteo Hall, spin-down. Y el coast-down que viene |
| 10 | How I learn, and what I refuse to delegate | **Primeros principios + la IA se queda la contabilidad** |
| 11 | How the work is organised | El ciclo y los 45 minutos |
| 12 | The plan to December | C01–C06 con fechas de review, y el horizonte 2027 |
| 13 | What I need from you | Fondo oscuro. La petición explícita |
| 14 | What I am asking for today | Cerrar con fecha |

Si hay que recortar por tiempo, la que menos cuesta es la **11**.

> [!tip] Por qué la 10 va donde va
> La slide de IA no puede ir antes de las de medida. Si cuentas que trabajas con
> agentes y **luego** enseñas los números, la pregunta mental del mentor es "¿esto
> lo has hecho tú?". Va después, y fusionada con primeros principios, para que el
> mensaje sea *la IA se queda lo que no enseña nada*.

> [!warning] La envolvente tiene tres techos, no dos
> Hasta v5 la hipérbola de potencia de batería llegaba hasta la velocidad de
> vacío medida. Esa esquina **no es alcanzable**: a esa velocidad la fuerza
> contraelectromotriz ya se come el bus entero y la máquina no puede dar par.
> `_figures.envelope()` resuelve ahora la restricción de tensión
> (`|v| ≤ 0,95·V_bus/√3`) y dibuja la rama que cierra la envolvente en el vacío.
> Es también el sitio donde actuaría el debilitamiento de campo, que en este
> motor es mal negocio: `I_ch = λm/Ld = 170 A` contra 120 A disponibles.

### Decisiones de contenido que se mantienen de v1

- La slide de medidas no dice "he medido esto" sino **"he medido, he contrastado y he
  encontrado una contradicción"**.
- Se dice explícitamente que **no parte de cero**: calibrar un motor eléctrico se
  parece a calibrar uno térmico.
- La slide de peticiones va sola y con fondo oscuro, y deja claro lo que **no** se
  les pide: validar FOC.

---

## C01 — review del 9 de octubre de 2026

> [!success] Estado: v2 construida y verificada
> `C01-review.pptx` / `.pdf` — 12 slides. `_check.py` OK, render revisado slide a slide.
> v1 (noche del 8) se descartó entera tras el feedback de Pol: ver `C01-feedback-pol.md`.

| Archivo | Qué es |
|---|---|
| `_figures_c01.py` | Figuras de C01 + recortes de foto nuevos (`assets/crops/c01_*.jpg`). Lee los CSV de `04_model/results/` |
| `C01_review.py` | El deck. **Parsea `04_model/params/*.m`** y los CSV del modelo: ningún número está tecleado a mano |

```bash
./.venv/Scripts/python.exe 01_plan/presentations/_figures_c01.py
./.venv/Scripts/python.exe 01_plan/presentations/C01_review.py
./.venv/Scripts/python.exe 01_plan/presentations/_check.py 01_plan/presentations/C01-review.pptx
./.venv/Scripts/python.exe 01_plan/presentations/_audit.py 01_plan/presentations/C01-review.pptx
```

Si cambia el modelo, antes: `04_model/scripts/run_predictions_L1.m` (regenera los CSV).

| # | Slide | Qué responde |
|---|---|---|
| 01 | Portada | |
| 02 | Why a model before the data | Neumáticos + ESP32 → modelo primero, predicciones congeladas |
| 03 | The force balance, with numbers | La ecuación con cada valor y sus entradas |
| 04 | Where every number comes from | MEASURED / VESC ESTIMATE / CONFIG / ASSUMED, con el porqué |
| 05 | Where the limits are | Fuerza en rueda vs velocidad: 120 A → 40 A batería → tensión, y la carga de carretera |
| 06 | The model: four blocks, one state | Diagrama limpio (no captura de Simulink) + chequeo contra C00 |
| 07 | Predictions, frozen before the test | 4 predicciones con banda + las dos maniobras simuladas |
| 08 | What moves the predictions | Tornado: qué parámetro mueve cada predicción |
| 09 | Designing the tests | Coast-down desde 30 km/h (idea de Pol, comprobada) + instrumento por predicción |
| 10 | What is in the model, and what is next | L1 / L2 / C02 |
| 11 | What I need from you | Cómo fijar los límites de corriente (fondo oscuro: es la petición) |
| 12 | Next: C02, motor and inverter | Propuesta de C02 + horizonte 2027 |

> [!tip] Cambios de sistema hechos en C01
> - `_deck._band`: interlineado 1,0 en el título. Era el "descuadre" del título que vio Pol:
>   con 1,15 la línea era más alta que la banda. Afecta también a C00 si se reconstruye (a mejor).
> - Títulos ≤ 42 caracteres en todo el deck, para que salgan todos al mismo tamaño.
> - `_check.py` ya imprime en UTF-8 (antes se caía con `−` o `≤` en la consola de Windows).
> - **Nuevo `_audit.py`:** la auditoría de números de la skill, automatizada. Cada número de
>   cada slide → el archivo:línea del repo que lo respalda, o `NOT FOUND`. C01: 65 números, 0 sin origen.
> - **Notas del orador:** cada slide lleva la pregunta probable del mentor (solo la pregunta).
