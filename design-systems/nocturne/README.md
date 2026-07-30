# Nocturne

**v1.0.0 · 2026-07-30 · Dark-first product UI, done with discipline.**

A sibling to the Dexter Design System for AI-generated engineering HTML that
should look like a modern dark product — Linear/Vercel lineage — without the
generic AI theatre.

| Resource | Location |
|---|---|
| Living style guide (view this) | <https://dexteryo.github.io/design-systems/nocturne/> |
| Canonical stylesheet | [`nocturne.css`](nocturne.css) |
| This spec (agent-facing) | `README.md` (this file) |
| Mermaid pre-render config (static SVG, dark) | [`mermaid-config.json`](mermaid-config.json) |
| Local source of truth | `~/dotfiles/dexteryo.github.io/design-systems/nocturne/` |

**If you are an AI agent generating HTML output for Dexter in the Nocturne
style: this file is your contract.** Read `nocturne.css` for exact values;
this file tells you which pieces to use and the rules you must not break.

---

## 1. The system in one paragraph

Nocturne is dark-first: near-black surfaces (ground → surface → raised),
hairline borders instead of shadows, one restrained indigo accent, and
contrast doing all the hierarchy work. The single permitted shadow is the
card's one-pixel top inner highlight — machined edge light, not elevation
theatre. Documents are a slightly raised content column on the dark ground
with accent mono section numbers (`01 —`); dashboards are the flagship —
metric cards, panels with raised header strips, register rows with 6px
status dots, tinted-pill chips. Every metric, value, and piece of evidence
is monospace with tabular numerals; evidence lives in small bordered inline
ref pills (`FundsRouter.java:214`). Calm, engineered, contemporary — and
explicitly not the AI look: no gradients, no glassmorphism, no glow.

## 2. Hard rules (never break these)

1. **Tokens only.** Every colour, font, space, and radius comes from a
   `--noct-*` custom property. Never hard-code a hex value in a component.
2. **System font stacks only, nothing from a CDN.** No webfonts, no
   `@font-face`, no external requests. JavaScript must be inlined/same-origin
   and progressive enhancement — the page must read if scripts never run.
3. **Self-contained output.** For a standalone file or artifact, inline
   `nocturne.css` into a `<style>` block — all three token blocks (dark
   default, `@media (prefers-color-scheme: light)`, `data-theme` overrides).
   Link the stylesheet only for pages hosted next to it.
4. **Both themes, dark first.** Dark is the default token block; light is the
   counterpart. Never restyle components inside a media query — flip tokens.
5. **One accent.** The indigo (`--noct-accent`) marks links, section numbers,
   the verdict bar, focus rings, and at most one key emphasis per page. The
   solid fill variant (`--noct-accent-fill`) is for the rare filled element.
   A second accent colour is a defect.
6. **Borders carry elevation.** The only shadow is the card's
   `inset 0 1px 0 var(--noct-highlight)` top edge. Drop shadows, glow, and
   backdrop blur are banned. Hierarchy comes from the surface scale
   (ground → surface → raised) plus 1px borders.
7. **No thin type on dark.** Display weights are 550–650 with tight tracking.
   Never 300-light on a dark ground.
8. **Machine truth is mono.** Metrics, values, timestamps, IDs, and evidence
   are `--noct-mono` with `font-variant-numeric: tabular-nums` (`.noct-num`),
   right-aligned in tables. Units are muted and small (`.noct-unit`).
9. **Evidence is a visual element.** Claims cite their source in a
   `.noct-ref` pill — `file:line`, ticket, date verified — inline with the
   claim, or in the `.noct-reg-meta` column in Panel mode.
10. **Stay on the spacing scale.** 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64
    (`--noct-s1…s8`). Radii: 8px panels, 6px small elements, 999px pills.
11. **No AI attribution** in the output.
12. **Structure must be true.** Section numbers only when order matters;
    chips only when state exists; a verdict box only when there is a verdict.

## 3. Choosing a mode

| Output | Mode | Body class |
|---|---|---|
| Investigation, design doc, post-mortem, RFC | **Document** | `noct-doc` |
| Dashboard, risk register, status page, run-book summary | **Panel** | `noct-panels` |
| Mixed (report with an embedded dashboard section) | Document base; wrap panel sections in a `noct-panels` container |

Panel mode is the flagship: if the content is scannable state, choose it.

## 4. Document mode recipe

