# Preguntas abiertas y riesgos del hardware

Lo que **no** está verificado. Cada línea es un candidato a experimento.
Extraído de la revisión crítica de 2026-08-21.

## Riesgo 1 — Margen de corriente de la batería (el más serio)

Picos de batería observados de **~40 A** contra una asunción de diseño de 25 A
(5 celdas × 5 A). Sobrepaso de ~1,6x, unos 8 A/celda de pico.

- Las celdas SINC ISR18650-26A **no tienen datasheet verificado**. Es habitual que
  celdas genéricas o remarcadas tengan capacidades de corriente infladas.
- El BMS (JK-BD4A17S4P) tiene límite continuo de 40 A → en los picos se está rozando
  también el límite del BMS, no solo el de las celdas.
- El BMS es hoy un backstop pasivo, solo visible por Bluetooth. Un evento de
  sobrecorriente se descubriría por el corte brusco, no por un aviso previo.

**Mitigación mientras no haya medida:** el limitador primario es el límite de corriente
configurado en el propio VESC, con margen por debajo de la capacidad real del pack y
del rating del BMS. Instrumentar temperatura del pack directamente: en un grupo 5P las
celdas exteriores se calientan más de lo que ve el termistor interno del BMS.

**Experimento pendiente:** caída de tensión bajo carga para estimar la capacidad real
de corriente del pack.

## Riesgo 2 — El corte de USB del VESC bajo carga no está diagnosticado

Catalogado como "posible EMI" pero nunca comprobado. Es un **fallo conocido y
documentado en la comunidad VESC**, sin causa única. Tres mecanismos candidatos,
no excluyentes:

1. Resistencias de terminación USB — el datasheet del STM32F405 no especifica bien
   los pull-ups; algunas revisiones de placas VESC 6 los cambiaron.
2. Acoplamiento EMI de la conmutación de fase hacia las líneas de datos USB.
   Difícil de arreglar cuando USB y potencia están en placas separadas (este caso).
3. Bucles de tierra entre la tierra del PC y la del VESC (referenciada a batería)
   en cuanto circula corriente. Puede llegar a matar un regulador.

Como el síntoma es "bajo carga, y el motor sigue funcionando", EMI o bucle de tierra
son más probables que un defecto de soldadura.

**Experimento barato pendiente (~30 min):** osciloscopio en D+/D- y en el raíl de 5 V
durante una rampa de carga. Probar hub USB aislado o ferrita como bisección.

## Riesgo 3 — El motor no está identificado con certeza

La referencia MY1020/BM1109 no está confirmada. Caracterizarlo (R de fase, back-EMF,
pares de polos) es barato y no requiere software. → Es el objetivo de **C01**.

## Implementaciones de referencia a revisar antes de programar nada

- **VESC Express** — firmware oficial de los desarrolladores de VESC para ESP32.
  Hace prácticamente lo mismo que el logger V1 planteado. Revisar antes de escribir código.
- El asistente de detección FOC de VESC Tool ya estima R, L y flujo magnético
  (rangos típicos ~15–35 mΩ y 4–20 µH para este tipo de motor). Sirve como contraste
  independiente de la medida manual.
- `syssi/esphome-jk-bms` — protocolo JK-BMS por UART/BLE ya deconstruido y mantenido.

## Gotcha de hardware confirmado

El TJA1050 es lógica de 5 V. Muchos módulos MCP2515/TJA1050 baratos alimentan todo el
módulo a 5 V, fuera de spec para los GPIO de 3,3 V del ESP32. **Verificar con multímetro
el nivel lógico real del módulo antes de cablear directo.**
