# Tracer

**v1.0.0 · 2026-07-30 · The ops briefing: Carbon-dark, trace flows, verdict first.**

A sibling to the Dexter Design System for AI-generated engineering HTML that
reads like a mission-control incident briefing — IBM Carbon's dark palette on
a blueprint grid, uppercase display headings, a filled verdict banner, and
the signature: native SVG trace diagrams whose dashed edges animate along
the routes they describe.

| Resource | Location |
|---|---|
| Living style guide (view this) | <https://dexteryo.github.io/design-systems/tracer/> |
| Canonical stylesheet | [`tracer.css`](tracer.css) |
| This spec (agent-facing) | `README.md` (this file) |
| Mermaid pre-render config (static SVG, dark) | [`mermaid-config.json`](mermaid-config.json) |
| Local source of truth | `~/dotfiles/dexteryo.github.io/design-systems/tracer/` |

**If you are an AI agent generating HTML output for Dexter in the Tracer
style: this file is your contract.** Read `tracer.css` for exact values; this
file tells you which pieces to use and the rules you must not break.

---

## 1. The system in one paragraph

Tracer is the briefing you hand someone at 23:00 when the release is blocked:
verdict first, evidence hop by hop, one diagram that shows where the signal
dies. Near-black Carbon ground (`#161616`) under a fixed blueprint grid that
fades down the page; IBM Plex voice (locally installed, system fallback);
uppercase 700-weight display headings with one accent-toned key phrase; a
filled mono verdict banner; a bordered stat strip of headline numbers; numbered
sections (`00 /`); severity pills in evidence tables; dark terminal code blocks
in both themes. The signature element is the trace diagram: hand-authored SVG
boxes in columns with stage labels, connected by dashed edges that march in the
direction of data flow — each edge colour is a declared route meaning, and
every diagram carries a legend. Unlike Nocturne (calm product UI), Tracer is
operational and forensic: several semantic hues may appear on one page because
each one is a route or a state, never decoration.

## 2. Hard rules (never break these)

1. **Tokens only.** Every colour, font, space, and radius comes from a
   `--trc-*` custom property. Never hard-code a hex value in a component.
   Sanctioned literals: the dark code-block ground (`#0d0d0d`) and the two
   ambient gradients (grid mask, diagram halo) defined in the stylesheet.
2. **No external assets.** IBM Plex is preferred but must come from the local
   machine (`"IBM Plex Sans", …system stack` — the stacks in `tracer.css`).
   Never load webfonts from a CDN; no `@font-face`, no external requests.
   JavaScript inlined and progressive enhancement only — the page must read
   fully if scripts never run (the reveal effect keys off a root `.trc-js`
   class added by script for exactly this reason).
3. **Self-contained output.** For a standalone file or artifact, inline
   `tracer.css` into a `<style>` block — all token blocks (dark default,
   `@media` light, both `data-theme` overrides). Link the stylesheet only for
   pages hosted next to it.
4. **Both themes, dark first.** Dark is the identity and the default token
   block; light is the counterpart. Flip tokens, never restyle components in
   media queries. Code blocks stay dark in both themes.
5. **Verdict before evidence.** The hero states the conclusion: kicker →
   uppercase title with one `.trc-lo` accent phrase → stand-first → filled
   `.trc-verdict` banner → `.trc-meta` stat strip. A reader who stops after
   the hero knows the answer.
6. **Colour is meaning.** Accent blue points (links, kickers, section labels,
   the nominal route). Red = failing/lost, green = proven/clean,
   yellow = degraded/attention, teal = secondary/derived route,
   purple = async/out-of-band. A hue that doesn't carry its meaning is a
   defect; never use one for decoration.
7. **Diagrams are native SVG with a legend.** Trace diagrams are hand-authored
   `<svg>` inside `.trc-diagram`, using the box/text/edge classes from the
   stylesheet. Every edge colour used must appear in the `.trc-legend`; a
   `.trc-figcap` provenance line (source + date) closes the figure. Never
   ASCII art, never raster screenshots.
8. **Motion is directional, not decorative.** The only animations are the
   `.trc-flow` marching-dash edges (they point in the direction of flow) and
   the scroll reveal. Both are disabled under `prefers-reduced-motion`. No
   other animation.
