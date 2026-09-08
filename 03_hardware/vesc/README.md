# VESC — configuración del equipo

Lo que hay aquí es **la configuración de mi inversor**, no la herramienta ni el
firmware. Es fuente de verdad de hardware: los `.m` de `04_model/params/` se
derivan de estos archivos.

| Archivo | Qué es |
|---|---|
| `MOTOR_1.9.xml` | `mcconf` — configuración de motor exportada desde VESC Tool (2026-08-10) |
| `MOTOR_1.9_app.xml` | `appconf` — configuración de aplicación (ADC del acelerador, CAN) |
| `screenshots/foc-detection_2026-07-29.png` | Detección FOC, primera tirada (a 97,85 A) |
| `screenshots/usb-serial-error_2026-08-10.png` | El corte de USB bajo carga. **No es una detección** |
| `reference/appconf_default.h` | Valores por defecto del firmware, autogenerados por VESC Tool |
| `reference/mcconf_default.h` | Ídem, lado motor |

Los dos `.h` son la referencia contra la que se lee un XML: dicen qué significa
cada campo y cuál es su valor de fábrica.

## Lo pesado está aquí, pero fuera de Git

Para no tener que buscar el VESC en dos sitios, el software de terceros vive en
esta misma carpeta — con `_` delante y en el `.gitignore`:

| Carpeta | Qué | Tamaño |
|---|---|---|
| `_firmware/` | Código fuente del firmware VESC (bldc, **FW 7.01**) | 219 MB |
| `_tool/` | `vesc_tool_6.06.exe`, el instalador | 166 MB |

La regla no cambia: **se versiona lo que escribo yo, no lo que descargo.** Es la
misma frontera que hay entre `.venv/` y mis scripts de Python.

`motor-parameters.md` cita el firmware por archivo y línea con enlaces a
`_firmware/`. En una máquina nueva hay que clonar ahí
[`vedderb/bldc`](https://github.com/vedderb/bldc) para que resuelvan; los números
de línea son de **FW 7.01**.

Los logs de ensayo del VESC Tool **no** están aquí: son datos, y van a
`06_data/<fecha>_<ensayo>/`.
