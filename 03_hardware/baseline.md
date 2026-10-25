# Hardware baseline — the quad as it is today

**Source of truth for the hardware.** Last full review: 2026-10-25.

Every value carries a tag: **MEASURED** (on this vehicle) · **VESC_ESTIMATE** (VESC
detection, not independent) · **CONFIG** (typed in by a human) · **ASSUMED** (guess,
must be replaced) · **MISSING**. Numbers that enter the model live in
`04_model/params/*.m`; this file says what the hardware *is*, and points there.

Detail and history: [motor-parameters](motor-parameters.md) ·
[open-questions](open-questions.md) · [vesc/](vesc/README.md) ·
[shopping-list](shopping-list.md).

---

## 1. Vehicle

Nitro Motors mini-quad, tubular steel chassis, originally 36 V / 800 W lead-acid.
Converted to Li-ion and a 48 V-class PMSM.

| Item | Value | Tag |
|---|---|---|
| Vehicle mass (no rider) | **38 kg** | MEASURED, scale, 2026-10-08 |
| Rider mass | 72 kg | MEASURED, scale, 2026-10-08 |
| Total | 110 kg | — |
| Wheelbase | 0.71 m | ASSUMED (commercial reference) |
| Static rear weight fraction | 0.65 | ASSUMED — needs a scale under each axle |
| CG height `h_cg` | — | **MISSING** — needed for load transfer |

Subjective: very good on dirt, drifts, rear wheels rarely spin (weight sits rearward).

## 2. Tyres and wheels

Front 13×4.10-6, rear 13×5.00-6 TR13, 6 in rims, pneumatic knobby, tubed.

| Item | Value | Tag |
|---|---|---|
| Nominal radius | 165.1 mm | MEASURED (tyre size) |
| Loaded rolling radius `r_roll` | 155 mm [150–160] | ASSUMED — **most leveraged unmeasured number** |

Measure `r_roll` by roll-out (rider seated, 10 revolutions, `r = D/(20π)`), never with a
ruler. Procedure in `04_model/params/vehicle_params.m`. New tyres bought (reported
2026-10-20): measure once they are fitted — the old 155 mm guess does not carry over.

## 3. Transmission

25H chain, **11T / 92T → i = 8.364** (MEASURED: teeth counted, confirmed by Hall count).
Original 11/72; the change to 92T transformed launch and low-speed behaviour.
Efficiency 0.95 [0.90–0.97] ASSUMED — never measured.

## 4. Motor

Donor: Urban Fox scooter, sold as "48 V ~1900 W BLDC". The market reference
(MY1020/BM1109) is **ruled out** — its rated torque and current are inconsistent with
the measured Kt. Treat any datasheet number as belonging to another motor.

| Item | Value | Tag |
|---|---|---|
| Topology | Radial flux, **inner rotor**, outer wound stator, 3 phases | Observed by Pol |
| Pole pairs `p` | **3** | MEASURED (Hall count) |
| Flux linkage `λm` | **16.855 mWb** | MEASURED (3 methods, 0.02 %) |
| `Rs` per phase | 28.02 mΩ | VESC_ESTIMATE (includes MOSFETs) |
| `Ld` / `Lq` | 99.2 / 112.8 µH, **Lq/Ld = 1.136** | VESC_ESTIMATE at 40 A |
| Rotor inertia | 1.558·10⁻⁴ kg·m² ±14 % | MEASURED |
| Back-EMF THD | 9.4 % (5th, 7th) | MEASURED |
| Kt | 0.0758 Nm/A | Derived |
| Magnet arrangement (surface / inset / interior) | — | **MISSING** — saliency says *not pure surface* |
| Stator slot count | — | **MISSING** |
| Temperature sensor | none fitted | MEASURED |

Lq > Ld with a current-dependent ratio means the rotor has *some* saliency; it does
not by itself prove interior magnets (see `02_knowledge/` for the reasoning). Settling
it needs a look inside or an Ld/Lq-vs-angle measurement.

## 5. Inverter — Flipsky FSESC 6.7 Mini Pro (VESC)

Product data: ~70 A continuous, 14–60 V, FOC, Hall support, CAN/USB/UART.

Operating configuration (CONFIG, full list in `motor_params.m` and `vesc/`):
FOC with Hall sensors, current control, PWM 30 kHz, current loop bandwidth 2000 rad/s,
no decoupling, MTPA off, field weakening off.

| Limit | Value |
|---|---|
| Motor current | ±120 A (abs 160 A) |
| Battery current | **40 A** discharge / −35 A regen — equals BMS rating, do not raise |
| Duty | 0.95 |
| Battery cut-off | 44.2 → 39.0 V |

**CAN:** mode = UNUSED (bus silent). No on-board termination (217 Ω measured unpowered
= transceiver leakage): both 120 Ω terminators must be external. Set CAN mode to VESC
before any bus bring-up. **Any link VESC ↔ mains-referenced equipment needs galvanic
isolation** (see EXP-001).

Observed in use: battery current peaks ~40 A, typical 20 A; at launch the motor-current
limit is reached, then duty becomes the limit as speed rises.

## 6. Battery and BMS

13S5P, 65 × SINC ISR18650-26A (no verified datasheet), ~13 Ah.
48.1 V nominal, 54.6 V full, 39.0 V empty.
`R_int` 0.10 Ω [0.06–0.15] ASSUMED — measure from voltage sag in a log.
Design assumption 5 A/cell = 25 A continuous; observed peaks ~40 A. **Risk 1** in
[open-questions](open-questions.md).

BMS: JK-BD4A17S4P, 40 A continuous, active balancing, Bluetooth only in use.
Physical comms interface not verified (BMS stays mounted).

## 7. Driver inputs and sensors

- Throttle: 3-wire 5 V Hall, wired directly to VESC ADC.
- Brake switch: original, disconnected.
- Wheel speed: 3144 Hall sensors + magnets available, not fitted.
- IMU: GY-LSM6DS3 (6-axis), not fitted.

## 8. Electronics and tools on hand

| Item | Status |
|---|---|
| ESP32-WROOM-32 (original) | **Destroyed** 2026-09-07 (ground loop, EXP-001) |
| ESP32 ×3 (new) | Bought, reported 2026-10-20. Not yet used |
| MCP2515 + TJA1050 CAN module | **Retired** — 5 V logic, not isolated |
| microSD module + 16 GB card, D4184 DC/DC, protoboard | Available |
| Oscilloscope, multimeter, soldering | Available. Floating phase voltages need a differential probe |

Isolated CAN (ISO1050) and the rest: [shopping-list](shopping-list.md).
**Firmware is parked until the data-logger cycle** (after C03, see roadmap).

## 9. Still open

Magnet arrangement · slot count · `r_roll` · `h_cg` · axle weights · `R_int` · cell
current capability · drivetrain efficiency · control-loop period (15 vs 30 kHz) ·
VESC firmware version · BMS overcurrent settings.

Superseded source: the August 2026 "master technical context" (in `_archive/`).
