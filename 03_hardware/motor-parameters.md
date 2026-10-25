# Parámetros del motor

> [!warning] Regla
> Cada valor lleva su origen. **MEDIDO** / **ESTIMADO** / **SIN VERIFICAR**.
> Nada entra en el modelo sin esta etiqueta.

Los valores para simulación viven en [`04_model/params/motor_params.m`](../04_model/params/motor_params.m).
Este documento explica **de dónde salen y qué convención siguen**.

## Detección FOC ×3 — 2026-09-07. La saliencia SÍ converge

Tres tiradas seguidas, sin cambiar nada, todas a **I = 40,00 A**:

| Tirada | R [mΩ] | L [µH] | Lq−Ld [µH] | λ [mWb] |
|---|---|---|---|---|
| 1 | 27,83 | 105,95 | 13,41 | 15,978 |
| 2 | 28,14 | 106,10 | 13,91 | 15,859 |
| 3 | 28,10 | 105,96 | 13,31 | 15,919 |
| **Media** | **28,02** | **106,00** | **13,54** | **15,919** |
| Dispersión | 0,5 % | 0,06 % | **1,9 %** | 0,3 % |

> [!success] La saliencia era repetible; lo que cambiaba eran los ajustes
> Con condiciones fijas repite al **1,9 %**. La horquilla vieja de 9,45 a 16,90 µH
> venía de tiradas con **corriente de detección distinta** — la del 29-jul usó
> 97,85 A frente a los 40 A de hoy.
>
> O sea: **no era ruido, era saturación magnética.** La saliencia es función de la
> corriente. Cualquier tabla de MTPA tendría que capturar precisamente eso, y
> cualquier número único de saliencia solo vale a su corriente.

De ahí: **Ld = 99,23 µH, Lq = 112,77 µH**, relación **Lq/Ld = 1,136**.

## Inercia y fricción del rotor — 2026-09-07

Tres arranques hasta velocidad de vacío seguidos de deceleración libre.
Log del VESC en `06_data/inercia/`, análisis en `04_model/scripts/inertia_from_vesc_log.py`.

Modelo de arrastre `T(ω) = T₀ + b·ω`. La deceleración da los **cocientes**
`T₀/J = 405 s⁻²` y `b/J = 0,89 s⁻¹`; el punto estacionario en vacío da la **escala**
(`Kt·iq = 0,1427 N·m a 573,9 rad/s`). Dos relaciones, una solución.

| | Valor |
|---|---|
| **Inercia del rotor `J`** | **1,558·10⁻⁴ kg·m²** (±14 %) |
| Fricción seca `T₀` | 63,1 mN·m |
| Fricción viscosa `b` | 138,8 µN·m·s/rad |
| Reparto a 5480 rpm | 44 % seca / 56 % viscosa |
| Constante mecánica `J/b` | 1,12 s |

> [!warning] Por qué solo ±14 % y no mejor
> **El método limpio no se pudo aplicar.** La idea era restar dos ensayos
> (acelerando a corriente conocida menos rueda libre) para que la fricción se
> cancelara sola. Pero el arranque duró ~0,3 s y el VESC loguea a 15 Hz: tres
> muestras con la corriente cayendo de 96 a 11 A. Inservible.
>
> La comprobación lo explica: con `J = 1,56·10⁻⁴` y 120 A disponibles, el motor
> en vacío llega a 5480 rpm en **10 ms**. Ningún log a 15 Hz captura eso.
>
> Lo que se usó —pendiente de deceleración anclada en el arrastre estacionario—
> es válido, pero **depende de `Kt`**, o sea de `λm`. No es independiente.
>
> **Y bajar la corriente NO lo arregla.** Para que el arranque durase 2 s harían
> falta ~2 A, y el motor ya consume 1,88 A solo para vencer su propio arrastre.
> No queda margen. El rotor es tan ligero que a cualquier corriente útil acelera
> más rápido de lo que el log puede ver. Es física, no ajustes.

