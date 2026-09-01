# Sesión: Simulink / gemelo digital

Contexto adicional para trabajar en `04_model/`. Se suma al `CLAUDE.md` raíz.

## Regla nº1 — Parámetros en `.m`, estructura en `.slx`

Git **no puede hacer diff de un `.slx`**: es un binario. Si metes los números dentro de
los bloques, pierdes el historial de por qué cambió el modelo.

Por tanto:
- Todos los parámetros viven en `params/*.m` como texto plano, con **unidades SI** y
  un comentario que diga si el valor es **MEDIDO** o **ASUMIDO**, y de dónde sale.
- Los bloques del `.slx` referencian variables, nunca números literales.
- Un cambio de calibración es entonces un diff legible en Git.

## Regla nº2 — Un parámetro asumido se declara

Si falta un dato de `03_hardware/baseline.md`, no lo estimes en silencio. Márcalo
`ASSUMED` en el `.m` y anótalo como pregunta abierta. Un modelo lleno de asunciones
ocultas produce resultados convincentes y falsos.

## Regla nº3 — El modelo no vale nada hasta que se correlaciona

Antes de usar el modelo para diseñar control, tiene que reproducir un ensayo real
medido (`06_data/`). Hasta entonces es una hipótesis, no una herramienta.

## Cómo enseñarme

Antes de un bloque, la física. Antes del modelo, la ecuación. Quiero saber qué
hipótesis mete cada simplificación y cuándo deja de valer. Si propones una estructura
de modelo, dime también qué **no** captura.

## Orden de construcción

1. Dinámica longitudinal del vehículo (masa, rueda, transmisión, rodadura, aero).
2. Máquina eléctrica en dq (PMSM).
3. Inversor + lazo de corriente.
4. FOC completo (Clarke, Park, control Id/Iq).
5. Estrategias de vehículo (tracción, launch).

No saltar niveles. Cada nivel se valida antes del siguiente.

## Estructura de la carpeta

```
params/     scripts .m con parámetros (texto, versionable)
models/     archivos .slx
scripts/    scripts de ensayo, comparación modelo-vs-datos, plots
results/    figuras y salidas de correlación
```

## Regla nº4 — El agente lee y simula; los bloques los pongo yo

El Simulink Agentic Toolkit expone tools de **escritura** sobre el `.slx` (crear y
conectar bloques, cambiar parámetros). No se usan salvo petición explícita mía en
esa misma conversación.

Motivo: el `.slx` es binario, así que un cambio hecho por el agente **no se puede
revisar en el diff**. Un modelo que yo no he construido es un modelo que no sé
defender delante de un mentor, y eso rompe el Objetivo 0.

Reparto:
- **Agente**: leer estructura del modelo, consultar parámetros, lanzar simulaciones,
  comparar contra `06_data/`, escribir y ejecutar `.m` de `params/` y `scripts/`,
  señalar qué no cuadra y por qué.
- **Yo**: colocar y conectar los bloques.
