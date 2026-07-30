# Basel

**v1.0.0 · 2026-07-30 · The grid is the argument.**

A design system for AI-generated engineering HTML in the Swiss International
Typographic Style: Müller-Brockmann / Ruder rationalism. Type is the only
ornament, one red is the only colour, and everything is ruthlessly flush-left.

| Resource | Location |
|---|---|
| Living style guide (view this) | <https://dexteryo.github.io/design-systems/basel/> |
| Canonical stylesheet | [`basel.css`](basel.css) |
| This spec (agent-facing) | `README.md` (this file) |
| Mermaid pre-render config | [`mermaid-config.json`](mermaid-config.json) |
| Local source of truth | `~/dotfiles/dexteryo.github.io/design-systems/basel/` |

**If you are an AI agent generating Basel-styled HTML for Dexter: this file
is your contract.** Read `basel.css` for exact values; this file tells you
which pieces to use and the rules you must not break.

---

## 1. The system in one paragraph

Basel sets engineering reports the way Müller-Brockmann set concert posters:
a visible, load-bearing grid; huge tight bold headlines; small bold section
titles beside oversized ghost numerals; a 2px black bar opening every
section; evidence as flush-right monospace source lines under the claim they
support. There is one family (Helvetica), one red (Pantone 186), no italics,
no curves, no shadows. Dashboards are printed tables: cells share 1px black
rules, values are enormous, status is a hard square. The verdict is the
system's single inversion — a black slab with a red label — and because
nothing else inverts, it cannot be missed.

## 2. Hard rules (never break these)

1. **Tokens only.** Every colour, font, space comes from a `--bsl-*` custom
   property. Never hard-code a hex value in a component.
2. **System font stacks only, nothing from a CDN.** No webfonts, no
   `@font-face`, no external requests. Scripts must be inlined/same-origin
   and progressive enhancement — the document must read if they never run.
3. **Self-contained output.** For a standalone file or artifact, inline
   `basel.css` into a `<style>` block (all three token blocks). Link the
   stylesheet only for pages hosted next to it.
4. **Both themes.** Light is default; dark comes from the `@media` block and
   the `data-theme` overrides. Never restyle components per theme — tokens
   flip.
5. **Basel has one red: it is both the signal and the alarm, and it is
   never decoration.** `--bsl-accent` = `--bsl-crit` by design. Red marks
   the key emphasis, the critical state, the pull-quote bar, the verdict
   label — at most one red emphasis per document beyond the semantics.
6. **No italics. Anywhere.** Hierarchy is SIZE and WEIGHT only. The
   stylesheet forces `em`/`i`/`cite` upright and bold; do not fight it.
7. **Flush-left everything.** No centred text, ever. The only sanctioned
   right alignment is machine truth: evidence lines, digit columns, kv
   values, panel meta.
8. **Radius 0 everywhere, no shadows ever.** Rules carry all structure:
   2px structural bars, 1px shared grid rules, hairlines.
9. **Stay on the spacing scale.** 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64
   (`--bsl-s1…s8`). Off-scale spacing is a defect.
10. **Numbers are tabular.** Any column of digits gets `.bsl-num`,
    right-aligned in tables.
11. **Evidence is a visual element.** Claims cite their source (`file:line`,
    ticket, date verified) as `.bsl-evidence` lines — flush-right monospace,
    `→`-prefixed, directly under the claim paragraph. Panel mode uses the
    `.bsl-reg-meta` column.
12. **The verdict slab is the one inversion — own it.** A black-filled
    block with white text and a red uppercase `data-label`. Use it only
    when there is a verdict; a second inversion on a page is a defect.
13. **No AI attribution** in the output.
14. **Structure must be true.** Ghost numerals only when order matters;
    chips only when state exists; red only when something is signalled.

## 3. Choosing a mode

| Output | Mode | Body class |
|---|---|---|
| Investigation, design doc, post-mortem, RFC, wiki export | **Document** | `bsl-doc` |
| Dashboard, risk register, status page, run-book summary | **Panel** | `bsl-panels` |
| Mixed (report with an embedded dashboard section) | Document base; wrap panel sections in a `bsl-panels` container |

## 4. Document mode recipe

```html
<body class="bsl-doc">
<div class="bsl-page">
  <div class="bsl-eyebrow">Doc type · Project · Context</div>
  <header class="bsl-masthead">
    <div>
      <h1 class="bsl-title">Headline with <em>one red</em> key word</h1>
      <p class="bsl-subtitle">Stand-first: the problem and the conclusion. Upright, never italic.</p>
    </div>
    <dl class="bsl-meta">
      <div><dt>Author</dt><dd>Dexter</dd></div>
      <div><dt>Date</dt><dd>YYYY-MM-DD</dd></div>
      <div><dt>Status</dt><dd>Draft / Final</dd></div>
    </dl>
  </header>

  <section class="bsl-section">
    <div class="bsl-sec-h"><span class="bsl-sec-num">01</span><h2>Section title</h2></div>
    <p>Prose with a claim.</p>
    <div class="bsl-evidence">WalletService.java:214 · verified YYYY-MM-DD</div>
    <div class="bsl-evidence">PAY-1204 · closed YYYY-MM-DD</div>
  </section>

  <div class="bsl-verdict" data-label="Recommendation">
    <h3>The verdict in one sentence.</h3>
    <p>Short rationale.</p>
    <ol><li>Action 1.</li><li>Action 2.</li></ol>
  </div>

  <footer class="bsl-colophon"><div>Title · date</div><div>Author</div></footer>
</div>
</body>
```