9. **Machine truth is mono.** Metrics, timestamps, IDs, queue depths, response
   codes, and evidence are `--trc-mono`; numbers get `.trc-num` tabular
   numerals, right-aligned in table columns.
10. **Evidence is traceable.** Every claim in an evidence table cites its
    source (log stream + timestamp, `file:line`, queue name) in mono, and
    carries a `.trc-sev` verdict pill (`hi`/`med`/`low`).
11. **No AI attribution** in the output. No emoji section markers.
12. **Structure must be true.** Numbered sections only when order matters;
    a verdict banner only when there is a verdict; severity pills only when
    severity was actually assessed.

## 3. Choosing a mode

| Output | Mode |
|---|---|
| Incident analysis, root-cause proof, investigation, post-mortem | **Briefing** (flagship) — full hero, numbered sections, trace diagram, evidence table |
| Status board, ownership matrix, run-book summary | **Board** — hero compressed to title + verdict + `.trc-meta`, then cards/tables/kv rows |

Tracer's flagship is the briefing. If the content argues a conclusion from
evidence, use the full recipe; if it only reports state, compress the hero
and lead with the stat strip and cards.

## 4. Briefing recipe

```html
<body class="trc">
<div class="trc-topbar"><div class="trc-topbar-inner">
  <a href="#summary">Verdict</a><a href="#arch">Trace</a><a href="#detail">Evidence</a><a href="#next">Next steps</a>
</div></div>

<header class="trc-hero"><div class="trc-wrap">
  <div class="trc-kicker"><span class="trc-kicker-bar"></span>INCIDENT ANALYSIS · STAGING · TICKET-123</div>
  <h1>Declined shows successful<br><span class="trc-lo">the decline never becomes an event</span></h1>
  <p class="trc-sub">Stand-first: what broke, what was traced, what the verdict is — three sentences.</p>
  <div class="trc-verdict bad">APP-SIDE — EVENT EMISSION GAP</div>
  <div class="trc-meta">
    <div class="trc-cell"><div class="trc-lab">Decline events emitted</div>
      <div class="trc-val bad">0<small>whole day, both txns</small></div></div>
    <div class="trc-cell"><div class="trc-lab">Pipeline defects</div>
      <div class="trc-val ok">0<small>SQS 0 · DLQ 0</small></div></div>
  </div>
</div></header>

<section id="summary"><div class="trc-wrap trc-rv">
  <div class="trc-seclabel"><span class="trc-n">00 /</span> Executive verdict</div>
  <h2>One-line conclusion as a heading</h2>
  <p class="trc-lead">The finding, self-contained. <code>Identifiers</code> in mono,
     tickets as a <span class="trc-chip">CHIP-123</span>.</p>
  <div class="trc-grid g3">
    <div class="trc-card"><span class="trc-corner">CLEAN</span><h3 class="ok">What's proven fine</h3><p>…</p></div>
    <div class="trc-card"><span class="trc-corner">GAP</span><h3 class="bad">Where it dies</h3><p>…</p></div>
    <div class="trc-card"><span class="trc-corner">CONTROL</span><h3 class="alt">The control case</h3><p>…</p></div>
  </div>
</div></section>

<!-- trace diagram: see §6 · evidence table: .trc-tbl with .trc-sev pills -->

<section id="next"><div class="trc-wrap trc-rv">
  <div class="trc-seclabel"><span class="trc-n">04 /</span> Ownership &amp; next steps</div>
  <div class="trc-callout bad"><div class="trc-t">Root gap — service name</div>
    <p>The one fix that matters, stated as an instruction.</p></div>
</div></section>

<div class="trc-wrap"><div class="trc-foot">
  <strong>Title</strong> — TICKET-123 · <span class="trc-mono">env · 2026-07-30</span><br/>
  Verdict restated in one line.
</div></div>

<script>
  document.documentElement.classList.add('trc-js');
  const o = new IntersectionObserver((es) => { es.forEach((e, i) => {
    if (e.isIntersecting) { setTimeout(() => e.target.classList.add('in'), i * 55); o.unobserve(e.target); }
  }); }, { threshold: 0.12 });
  document.querySelectorAll('.trc-rv').forEach((el) => o.observe(el));
</script>
</body>
```

