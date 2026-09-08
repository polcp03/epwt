# EXP-001: Bucle de tierra entre el VESC y el PC

**Estado:** pendiente de medir. Abierto el 2026-09-07 tras destruir un ESP32.

## Pregunta

¿Cuánta tensión de modo común hay entre la masa del VESC (referenciada a la batería
13S, flotante) y la masa del PC (referenciada a la red eléctrica), y cuánta corriente
circula cuando se unen las dos por el cable de masa del bus CAN?

## Por qué existe este experimento

El 2026-09-07 se destruyó un ESP32-WROOM-32 montando el primer sniffer de CAN.
Ver [incidente](#incidente-2026-09-07) abajo.

Esto **ya estaba anticipado** en `03_hardware/open-questions.md`, Riesgo 2:

> "Bucles de tierra entre la tierra del PC y la del VESC (referenciada a batería)
> en cuanto circula corriente. Puede llegar a matar un regulador."

Y en `01_plan/backlog.md`: *"30 min de osciloscopio antes de construir nada para
evitarlo"*. Se montó sin hacer esa medida. Coste: una placa.

## Hipótesis

**H1.** Con el VESC apagado, la diferencia de potencial entre su masa y la tierra del
PC es pequeña (< 1 V DC, < 5 V AC). Unirlas no hace nada.

**H2.** Con la etapa de potencia del VESC conmutando, el conjunto batería + VESC + motor
oscila en potencial respecto a tierra a alta frecuencia, por acoplamiento capacitivo
entre las fases del motor y el chasis. La amplitud supera los ±7 V de rango de modo
común que aguanta un transceptor CAN no aislado.

**H3.** Al unir ambas masas, esa oscilación empuja corriente por el cable de unión
según `I = C · dV/dt`. Esa corriente es la que degrada los pines y el raíl de 3,3 V.

Si H2 y H3 se confirman, la conclusión es que **cualquier conexión no aislada entre el
VESC en carga y un equipo referenciado a red es insegura**, independientemente del
cableado. No es un error de montaje: es una propiedad del sistema.

## Método

Tres medidas, de menos a más riesgo. **No saltar pasos.**

### M1 — Potencial estático (multímetro, seguro)

Multímetro entre el **negativo de la batería** y la **tierra del PC** (tornillo del
chasis o malla de un conector metálico). Nada más conectado entre los dos sistemas.

Medir en DC y en AC, en tres estados:

| Estado | V DC | V AC |
|---|---|---|
| VESC apagado | | |
| VESC encendido, motor parado | | |
| Motor girando en carga ligera | | |

> [!warning] Puede aparecer tensión de red
> Si la fuente del PC tiene fugas por sus condensadores Y, se pueden leer decenas de
> voltios AC. Es alta impedancia y poca corriente, pero **no tocar las puntas con la piel**.

### M2 — Corriente del bucle (multímetro, seguro)

Unir las dos masas **a través de una resistencia de 1 kΩ**, no directamente. Medir la
caída de tensión en la resistencia. `I = V / 1000`.

Mismos tres estados que M1. La resistencia limita la corriente a un valor inofensivo
y convierte el problema en una lectura de tensión.

### M3 — Forma de onda (osciloscopio)

> [!danger] Cómo NO hacerlo
> **No pinzar la masa del osciloscopio al VESC.** La pinza de masa del osciloscopio
> está unida a tierra de red. Pinzarla al VESC crea exactamente el cortocircuito que
> se está intentando medir, a través del propio cable del osciloscopio.

Forma correcta:

- Pinza de masa → **tierra del PC / chasis** (donde ya está referenciada).
- Punta de la sonda (×10) → **negativo de la batería del VESC**.

La sonda es de 1 MΩ, así que no une las masas de verdad: mide el potencial sin dejar
pasar corriente apreciable. Capturar durante una rampa de carga.

Qué buscar: picos de alta frecuencia sincronizados con la conmutación. Anotar amplitud
pico a pico y frecuencia.

### M4 — Bisección (opcional, si M1-M3 no son concluyentes)

Repetir M2 con ferritas de pinza en el cable de unión.

- Mejora clara → el mecanismo dominante es EMI conducida de alta frecuencia.
- Sin cambio → es un bucle de tierra de baja frecuencia.

## Criterio de decisión

| Resultado | Conclusión |
|---|---|
| M3 muestra picos > ±7 V | H2 confirmada. Aislamiento galvánico obligatorio, no opcional. |
| M2 da > 10 mA en carga | H3 confirmada. Cuantifica el daño. |
| Todo < 1 V y < 1 mA | Hipótesis refutada. Buscar otra causa del fallo del 07-09. |

## Datos

Pendiente. → `06_data/`

## Conclusión

Pendiente.

## Limitaciones

- El multímetro no es true-RMS a alta frecuencia: M1 en AC es orientativa, no exacta.
- No se mide el acoplamiento capacitivo fase→chasis directamente, solo su efecto.
- El resultado depende de este PC y esta instalación eléctrica. Con otra toma de
  corriente los números pueden cambiar.

---

## Incidente 2026-09-07

**Montaje:**

```
PC (tierra de red) --USB--> ESP32 --3V3--> modulo MCP2515/TJA1050 --CAN-H/L--> VESC (13S, ~54 V)
                                                                   --GND-----> VESC
```

El VESC estaba **encendido** con la batería puesta. **No** estaba conectado por USB al
PC (bucle de tierra por doble USB descartado por el usuario).

**Secuencia:**

1. Cableado según arriba. Módulo CAN alimentado desde el pin 3V3 del ESP32.
2. Primer intento de subida de firmware: falla con `No serial data received`.
3. El ESP32 calienta hasta no poder mantener el dedo encima.
4. Se quita el VCC del módulo. El LED del módulo **sigue parpadeando** → el módulo se
   estaba alimentando por los pines SPI (corriente saliendo por los GPIO del ESP32).
5. El puerto COM desaparece del sistema.
6. Con todo desconectado y solo el USB, la placa **sigue calentando** y no responde a
   `esptool` ni con BOOT + EN.

**Diagnóstico:** cortocircuito interno en el ESP32. El chip conversor USB-serie sigue
enumerando (Windows hace el sonido de conexión) porque es un componente aparte
alimentado por los 5 V del USB — eso **no** indica que el ESP32 esté vivo.

**Fallo de diseño identificado:** alimentar el módulo CAN desde el raíl de 3,3 V del
ESP32 pone ese raíl en contacto eléctrico directo con el lado CAN del transceptor, que
mira a un sistema de 54 V que conmuta. No hay nada en medio. Con el pinout perfecto, el
montaje ya era vulnerable.

**No confirmado:** que el mecanismo exacto fuera el bucle de tierra. Es la hipótesis
más consistente con los datos, pero **sin medir no es un hecho**. Ese es el objeto de
este experimento.

## Reglas que salen de aquí

1. Nunca conectar el VESC a nada referenciado a red sin aislamiento galvánico.
2. Cablear siempre con todo apagado. Al conectar: GND primero, VCC último. Al
   desconectar, al revés.
3. Alimentar los módulos periféricos desde su propia fuente, no desde el pin de 3,3 V
   del microcontrolador.
4. Probar el firmware contra un nodo CAN de juguete antes de acercarse al VESC.
5. Antes de montar hardware nuevo, releer `open-questions.md`. El aviso estaba escrito.
