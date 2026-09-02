# ePWT

> [!abstract] El proyecto en una frase
> Banco de aprendizaje de powertrain eléctrico. **El quad es la planta física, Simulink
> es el gemelo digital, y el ciclo de dos semanas con mentores es el motor de progreso.**
> Todo lo demás es subproducto.
>
> **Objetivo 0:** convertirme en mejor ingeniero. Lo que no sirva a eso se corta o se aplaza.

---

## 🎯 Ahora mismo

> [!todo] Ciclo C01 — Caracterizar la planta
> **Abre [[C01]], busca el primer día sin marcar, haz eso. Nada más.**
>
> | | |
> |---|---|
> | **Objetivo** | Medir los parámetros reales del motor |
> | **Entregable** | Presentación + primeras medidas + EXP-001 |
> | **Presupuesto** | 2 h/día · 28 h |
> | **Review** | fecha por confirmar |

### Progreso

| Día | Tarea | Contexto | |
|---|---|---|---|
| D1 | Git: commit, rama, PR | dirección | ⬜ |
| D2 | Entender mi hardware | dirección | ⬜ |
| D3 | Teoría PMSM | modelo | ⬜ |
| D4 | Medir R y pares de polos | banco | ⬜ |
| D5 | Medir back-EMF | banco | ⬜ |
| D6 | Calcular Ke en Python | datos | ⬜ |
| D7 | Parámetros de vehículo | banco | ⬜ |
| D8 | Detección FOC del VESC | banco | ⬜ |
| D9 | EXP-001: comparar | datos | ⬜ |
| D10 | Nota de conocimiento | modelo | ⬜ |
| D11-12 | Presentación | dirección | ⬜ |
| D13 | Ensayo con examinador | dirección | ⬜ |
| D14 | **Review con mentores** | — | ⬜ |

---

## 🗺️ El camino

> [!example]- C01 → C06 (desplegar)
> | Ciclo | Objetivo |
> |---|---|
> | **C01** | Caracterizar la planta ← *estás aquí* |
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
| `06_data/` | Logs de ensayos |
| `07_experiments/` | Hipótesis → medida → conclusión |
| `08_decisions/` | Decisiones y alternativas |

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
