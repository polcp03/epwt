# Visión — ePWT

Capturado el 2026-08-31 a partir del braindump estratégico completo.
**Este archivo no se ejecuta.** Existe para que nada se pierda y para que el ciclo
activo pueda ignorarlo con tranquilidad. Se revisa cada ~3 meses, no cada semana.

---

## Objetivo 0 — El único que no se negocia

Convertirme en un ingeniero técnicamente sólido, capaz de trabajar en sistemas
eléctricos, electrónicos, control, software y motores eléctricos. Todo lo demás
está subordinado a esto.

**Contexto profesional:** ~2 años de experiencia, ingeniería de automoción
(calibración de motores térmicos). Traslado a Israel previsto (fecha abierta;
el proyecto continúa allí sin interrupción). Sectores objetivo: robótica,
semiconductores, defensa, drones, motores eléctricos, electrónica, control.

**Ventaja que ya tengo y no debo tratar como cero:** calibrar un motor eléctrico
(mapas de corriente, curvas de par, field weakening) es conceptualmente cercano a
calibrar uno térmico (inyección, ignición). El oficio transfiere; el dominio no.

---

## Las cuatro capas

### Capa 1 — El sustrato: el quad
Plataforma física de aprendizaje. El hardware **ya existe y funciona** (motor, VESC,
batería 13S5P, BMS, ESP32). No es un proyecto de fabricación mecánica.

Rol del hardware en este proyecto: **fuente de parámetros medidos y banco de
validación**, no objeto de rediseño.

Áreas técnicas a desarrollar: control (clásico, PID, motores eléctricos,
estabilidad, respuesta dinámica, control de tracción, launch control), electrónica
de potencia (inversores, sensores, baterías, BMS, comunicaciones, embebidos),
software (arquitectura, modularidad, interfaces, Git/GitHub, PRs, código mantenible).

### Capa 2 — El método
- **Ciclo de 2 semanas con mentores.** El motor del proyecto. Deadline externa,
  crítica real, y obligación de explicar. Resuelve simultáneamente la procrastinación,
  la saturación y la verificación de comprensión.
- **Aprender haciendo:** construir, experimentar, equivocarse, analizar, explicar,
  reconstruir. No cursos pasivos.
- **Explicar como test de comprensión.** Si no lo sé explicar simple, no lo entiendo.
- **Primeros principios, racionados.** Profundo en el núcleo (Clarke/Park, inversor,
  máquina eléctrica, dinámica longitudinal). Copiar sin vergüenza en todo lo demás.

### Capa 3 — La infraestructura
Repositorio Git como fuente única de verdad. `CLAUDE.md` corto. Skills y agentes
**solo cuando codifiquen un proceso que ya haya hecho tres veces.**

### Capa 4 — Congelada (ver `backlog.md`)
Marca personal, contenido, empresa, second brain, agentes de información.
Reconocidas como valiosas. Aplazadas por decisión explícita, no por descarte.

---

## Problemas personales que el sistema debe atacar

Estos no son adornos: son la razón de que el sistema tenga la forma que tiene.

| Problema | Cómo lo ataca el sistema |
|---|---|
| Sin deadline, procrastino indefinidamente | Ciclo de 2 semanas con entregable a mentores |
| Me saturo al ver todo lo pendiente | Solo existe el ciclo activo; el resto vive en `backlog.md` |
| Busco el plan perfecto en vez de ejecutar | Planificación detallada solo del ciclo actual; los siguientes, en una línea |
| Digo "sí, lo he entendido" bajo presión sin haberlo entendido | Obligación de explicar en cada review; el agente examinador |
| Ideas dispersas entre papel, WhatsApp y ningún sitio | `backlog.md` como único destino |
| Entiendo pero explico mal | Presentaciones quincenales, en inglés |
| Vergüenza social / hablar en público | Presentaciones ahora; vídeo más adelante |

---

## Filosofía de uso de la IA

**No delegar la cognición: aumentarla.** La IA no debe darme conclusiones que yo
debería alcanzar. Debe extraer lo relevante, explicar fundamentos, generar
contraargumentos, encontrar errores en mi razonamiento y **examinarme**.

Corolario práctico: un agente que me entrega una síntesis para que la acepte tiene
valor negativo. Un agente que me pregunta "¿por qué crees eso?" tiene valor alto.

**Agente examinador (aprobado, sin construir todavía):** alimentado con libros de
texto reales del dominio, con el rol de cuestionarme y comprobar si domino la teoría
antes de una review. Se construye cuando exista material y una rutina que codificar.
Uno, no diez.

**Descartado:** flota de 10+ agentes "expertos". Un subagente es el mismo modelo con
otro prompt: simula la revisión por pares sin aportar su valor epistémico.

**Descartado:** arquitectura portable entre modelos. Decisión: Claude Code, sin plan
de migración. La portabilidad es un problema que se gana, no que se previene.

---

## Horizontes técnicos (no ahora, pero es hacia donde vamos)

- Gemelo digital en Simulink: dinámica longitudinal + máquina eléctrica, parametrizado
  con medidas reales y validado contra ensayos.
- Control de par / lazo de corriente en simulación, luego en el ESP32 (Model-Based Design).
- Control de tracción y launch control.
- MPC — **requiere un modelo validado primero.** Es secuencia, no rechazo.
- Telemetría y logging propio; análisis de datos en Python.
- Percepción, cámaras, sistemas autónomos, robot acompañante. Muy lejos, pero el quad
  debe seguir siendo una plataforma que crece durante años. El proyecto no "termina".

---

## Restricciones y datos duros

- **Tiempo disponible:** ~2 h/día, fines de semana incluidos. ~14 h/semana,
  ~28 h por ciclo. Con flexibilidad al alza.
- **Mentores:** ingenieros y doctores en motores térmicos, cada 2 semanas.
  Pueden aportar rigor de ingeniería, crítica de método y accountability.
  **No pueden validar el dominio EV/FOC** — para eso hace falta otra fuente.
- **Idioma:** conversación en español; repo público, código, presentaciones y
  LinkedIn en inglés.
- **Seguridad:** ver `CLAUDE.md`. El margen de batería es el riesgo real del proyecto.