Voice: complete sentences; the stand-first and every `.trc-lead` must be
readable in isolation. Section labels count from `00 /` (the verdict is
section zero). Verdict banner variants: default accent = finding,
`ok` = cleared, `warn` = degraded/undetermined, `bad` = defect confirmed.

## 5. Evidence tables

Wrap tables in `.trc-tbl`. Columns for a hop-by-hop trace: Hop · Source ·
Observed · Verdict. The Source cell is mono (log stream, queue name,
`file:line`); the Verdict cell is a `.trc-sev` pill: `hi` (the gap),
`med` (works-as-designed but contributing), `low` (clean/verified). Code
evidence goes in `pre` blocks with the four token classes: `.c` comment,
`.k` keyword, `.s` string, `.r` alarm — highlight sparingly, the alarm class
marks the exact failing line only.

## 6. Trace diagrams (the signature)

Hand-authored SVG inside `.trc-diagram`, followed by `.trc-legend` and
`.trc-figcap`. Grammar:

- **Layout:** left-to-right columns = stages of the system; `.trc-stage`
  uppercase labels across the top; `viewBox` sized to content
  (≈ `0 0 1120 H`), `width="100%"`.
- **Nodes:** `<rect class="trc-box" rx="9">` + up to three text lines:
  `.trc-nlabel` (name), `.trc-nsub` (mono detail), `.trc-ntag` (mono
  emphasis). Box variants: `src` (accent border, entry/source), `bad` (red
  border, where it fails), `ok` (green-tinted, proven clean). Label/tag
  variants `ok`/`bad` recolour the text.
- **Edges:** `<path class="trc-edge trc-flow main|fail|ctrl|alt|async">` with
  a matching `marker-end`. Define one `<marker class="trc-m-<route>">` per
  route used. Route meanings are fixed:
  `main` = nominal path · `fail` = the failing/lost signal ·
  `ctrl` = the proven control path · `alt` = secondary/derived read path ·
  `async` = out-of-band. The `fail` edge terminates at the box where the
  signal dies — visibly short of the next stage.
- **Legend:** one `.trc-legend span` per route used, `<i class="<route>">`
  swatch + a phrase stating what that route *means in this diagram*.
- **Caption:** `.trc-figcap` with source of truth and revision date.
- **Motion:** `.trc-flow` dashes march along each edge; reduced-motion turns
  them into plain dashed lines. Accessibility: `role="img"` +
  `aria-label` describing the flow and where it breaks.

For diagram types that don't fit the trace grammar (sequence, state, ER,
gantt), pre-render Mermaid to static SVG with `mermaid-config.json`
(`npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg --configFile
mermaid-config.json --backgroundColor transparent`), pin the figure to the
dark ground (`background:#161616` on its `.trc-diagram`), and keep the DSL in
a `<details>` beside it.

## 7. Anti-patterns

- **Rainbow abuse.** Five hues are available; a page that uses one it can't
  justify semantically has failed rule 6. Most briefings need three.
- **Decorative animation.** Nothing pulses, glows, or bounces. If a dash
  animation doesn't communicate flow direction, remove it.
- **Verdict-free heroes.** A Tracer page without a conclusion in the hero is
  the wrong system — use Nocturne or DDS for neutral documentation.
- **Screenshot diagrams, ASCII art, Mermaid where the trace grammar fits.**
- **CDN fonts** (the original inspiration loaded Google Fonts — Tracer does
  not), gradient text, glassmorphism beyond the topbar's backdrop blur,
  drop shadows, emoji, off-token colours.
- **Content hidden without JS** — the reveal effect must stay keyed to
  `.trc-js`.

## 8. Changing the system

The system is versioned (`v1.0.0`, header of `tracer.css`). Change tokens or
components only in this directory; bump the version and revision date in
`tracer.css`, `index.html`, and this file together. A component that is not
demonstrated on the style guide page is not in the system. Downstream copies
(inlined styles in old documents) are snapshots; they do not get retrofitted.

## Lineage

IBM Carbon Design System (palette, Plex voice, grid discipline) · NASA/ops
mission-control briefings (verdict-first structure) · network-diagram
marching-ants convention (animated flows) · sibling to Nocturne (dark
restraint) and the Dexter Design System (token discipline, evidence-first).