> [!success] Decisión: no se repite. El ±14 % sobra de largo
> | | Inercia | Peso |
> |---|---|---|
> | Rotor | 1,56·10⁻⁴ kg·m² | **0,4 %** |
> | Vehículo, visto desde el motor | 3,85·10⁻² kg·m² | **99,6 %** |
>
> El vehículo pesa **247 veces** más que el rotor. Un ±14 % sobre el 0,4 % es un
> **±0,06 % sobre el total**. Refinarlo no cambia ningún resultado.
>
> **Lo que sí se hará**, con las ruedas montadas: el mismo ensayo con el quad
> sobre caballetes. La inercia total es 250 veces mayor, así que la deceleración
> dura minutos en vez de un segundo y el log de 15 Hz sobra. Ese es el número
> que el modelo usa de verdad.
>
> Si alguna vez hiciera falta `J` del rotor con precisión, el método es atornillar
> un disco de inercia conocida al eje y restar. No hace falta.

## Detección FOC del VESC — el histórico de dos tiradas

| Parámetro | 2026-07-29 | 2026-08-10 (config guardada) | Dispersión |
|---|---|---|---|
| Resistencia `R` | 27,90 mΩ | **28,80 mΩ** | 3 % |
| Inductancia media `L` | 106,49 µH | **105,25 µH** | 1 % |
| Saliencia `Lq−Ld` | 16,90 µH | **9,45 µH** | **79 %** |
| Flux linkage `λm` | 16,07 mWb | **16,016 mWb** | 0,3 % |
| Sensores | Hall | Hall | — |

Fuentes: `Screenshot 2026-07-29 152318.png` y `MOTOR_1.9.xml`.

**Se creía** que la saliencia era ruido irreproducible. **Falso**, ver la sección de
arriba: las tiradas usaban corrientes de detección distintas y la saliencia depende
de la corriente. Estas dos filas se conservan solo como registro histórico; los
valores vigentes son los de la tanda del 07-09.

## Flux linkage: **λm = 16,86 mWb, MEDIDO** — 2026-09-07

> [!success] Back-EMF en circuito abierto, independiente del VESC
> Motor desconectado del inversor, sonda entre fase A y fase B, arrastre con taladro.
>
> $$\lambda_m = \frac{A_1}{\sqrt{3}\cdot 2\pi f}$$
>
> **Datos crudos** (`06_data/2026-09-07_back-emf/raw/scope_txt/`), dos capturas a 1310 y 2510 rpm mecánicos:
> **16,826 y 16,883 mWb → coinciden al 0,17 %** con la velocidad duplicada.

### La amplitud se toma como RMS, no como pico de la FFT

El taladro no gira a velocidad constante: el periodo tiene una desviación del
**1-2 %** dentro de la ventana. Eso ensancha el pico del fundamental en la FFT y
hace que una amplitud leída del pico salga **baja**.

El estimador `A1 = √2 · RMS(banda del fundamental)` es inmune a ese ensanchamiento.

| Estimador | Dispersión entre las dos capturas |
|---|---|
| Pico de la FFT | 1,08 % |
| **RMS de la banda** | **0,17 %** |

Y el sesgo tiene el signo correcto: la captura con más jitter (1,97 %) era la que
daba el valor más bajo. Es la explicación completa, no una corrección a ojo.

### Historial: la tanda de pantallazos dio 16,51 mWb

Antes de exportar datos crudos se analizaron **43 pantallazos leyendo los píxeles**
(calibrando con las gridlines). Ajuste por el origen: `A1 = 0,17968·f`, R² = 0,9911,
ordenada a 1,3σ de cero, y `λm` plana en un rango de velocidad de 16:1.

Salió **16,51 mWb, un 2,0 % por debajo** del valor con datos crudos — mismo sesgo de
jitter, más 47 mV de resolución de píxel. Que coincidan al 2 % valida el método de
extracción por píxeles, pero **manda el dato crudo**.

Lección de método: el formato de exportación no es un detalle administrativo.
Un CSV bueno valió más que 43 imágenes.

### Tercera confirmación independiente: el vacío estacionario

Del mismo log de inercia, con el motor clavado en el techo de duty durante 443
muestras: 16.440 ERPM, `|v_dq|` = 28,886 V, `iq` = 1,883 A, batería 52,77 V.

$$\lambda_m = \frac{|v| - R\,i}{\omega_e} = 16{,}748\ \text{mWb}$$

El VESC informa de la tensión que **ordena**, no de la que aplica. El tiempo muerto
cuesta `t_d · f_sw · V_bus` = 0,12 µs × 30 kHz × 52,77 V = **0,19 V**. Devolviéndola:

