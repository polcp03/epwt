# Lista de compra — hardware pendiente

Actualizada 2026-09-07. Marcar `[x]` al recibir y mover al inventario de `baseline.md`.

## Prioridad 1 — bloquea el logger de CAN

- [ ] **ESP32-WROOM-32 DevKit ×2**
  Buscar: `ESP32 WROOM 32 DevKit 38 pin`
  ~6 €/ud. Uno para el logger, otro para hacer de VESC falso en banco.
  El Starter Kit del inventario **no trae placa** (verificado 2026-09-07).

- [ ] **Módulo CAN aislado ISO1050 ×1**
  Buscar: `ISO1050 isolated CAN transceiver module`
  ~10 €. **Sustituye al MCP2515/TJA1050.** Aislamiento galvánico entre el lado del
  VESC y el lado del ESP32: es la causa raíz del incidente del 07-09.
  Alternativa barata y peor: `SN65HVD230` (~3 €) — 3,3 V nativo pero **sin aislar**.

- [ ] **Lector microSD USB ×1**
  Buscar: `lector tarjetas microSD USB`
  ~5 €. El PC no tiene ranura SD (verificado: solo lector de smartcards del teclado HP).
  El adaptador microSD→SD que ya hay es pasivo, no sirve sin ranura.

## Prioridad 2 — diagnóstico del Riesgo 2 (corte de USB del VESC bajo carga)

- [ ] **Aislador USB ADUM3160 ×1**
  Buscar: `USB isolator ADUM3160`
  ~12 €. Pedido por `01_plan/backlog.md`. Corta la conexión eléctrica PC↔VESC dejando
  pasar los datos. USB 1.1 (velocidad baja) — suficiente para VESC Tool.

- [ ] **Ferritas de pinza, pack ×1**
  Buscar: `ferrite clamp 5mm 7mm cable`
  ~6 €. La otra mitad de la bisección EMI vs bucle de tierra (ver `EXP-001`).

- [ ] **Resistencias 120 Ω 1/4 W, pack ×1**
  Buscar: `resistencias 120 ohm 1/4W`
  ~3 €. Medido el 07-09: **el VESC no lleva terminación de bus** (217 Ω entre CAN-H y
  CAN-L con la placa sin alimentar = fuga por el transceptor, no una resistencia real).

## Total aproximado

~48 €

## Ya en inventario — NO comprar

- Módulo microSD AMS1117 + tarjeta Kodak 16 GB
- Protoboard, cables dupont
- Osciloscopio, multímetro, equipo de soldadura

## Descartado

- **MCP2515 + TJA1050**: se queda en el cajón. 5 V contra los 3,3 V del ESP32, sin
  aislamiento, y añade un bus SPI que compite con el módulo SD. El ISO1050 lo sustituye.
- **ESP32-WROOM-32 nº 1**: destruido el 2026-09-07. Cortocircuito interno. Marcar y
  guardar aparte para no confundirla con una buena.
