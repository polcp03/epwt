# Hardware baseline — el quad tal y como está hoy

Extraído del master technical context (agosto 2026). **Fuente de verdad del hardware.**
Regla: cada valor debe estar marcado como MEDIDO o ASUMIDO. Lo que no esté medido, no entra en el modelo sin decirlo.

---

5. CURRENT VEHICLE BASELINE
======================================================================

Vehicle:
Nitro Motors mini-quad platform.

Original configuration:
approximately 36 V / 800 W class electric mini-quad.

Chassis:
tubular steel structure.

Approximate commercial reference dimensions:
- length: approximately 105 cm;
- width: approximately 60–69 cm;
- height: approximately 70 cm;
- seat height: approximately 49–54 cm;
- wheelbase: approximately 71 cm;
- ground clearance: approximately 8.5 cm.

Original vehicle mass has been referenced at approximately 45 kg.
Lithium conversion is expected to reduce mass by approximately 5 kg compared with the original lead-acid battery system.

IMPORTANT:
These dimensions and masses are not yet frozen model parameters and should be measured on the actual vehicle.

The current driver mass used in previous calculations has been approximately 72 kg, giving a rough system mass of around 110–112 kg. This is an estimate and must be replaced by a measured baseline before the final vehicle model is parameterised.

UPDATE 2026-09-07 - the 40 kg figure now has two agreeing sources: the
45 kg stock platform minus ~5 kg for the lead-acid -> Li-ion swap, and Pol
lifting the quad and judging it "about 40 kg". Two independent estimates on
the same number, but neither is a scale. Tagged ESTIMATED, not MEASURED.

======================================================================
6. TYRES / WHEELS
======================================================================

Current tyre sizes:

Front:
13 × 4.10-6 TR13

Rear:
13 × 5.00-6 TR13

Wheel/rim size:
6 inch.

Tyres:
pneumatic, tubed, knobby/off-road type.

Current application:
dirt / grass / asphalt-capable recreational use.

The effective rolling radius remains a model-calibration parameter. Nominal tyre size is not sufficient to define the exact rolling radius under vehicle load.

UPDATE 2026-09-07 - working values entered in the model.
13 in nominal -> 330.2 mm OD -> 165.1 mm unloaded radius.
Pol's observation: the mass sits well to the rear and the tyres run at low
pressure, so the rear tyre visibly squashes. Model uses r_roll = 155 mm
(about 6 % deflection), band 150-160 mm, tagged ASSUMED.

This is now the most leveraged unmeasured number in the whole vehicle: it
divides torque into tractive force AND multiplies speed, so its error lands
twice. Measure it by ROLL-OUT, not with a ruler: rider seated, mark the tyre,
push the quad ten wheel revolutions in a straight line, r_roll = D/(10*2*pi).
A ruler measures the deformed shape; only rolling measures the radius the
vehicle actually travels on.

======================================================================
7. TRANSMISSION
======================================================================

Chain:
25H.

Current:
11T motor sprocket / 92T rear sprocket.

Original:
11T / 72T.

Current ratio:
92 / 11 ≈ 8.36:1.

The change from 72T to 92T produced a major improvement in vehicle launch and low-speed behaviour.

Current real-world observation:
the quad performs very well on dirt, is capable of drift and is considered subjectively very fun to drive.

Current traction observation:
major wheelspin is not currently a dominant problem. Because the driver/vehicle mass distribution places significant weight towards the rear, the driven rear tyres generally retain useful traction.

Nevertheless, launch-control and traction-control are interesting future engineering functions and may be implemented once the necessary measurements and models exist.

======================================================================
8. MOTOR
======================================================================

Motor:
48 V BLDC motor from an Urban Fox scooter donor.

Market identification previously associated with:
MY1020 / BM1109 type.

Approximate market power:
1900–2000 W.

Previous reference values encountered:
- nominal speed: approximately 4300 rpm;
- no-load speed: approximately 5400 rpm;
- nominal torque: approximately 4.0 N·m;
- peak torque: approximately 6.9 N·m;
- efficiency: approximately 82%;
- nominal current: approximately 34–40 A depending on source;
- peak current: approximately 41–46 A depending on source.

