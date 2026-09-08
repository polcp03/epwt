# ePWT — Electric Powertrain Learning Bench

Banco de aprendizaje de powertrain eléctrico. El quad es la planta física, Simulink
es el gemelo digital, y un ciclo de dos semanas con mentores es el motor de progreso.
Todo lo demás es subproducto.

**Objetivo 0: convertirme en mejor ingeniero.** Lo que no sirva a eso se corta o se aplaza.

## Cómo trabajar conmigo

- **Enseña, no entregues.** Si el punto es que yo lo aprenda, no escribas el código
  o el modelo por mí. Explica el fundamento, propón el camino, déjame implementar, revisa.
- **Cuestiona.** No estés de acuerdo por defecto. Si mi razonamiento tiene un fallo,
  dilo con argumentos.
- **Hazme explicar.** Si no sé explicar algo con mis palabras, no lo entiendo.
- **Primeros principios donde importa:** motor, inversor, control, dinámica del vehículo.
  En build systems, protocolos y librerías: copiar sin vergüenza.
- **No inventes datos.** Si falta un parámetro del hardware, dilo. No lo estimes en silencio.

## Idioma

- Conversación y notas internas (`01_plan/`, `02_knowledge/`, `07_experiments/`): español.
- Público y técnico — `README.md`, código, comentarios, commits, presentaciones a
  mentores, LinkedIn: **inglés**.

## Mapa del repo

Numeradas por orden de flujo de trabajo, no alfabético.

| Carpeta | Qué contiene |
|---|---|
| `01_plan/` | **El esqueleto.** Ciclo activo, roadmap, visión, backlog, y las presentaciones con sus imágenes. Empieza siempre por el ciclo activo. |
| `02_knowledge/` | Lo que aprendo, por temas. Markdown plano (Obsidian). |
| `03_hardware/` | El quad: baseline y parámetros medidos. **Fuente de verdad** del hardware. |
| `04_model/` | Simulink: gemelo digital. Tiene su propio `CLAUDE.md`. |
| `05_firmware/` | Código embebido (ESP32 / Arduino). Tiene su propio `CLAUDE.md`. |
| `06_data/` | Ensayos reales, una carpeta por campaña `AAAA-MM-DD_<ensayo>`. Los crudos van en `raw/`, fuera de Git. |
| `07_experiments/` | Hipótesis → medida → conclusión. |
| `08_decisions/` | Decisiones con impacto: alternativas y razonamiento. |
| `_tools/`, `_archive/` | Software de terceros (VESC Tool, firmware VESC, MCP server) y material retirado. **Fuera de Git.** |

`START-HERE.md` es el panel de entrada: dice qué toca hoy.

## Sesiones especializadas

Cada tarea concreta abre una sesión nueva. Las áreas de abajo son **contextos**, no
sesiones permanentes: dicen qué reglas aplican, no cuántos chats hay abiertos.

| Área | Reglas extra |
|---|---|
| Modelo / Simulink | `04_model/CLAUDE.md` |
| Firmware / embebido | `05_firmware/CLAUDE.md` |
| Datos / análisis | (sin reglas extra todavía) |
| Dirección / planificación | solo este archivo |

**REGLA OPERATIVA — importante.** Pol trabaja por voz y normalmente lanza Claude Code
desde la raíz, sin hacer `cd`. Por tanto:

> En cuanto el trabajo de una sesión caiga en un área con `CLAUDE.md` propio,
> **léelo antes de responder nada sustantivo.** No esperes a que te lo pidan.

Si en cambio la sesión se lanza con `cd 04_model && claude`, ese archivo se carga solo.
Las dos vías son válidas; la primera exige que yo lea, la segunda es automática.

## Reglas de trabajo

- **Solo existe el ciclo activo.** Si algo no cabe en el ciclo actual, va a
  `01_plan/backlog.md`, no a mi cabeza.
- Trazabilidad mínima: las decisiones y los experimentos se escriben. Nada de IDs
  formales, campos de estado ni matrices de trazabilidad.
- Rama + Pull Request para cambios que no sean triviales, aunque trabaje solo.
  Aprender Git/GitHub de verdad es un objetivo explícito del proyecto.

## Entorno (verificado, no asumir otra cosa)

| Qué | Cómo se invoca |
|---|---|
| Python + análisis | `./.venv/Scripts/python.exe` — numpy, pandas, matplotlib, scipy, control |
| MATLAB / Simulink | MCP `matlab` (**requiere MATLAB abierto**) o `matlab -batch "..."`, ~25 s |
| Arduino / ESP32 | `$LOCALAPPDATA/Programs/Arduino IDE/resources/app/lib/backend/resources/arduino-cli.exe`, core `esp32:esp32` |
| Git / GitHub | `git` + `gh` (PRs desde terminal) |

**No hay Node ni LibreOffice.** No usar `pptxgenjs` ni contar con renderizar PPTX.
Detalle completo y toolboxes disponibles en `08_decisions/DEC-002-entorno-tecnico.md`.

## Seguridad (no negociable)

Batería 13S5P Li-ion. Picos de corriente observados ~40 A contra una asunción de
diseño de 25 A, y el BMS tiene límite continuo de 40 A. Ningún ensayo de corriente
alta sin: (1) límite de corriente configurado en el VESC, (2) comprobación de
temperatura del pack al terminar, (3) nunca cargar sin supervisión.

## Estado

Ciclo activo: ver `01_plan/`.
