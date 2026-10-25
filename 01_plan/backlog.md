# Backlog — todo lo que NO se hace ahora

Destino único de las ideas. Si algo no cabe en el ciclo activo, viene aquí y se sale
de la cabeza. Nada de esto está descartado; está **aplazado con criterio de entrada**.

Regla: una entrada solo se activa cuando se cumple su condición, y entonces se
convierte en el objetivo de un ciclo.

---

## Proyectos separados (fuera de este repo, por decisión propia)

**Second brain personal + LLM sobre él.** Conocimiento de universidad, Formula Student,
calibración, trabajo, proyectos. Obsidian como candidato. Referencia mencionada:
el trabajo de Karpathy sobre wiki/LLM en GitHub.
*Por qué fuera:* es un proyecto de gestión del conocimiento, no de ingeniería de
powertrain. Mezclarlo aquí fue la causa de la saturación inicial.
*Nota:* `02_knowledge/` de este repo ya es Markdown plano y se puede abrir con Obsidian
sin conversión. El second brain personal puede absorberlo más adelante.

**Agentes de información / actualidad.** Síntesis semanal sobre robótica, defensa,
drones, semiconductores, IA, ecosistema israelí, y referentes técnicos concretos.
*Argumento a favor (suyo, válido):* no quiere perder tiempo en redes; prefiere
señal filtrada de gente cuyas acciones tienen consecuencias reales.
*Riesgo a vigilar:* una síntesis que se acepta sin cuestionar es cognición delegada.
Si se construye, debe entregar **fuentes + preguntas**, no conclusiones.

---

## Dentro de este proyecto, más adelante

| Idea | Condición de entrada |
|---|---|
| **Agente examinador** (alimentado con libros de texto, me cuestiona antes de las reviews) | Que exista material de referencia elegido y ≥3 ciclos de rutina que codificar |
| **Skills propias** (analizar datos, generar reporte, documentar decisión, preparar review) | Haber hecho la tarea a mano 3 veces. Antes, no hay proceso que codificar |
| **CI: compilar el firmware en cada push** | Que haya firmware propio en el repo |
| **Logger de telemetría propio (ESP32 + CAN)** | Que el gemelo necesite datos que el VESC Tool no da. Revisar VESC Express antes de escribir nada |
| **Dashboard / análisis en Python de los logs** | Que existan los primeros CSV |
| **Hook de fin de sesión: avisar de trabajo sin commitear** | Haber cerrado 3 sesiones más olvidando el commit. Ver la nota de abajo |
| **Control de tracción, launch control** | Modelo validado + control de par funcionando |
| **MPC** | Modelo validado. MPC sin modelo es imposible por definición |
| **Percepción, cámaras, autonomía, robot acompañante** | Muy lejos. Mantener como horizonte, no planificar |
| **Diagnóstico del corte de USB del VESC bajo carga** | Fallo conocido en la comunidad VESC (EMI / bucle de tierra / pull-ups). 30 min de osciloscopio antes de construir nada para evitarlo |
| **Decidir `l_in_current_max` (hoy 40 A = límite continuo del BMS)** | Salió del modelo C01: por encima de 9 km/h cada aceleración a fondo va pegada a 40 A. Llevado a la review C01 como pregunta a los mentores |
| **Medir `R_int` del pack** | Caída de tensión ante un escalón de corriente en un log del VESC. Hoy ASSUMED 0,10 Ω sin datasheet |
| **`si_wheel_diameter` 0,30 m vs `2·r_roll` 0,31 m** | Decidir cuál vale cuando se haga el roll-out con neumáticos nuevos |
| **Altura del CG (`h_cg`)** | MISSING. La necesita el load transfer del L2 (examen C01, bloque I) |
| **EXP-001 (bucle de tierra) sin medir** | Sigue sin día. Antes de montar el ESP32 nuevo: M1 y M2 son 20 min de multímetro |

---

## Higiene de Git: qué automatizar y qué no

Abierto el 2026-09-09, tras una operación de rescate: 46 archivos nuevos y 24
modificados llevaban hasta dos semanas sin commitear. Todo el trabajo técnico de C00
—caracterización del motor, inercia, EXP-001, decks— vivía solo en el disco.

**Fontanería, hecho o inmediato.** No requiere criterio, así que se automatiza sin
debate: `push.autoSetupRemote` (mata el `-u` de la primera subida), `fetch.prune`
(limpia referencias a ramas remotas muertas), y en GitHub desactivar el squash merge
y activar el borrado de rama al mergear.

Lo del squash no es cosmético: el PR #4 aplastó 7 commits temáticos en uno solo
titulado como el primero de ellos, así que ahora `a3e6f9b` dice "versiona la config
del VESC" y contiene además el motor, la inercia, EXP-001 y las presentaciones.
El contenido está intacto; la trazabilidad no. Desactivar la opción en el repo hace
el error irrepetible, que es mejor que recordar no cometerlo.

**Criterio, NO se automatiza.** Agrupar los cambios por tema y escribir por qué el
VESC se queda un 5,5 % corto en λm son decisiones de ingeniería. Un commit automático
produciría exactamente la historia inútil que este proyecto intenta evitar.

**El punto intermedio, aplazado.** El fallo real fue olvidarse, no no saber. Un hook
de fin de sesión que *avise* (nunca que commitee) es la herramienta correcta. Pero
aplica la regla de entrada de las skills propias: tres repeticiones a mano antes de
codificar nada. Va una.

Mientras tanto, la disciplina es manual: al cerrar sesión, `add` por tema → `commit`
→ `push`, aunque el trabajo esté a medias. Un WIP con mensaje honesto vale más que
46 archivos en el limbo.

---

## Marca personal, contenido y empresa

Reconocido como objetivo real a largo plazo. **Cero acción de investigación ahora.**

- **LinkedIn:** activo, pero como *subproducto*. Cada review con mentores produce
  material; publicar es copiar y traducir, no un proyecto aparte. Sin agente.
- **YouTube / newsletter / formación:** más adelante. Doble función reconocida —
  construir marca y forzar comprensión real. La excusa del vídeo es aprender a
  explicar y perder vergüenza; ese objetivo ya lo cubren las presentaciones por ahora.
- **Empresa tecnológica (robótica u otra):** horizonte a años. Primero: conocimiento,
  experiencia, entender sectores y detectar problemas reales. No forzar una idea.
- **Organización AI-first como laboratorio:** aprender a trabajar con IA como capa
  común de conocimiento antes de tener equipo. Este repo ya es la versión mínima.
