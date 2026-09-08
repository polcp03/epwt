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

#### Áreas de conocimiento a desarrollar

Punto de partida: ingeniería de automoción, base mecánica. La ampliación va hacia
electrónica, software, control y sistemas eléctricos. De fundamentos a avanzado.

**Control** — control clásico, PID, MPC, control de motores eléctricos, estrategias,
estabilidad, respuesta dinámica, modelado de sistemas, control bajo restricciones,
control de tracción, launch control. No implementar sin comprender las matemáticas
y la física de debajo.

**Sistemas eléctricos y electrónicos** — motores, inversores, electrónica de potencia,
sensores, actuadores, baterías, BMS, comunicaciones, microcontroladores, sistemas
embebidos, arquitectura electrónica.

**Software** — la base de Python para análisis es razonable; la disciplina de ingeniero
de software no. Históricamente ha delegado esta parte en equipos. Por eso interesa
especialmente: arquitectura, cómo estructurar un proyecto, separar responsabilidades,
organizar módulos, diseñar interfaces, gestionar dependencias, mantener un proyecto
grande, código mantenible, Git, GitHub, Pull Requests, ramas, revisión de código,
documentación. **El objetivo no es saber programar: es saber construir software con
arquitectura correcta.**

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

### Harness engineering — lo que sí se aplica

Pol ha estudiado prompt engineering, context engineering y harness engineering, y ha
hecho un curso de Claude Code. La referencia metodológica es la filosofía de Boris,
creador de Claude Code. Quiere aplicarla de verdad, no tener una conversación larga
con un LLM.

Lo que ya está implementado y funciona:
- `CLAUDE.md` corto en la raíz, con `CLAUDE.md` propios por área (`04_model/`, `05_firmware/`).
- El repositorio **es** la memoria externa. Cada sesión recibe punteros, no volcados.
- Contexto acotado por carpeta. Una sesión = una tarea con objetivo comprobable.

Lo que está pendiente y **solo entra cuando haya fricción real**:
- Skills que codifiquen tareas repetidas (criterio: haberlas hecho a mano 3 veces).
- Loops de verificación explícitos: objetivo → ejecutar → comprobar → corregir → repetir.
- Agentes en paralelo (uno investiga, otro implementa, otro valida). Idea atractiva,
  sin valor demostrado todavía en un proyecto de una persona.

**Principio rector: menos prompts, más herramientas.** Preferir scripts, skills y
contexto estructurado a explicar lo mismo cada vez. Pero construir la herramienta
*después* de haber hecho la tarea a mano, nunca antes.

---

## Mentalidad: aprender de los mejores

Dos ideas que Pol quiere que guíen el proyecto, y que en la práctica se contradicen
si no se raciona:

**No reinventar la rueda.** Las empresas que ya funcionan han gastado cantidades
enormes en desarrollar estrategias, productos y procesos. Estudiar qué funciona y
adaptarlo es más inteligente que derivarlo todo desde cero.

**Primeros principios.** Entender la física real, cuestionar supuestos, reconstruir
la solución desde los fundamentos.

**La regla que las reconcilia:** primeros principios en el núcleo que quiere dominar
(motor, inversor, control, dinámica del vehículo). Copiar sin vergüenza en todo lo
demás (build systems, protocolos, librerías, tooling).

Corolario que ya ha aparecido en la práctica: Motor Control Blockset trae FOC ya
implementado. Usarlo directamente daría un quad que funciona y un ingeniero que no ha
aprendido nada. **Primero construirlo desde las ecuaciones, después compararlo con la
implementación de referencia.** La diferencia entre ambas versiones es el aprendizaje.

**Israel y la cultura startup.** Una de las razones del traslado es aprender de ese
ecosistema: probar, fallar, aprender, iterar, no rendirse. No hay idea de startup
todavía, y está bien — primero conocimiento, experiencia y detectar problemas reales.
No forzar una idea.

## Por qué profundidad, y no "orquestador generalista"

Añadido el 2026-09-06 tras revisar el discurso dominante sobre el futuro de la
ingeniería. Es el criterio de decisión para elegir en qué gastar las horas.

**El discurso que circula:** "cada vez importa menos especializarse; lo que importa
es entender un poco de todo, plantear bien los problemas y dejar que los agentes de
IA los resuelvan."

