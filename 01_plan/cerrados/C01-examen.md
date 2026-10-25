# C01 — Examen de preparación para la review

> [!abstract] Cómo funciona
> Respondes tú primero, por voz, aunque sea a medias o con un "no lo sé, pero creo…".
> Claude corrige debajo de cada pregunta. **Tus respuestas corregidas son el guion
> del deck**: cada bloque se convierte en una o dos slides.
>
> ★ = pregunta que casi seguro te harán los mentores.
> Review: **viernes 9 de octubre**.

---

## A · El planteamiento — sin esto, el resto no se sostiene

**A1 ★** No hay neumáticos, así que tampoco coast-down. ¿Por qué haces un modelo **antes**
de tener las medidas? ¿Qué ganas con eso, qué riesgo corres, y cómo evitas acabar
ajustando el modelo hasta que la curva salga bonita?

**A2 ★** Has pesado el quad: 38 kg. El repo lo estimaba en 40 kg. ¿La estimación
era buena o mala? Contesta con números, no con adjetivos. ¿Qué cosas incluye y
cuáles no incluye ese 38?

**A3** MEASURED, ESTIMATED, ASSUMED, MISSING: ¿en qué se diferencian? ¿Por qué
etiquetar cada parámetro cambia lo que puedes concluir del modelo?

## B · Dinámica longitudinal — el núcleo de la presentación

**B1 ★** Escribe de memoria el balance de fuerzas longitudinal. Para cada término:
¿de qué depende, y cómo crece con la velocidad (constante, lineal, cuadrático)?

**B2 ★** ¿Cómo pasas del par del motor a la fuerza en la rueda? ¿Qué parámetros
entran? Si cada uno sube un 10 %, ¿qué pasa con la fuerza?

**B3 ★** ¿Por qué `r_roll` es el parámetro con más palanca de todo el vehículo?
Pista: un error del 6 % en `r_roll` se te cuela en **dos** sitios. ¿En cuáles?

**B4** Al acelerar el vehículo también aceleras cosas que giran: rotor, piñón,
ruedas. ¿Cómo se meten en la ecuación? ¿Por qué el rotor apenas pesa en el
resultado, pese a girar 8 veces más rápido que la rueda?

**B5 ★** `Crr` y `CdA`: ¿cuál de los dos domina a 15 km/h, y cuál a 50 km/h?
¿Por qué un coast-down de este quad mide bien `Crr` y mal `CdA`?

**B6** ¿Qué **no** captura tu modelo? Enumera al menos cuatro cosas, y para cada
una di cuándo dejaría de ser despreciable.

## C · Motor — lo básico, bien dicho

**C1 ★** Escribe la ecuación de par del PMSM en dq. ¿De dónde sale cada término?
¿Y el 3/2?

**C2 ★** Mediste `λm` con tres métodos distintos y coinciden al 0,02 %. ¿Por qué
importa eso más que haber repetido diez veces el mismo método?

**C3** ¿Qué limita la velocidad máxima del motor? Con un bus de 48 V, ¿a qué
régimen la back-EMF se come toda la tensión que el inversor te puede dar?
Hazlo en papel con tus `λm` y `p`.

**C4 ★** Corriente de motor y corriente de batería: ¿por qué no son iguales? A baja
velocidad y par máximo, ¿cuál de las dos es mayor, y por qué?

## D · Batería — el mínimo, y la seguridad

**D1** ¿Cuál es el modelo más simple de batería que sirve para esto? ¿Qué efecto
tiene `R_int` sobre el par disponible a alta velocidad?

**D2 ★** Has visto picos de 40 A de batería, y el BMS corta a 40 A. En el VESC hay
un límite de corriente de motor y otro de batería. ¿Cuál de los dos protege al
pack? ¿Por qué no basta con el otro?

## E · Predicción y validación — lo que te diferencia

**E1 ★** ¿Qué tres o cuatro magnitudes vas a predecir? Para cada una: el valor, su
banda de error, y el ensayo concreto que la validará cuando tengas neumáticos.

**E2** ¿Cómo calculas esa banda? ¿Qué parámetro aporta la mayor parte de la
incertidumbre de cada predicción?

**E3 ★** Supón que mides y la predicción cae fuera de la banda. ¿Qué concluyes?
¿Y qué **no** puedes concluir?

## F · Lo que no entiendes

**F1 ★** Dime tres cosas de este ciclo que todavía no entiendes. Son los 10 minutos
más valiosos de la review: llévalas preparadas, no improvisadas.

---

## Respuestas y correcciones

_(se rellena a medida que respondes)_

---

## G · Entender el modelo (ronda del 9 oct, antes de tocar el deck)

**G1** ¿Qué variable del quad no puede cambiar de golpe, y cuál sí puede en milisegundos?
→ Con eso: ¿por qué el modelo tiene un solo integrador?

