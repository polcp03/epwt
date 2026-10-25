---
name: corregir
description: Correct Pol's answers to ePWT lessons and exams as a senior engineer would. Use when Pol says he has answered (en el artifact, en el examen, por voz), asks "corrígeme", "revisa mis respuestas", "¿cómo lo he hecho?", or at the start of any session in an active cycle with lesson artifacts (check their `answers` collection for uncorrected entries). Covers reading answers from the artifact database, the verdict format, debating instead of handing over the solution, and closing the loop into 02_knowledge/ (topic notes + errores.md with spaced re-asking).
---

# Corregir — the senior engineer's review of Pol's answers

The goal is that Pol can explain it in an interview in Israel, from first principles,
about **his** quad. Grade against that bar, not against "roughly right".

## 1. Find the answers

Lesson and exam artifacts keep answers in their database, collection `answers`, doc
`<lesson>-<q>` with fields `question`, `text`, `savedAt`, and `feedback` once corrected.
Artifact links are in the active cycle file (`01_plan/C0X.md`) and `START-HERE.md`.
`ArtifactData list` each one; correct every doc without `feedback`. Answers given in
chat or by voice: correct them in chat, same format.

Voice answers arrive as long transcripts that often answer several questions at once.
Split them by question before grading, and say so (see habit in rule 4).

## 2. Verdict per answer

Write `feedback` with ArtifactData `update` (pin `if_version`), in Spanish, short:

- First line: ✅ / ⚠️ / ❌ and the one thing that decides it.
- Then one line per point: ✅ what is right *and why it matters*, ❌ what is wrong,
  ⚠️ what is vague or missing.
- **Errors with high confidence get named plainly.** Do not soften a wrong physics claim.
- **Gaps get a guiding question, not the answer:** "calcula X con tu λm", "¿y en tu VESC?",
  "¿por qué no circulan 120 A?". He redoes it; the lesson's own solution is already
  one click away, so the feedback must add what the solution does not.

## 3. What a senior pushes on (checklist)

- Did he answer **the question asked**, or recite everything he knows?
- **"En general" vs "en mi quad"**: field weakening exists, but is it on in his VESC?
  Use his measured numbers (`04_model/params/*.m`, `03_hardware/baseline.md`).
- **A number**: can he put an order of magnitude on it? If a quick calculation exists,
  ask for it.
- **Physics statements**: Faraday, Lorentz, energy balance — one wrong word changes the law.
- **Evidence**: when the question says "justify with something you did", demand the
  measurement (date, method, value).
- Mixed concepts: thermal vs magnetic vs configured limits; phase vs battery current;
  duty vs frequency; electrical vs mechanical degrees.
- Say clearly what was **good**, with the reason. Pol asked for criticism, not for
  pessimism.

## 4. Close the loop — mandatory

1. **`02_knowledge/<tema>.md`**: copy what he said well, in *his* words, trimmed and
   corrected. Not textbook prose. One section per idea.
2. **`02_knowledge/errores.md`**: one row per error: date, topic, what he said, the correct
   version (one line), when to re-ask, status 🔴. Habits (answering too much, no units)
   count as errors.
3. Re-asking: at the start of every exam and in the Saturday exercise, ask the open 🔴/🟡
   rows **without showing the correct column**. Right once → 🟡, right again on another
   day → 🟢.
4. Tell Pol in chat, in ≤6 lines: score (✅/⚠️/❌ count), the single most important
   correction, and the one question he must redo.
5. Commit the knowledge files on the current branch (`Record corrections for L1`).

## Do not

- Do not rewrite or republish the lesson to "fix" his misunderstanding. Correct the
  person, not the material — unless the material itself is wrong; then say so first.
- Do not grade an answer he has not given. No attempt → ask for one (cerebro primero).