The masthead is asymmetric by contract: title left (~2/3), meta stacked
right (~1/3). Components: `.bsl-stats` (headline numbers under a 2px bar),
`.bsl-table` (2px black header rule, hairline body, `tr.bsl-total` closes
with a 2px rule), `.bsl-pull` (huge red-barred flush-left statement — at
most one per document), `pre`/`code` (flat grey field). While composing,
`.bsl-grid-visible` on any container exposes the 12-column rules — useful
for working drafts, remove or keep deliberately for finals.

Voice: complete sentences; prose ≤ 68ch; the verdict label comes from
`data-label` ("Recommendation", "Finding", "Open question" — whatever is
true).

## 5. Panel mode recipe

```html
<body class="bsl-panels">
<div class="bsl-page">
  <div class="bsl-board-h"><h1>Board title</h1>
    <span class="bsl-board-meta">2026-07-30 09:00 UTC</span></div>

  <div class="bsl-metric-grid">
    <div class="bsl-metric"><div class="bsl-metric-l">Label</div>
      <div class="bsl-metric-v">1,284<span class="bsl-unit">unit</span></div></div>
  </div>

  <div class="bsl-panel-grid">
    <div class="bsl-panel">
      <div class="bsl-panel-h"><h3>Panel title</h3><span class="bsl-panel-meta">meta</span></div>
      <div class="bsl-panel-b">
        <div class="bsl-kv"><span>Key</span><b>value</b></div>
        <div class="bsl-reg-row"><span class="bsl-dot warn"></span><b>Risk title</b>
          <span class="bsl-reg-meta">TICKET-123</span></div>
      </div>
    </div>
  </div>

  <span class="bsl-chip ok">verified</span>
  <span class="bsl-chip warn">in review</span>
</div>
</body>
```

The metric and panel grids share 1px black rules like a printed table — the
rules are the grid background showing through 1px gaps, so plan cell counts
to fill complete rows (a ragged last row exposes the black field). Status
vocabulary: `ok` = verified / healthy · `warn` = in-review / degraded ·
`crit` = failing / stale (crit is the accent red — an alarm, not a theme) ·
`info` = informational · `neutral` = draft / unknown. Squares
(`.bsl-dot`, hard-edged, never circles) for rows; chips (`.bsl-chip`,
uppercase letterspaced text over a 2px semantic underline) for inline
labels — one per context, not both.

## 6. Diagrams

Mermaid only, themed through [`mermaid-config.json`](mermaid-config.json):
white ground, black lines and boxes, the viz palette in order for pies and
charts. Pre-render for self-contained output:

```
npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg --configFile mermaid-config.json
```

then inline the SVG and keep the DSL beside it in a `<details>` block.
Pre-rendered SVG is light-baked: pin its figure to the light ground
(`style="background:#FFFFFF"` — the one sanctioned literal hex). Diagram
rules follow the type rules: monochrome first, red reserved for the one
path or state that matters; every figure gets a numbered flush-left caption
(`FIG 01 · title · rev date`). Charts use `--bsl-v1…v6` in order — red
first, black second: a Basel chart is monochrome with one signal.

## 7. Anti-patterns

- **Italics.** In any element, at any size. Weight and size carry emphasis.
- **Centred text.** Titles, captions, table cells, footers — nothing centres.
- **Rounded corners.** Radius 0 is the system; a single `border-radius` is a defect.
- **Shadows.** Rules carry structure; elevation does not exist on paper.
- **A second accent.** There is one red. Semantic ok/warn/info are states,
  not accents, and never decorate.
- **Decorative icons.** No icon fonts, no emoji markers, no pictograms.
  Type, rules, and squares are the entire vocabulary.
- Webfonts, CDN assets, external images or scripts.
- Off-scale spacing, non-tabular digit columns, prose wider than 68ch.
- A second inversion (any dark-filled block that is not the verdict slab).

## 8. Changing the system

The system is versioned (`v1.0.0`, header of `basel.css`). Change tokens or
components only in this directory, bump the version and revision date in
`basel.css`, `index.html`, and this file, and keep the directory consistent.
New components go into `basel.css` **and** the style guide in the same
change — a component that isn't on the guide isn't in the system. Downstream
copies (inlined styles in old documents) are snapshots; they do not get
retrofitted.

## Lineage

Josef Müller-Brockmann grid systems · Emil Ruder typography ·
Akzidenz-Grotesk / Helvetica poster tradition · Massimo Vignelli.
