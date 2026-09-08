# Roadmap por ciclos

Regla: **solo el ciclo activo está planificado en detalle.** Los siguientes existen
como dirección, no como plan. Se concretan al abrirlos. Si esta lista empieza a crecer
hacia abajo con detalle, es la señal de que estoy buscando el plan perfecto otra vez.

Presupuesto: ~28 h por ciclo (2 h/día, fines de semana incluidos).

## Calendario real

> [!warning] Vacaciones 10 → 27 de septiembre
> Sin ordenador. **No se planifica trabajo dentro de ese hueco.** Un proyecto que
> exige trabajar en vacaciones el primer mes no llega al mes doce.

| Ciclo | Fechas | Objetivo | Review |
|---|---|---|---|
| **C00** | 2 → 9 sep | Kickoff con mentores + primeras medidas | mar 8 o mié 9 sep |
| — | 10 → 27 sep | *Vacaciones* | — |
| **C01** | 28 sep → 11 oct | Caracterizar la planta: R, Ke, polos, vehículo | lun 12 oct |
| **C02** | 12 → 25 oct | Modelo longitudinal validado con coast-down | lun 26 oct |
| **C03** | 26 oct → 8 nov | PMSM en dq. Entender Clarke y Park | lun 9 nov |
| **C04** | 9 → 22 nov | Inversor + lazo de corriente. Control de par | lun 23 nov |
| **C05** | 23 nov → 6 dic | Instrumentar el vehículo (data logger) | lun 7 dic |
| **C06** | 7 → 20 dic | Correlación modelo ↔ vehículo | lun 21 dic |

**Fin de 2026: modelo validado contra el vehículo real.** Ese es el objetivo del año.

Después de C06 (no antes): control de tracción, launch control, y **entonces** MPC —
que requiere exactamente lo que C06 produce, un modelo validado.

### Horizonte largo — una línea por trimestre, y nada más

Deliberadamente vago. Concretarlo ahora sería buscar el plan perfecto.

| Trimestre | Dirección |
|---|---|
| **T4 2026** (C01–C06) | Del hardware medido a un modelo validado |
| **T1 2027** | Control implementado: del modelo al ESP32. Aquí entra el firmware en serio |
| **T2 2027** | Funciones de vehículo: tracción, launch. Y MPC si el modelo aguanta |
| **T3 2027+** | El quad es plataforma: percepción, autonomía, lo que aparezca |

## Cómo funciona un ciclo

El ciclo es el motor del proyecto. Sin ritual, es solo el nombre de una carpeta.

> [!todo] Apertura — 1 sesión, el día después de la review
> 1. Leer el cierre del ciclo anterior. Qué salió mal se arrastra, no se olvida.
> 2. Elegir **un** objetivo. Uno. Si necesita un "y", son dos ciclos.
> 3. Definir el entregable: qué se enseña el día de la review.
> 4. Escribir el plan diario. 14 bloques de 2 h.
> 5. Todo lo que no quepa → `backlog.md`.

> [!tip] Durante — cada sesión
> Cerrar escribiendo **una línea** en la bitácora: qué hice, qué aprendí, qué queda.
> Es la costumbre más barata y de más valor del sistema. Sin ella, cada sesión
> empieza a ciegas.

> [!success] Cierre — última sesión antes de la review
> 1. Rellenar Resultado / Qué aprendí / Qué salió mal.
> 2. Ensayar la explicación en voz alta, con Claude de examinador.
> 3. Si no lo sé explicar sin apuntes, **no está terminado**.

### La review, en 45 minutos

Sus mentores son ingenieros de motores térmicos: no pueden validar el FOC, pero sí
el razonamiento de ingeniería. El formato aprovecha lo que sí saben:

| Tiempo | Qué |
|---|---|
| 5 min | Qué dije que haría |
| 15 min | Qué he hecho, con datos |
| 10 min | **Lo que no entiendo** — la parte más valiosa |
| 10 min | Crítica: ¿el razonamiento se sostiene? |
| 5 min | Objetivo del siguiente ciclo |

Los 10 minutos de "lo que no entiendo" son el núcleo. Enseñar solo lo que funciona
convierte la review en un teatro y desperdicia a dos doctores.

## Cómo mido si esto funciona

El objetivo es "ser mejor ingeniero", que no se mide. Estos cuatro indicadores sí,
y se revisan **cada 3 ciclos**, no cada semana:

1. **¿Puedo explicar algo hoy que hace 6 semanas no?** Sin apuntes, a alguien que no
   sabe del tema. Es el único indicador que importa de verdad.