**G2** El bloque "VESC ramp" es un *Rate Limiter*, con 0,3 s de subida y 0,1 s de bajada.
Si giras el puño de 0 a 100 % de golpe, ¿qué hace ese bloque con la orden de corriente?

**G3** El bloque "Motor + VESC limits" hace T = 3/2·p·λm·iq, donde iq es el menor de tres
límites. Para cada límite (120 A de motor, techo de tensión, 40 A de batería): ¿cuál manda
parado, cuál a media velocidad y cuál cerca de la punta?

**G4** ¿Para qué necesita el motor saber a qué velocidad va el quad? Tres razones.

**G5** De cada número de la slide 4, ¿de dónde sale? Medido por ti / estimado por el VESC /
configurado por una persona / asumido. Incluye R_int.

**G6** ¿Qué limita la velocidad punta: el equilibrio de fuerzas o la tensión de la batería?
¿Por qué el tornado dice que CdA casi no la mueve?

**G7** Tienes un simulador y quieres saber cuánto cambia la velocidad punta con Crr.
¿Qué harías? (Así se han calculado las barras y las bandas.)

**G8** Si tú diseñaras el coast-down, ¿desde qué velocidad lo empezarías? ¿Qué ganas
empezando más alto, y qué te cuesta?

**G9** ¿Patina a fondo? F_trac = (3/2·3·0,016855·120)·8,3636·0,95/0,155.
F_grip = μ·0,65·110·9,81 con μ = 0,75. Calcúlalo y di si hace falta launch control.

**G10** Tu 04_model/CLAUDE.md dice "no saltar niveles: cada nivel se valida antes del
siguiente". Quieres C02 = motor + inversor sin haber validado el vehículo. ¿Cómo lo
defiendes delante de los mentores?

> [!success] Bloque G respondido el 9 oct — veredicto en el chat
> ✅ G1, G2, G6, G7, G8, G9 · ⚠️ G3 (no veías el límite de batería), G4 (el *para qué*),
> G5 (R_int y 0,95/√3). Correcciones aplicadas al deck. **G10 sigue sin responder.**

---

## H · Ensayo: la pregunta que te harán en cada slide

Sin respuestas a propósito. Contesta en voz alta, sin mirar la slide. Si una no
sale en 30 segundos, esa es la slide que tienes que repasar.

| Slide | La pregunta |
|---|---|
| 02 | ¿Por qué no esperaste a tener neumáticos? ¿Qué gana un modelo sin datos? |
| 03 | ¿Por qué la rodadura es constante y la aero crece con v²? ¿Qué es m_eq y por qué no es solo la masa? |
| 04 | De todos los ASSUMED, ¿cuál te preocupa más y por qué? ¿De dónde sale μ = 0,75? |
| 05 | ¿Por qué la corriente de batería y la de motor no son la misma? ¿Qué pasa a partir de 9 km/h? |
| 05 | ¿Por qué la curva se desploma cerca de 35 km/h? |
| 05 | En C00 dijiste 1,9 kW de techo de batería; hoy dices 1,8. ¿Qué ha cambiado? |
| 06 | ¿Por qué un solo integrador? ¿Qué entra y qué sale de cada bloque? |
| 06 | ¿Qué valida el −0,6 % y qué **no** valida? |
| 07 | ¿Cómo sale la banda ± de cada predicción? ¿Son simulaciones o cálculos a mano? |
| 08 | ¿Por qué la tensión del pack no entra en la banda? |
| 09 | ¿Por qué desde 30 km/h y no desde 15? ¿Por qué ida y vuelta? |
| 10 | ¿Por qué no modelas el deslizamiento del neumático? |
| 11 | (La haces tú) ¿Cómo fijarías los límites de corriente en un motor térmico? |
| 12 | **G10:** tu propia regla dice "no saltar niveles". ¿Por qué motor + inversor en C02 sin validar el vehículo? |

Y una más, que siempre cae: **A1, con tus palabras** — ¿qué diferencia hay entre
calibrar y validar un modelo?

---

## I · Para cuando abras el L2 (después de la review)

`04_model/models/longitudinal_L2.slx` es la misma física que L1, agrupada en 4
bloques, con dos huecos vacíos. Rellenarlos es tuyo.

**I1 — Load transfer.** El bloque `F_grip (static - L2 hook)` usa hoy `μ·x_cg·m·g`.
Al acelerar, la fuerza normal trasera cambia. Escribe tú el término que falta.
¿Qué parámetro necesitas que hoy está como MISSING en `vehicle_params.m`?

**I2 — Launch control.** El bloque `Launch control hook` hoy no hace nada. Para
limitar la corriente cuando la rueda patina, ¿qué señal te dice que está patinando?
¿La tiene el modelo hoy? Si no, ¿qué tendrías que añadir antes?

**I3 — Antes de simular.** Cuando rellenes I1: ¿esperas que el tiempo 0 → 25 km/h
baje, suba o no cambie? ¿Por qué? Escríbelo **antes** de lanzar
`run_regression_L1_L2.m`.
