# C01 — Frozen predictions, level 1 longitudinal model

**Frozen before any vehicle test.** Do not re-tune these numbers when data
arrives: compare against them. Full table, generated:
[`C01_predictions_table.md`](C01_predictions_table.md) ← `scripts/run_predictions_L1.m`.

Model: `models/longitudinal_L1.slx`, built by `scripts/build_longitudinal_L1.m`.
Parameters: `params/*.m`. Every ASSUMED value carries its range there.

## Predictions — v3, 2026-10-09 (V_oc = 50 V, m_total = 110 kg, flat dirt)

| Prediction | Nominal | Band | Dominant unknown |
|---|---|---|---|
| Top speed | 34.2 km/h | ± 1.2 | r_roll (65 %) |
| 0 → 25 km/h, full throttle | 2.8 s | ± 0.5 | grip μ (60 %) |
| Coast-down 30 → 5 km/h | 17.2 s | ± 5.6 | Crr (96 %) |
| Battery 40 A limit kicks in | 9.0 km/h | ± 0.6 | R_int (68 %) |

Pack voltage is a test condition, not an unknown: 46 V → 31.4 km/h, 54 V → 36.9 km/h.
Measure V_bat before every run.

### What changed from v1 (2026-10-08), and why it is not re-tuning

| | v1 | v2 | Why |
|---|---|---|---|
| Rider mass | ASSUMED 72 kg, range 65–80 | MEASURED 72 kg | Pol on a scale. Nominal unchanged, band of 0→25 shrinks 0.4 → 0.3 s |
| Coast-down window | 25 → 10 km/h | 30 → 5 km/h | Pol's test design (exam G8): start as high as the quad reaches |

### v3 (2026-10-09, before the review)

| | v2 | v3 | Why |
|---|---|---|---|
| Grip μ | ASSUMED 0.75, range 0.60–0.90 (dry asphalt) | ASSUMED 0.60, range 0.45–0.75 (dirt) | Wrong surface: the quad is driven on dirt (Pol). Order of magnitude only, no tyre data |

Effect: the launch becomes grip-limited (421 N grip < 463 N motor), the 0 → 25
band grows 0.3 → 0.5 s and μ becomes its dominant unknown. Top speed and
coast-down unchanged. Battery-limit speed 9.1 → 9.0 km/h (the launch is now
grip-limited, so current builds differently).

No vehicle data was used for any version. All changes are inputs, not fits.

## Does a higher coast-down start help? (Pol's G8 answer, checked)

Spread in coast time to 5 km/h, from each parameter's range (`C01_coast_start.csv`):

| Start | from Crr | from CdA |
|---|---|---|
| 15 km/h | 3.02 s | 0.19 s |
| 20 km/h | 4.09 s | 0.39 s |
| 25 km/h | 4.88 s | 0.64 s |
| 30 km/h | 5.47 s | 0.92 s |

Yes: CdA shows ~5× more from 30 than from 15 km/h. But it stays small next to
Crr — with a 34 km/h top speed, CdA is weakly observable by nature, not because
of the test.

## First consistency check — motor side only

Wheels off the ground (no road load), V = 52.77 V, duty 0.9486, as in the C00
no-load telemetry:

| | Model | Measured C00 |
|---|---|---|
| Speed | 16 343 ERPM = 5448 rpm | 16 440 ERPM = 5480 rpm (−0.6 %) |
| iq | 1.88 A | 1.883 A |

lambda_m comes from the scope and the drag from the spin-down fit, both
independent of this test, so this checks the motor + voltage-ceiling + drag
chain. **It says nothing about the vehicle side.** Mechanical rpm = ERPM / p,
p = 3 pole pairs.

## Where the limits are (`C01_envelope.csv`)

| Speed | What limits the wheel force |
|---|---|
| 0 → 9 km/h | motor current, 120 A (CONFIG) → ~463 N |
| 9 → ~30 km/h | battery current, 40 A (CONFIG, = BMS continuous rating) |
| ~30 → 36 km/h | voltage ceiling, 0.95·V_bat/√3 |

Grip with μ = 0.60 (ASSUMED, dirt) is 421 N: the motor (463 N) out-pulls the
tyre at launch. On dry asphalt (μ = 0.75, 526 N) it would not. This is the
quantitative case for launch control.

## What the model does not capture

Wheel slip · load transfer (static rear share only) · grade and wind · tyre
pressure and temperature on Crr · inverter losses · current-loop dynamics
(quasi-static iq) · thermal drift of R and R_int · speed-dependent chain losses
(one η) · no field weakening (disabled in the VESC, correct).

## Method notes

- Band = one-at-a-time sweep over each ASSUMED range, root-sum-square of the
  max |delta|. Assumes independent parameters — Crr and CdA from a joint fit
  will not be.
- The coast-down keeps the motor coupled through the chain: the rotor drag
  measured in C00 (63 mN·m + 139 µN·m·s/rad) is part of the predicted
  deceleration.

## L2 — structure only

`models/longitudinal_L2.slx` (`scripts/build_longitudinal_L2.m`): the same
physics regrouped into Driver+VESC / Motor / Battery / Vehicle, with two empty
hooks (launch control, load transfer). `scripts/run_regression_L1_L2.m`:
max |v_L1 − v_L2| = 0.00 km/h on both manoeuvres, 2026-10-09.

## Derived numbers the C01 deck shows (computed in `C01_review.py` from params)

| Number | From | Note |
|---|---|---|
| m_eq = 114.5 kg | 110 kg + 4 kg wheels (ASSUMED) + J_rotor·i²/r² = 0.45 kg | rotor counts ×70 through i², still tiny |
| Battery power at the 40 A limit ≈ 1.8 kW | (50 V − 0.10 Ω · 40 A) · 40 A = 46 V · 40 A | **C00 said 1.9 kW** = 40 A · 48 V nominal, no sag. The difference is R_int (ASSUMED) |
| F_roll = 32 N, F_aero(30 km/h) = 25 N, grip = 421 N | Crr·m·g, ½ρ·CdA·v², μ·0.65·m·g | at top speed (34 km/h) rolling ≈ aero ≈ 32 N |
