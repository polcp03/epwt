# C01 deck — feedback de Pol (noche del 8 al 9 oct)

Pendiente de aplicar **después** de la ronda de preguntas sobre el modelo. No antes.

## Forma
- Descuadre de letras, incluso en el título.
- Más visual: imágenes nuevas, **no reutilizar** las de C00. Sigue pareciendo cutre.

## Qué sobra
- Polos del VESC (14 → 6): no pinta nada en esta review.
- La masa medida como "logro": no hace falta. Ir directo al grano.
- Slide 10 ("lo que no entiendo"): no le ve el sentido en su forma actual.
- Sí se queda: por qué no hay coast-down (neumáticos + ESP32).

## Qué falta
- Ecuación de fuerzas: bien, pero **con datos**: qué μ, por qué ese μ, masa total, cada valor con su origen.
- Motor y batería: **de dónde sale cada número** (¿medido, del VESC, configurado, asumido?). R_int: ¿quién la midió?
- Explicar mejor el modelo: por qué un solo integrador, qué hace el bloque MATLAB, qué hace el VESC ramp.
- Predicciones: decir que son simulaciones, por qué el coast-down empieza a 25 km/h, cómo se calculan las bandas.
- Tornado: "change from nominal" no se entiende.
- Lo que no captura: discutir qué entra y qué no (slip, load transfer, presión, pérdidas de inversor, cadena). Pérdidas de transmisión: nunca se hablaron.

## Dirección
- C01 = explicar bien el modelo longitudinal, lo básico.
- C02 = motor + inversor en serio (Clarke, Park, control de corriente). Es lo que le interesa.
