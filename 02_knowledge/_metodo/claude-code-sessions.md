# Cómo organizar las sesiones de Claude Code

Nota de aprendizaje sobre el harness. Responde a: "¿cuántos chats abro y para qué?"

## 1. El problema real: el contexto es un recurso finito

Un LLM no tiene memoria entre sesiones. Todo lo que sabe en un momento dado está en su
**ventana de contexto**: las instrucciones, los archivos leídos y la conversación entera.

Esa ventana es grande, pero no infinita, y tiene una propiedad poco intuitiva:
**más contexto no es mejor contexto.** Una conversación de tres horas que ha tocado
Simulink, batería, Git y planificación tiene mucha información — y también mucho ruido.
La señal relevante para la pregunta actual queda diluida.

Esto ya me pasó: metí ~8.000 palabras de contexto estratégico de golpe y la respuesta
fue peor, no mejor. **Ese es exactamente el fallo que la arquitectura de sesiones evita.**

## 2. La regla

> **Una sesión = una tarea con un objetivo comprobable.**

No "una sesión al día" ni "una sesión por tema eterno". Cuando el objetivo se cumple,
la sesión se cierra. Si estoy en la misma sesión desde hace tres horas y he cambiado
de tema dos veces, el contexto ya está sucio.

## 3. Contextos, no sesiones permanentes

**Aclaración importante** (esto estaba mal explicado antes y se contradecía con la
regla de arriba): los cuatro "tipos" de abajo **no son cuatro chats abiertos de forma
permanente**. Son **contextos**: categorías de trabajo, cada una con sus reglas.

Cada tarea concreta abre **una sesión nueva**, y esa sesión *pertenece* a un contexto.
En un ciclo puedo abrir 8 sesiones de modelo distintas: una por cada tarea. Todas
comparten las reglas de `04_model/CLAUDE.md`, y ninguna hereda la conversación de la
anterior — lo que heredan es **lo que quedó escrito en el repo**.

## 3b. Los cuatro contextos de este proyecto

### Sesión de dirección (raíz del repo)
Planificar el ciclo, revisar el roadmap, cerrar decisiones, preparar la review.
Se abre desde la raíz. Carga el `CLAUDE.md` principal.
Frecuencia: al abrir y al cerrar cada ciclo. Corta.

### Sesión de modelo (`cd 04_model`)
Simulink, física del vehículo, control, parámetros.
Carga `CLAUDE.md` raíz **+** `04_model/CLAUDE.md`.
Es donde vivirá la mayor parte del trabajo durante los próximos meses.

### Sesión de firmware (`cd 05_firmware`)
ESP32, CAN, adquisición, arquitectura de software embebido.
Carga `CLAUDE.md` raíz **+** `05_firmware/CLAUDE.md`.

### Sesión de datos (`cd 06_data`)
Procesar logs, plots, comparar modelo contra medida.

## 4. Cómo funciona técnicamente (y cómo lo hago yo, que trabajo por voz)

Claude Code lee el `CLAUDE.md` del directorio desde el que se lanza **y los de los
directorios padre**. Hay dos formas de trabajar:

**Vía A — automática.** `cd 04_model && claude`. Carga las reglas generales **más** las
de Simulink, y nada de firmware ni de estrategia. Es la más limpia.

**Vía B — por voz, que es como trabajo yo.** Lanzo desde la raíz y digo *"vamos a
trabajar el modelo"*. Entonces Claude tiene que **leer `04_model/CLAUDE.md` él mismo**
antes de responder. Está escrito como regla operativa en el `CLAUDE.md` raíz, así que
no hace falta que lo recuerde yo cada vez.

La vía B mete algo más de contexto que la A, pero la diferencia es pequeña y la
comodidad es grande. **La vía A merece la pena solo para sesiones largas de un área.**

Eso es *context engineering*: la tarea recibe lo que necesita y poco más. Sin MCP, sin
subagentes, sin infraestructura. Solo carpetas y archivos.

## 5. Cómo empezar y cerrar una sesión

**Al empezar**, una frase que sitúe: *"Estamos en C01. Hoy quiero medir la resistencia
de fase. Lee `03_hardware/baseline.md` antes de responder."*

Es mejor que volcar contexto: le dices **dónde mirar** en vez de pegarle el contenido.
El repositorio es la memoria; la sesión solo necesita el puntero.

**Al cerrar**, la costumbre más barata y de más valor de todo el sistema:

> Escribir el estado antes de cerrar. Qué he hecho, qué he aprendido, qué queda.

Va al archivo del ciclo (`01_plan/C0X.md`). Sin eso, cada sesión nueva empieza a
ciegas y hay que reconstruir el contexto a mano. **Si importa, se escribe.**

## 6. Qué NO hacer

- **Una sesión infinita para todo el proyecto.** Es el fallo que ya cometí.
- **Pegar documentos enteros.** Guárdalos en el repo y di dónde están.
- **Cambiar de tema sin cerrar.** Si pasas de Simulink a planificación, sesión nueva.
- **Esperar que recuerde la sesión de ayer.** No la recuerda. Lo que recuerda es lo
  que está escrito en el repositorio.

## 7. Agentes y skills: cuándo, no si

Un agente o una skill **codifican un proceso que ya haces bien**. Todavía no he hecho
ninguno de estos procesos, así que no hay nada que codificar.

Criterio de entrada, escrito en `01_plan/backlog.md`: cuando haya hecho la misma
tarea a mano **tres veces** y me moleste repetirla, esa es la señal. Antes, no.
