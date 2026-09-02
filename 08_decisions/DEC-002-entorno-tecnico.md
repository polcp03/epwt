# DEC-002: Entorno técnico

**Fecha:** 2026-09-01. Todo verificado ejecutándolo, no asumido.

| Herramienta | Versión | Cómo se usa |
|---|---|---|
| MATLAB / Simulink | R2023b | MCP conectado + `matlab -batch` (~25 s) |
| Python | 3.14.6 en `.venv/` | numpy, pandas, matplotlib, scipy, control |
| arduino-cli | 1.5.1 + esp32 3.3.11 | Compila limpio |
| git / gh | 2.54 / 2.97 | PRs desde terminal |

**Probado de extremo a extremo:** CSV → pandas → filtro scipy → gráfica PNG inspeccionable.

## Toolboxes: están las 40

Incluidas **Motor Control Blockset**, Simscape Electrical, Vehicle Dynamics Blockset,
Powertrain Blockset, **MPC Toolbox**, Embedded Coder, System Identification.

> [!danger] La trampa
> Motor Control Blockset trae **FOC para PMSM ya hecho**. Arrastrar ese bloque da un
> quad que funciona y un ingeniero que no ha aprendido nada.
>
> **Regla:** primero lo construyo desde las ecuaciones, después lo comparo con la
> referencia. La diferencia entre mi versión y la suya es el aprendizaje.

Consecuencia buena: MPC deja de ser inalcanzable. Sigue necesitando el modelo validado
de C06, así que la secuencia no cambia — pero pasa a ser objetivo real a ~6 meses.

## MCP de MATLAB

Binario oficial de MathWorks (`github.com/matlab/matlab-mcp-server`) v0.12.0, en `_tools/`.
No necesita Python — importante, porque MATLAB Engine for Python en R2023b solo soporta
Python 3.9/3.10/3.11 y aquí hay 3.14.

**Requiere MATLAB abierto**: se engancha a una sesión existente, no la arranca.
