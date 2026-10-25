# DEC-003: Fuera Obsidian, el repo se lee en VS Code y GitHub

**Fecha:** 2026-10-25 · **Sustituye a:** [DEC-001](DEC-001-herramienta-de-organizacion.md)

## Decisión

Se elimina Obsidian del proyecto: carpeta `.obsidian/`, nota de instalación y los
enlaces `[[wikilink]]`, que pasan a enlaces Markdown normales.

## Por qué

- **No se usaba.** En dos ciclos no hubo ni una nota creada desde Obsidian. DEC-001
  asumía que el grafo y los backlinks ayudarían a navegar; la navegación real fue
  `01_plan/` desde el explorador de archivos y los artifacts en claude.ai.
- Los `[[wikilinks]]` y los callouts `[!todo]` no funcionan en GitHub, y el repo es
  público: es parte del portfolio. Lo que se ve en GitHub tiene que verse bien.

## Alternativas

Mantenerlo "por si acaso": descartado. Coste pequeño pero real (un formato que solo
entiende una herramienta) a cambio de cero uso.

## Consecuencias

- Los `.md` siguen siendo Markdown plano; DEC-001 tenía razón en que salir no cuesta nada.
- Quedan callouts `> [!...]` en algunos archivos: en GitHub se ven como cita normal.
  No se convierten en masa; se arreglan cuando se toque cada archivo.
