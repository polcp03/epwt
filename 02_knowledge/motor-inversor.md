# Motor + inversor — lo que sé explicar

Sacado de mis respuestas en L1 (25-oct), corregido. Si una frase no me suena a mí,
la reescribo. Los fallos están en [errores](errores.md).

## Velocidad máxima en vacío

Al girar, los imanes del rotor hacen cambiar el flujo que atraviesa las bobinas, y eso
induce una tensión: la **back-EMF**, proporcional a la velocidad (e = ωe·λm). El motor
acelera hasta que la back-EMF casi iguala la tensión máxima que el inversor puede
aplicar (con SVPWM, Vbus/√3 de pico por fase). Ahí ya no queda tensión para empujar
corriente, y sin corriente no hay par: la velocidad se estabiliza. No llega del todo
al ideal porque hace falta algo de corriente (1,9 A en mi motor) para vencer la fricción.

Para ir más rápido: más tensión de bus o **debilitamiento de campo**, que es inyectar
id negativa para restar flujo al del imán. En mi VESC está desactivado.

## Back-EMF sin corriente

No hace falta corriente, hace falta flujo que cambie. Lo medí el 7-sep: motor
desconectado, girado con un taladro, osciloscopio entre dos fases → λm = 16,855 mWb.

## Por qué hay que saber dónde está el rotor

El par máximo sale cuando el campo de las bobinas va **90° eléctricos** por delante del
campo de los imanes. Para colocarlo ahí, el inversor tiene que saber dónde está el
rotor: en mi quad lo dice el sensor Hall.

## El camino de la energía

Batería (química → eléctrica, vigilada por el BMS) → **DC-link**: condensadores que
aportan los picos de corriente de la conmutación, que el cable de batería no puede dar
tan rápido → seis transistores, dos por fase, gobernados por el micro → tres tensiones
alternas en las fases → par en el rotor → reducción por cadena (11/92), que cambia
velocidad por par → la rueda pasa de rotación a avance.

## El rotor de mi motor

Rotor interno, estator bobinado por fuera. Mido Lq/Ld = 1,136: hay algo de saliencia,
así que **no es un rotor de imanes en superficie puro**. Pero es poca para un IPM típico
(2–3). Qué es exactamente (imanes encastrados o interiores con poca saliencia) no lo sé
sin abrirlo. *Abierto.*
