---
name: review-deck
description: Build, revise or audit a mentor-review slide deck for ePWT (the C0x kickoff/review presentations in 01_plan/presentations/). Use when Pol asks for a deck, slides, a presentation, a review deck, or asks to check/fix an existing one before presenting. Covers the editorial rules learned from the C00 feedback round, the mandatory number audit against the repo, and the build/verify loop.
---

# Review decks for ePWT

A deck is built by running Python that emits a `.pptx`, never by hand. The
mechanics — palette, five layouts, primitives, rebuild commands — live in
[`01_plan/presentations/README.md`](../../../01_plan/presentations/README.md).
**Read that file before touching anything.** This skill is the part the README
does not carry: what goes on a slide, and what has to be true before it does.

## The audience decides the content

Two mentors, both combustion-engine engineers. They **cannot** validate FOC,
dq-frame machines or power electronics, and the deck says so out loud. What they
*can* attack is engineering reasoning: method choice, whether a number is
defensible, whether an explanation holds together.

So the deck's job is to hand them things they can bite. A slide that only says
"look what I built" wastes them.

## Editorial rules

These come from Pol's line-by-line review of C00 v5 on 2026-09-08. They are
preferences with reasons, not style points.

**No motivational slides.** The v5 slide headlined "Objective zero: become a
better engineer" was cut on sight. Purpose statements, mission framing and
learning goals do not go on slides — they show through the engineering or they
do not exist. The *substance* that was on that slide (what transfers from
combustion calibration and what does not) survived, because it tells the
audience which half they are qualified to attack. Keep the substance, kill the
banner.

**A decision explained in prose is a decision not yet explained.** The gear-ratio
slide was a paragraph; Pol asked for formulas. Four lines beat a paragraph:
what it is, what it buys, the ceiling that makes more pointless, what it costs.
Add a comparison column (before / after) and the argument makes itself. This is
the single strongest pattern in the deck — reach for it whenever a slide is
about a choice.

**Cut any slide that does not carry new information.** "Three things found by
reading" went because its content already lived on the limits slide. Redundancy
reads as padding, and padding is what a 45-minute review cannot afford.

**Three columns of prose is not a visual slide.** The pattern that works:
coloured header bar → **one bold claim, one sentence** → the scope as chips.
Everything the grey paragraph used to say is either in the claim or is not
worth saying.

**Charts: one unit on an axis. Never two.** The rad/s primary plus rpm secondary
came off. Pick the unit the audience thinks in — rpm, km/h, N·m — and stay there.

**No text floating in a plot.** Every label attaches to what it labels, with an
arrow if it is not adjacent. If a label needs to sit in the middle of the data,
the layout is wrong.

**Always show the horizon past the committed plan.** The timeline stopped at C06
and Pol wanted 2027 on it: traction control, launch control, MPC. Mentors invest
in a trajectory, not a fortnight. Keep it to three words each — it is direction,
not plan, and `01_plan/roadmap.md` is where it comes from.

**One paragraph per slide, maximum, and only at the bottom as a band.** If a
slide needs a paragraph to be understood, the paragraph is the problem.

## The number audit — do not skip this

Every number on a slide must resolve to `03_hardware/`, `04_model/params/`,
`06_data/` or `03_hardware/vesc/*.xml`. Before any deck is presented, grep the
repo for each figure on it.

This is not paranoia. The C00 audit caught two live defects hours before the
meeting:

- A headline finding ("every logged speed is 28 % too high") that contradicted
  the config export it cited — and three notes in the repo disagreeing with each
  other about the same field.
- A "top speed ≈ 41 km/h" that existed nowhere but in the deck source.

Both would have been asked about. The checks that find this class of problem:

1. `grep` each number across the repo. **A number that appears only in the deck
   is a fabricated number** until proven otherwise.
2. When a slide cites a config field, open the XML and read the field. Notes go
   stale; the export does not.
3. Every value carries its tag — MEASURED / VESC_ESTIMATE / CONFIG / ASSUMED /
   MISSING. If a slide shows an assumed number, **the slide says ASSUMED on it**
   (see the grip line in `_figures.gearing()`). Never silently promote an
   assumption to a fact to make a slide land better.
4. Derived figures get recomputed in the figure code from the constants at the
   top of `_figures.py`, not typed in. Then they cannot drift.

## Physics review of every figure

`_check.py` catches text overflow. It cannot catch a curve that is wrong.

The C00 envelope drew the battery constant-power hyperbola all the way to the
measured no-load speed — a region the machine cannot reach, because at that
speed the back-EMF alone consumes the whole bus. Nobody would have caught it
from the render. Ask of every plot: *what limit closes this curve, and did I
draw it?*

**Never show a raw instrument capture when a processed comparison makes the same
point.** A raw scope trace carries every artefact of the measurement, and the
first question from the room will be about the weirdest-looking feature on it —
which is almost never the point of the slide. The C00 back-EMF capture drew the
question "why are the peaks spiky?", costing a detour into winding harmonics.

The fix is to plot **the measurement against the model fit** — measured trace
overlaid on the extracted fundamental — and to state the difference in the
caption as a known, quantified quantity rather than leaving it to be discovered.
For that back-EMF slide: 7th harmonic at 8.1 % of fundamental, 5th at 4.5 %,
spatial harmonics of a concentrated winding, which is exactly why lambda_m is
extracted from the fundamental and not from the peak. Anticipating the question
in the caption turns a weakness into evidence of rigour.

## Build and verify loop

```bash
./.venv/Scripts/python.exe 01_plan/presentations/_figures.py
./.venv/Scripts/python.exe 01_plan/presentations/C0X_kickoff.py
./.venv/Scripts/python.exe 01_plan/presentations/_check.py
powershell -File 01_plan/presentations/_render.ps1 01_plan/presentations/C0X-kickoff.pptx _renders
powershell -File 01_plan/presentations/_pdf.ps1 01_plan/presentations/C0X-kickoff.pptx
```

`_check.py` must print OK before rendering. Then **look at the renders** — read
the PNGs back, do not assume. The checker finds spills; the eye finds arrows
pointing at nothing, colliding diagram lines and bad photo crops.

The PDF is the transport format. It is what gets presented, from Drive, in a
browser. Do not present the `.pptx` from a converted Google Slides copy without
re-checking the text-heavy slides first — Slides re-flows with its own metrics.

## Working with Pol on a deck

- **Give the verdict first, then the findings, ranked.** Short answers; he
  saturates on long text. Conclusion, then numbered points.
- **Disagree when there is a reason to.** He cut the "objective zero" slide and
  he was right about the banner; keeping its two columns was worth arguing for,
  and he took the argument. Say which part of a cut you would keep and why.
- Editing the deck is bookkeeping, not thinking — the deck itself says the AI
  takes notes, plots, traceability and formatting, never the reasoning. Building
  slides for him is in scope. Deciding what the engineering argument *is* is not:
  surface the options and let him pick.
- Flag every change made that he did not ask for, explicitly, in the summary.

## Rehearsal

The cycle ritual (`01_plan/roadmap.md`) says a cycle is not finished until he can
explain it out loud without notes. When asked to examine: pick the slide with the
weakest sourcing, ask why that method and not another, and ask what would have to
be true for the number to be wrong. Do not accept an answer that restates the
slide.
