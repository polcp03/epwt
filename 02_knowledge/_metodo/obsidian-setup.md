# Obsidian: instalación y uso en este proyecto

Obsidian es **el visor** del repositorio. No es una app aparte donde copiar cosas:
abre la carpeta que ya existe y muestra los mismos `.md` con una interfaz decente.

## Qué es (y qué no)

- **No tiene formato propio.** Trabaja sobre archivos `.md` normales, en tu disco.
- **No hay migración.** Apuntas Obsidian a `PROJECT_ePWT/` y ya está.
- **No hay segunda fuente de verdad.** Editas en Obsidian → cambia el archivo →
  Git lo ve. Editamos Claude y yo el mismo archivo → Obsidian lo ve. Es la misma cosa.
- **Es gratis** para uso personal y funciona sin conexión.
- **Se desinstala sin consecuencias.** Si no aporta, se borra la app y los archivos
  siguen exactamente igual.

## Instalación (5 minutos, una vez)

1. Descargar de **obsidian.md** e instalar (Windows, gratis).
2. Al abrirlo pide un vault. Pulsar **"Open folder as vault"**
   (*no* "Create new vault" — eso crearía una carpeta nueva y vacía).
3. Elegir `C:\Users\Pol Cruañas\Documents\PROJECT_ePWT`.
4. Confirmar que confías en el vault (pide permiso para plugins).
5. Abrir `START-HERE.md`. Ese es el panel.

Eso es todo. No hace falta ningún plugin para empezar.

## Cómo se usa para el trabajo diario

**Las casillas se marcan haciendo clic.** En `C01.md`, cada `- [ ]` se ve como una
casilla real. Al pulsarla, Obsidian escribe `- [x]` en el archivo. Eso significa que
**tu progreso queda en Git**, y que Claude ve exactamente por dónde vas sin que se lo
cuentes.

**Los `[[enlaces]]` son navegables.** `[[C01]]` lleva al archivo del ciclo. En el panel
de la izquierda, "Graph view" dibuja cómo se conectan las notas.

**Búsqueda:** `Ctrl+Shift+F` busca en todo el proyecto. `Ctrl+O` salta a cualquier nota
escribiendo su nombre.

**Modo de vista:** `Ctrl+E` alterna entre editar y leer. Para leer el plan, modo lectura.

## Plugins: por ahora, ninguno

Existe el plugin **Tasks**, que agrega todas las casillas del vault en un panel único
con consultas y fechas. Es bueno, y por eso mismo hay que decir esto claramente:

> Instalarlo ahora sería el error que ya identificamos. Configurar el sistema perfecto
> **se siente** como progreso, y el avance real es cero.

Criterio de entrada, como todo lo demás: **cuando tenga 3 ciclos cerrados** y las
casillas repartidas por varios archivos me molesten de verdad, entonces Tasks. Antes, no.
Con un solo ciclo activo, abrir `C01.md` y mirar ya funciona.

## Git y Obsidian conviviendo

Ya está configurado en `.gitignore`:

- `.obsidian/workspace.json` → **ignorado**. Guarda qué ventanas tienes abiertas y
  cambia constantemente. Sin ignorarlo, salen conflictos de merge sin parar.
  Es el error nº1 documentado de este montaje.
- El resto de `.obsidian/` → **sí se versiona**, para que la configuración viaje con
  el repositorio.

**Aviso:** no poner Obsidian Sync, OneDrive ni iCloud sobre esta carpeta mientras use
Git. Dos sistemas de sincronización sobre los mismos archivos se pelean y corrompen.
Git ya hace ese trabajo.

## Móvil

Obsidian tiene app de iOS. Para sincronizar sin pagar Obsidian Sync haría falta montar
Git en el móvil, que es más lío que valor ahora mismo. **Aplazado** — si quiero
consultar el plan desde el iPhone, GitHub en el navegador ya lo muestra bien.

## Cuándo revisar esta decisión

Si en dos ciclos no he abierto Obsidian ni una vez, se desinstala y tema cerrado.
Ver [[DEC-001-herramienta-de-organizacion]].