$$\lambda_m = 16{,}858\ \text{mWb} \quad\text{frente a}\quad 16{,}855\ \text{mWb del osciloscopio}$$

**Un 0,02 % de diferencia.** Dos métodos que no comparten ni un supuesto.

Y explica el déficit de la detección: **esos mismos 0,19 V son una fracción mucho
mayor de la tensión, baja, que hay durante el ensayo de detección.** El error
absoluto es el mismo; el relativo no.

### El VESC se queda un 5,5 % corto, y en la dirección correcta

| Método | λm | vs osciloscopio |
|---|---|---|
| **Osciloscopio, datos crudos** | **16,855 mWb** | — |
| **Vacío estacionario + tiempo muerto** | **16,858 mWb** | **+0,02 %** |
| Vacío estacionario, sin corregir | 16,748 mWb | −0,6 % |
| Detección FOC (3 tiradas) | 15,919 mWb | **−5,5 %** |

Ese signo es el que predice la teoría. El VESC deduce `λ` a partir de la tensión
que **ordena**, no de la que realmente aplica: el tiempo muerto hace que la real sea
mayor. Y resta una `R` que ya viene inflada por la caída en los MOSFET. Los dos
errores empujan `λ` hacia abajo.

Tres métodos, ningún supuesto compartido, y la discrepancia que queda tiene una causa
física cuantificada. Eso ya no es una coincidencia: es `λm` cerrado.

**Consecuencia:** `Kt = 1,5·p·λm` = **0,0758 N·m/A** (antes 0,0721 con el dato del
VESC). El modelo usa 16,855 mWb para la planta; el observador del VESC sigue creyendo
15,92, y ese desajuste del 5,5 % es hardware, no modelo.

### Contenido armónico — y una comprobación de que la medida es buena

Proporción sobre el fundamental, **idéntica en las dos capturas**:

| Armónico | 5º | 7º | 11º | 13º | THD |
|---|---|---|---|---|---|
| % del fundamental | 4,0 | **8,1** | 2,0 | 1,4 | **9,4 %** |

> [!success] No hay 3º ni 9º, y eso tiene que ser así
> Los armónicos triples están **en fase en las tres fases**, así que se cancelan en
> cualquier tensión entre fases. Que no aparezcan no es suerte: es la física
> confirmando que la medida está bien tomada.

El modelo dq asume senoide, luego **no reproducirá el rizado de par** que generan el
5º y el 7º (que en el marco del rotor se ven como 6º orden). Irrelevante a nivel
vehículo; conviene recordarlo antes de culpar a otra cosa de un hueco de correlación.

Análisis reproducible en `04_model/scripts/backemf_extract.py` y `backemf_fit.py`.

## Convención: RESUELTO por código, ya no es una incógnita

> [!success] La `R` del VESC es **por fase**, no entre fases
> `mcpwm_foc_measure_resistance()` calcula `R = norm(v_dq) / norm(i_dq)` con el
> rotor bloqueado ([`mcpwm_foc.c:1869`](vesc/_firmware/motor/mcpwm_foc.c), muestreo en `:4144`).
> `v_dq` e `i_dq` son magnitudes **de fase** en el marco dq invariante en amplitud.
> Luego `foc_motor_r` es la resistencia por fase.
>
> **Verificación pendiente:** el multímetro entre dos fases debe leer ≈ 2·R = 57,6 mΩ.
> Ya no resuelve una duda; ahora es una comprobación de que el ensayo del VESC no miente.

Matiz importante: esa `R` incluye la resistencia de conducción de los MOSFET y el
efecto del tiempo muerto. Es una **cota superior** de la resistencia real del bobinado.

VESC usa exactamente las ecuaciones del bloque PMSM de Simulink
([`virtual_motor.c:305-345`](vesc/_firmware/motor/virtual_motor.c), el propio comentario del firmware cita a MathWorks):

$$v_d = R i_d + L_d \frac{di_d}{dt} - \omega_e L_q i_q$$
$$v_q = R i_q + L_q \frac{di_q}{dt} + \omega_e (L_d i_d + \lambda_m)$$
$$T_e = \tfrac{3}{2} p \,(\lambda_m + (L_d - L_q) i_d)\, i_q$$