IMPORTANT:
The exact motor reference is NOT fully confirmed. These values must therefore remain reference estimates, not validated design specifications.

UPDATE 2026-09-06 — the market reference is now positively RULED OUT.
Pole pairs measured by Hall pulse counting: p = 3 (MEASURED, see motor-parameters.md).
With the VESC flux linkage of 16.0 mWb this gives Kt = 0.0721 Nm/A, so the quoted
"nominal torque of approximately 4.0 Nm" would require 55 A, well above the quoted
nominal current of 34-40 A. The two figures cannot both describe this machine.
Treat every number in the list above as belonging to a different motor. The only
motor data that enters the model now comes from 04_model/params/motor_params.m.

UPDATE 2026-09-06 — transmission ratio 92/11 independently confirmed by the same
Hall count landing on its predicted value (25.1 pulses per rear-sprocket turn).

The project will eventually characterise experimentally:
- phase resistance;
- phase inductance;
- flux linkage;
- back-EMF constant;
- Kv;
- pole pairs;
- torque constant;
- Hall sequence/angle;
- mechanical speed;
- thermal response;
- losses;
- possibly inertia.

The motor currently works successfully on the vehicle.

======================================================================
9. VESC / INVERTER
======================================================================

Inverter:
FLIPSKY FSESC 6.7 Mini Pro.

Reference capabilities:
- approximately 70 A continuous current;
- approximately 200 A instantaneous/peak capability according to product information;
- 14–60 V operating range;
- programmable;
- FOC / BLDC / DC modes;
- current / duty-cycle / speed / position control;
- regenerative braking support;
- CAN;
- USB;
- UART;
- SPI;
- I2C;
- Hall support;
- 5 V @ 1 A BEC.

The VESC is currently used as the low-level inverter and motor controller.

Architectural intent:
VCU/MCU = high-level vehicle control.
VESC = low-level motor control and FOC.

The project may later investigate the open-source VESC firmware in depth and potentially modify motor-control functions, including FOC and field weakening. This is long-term exploratory work, not an initial requirement.

======================================================================
10b. VESC CAN CONFIGURATION (source-tree defaults, 2026-09-07)
======================================================================

From `03_hardware/vesc/reference/appconf_default.h` (autogenerated by VESC Tool).
NOT read back from the device - confirm in VESC Tool before trusting.

- CAN baud rate: 2 = 500 kbit/s.
- Controller ID: 15 -> status frames carry extended IDs 0x090F, 0x0E0F, 0x0F0F, 0x100F.
- CAN status msgs R1: 15 = bitfield 0b1111 = status 1, 2, 3 and 4 enabled.
- CAN status rate 1: 50 Hz.
- CAN mode: 3 = CAN_MODE_UNUSED -> **CAN transmission disabled**.

The last one matters: `comm_can.c:1533` only sends status frames when
`can_mode == CAN_MODE_VESC` (0). With mode 3 the bus is silent regardless of wiring.
Set CAN Mode to VESC in App Settings -> General before any bus bring-up.

======================================================================
10. CURRENT VESC CALIBRATION / OPERATION
======================================================================

Current control mode:
current control.

Rotor-position sensing:
motor Hall sensors.

Hall detection:
performed using VESC Tool and successfully calibrated.

Current observations:
- motor-current limit used during experimentation: up to approximately 120 A;
- battery-current peak observed: close to 40 A;
- typical battery-current peaks/levels during tests: approximately 20–20+ A;
- high motor current produces noticeable motor and wiring heating;
- after changing to 11/92 gearing, the vehicle needs less motor current for the desired tractive performance and heating is reduced.

The current experiments have demonstrated that the motor can operate successfully under load.

Previous free-running/no-load tests produced very low current because little torque was required.

The project aims to understand the VESC behaviour in depth rather than treating it as a black box.

======================================================================
11. VESC OBSERVED ERPM / DUTY-CYCLE BEHAVIOUR
======================================================================

During vehicle launch experiments:
- current can rise strongly at low speed;
- the VESC can reach the configured motor-current limit;
- with increasing speed, duty cycle becomes increasingly important;
- the system can transition from a current/torque-limited region toward a voltage/duty-limited region.

