# DEC-001: Herramienta de organización personal

> **Sustituida por [DEC-003](DEC-003-fuera-obsidian.md) (2026-10-25).** Obsidian no se llegó a usar.

**Fecha:** 2026-09-01

## Decisión

**Obsidian, apuntado directamente a la carpeta del repositorio.** Sin Notion. Sin Tana.
Sin migración de contenido. Sin segunda fuente de verdad.

## Contexto

El repositorio ya es un conjunto de archivos Markdown planos. Obsidian **no tiene
formato propio**: abre una carpeta de `.md` y ya está. Eso significa que apuntarlo a
`PROJECT_ePWT/` cuesta literalmente 30 segundos y cero migración.

Lo que gano: vista de grafo, backlinks entre notas, búsqueda rápida, editor cómodo,
app móvil. Lo que **no** pierdo: los archivos siguen siendo los mismos, Git los sigue
versionando, y yo los sigo leyendo y escribiendo sin ninguna capa intermedia.

## Alternativas consideradas

**Notion.** Descartada. Guarda el contenido en su base de datos, no en archivos. Eso
crea una segunda fuente de verdad que se desincroniza del repo, y saca el conocimiento
del sitio donde vive el trabajo. Además, su estructura (bases de datos, relaciones,
plantillas) hay que diseñarla y mantenerla, y solo sigue siendo útil mientras alguien
la cuida — es trabajo permanente, no una herramienta que trabaja para ti.

**Tana.** Descartada, y es la más tentadora porque es la más moderna. Razones: es
web-only sin buen soporte offline, es cara, su móvil está verde, y el modelo de
"supertags" exige cambiar la forma de pensar la información. Aprender Tana sería un
proyecto en sí mismo. No es el proyecto que quiero hacer.

**Nada / solo el repo.** Viable, y es lo que hay hoy. Obsidian solo añade una capa de
lectura encima; si no aporta, se desinstala y no se pierde nada. Esa reversibilidad
total es la razón principal para probarlo.

## Razonamiento

El criterio es: **una sola fuente de verdad, y el resto son visores.** Obsidian cumple
porque no es dueño de los datos. Notion y Tana no cumplen porque sí lo son.

Hay un segundo criterio, más importante para mí en concreto. Mi patrón documentado es
buscar el sistema perfecto en vez de ejecutar. Explorar apps de productividad es
**procrastinación disfrazada de progreso**: se siente productivo y el avance real es
cero. Ese riesgo, en mi caso, es mayor que el beneficio de cualquier herramienta.

Obsidian sobre la carpeta que ya existe es la opción con más beneficio y menos
superficie de distracción: no hay nada que configurar, nada que migrar, nada que decidir.

## Consecuencias

- Añadir a `.gitignore`: `.obsidian/workspace.json` y `.obsidian/workspace-mobile.json`.
  Guardan la disposición de ventanas y cambian a cada rato; sin ignorarlos, salen
  conflictos de merge constantes. Es el error nº1 documentado de este montaje.
- El resto de `.obsidian/` (configuración, plugins) **sí** se versiona: así la
  configuración viaja con el repo.
- No usar Obsidian Sync ni iCloud/OneDrive sobre la carpeta a la vez que Git.
  Dos sistemas de sincronización sobre los mismos archivos se pelean.
- El second brain personal (universidad, Formula Student, calibración) sigue siendo un
  proyecto aparte, en otra carpeta. Ver `01_plan/backlog.md`.

## Revisión

Si en dos ciclos no he abierto Obsidian ni una vez, se desinstala y se cierra el tema.