Y el reparto de la inductancia ([`foc_math.c:782`](vesc/_firmware/motor/foc_math.c)):
`Lq = L + diff/2`, `Ld = L − diff/2` → **Ld = 100,53 µH, Lq = 109,98 µH**.

Los cuatro valores entran en el bloque de Simulink **sin reescalar**.

## Pares de polos: **p = 3, MEDIDO** — 2026-09-06

> [!success] Conteo de pulsos Hall, con la transmisión montada
> Una línea Hall da `p` ciclos por vuelta mecánica del motor. Una vuelta de la
> corona (92T) son 92/11 = 8,364 vueltas de motor, luego se esperan `8,364·p`
> destellos: **25,1 si p=3**, 33,5 si p=4.
>
> **Contados: 25, repetible.** → `p = 3`. Sin zona gris.
>
> Método: LED con resistencia de 1 kΩ entre +5 V y la señal Hall (salida en
> colector abierto: absorbe corriente, no la entrega). Giro de una vuelta de
> corona en ~30 s, tres repeticiones.

De propina, valida la **relación de transmisión 92/11**: con una relación
distinta el conteo no habría caído sobre ninguna fila válida de la tabla.

Y cierra la contradicción que tenía este documento: el par nominal de mercado
de ~4,0 N·m **no corresponde a este motor**. Con `p = 3` y el `Kt = 0,0758 N·m/A`
que sale de la λm medida, harían falta 53 A para 4 N·m, muy por encima de la citada
(34–40 A). La referencia MY1020/BM1109 queda descartada como fuente fiable,
justo como avisaba [baseline](baseline.md).

### Registro histórico del razonamiento

El VESC tenía `si_motor_poles = 6` (p = 3) **tecleado a mano**, no medido.

> [!important] Que el quad funcione bien no valida `p`
> `si_motor_poles` solo alimenta el display de RPM y la telemetría
> ([`commands.c:929`](vesc/_firmware/comm/commands.c), `canard_driver.c:517`).
> **No entra en la ley de control FOC**, que trabaja siempre en ángulo eléctrico.
> Se puede conducir años con `p` mal puesto y no notarlo.

La tabla anterior enfrentaba "la velocidad en vacío dice p=3" contra "el par dice p=4".
Eso estaba mal planteado: **las dos referencias salían del mismo motor no confirmado**
(MY1020/BM1109). No son dos evidencias en conflicto, son cero evidencias.

Consecuencia directa: `Kt = 1,5·p·λm` escala lineal con `p`. **Todo el eje de par del
modelo vale lo que valga esa medida.** Con p=3 y la λm medida, `Kt = 0,0758 N·m/A`
→ 3,03 N·m a 40 A. (Con la λm del VESC salía 0,0716; ese 5,5 % es hardware, no modelo.)

### Cómo medirlo

> [!success] Conteo de transiciones Hall — el método bueno
> Una vuelta eléctrica son **6 cambios de estado Hall**. Contar transiciones en una
> vuelta mecánica completa y dividir entre 6 da `p` directamente.
> Cuenta eventos discretos, no mide velocidad: no acumula error.

Alternativa ERPM: `ERPM = RPM_mec × p`. Marcar la rueda, girar despacio, leer ERPM en
VESC Tool y contar vueltas en vídeo. Más rápido, menos exacto.

## Pendiente de medir

- [x] **Pares de polos** = 3 (conteo Hall, 2026-09-06)
- [ ] R entre fases con multímetro, para contrastar con los ≈ 56,0 mΩ esperados (2·28,02)
- [x] **Back-EMF con osciloscopio** → `λm` = 16,86 mWb MEDIDO (2026-09-07)
      (16,51 fue la tanda de pantallazos, superada por el dato crudo)
- [x] **Inercia y fricción** → `J` = 1,558e-4 kg·m² (±14 %), 2026-09-07
- [x] **Detección FOC ×3** → la saliencia converge: 13,54 ± 0,26 µH
- [ ] Inercia **del vehículo** sobre caballetes, con ruedas: es la que usa el modelo
      (bajar `l_current_max` NO sirve para el rotor solo — ver la decisión de arriba)
- [ ] Radio de rodadura cargado, masa total, coastdown → ver `vehicle_params.m`