2. **¿El modelo predice mejor?** A partir de C06, el error de correlación es un número
   que baja o no baja. No admite autoengaño.
3. **¿Cuántos ciclos he cerrado en fecha?** Mide el sistema, no el conocimiento.
   Si van dos seguidos fallando, el problema es el plan, no yo.
4. **¿Cuántas decisiones tengo escritas con su porqué?** Mide si estoy haciendo
   ingeniería o solo tocando cosas.

> [!warning] Lo que NO se mide
> Horas invertidas, archivos escritos, líneas de código, commits. Todo eso se puede
> subir sin aprender nada. Optimizar un indicador falso es peor que no medir.

## Por qué este orden

Cada ciclo consume la salida del anterior. C02 no puede empezar sin los números de C01.
C04 no significa nada sin la máquina de C03. MPC no es implementable sin C06.

No es una secuencia arbitraria: es la cadena de dependencias real. Saltarse un eslabón
produce un sistema que parece funcionar y que no se puede depurar, porque no sabes qué
capa está mintiendo.

## El data logger: por qué NO va primero, y la excepción

**El problema real:** hoy solo puedo registrar con el motor en vacío. Con el vehículo
funcionando, el USB del VESC se corta bajo carga. Para logs con carga haría falta un
data logger propio con ESP32 — que no existe todavía.

**¿Habría que construirlo primero, entonces?** No, y por dos razones:

1. **C01 no lo necesita.** R de fase, pares de polos y back-EMF se miden con el motor
   parado o girando a mano. Multímetro y osciloscopio. Cero software.
2. **No sé aún qué medir.** Un logger se diseña a partir de las señales que el modelo
   pide. Construirlo antes del modelo es adivinar qué canales, a qué frecuencia y con
   qué resolución — y equivocarse sale caro en semanas de trabajo embebido.

**La excepción que sí merece adelantarse (30 minutos):** diagnosticar el corte de USB.
El síntoma es "bajo carga" → apunta a EMI de la conmutación de fase o a bucle de tierra.
Pero hay un detalle que cambia el cálculo: **un ensayo de coast-down es, por definición,
sin par** — acelerar, soltar, y dejar que el vehículo decelere solo. Con corriente de
fase casi nula, es plausible que el USB **no** se corte.

Y el coast-down es exactamente el ensayo de validación que necesita C02.

Por tanto, antes de dar por hecho que hace falta el logger: probar un coast-down
registrando por USB. Si funciona, **C02 se valida sin construir nada** y el logger se
queda donde está, en C05. Si no funciona, ya tengo el dato con certeza en vez de con
una suposición — y sé que el logger es un bloqueante real.

Media hora de osciloscopio en D+/D- y en el raíl de 5 V durante una rampa de carga
completa el diagnóstico. Ver `03_hardware/open-questions.md`.

## Lo que cambia ahora que sé qué toolboxes tengo

Verificado el 2026-09-01: la licencia de estudiante trae **las 40 toolboxes**,
incluidas Motor Control Blockset, Simscape Electrical, Vehicle Dynamics Blockset,
Powertrain Blockset, MPC Toolbox y Embedded Coder. Ver `08_decisions/DEC-002-entorno-tecnico.md`.

Esto no acelera el roadmap. Lo hace **más peligroso**, y conviene decirlo claro:

Motor Control Blockset trae FOC para PMSM ya hecho. Arrastrar ese bloque da un quad que
funciona y un ingeniero que no ha aprendido nada. El objetivo declarado del proyecto es
entender FOC, no usarlo.

**Regla para todo el roadmap:** primero lo construyo desde las ecuaciones, después lo
comparo contra la implementación de referencia. La diferencia entre mi versión y la suya
es el contenido de aprendizaje — ahí está lo que no sabía que no sabía.

Dos consecuencias concretas:
- **C03/C04:** construir Clarke, Park y los lazos de corriente a mano antes de abrir
  ningún ejemplo de MCB.
- **MPC (post-C06):** deja de ser inalcanzable. MPC Toolbox está. Sigue necesitando el
  modelo validado de C06, así que la secuencia no cambia — solo deja de ser un horizonte
  lejano y pasa a ser un objetivo real a ~6 meses.

## Qué NO está en este roadmap, a propósito

Rediseño mecánico, montaje de batería, soportes, chasis. El hardware es la planta y el
banco de validación, no el objeto de trabajo. Cambios de hardware, sí — cuando el modelo
o los datos los pidan, no por iniciativa propia.
