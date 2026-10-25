# ePWT

> [!abstract] El proyecto en una frase
> Banco de aprendizaje de powertrain eléctrico. **El quad es la planta física, Simulink
> es el gemelo digital, y el ciclo de dos semanas con mentores es el motor de progreso.**
> Todo lo demás es subproducto.
>
> **Objetivo 0:** convertirme en mejor ingeniero. Lo que no sirva a eso se corta o se aplaza.

---

## 🎯 Ahora mismo

> [!todo] C02 — Motor + inversor, solo modelo · review **vie 30 oct**
> **Abre el plan y haz solo lo de hoy:** [C02 · Plan de estudio](https://claude.ai/artifact/BQURLvXASA1aoiGCevCGTa)
>
> | | |
> |---|---|
> | **Ciclo** | [[C02]] — lecciones, exámenes y entregable |
> | **Ritmo** | 45–60 min mar–jue · sábado un ejercicio · predice → núcleo → laboratorio → criterio → cierre |
> | **Fuera de alcance** | el vehículo y el VESC no se tocan; validación cuando haya data logger |

> [!success] C01 cerrado — review hecha
> Modelo longitudinal L1 presentado y entendido por los mentores. Ver [[C01]].

> [!info] El año, de un vistazo
> | | |
> |---|---|
> | **C00** · 2–9 sep | Kickoff |
> | **C01** · 28 sep–9 oct | Modelo longitudinal |
> | **C02** · 21–30 oct | Motor + inversor: modelar y explicar ← *estás aquí* |
> | **C03–C06** | Reviews 13 nov · 27 nov · 11 dic · 25 dic (se moverá) |
>
> **Secuencia:** modelo de motor + inversor → data logger → validación con datos reales.

## 🗺️ El camino

> [!example]- C01 → C06 (desplegar)
> | Ciclo | Objetivo |
> |---|---|
> | C01 | Modelo longitudinal ✓ |
> | **C02** | Motor + inversor: Clarke, Park, modelo dq ← *estás aquí* |
> | C03–C06 | En discusión: lazo de corriente → data logger → validación |
>
> Después: control de tracción, launch control y **MPC**.
> Detalle en [[roadmap]].

---

## 📂 Dónde está cada cosa

> [!info]- Navegación
> **Planificar** → [[C02]] · [[roadmap]] · [[backlog]] · [[vision]]
> **Aprender** → [[git-workflow]] · [[claude-code-sessions]] · [[obsidian-setup]]
> **El quad** → [[baseline]] · [[open-questions]]
> **Decisiones** → [[DEC-001-herramienta-de-organizacion]] · [[DEC-002-entorno-tecnico]]

| Carpeta | Qué hay |
|---|---|
| `01_plan/` | Ciclos, roadmap, visión, backlog |
| `02_knowledge/` | Lo que aprendo, por temas |
| `03_hardware/` | El quad: baseline y medidas |
| `04_model/` | Simulink |
| `05_firmware/` | ESP32 / Arduino |
| `06_data/` | Ensayos, por campaña con fecha |
| `07_experiments/` | Hipótesis → medida → conclusión |
| `08_decisions/` | Decisiones y alternativas |

---

## 🧭 Si eres una sesión nueva, lee esto primero

> [!abstract]- Cómo orientarse en 2 minutos
> 1. **`CLAUDE.md`** — cómo trabajar con Pol, mapa del repo, entorno, seguridad.
> 2. **Este panel** — qué toca hoy y qué está bloqueado.
> 3. **El ciclo activo** en `01_plan/` — el plan concreto con casillas.
> 4. Si el trabajo es de un área con `CLAUDE.md` propio (`04_model/`, `05_firmware/`),
>    **léelo antes de responder nada sustantivo**. Pol trabaja por voz desde la raíz.
>
> **No vuelvas a abrir la estrategia.** [[vision]] y [[backlog]] están cerrados;
> se leen una vez, no se rediscuten. Si aparece una idea nueva, va a [[backlog]].
>
> Lo que NO hay en esta máquina: Node, LibreOffice. Lo que sí: Python en `.venv/`,
> MATLAB por MCP (con MATLAB abierto), `arduino-cli`, `git` y `gh`.

---

## ⚖️ Mis tres reglas

> [!warning] Las que evitan que me sabotee
> 1. **Solo existe el ciclo activo.** Toda idea nueva va a [[backlog]], no a mi cabeza.
> 2. **Si un día se cae, se cae.** No se recupera acumulando.
> 3. **Si importa, se escribe.** Cerrar cada sesión con una línea en la bitácora.

---

> [!danger] Seguridad — no negociable
> Batería 13S5P Li-ion. Picos de **~40 A** contra una asunción de diseño de 25 A,
> y el BMS corta a 40 A continuos.
>
> Ningún ensayo de corriente alta sin: límite configurado en el VESC · comprobar
> temperatura del pack al terminar · **nunca cargar sin supervisión**.