```html
<body class="noct-doc">
<div class="noct-page">
  <div class="noct-col">
    <header class="noct-dotgrid" style="margin: calc(-1 * var(--noct-s7)) calc(-1 * var(--noct-s7)) var(--noct-s5); padding: var(--noct-s7);">
      <div class="noct-eyebrow">Doc type · Project · Context</div>
      <h1 class="noct-title">Headline with <em>one accented</em> key word</h1>
      <p class="noct-subtitle">Stand-first: the problem and the conclusion in two sentences.</p>
      <dl class="noct-meta" style="margin-bottom: 0;">
        <div><dt>Author</dt><dd>Dexter</dd></div>
        <div><dt>Date</dt><dd>YYYY-MM-DD</dd></div>
        <div><dt>Status</dt><dd>Draft / Final</dd></div>
      </dl>
    </header>

    <section class="noct-section">
      <div class="noct-sec-h"><span class="noct-sec-num">01 —</span><h2>Section title</h2></div>
      <p>Prose with a claim <span class="noct-ref">FundsRouter.java:214</span>
         and a shortcut <kbd class="noct-kbd">⌘K</kbd>.</p>
    </section>

    <div class="noct-verdict" data-label="Recommendation">
      <h3>The verdict in one sentence.</h3>
      <p>Short rationale.</p>
      <ol><li>Action 1.</li><li>Action 2.</li></ol>
    </div>

    <footer class="noct-colophon"><div>Title · date</div><div>Dexter</div></footer>
  </div>
</div>
</body>
```

Components: `.noct-stats` (mono headline numbers between hairlines),
`.noct-table` (hairline rows, `tr.noct-total` closing rule on a raised
ground), `.noct-pull` (accent-barred pull quote, upright type), `pre`/`code`
(one surface step down). The dot grid (`.noct-dotgrid`) belongs on the
hero/header band only — never behind body text. The first section's
`.noct-sec-h` after the header can drop its top hairline
(`style="border-top:0; margin-top:0;"`) if the header already rules it off.

Voice: complete sentences; prose ≤ 68ch; the verdict label comes from
`data-label` ("Recommendation", "Finding", "Open question" — whatever is
true).

## 5. Panel mode recipe

```html
<body class="noct-panels">
<div class="noct-page">
  <div class="noct-board-h">
    <h1>Board title</h1>
    <span class="noct-board-meta">env · 2026-07-30 14:00 UTC</span>
  </div>

  <div class="noct-metric-grid">
    <div class="noct-metric"><div class="noct-metric-l">Label</div>
      <div class="noct-metric-v">1,284<span class="noct-unit">unit</span></div></div>
  </div>

  <div class="noct-panel">
    <div class="noct-panel-h"><h3>Panel title</h3><span class="noct-panel-meta">meta</span></div>
    <div class="noct-panel-b">
      <div class="noct-kv"><span>Key</span><b>value</b></div>
      <div class="noct-reg-row"><span class="noct-dot warn"></span><b>Risk title</b>
        <span class="noct-reg-meta">TICKET-123</span></div>
    </div>
  </div>

  <span class="noct-chip ok">healthy</span>
  <span class="noct-chip warn">degraded</span>
</div>
</body>
```

Status vocabulary: `ok` = healthy / verified · `warn` = degraded / in-review
· `crit` = failing / stale · `info` = informational · `neutral` = draft /
unknown (hollow-ring dot, hairline chip). Dots for rows, chips for inline
labels — pick one per context, not both. `accent` chips exist for the rare
"this is the one" marker and follow the one-accent budget.

## 6. Diagrams

Nocturne has no diagram grammar of its own; it borrows the DDS approach:

- **Mermaid** for sequence, state, ER, gantt, pie, and the rest. Pre-render
  to static SVG with the dark config:
  `npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg --configFile mermaid-config.json`,
  inline the SVG, keep the DSL beside it in a `<details>`.
- Pre-rendered SVG is dark-baked: pin its figure to the dark ground —
  `<figure class="noct-card" style="background:#0E1015; padding:var(--noct-s4)">`.
  This literal hex is the one sanctioned exception to the tokens-only rule.
- Charts use `--noct-v1…v6` in order. Every diagram carries a mono caption
  with revision date and a status chip — a diagram without provenance is a
  sketch.
- Diagrams are vector (SVG). Never ASCII art, never raster screenshots.

## 7. Anti-patterns

The generic AI dark mode this system exists to prevent:

- **Gradient text and purple-to-blue gradient heroes.** The hero is type,
  space, and at most the dot grid.
- **Glassmorphism / `backdrop-filter: blur`.** Surfaces are opaque.
- **Drop shadows for elevation.** Borders carry elevation; the inset top
  highlight is the only shadow.
- **Light-weight thin display type on dark.** 550–650 or nothing.
- **More than one accent.** Semantic colours are state, not accents.
- **Decorative glow** — no `box-shadow` halos around accent elements, no
  neon.
- Webfonts, CDN assets, emoji section markers, off-scale spacing,
  non-tabular number columns, prose wider than 68ch.

## 8. Changing the system

The system is versioned (`v1.0.0`, header of `nocturne.css`). Change tokens
or components only in this directory; bump the version and revision date in
`nocturne.css`, `index.html`, and this file together. A component that is
not demonstrated on the style guide page is not in the system. Downstream
copies (inlined styles in old documents) are snapshots; they do not get
retrofitted.

## Lineage

Linear (hairline borders, neutral restraint) · Vercel/Geist (mono values,
dot grid) · Stripe dashboard density · Radix Colors dark-scale thinking ·
sibling to the Dexter Design System (token discipline, evidence-first).