**Por qué se compra tan fácil:** los referentes que lo difunden viven de audiencia
generalista. "No hace falta profundizar" vende mucho más que "pásate 200 horas con
las ecuaciones de la máquina". Sesgo de fuente, no evidencia.

### El argumento técnico que lo desmonta

> Si generar es gratis, **el cuello de botella pasa a ser verificar.**
> Y solo se puede verificar lo que se entiende de verdad.

Un agente escribe un FOC completo en 30 segundos. La pregunta que separa a un senior
de un operador de prompts es: *¿está bien?* ¿El ancho de banda del lazo de corriente
es coherente con la constante eléctrica del motor? ¿El anti-windup aguanta en
saturación de tensión? ¿Por qué vibra a 200 rpm? Eso no se orquesta. Se sabe.

Es la misma tesis de Karpathy sobre entidades irregulares: los modelos disparan en
dominios verificables y se estancan donde la verificación es difícil o inexistente.
El humano que sabe verificar es el recurso escaso.

### Lo que sí es cierto del discurso

Descomponer problemas con precisión, diseñar contexto y saber cuándo usar la
herramienta simple **sí** son habilidades nuevas y valiosas. Pero no sustituyen al
dominio: lo multiplican. Amplitud sin profundidad no produce un arquitecto; produce
un jefe de proyecto incapaz de auditar a nadie.

El patrón real de carrera es en **T**: generalista al principio — enviar sistemas
enteros uno solo, que es exactamente lo que es ePWT — y especialista a partir de
senior. No "generalista para siempre". Los informes de contratación de 2026 apuntan
a que el mercado paga la profundidad (brechas del 30–50%), aunque son fuentes de
reclutamiento y conviene tomarlas como dirección, no como dato duro.

### Consecuencias operativas

1. **Regla de verificación.** Lo que un agente genere en el núcleo (motor, inversor,
   control, dinámica) debe poder explicarse sin mirarlo. Si no, no está hecho.
   En build systems, protocolos y glue code: copiar sin vergüenza.
2. **El gemelo digital es el verificador.** Modelo + banco real = *ground truth*.
   Permite **comprobar** en vez de creer. Casi ningún candidato tiene eso.
3. **Práctica deliberada por sesión.** Una habilidad aislada por sesión, no el
   sistema entero a la vez. Menos carga cognitiva, más retención.
4. **La amplitud llega sola.** Dominado un lazo de control de verdad, extenderlo a
   estimación de estado, baterías o percepción es transferencia, no empezar de cero.

**Identidad objetivo — la frase que hay que poder decir en una entrevista:**
no "arquitecto de agentes de IA", sino *ingeniero de control de powertrain que
verifica con modelos y datos reales, y que opera con agentes*. El segundo perfil es
escaso; el primero, en 2027, lo tendrá todo el mundo.

### Lectura del mercado israelí (revisar al llegar)

Señal consistente en las ofertas: control de motor con C/C++ bare-metal sobre TI
C2000, embebido, y bring-up / integración / validación de sistemas autónomos y
robótica física. Es una economía de hardware, defensa y autonomía, no de SaaS.
Más de la mitad de las startups vinculadas a la DDR&D trabajan en UAV.

**Consecuencia:** no hay que convertir el quad en un dron. La máquina es la misma
—PMSM con FOC— y el núcleo transferible es idéntico: FOC + embebido + modelo
validado. La adaptación al mercado es de **encuadre y de una capa técnica añadida
más tarde** (estimación de estado / control sin sensor), no de cambio de roadmap.

**Cautela pendiente de confirmar:** buena parte del trabajo de defensa clasificado
exige ciudadanía y habilitación de seguridad. El objetivo realista de entrada es la
franja comercial y dual —robótica, movilidad, semiconductores, autonomía— que no
tiene ese filtro y usa la misma física.

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
  LinkedIn en inglés. El inglés no es objetivo principal, pero es infraestructura:
  el repo lo leerán reclutadores israelíes.
- **Aspectos personales secundarios pero reales:** le cuesta hablar en público y tiene
  cierta vergüenza social. Presentaciones y, más adelante, vídeo, son parte de la cura.
  No convertirlo en objetivo del proyecto, pero tampoco evitarlo.
- **Seguridad:** ver `CLAUDE.md`. El margen de batería es el riesgo real del proyecto.
