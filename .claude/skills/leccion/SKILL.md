---
name: leccion
description: Build or revise an ePWT lesson or exam artifact (the C0X lessons in 01_plan/C0X/*.html, published as claude.ai artifacts). Use when Pol asks for a lesson, a class, a lección, an exam, an exercise for Saturday, or to improve the visuals of one. Covers when to build (only the next one), the ~55-minute format with hidden-solution answer boxes, the realistic 3D model of HIS motor, sourcing from BOOKS/ with page citations, and what must be agreed with Pol first.
---

# Lección — building one ePWT lesson

Lessons are a means. The end is Pol explaining it from first principles. The C02
history is the warning: lessons rebuilt three times in five days, and Pol still on L1
when the plan said L3. **Less material, more of his own output.**

## Before building

1. **Only the next lesson.** Build for tomorrow, not for the whole cycle. Future lessons
   exist as one line in the cycle file.
2. **Agree the six ideas with Pol** (titles only) before writing HTML. Wait for his OK.
3. **Source first.** Find the section in `BOOKS/` (index: `02_knowledge/fuentes.md`).
   Every idea cites book, section and page. Read the pages; never cite from memory.
4. **Check `02_knowledge/errores.md`.** Open errors on this topic become the spaced-
   repetition questions of the lesson.

## Format (≈ 55 min, from C02)

predice (5 min, 2–3 questions) → núcleo (6 ideas, each with its drawing and one
question) → laboratorio (max 2 interactives: change a parameter, predict, see) →
criterio (one "you are in this situation, what do you do?" + one "find the error") →
cierre (explain aloud + "what I still do not get").

- Every question uses the answer box: `<div class="qa" data-q="id">` with the solution
  in `<template class="sol">`, revealed only after saving. Answers go to the artifact
  db `answers/<lesson>-<q>` for the `corregir` skill. Copy the mechanism from
  `01_plan/C02/L1-bateria-a-par.html`.
- Questions force reasoning from his numbers (p = 3, λm = 16.855 mWb, Rs = 28 mΩ,
  Ld/Lq = 99/113 µH, 52 V bus, 120 A / 40 A limits, i = 8.364, 110 kg). Values from
  `04_model/params/*.m`, never typed from memory.
- Long reference material goes in a collapsed annex, not the main path.
- Desk study on a PC: long interactives are fine; do not optimise for mobile.

## Visuals — his motor, not a generic one

Pol builds mental maps from geometry, not text. Every motor visual is **his** machine:

- Radial flux, **inner rotor**, **outer slotted stator** with laminations visible,
  windings coloured by phase (U/V/W consistent across all lessons), **6 magnets
  (p = 3)**, shaft, Hall sensors at the stator.
- Rotor magnet arrangement and slot count are **MISSING** in `03_hardware/baseline.md`.
  Until measured: draw surface-like magnets, label the slot count "ilustrativo", and
  never present either as his real geometry.
- 3D with three.js (r128 from cdnjs + OrbitControls), real materials (steel, copper,
  magnet), cut-away so the inside is visible, labelled parts. Reuse one motor scene
  across lessons rather than drawing a new abstraction each time.
- 2D schematics (inverter leg, circuits) as inline SVG with the lesson's colour tokens.
- Load the `artifact-design` skill before writing the page.

## Publish

Source HTML in `01_plan/C0X/`, published as an artifact; link it in the cycle file and
in the day table of `START-HERE.md`. Commit the source.
