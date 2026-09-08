# ePWT

> [!abstract] El proyecto en una frase
> Banco de aprendizaje de powertrain eléctrico. **El quad es la planta física, Simulink
> es el gemelo digital, y el ciclo de dos semanas con mentores es el motor de progreso.**
> Todo lo demás es subproducto.
>
> **Objetivo 0:** convertirme en mejor ingeniero. Lo que no sirva a eso se corta o se aplaza.

---

## 🎯 Ahora mismo

> [!todo] C01 — Medir el vehículo · 28 sep → 11 oct
> **Abre [[C01]]. 14 bloques × 2 h. Objetivo: cerrar el lado vehículo de
> `vehicle_params.m`.**
>
> | | |
> |---|---|
> | **Entregable** | `r_roll`, masas, `Crr`, `CdA`, `eta_drive`, `R_int` medidos + coast-down escrito |
> | **Review** | Lunes 12 de octubre |
> | **Bloqueante** | D2: la config del VESC corrompe el canal de velocidad. Antes que nada |
> | **Antes** | Vacaciones 10–27 sep. Sin trabajo planificado |

> [!success] C00 cerrado — 8 de septiembre
> Reunión hecha y bien. Lo que engachó a los mentores **fue el método, no las
> medidas**. La segunda vez el método ya no impresiona: el 12 de octubre toca
> enseñarlo produciendo un número. Ver el cierre en [[C00]].
>
> Sigue pendiente: confirmar las seis fechas de review en el calendario.

> [!info] El año, de un vistazo
> | | |
> |---|---|
> | **C00** · 2–9 sep | Kickoff |
> | *10–27 sep* | *Vacaciones* |
> | **C01** · 28 sep–11 oct | Medir el vehículo → review 12 oct |
> | **C02–C06** | Hasta el 21 dic |
>
> **Meta de 2026: modelo validado contra el vehículo real.**

## 🗺️ El camino

> [!example]- C01 → C06 (desplegar)
> | Ciclo | Objetivo |
> |---|---|
> | **C01** | Medir el vehículo ← *estás aquí* |
> | C02 | Modelo longitudinal validado con coast-down |
> | C03 | PMSM en dq. Entender Clarke y Park |
> | C04 | Inversor + lazo de corriente |
> | C05 | Instrumentar el vehículo (data logger) |
> | C06 | Correlación modelo ↔ vehículo |
>
> Después: control de tracción, launch control y **MPC**.
> Detalle en [[roadmap]].

---

## 📂 Dónde está cada cosa

> [!info]- Navegación
> **Planificar** → [[C01]] · [[roadmap]] · [[backlog]] · [[vision]]
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