The project will use these observations to understand:
- back-EMF;
- DC-bus voltage limitation;
- duty-cycle limitation;
- Iq/Id behaviour;
- base-speed region;
- field weakening.

VESC reports ERPM, which is electrical RPM rather than necessarily mechanical shaft RPM.

Mechanical RPM will eventually be independently validated to determine the actual motor pole-pair count.

======================================================================
12. BATTERY
======================================================================

Configuration:
13S5P.

Number of cells:
65.

Chemistry:
Li-ion.

Cell identification:
SINC ISR18650-26A.

Pack capacity:
approximately 13 Ah.

No verified public datasheet has been established for the exact SINC cell.

A previous conservative engineering assumption was approximately 5 A continuous per cell, giving approximately 25 A for 5P. This is an engineering assumption only.

Battery is currently functional and adequate for the current vehicle.

Future option:
custom battery with higher-quality/higher-current cells if the present pack becomes a demonstrated limitation.

No decision has yet been made to replace the current battery.

======================================================================
13. BMS
======================================================================

Installed BMS:
JIKONG / JK Smart BMS.

Exact model:
JK-BD4A17S4P.

The installed pack is 13S and therefore within the model family's applicable series range.

Reference product information for the model includes:
- 7–17S Li-ion capability;
- 40 A continuous discharge capability;
- higher short-duration capability depending on configuration;
- active balancing;
- temperature monitoring;
- Bluetooth;
- CAN / RS485 options depending on hardware variant.

The exact physical communication interface enabled on the installed BMS has NOT been verified because the BMS is mounted and will not be dismantled merely for inspection.

Current BMS usage:
primarily Bluetooth monitoring/configuration via mobile device.

Observed use:
monitoring cell voltages, pack state and current during vehicle tests.

The BMS is not yet integrated into the ESP32 control architecture.

======================================================================
14. ACCELERATOR
======================================================================

Standard Hall-effect throttle.

Known characteristics:
- 3 wires;
- 5 V supply;
- analogue Hall output.

Current architecture:
Throttle → VESC ADC directly.

Future architecture:
Throttle → ESP32/VCU → high-level request → VESC via CAN.

This transition should occur only after the autonomous logger and measurement infrastructure are functioning.

======================================================================
15. BRAKE
======================================================================

Original quad brake switch.

Expected signal:
digital ON/OFF.

Current status:
disconnected from the electronics.

Future use:
input to the ESP32/VCU.

======================================================================
16. WHEEL-SPEED SENSOR
======================================================================

Future hardware already available:
- 3144 / 550A Hall sensors;
- neodymium magnets.

Planned mounting:
front wheel / rim.

Purpose:
independent vehicle wheel-speed measurement.

Future use:
- launch-control development;
- traction-control development;
- wheel-slip estimation;
- model/vehicle validation.

Exact magnet count and sensor geometry remain to be defined.

======================================================================
17. IMU
======================================================================

Module:
GY-LSM6DS3.

Important correction:
LSM6DS3 is NOT a GPS.

It is a 6-axis IMU:
- 3-axis accelerometer;
- 3-axis gyroscope.

Interfaces:
I2C / SPI.

Planned use:
later-stage vehicle-dynamics observation, launch-control and traction-control research.

It is intentionally NOT included in V1.

======================================================================
18. ELECTRONICS AVAILABLE
======================================================================

Confirmed development hardware:

1 × ESP32-WROOM-32. **DESTROYED 2026-09-07** — internal short after a ground-loop
event while wiring the first CAN sniffer. See `07_experiments/EXP-001-bucle-tierra-vesc-pc.md`.

1 × MCP2515 + TJA1050 CAN module. **RETIRED** — not to be used against the VESC:
5 V transceiver logic and no galvanic isolation.

The MCP2515/TJA1050 module exposes:
- INT;
- SCK;
- SI;
- SO;
- CS;
- GND;
- VCC.

The module includes a 120 Ω termination jumper.

1 × AMS1117-based microSD module.

microSD interface:
- CS;
- SCK;
- MOSI;
- MISO;
- VCC;
- GND.

