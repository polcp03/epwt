# Roadmap por ciclos

Regla: **solo el ciclo activo está planificado en detalle.** Los siguientes existen
como dirección, no como plan. Se concretan al abrirlos. Si esta lista empieza a crecer
hacia abajo con detalle, es la señal de que estoy buscando el plan perfecto otra vez.

Presupuesto: ~28 h por ciclo (2 h/día).

| Ciclo   | Objetivo                                                                      | Entregable a mentores                                     |
| ------- | ----------------------------------------------------------------------------- | --------------------------------------------------------- |
| **C01** | Caracterizar la planta: R de fase, Ke, pares de polos, parámetros de vehículo | Visión + plan + primeras medidas + EXP-001                |
| **C02** | Modelo longitudinal del vehículo en Simulink, parametrizado con C01           | Modelo que reproduce un coast-down real                   |
| **C03** | Modelo eléctrico de la PMSM en dq. Entender Clarke y Park de verdad           | Explicar FOC con mis palabras + simulación                |
| **C04** | Inversor + lazo de corriente en simulación. Control de par                    | Respuesta de par simulada, con ancho de banda justificado |
| **C05** | Adquisición de datos real. Instrumentar el vehículo                           | Primeros logs propios en `06_data/`                       |
| **C06** | Correlación modelo ↔ vehículo. Dónde falla el modelo y por qué                | Gráfica de correlación y análisis del error               |

Después de C06 (no antes): control de tracción, launch control, y **entonces** MPC —
que requiere exactamente lo que C06 produce, un modelo validado.

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