1 × Kodak 16 GB microSD card.

1 × GY-LSM6DS3.

3144 / 550A Hall sensors.

Neodymium magnets.

1 × D4184 GA4D1K DC/DC module.

1 × ESP32 Basic Starter Kit. Verified 2026-09-07: contains **no** ESP32 board.

1 × protoboard.

======================================================================
19. INSTRUMENTATION / TOOLS
======================================================================

Available:
- oscilloscope;
- multimeter;
- soldering equipment.

The oscilloscope is intended to be used for:
- Hall signal validation;
- supply-noise investigation;
- PWM/inverter observation where electrically safe;
- validation of the current EMI/USB problem;
- later experimental motor characterisation.

A proper differential probe must be used for measurements that require floating phase-voltage measurement. The oscilloscope ground clip must not be connected arbitrarily to a switching motor phase.

======================================================================

---

39. CURRENT HARDWARE INVENTORY — MASTER LIST
======================================================================

VEHICLE / POWERTRAIN
- Nitro Motors mini-quad chassis.
- 48 V BLDC motor, approximately 1900 W, exact identification pending.
- FLIPSKY FSESC 6.7 Mini Pro.
- 13S5P Li-ion battery.
- 65 SINC ISR18650-26A cells.
- JK-BD4A17S4P BMS.
- 11T motor sprocket.
- 92T rear sprocket.
- 25H chain.
- 13×4.10-6 front tyre.
- 13×5.00-6 rear tyre.
- Standard 5 V Hall throttle.
- Original brake switch.

ELECTRONICS
- ESP32-WROOM-32 ×1 — **DESTROYED 2026-09-07** (internal short, see EXP-001). Not usable.
- MCP2515 + TJA1050 CAN module ×1 — **RETIRED**: 5 V logic, no galvanic isolation.
  Replaced by an ISO1050 isolated module. See `shopping-list.md`.
- 120 Ω termination jumper on CAN module.
- AMS1117 microSD module ×1.
- Kodak 16 GB microSD ×1.
- GY-LSM6DS3 ×1.
- 3144 / 550A Hall sensors.
- Neodymium magnets.
- D4184 GA4D1K DC/DC module.
- ESP32 Basic Starter Kit.
- Protoboard.

TOOLS
- Oscilloscope.
- Multimeter.
- Soldering equipment.

======================================================================
40. KNOWN HARDWARE INTERFACES
======================================================================

VESC CAN connector shown/identified:
- GND (-)
- CAN Low (CAL)
- CAN High (CAH)
- 5 V.

MEASURED 2026-09-07: 217 Ω between CAN-H and CAN-L with the board unpowered.
That is leakage through the unpowered transceiver, not a termination resistor —
**this VESC has no bus termination**. Both 120 Ω terminators must be provided externally.

VESC also has other ports including:
- SENSE;
- COMM;
- SWD;
- USB.

Current V1 only requires CAN and a suitable 5 V/GND source, subject to final electrical verification.

MCP2515 module:
- INT;
- SCK;
- SI;
- SO;
- CS;
- GND;
- VCC.

microSD module:
- CS;
- SCK;
- MOSI;
- MISO;
- VCC;
- GND.

======================================================================
41. OPEN / UNVERIFIED ITEMS
======================================================================

The following must NOT be treated as final values:

- exact motor model;
- exact motor manufacturer;
- exact motor pole pairs;
- exact motor mechanical RPM;
- exact motor electrical constants;
- exact motor continuous thermal capability;
- exact vehicle mass;
- exact mass with driver;
- exact effective tyre radius;
- exact CG location;
- exact front/rear weight distribution;
- exact battery cell discharge capability;
- exact BMS communication interface enabled;
- exact BMS configured overcurrent settings;
- exact VESC firmware revision;
- exact VESC Tool version;
- exact VESC CAN status-message configuration;
- exact V1 logger sampling rates;
- exact logger power topology;
- exact electrical compatibility/logic-level details between ESP32 and the specific MCP2515/TJA1050 module;
- current regenerative-braking configuration;
- exact wheel-speed sensor geometry.

======================================================================
