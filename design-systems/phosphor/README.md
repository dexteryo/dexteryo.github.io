# Phosphor

**v1.0.0 · 2026-07-30 · Engineering console. Dark-first. Everything mono.**

A sibling to the Dexter Design System for output that should read like an
engineering console: phosphor green on near-black, one monospace family,
zero decoration — if it is on screen it means something.

| Resource | Location |
|---|---|
| Living style guide (view this) | <https://dexteryo.github.io/design-systems/phosphor/> |
| Canonical stylesheet | [`phosphor.css`](phosphor.css) |
| This spec (agent-facing) | `README.md` (this file) |
| Mermaid pre-render config | [`mermaid-config.json`](mermaid-config.json) |
| Local source of truth | `~/dotfiles/dexteryo.github.io/design-systems/phosphor/` |

**If you are an AI agent generating HTML output for Dexter in the Phosphor
style: this file is your contract.** Read `phosphor.css` for exact values;
this file tells you which pieces to use and the rules you must not break.

---

## 1. The system in one paragraph

Everything is monospace — body, headings, tables, labels — and hierarchy
comes from size, weight, and colour, never from a second typeface. Dark is
the default (near-black ground, green-cast greys, phosphor-green accent);
the light theme is a "paper terminal", a DEC printout on warm paper. The
aesthetic is carried by furniture, not effects: rule-line section headers
(`── § 01 · TITLE ─────`), bracket status chips (`[ OK ]`), dot-leader
key–value rows, `$`-prompted code blocks, inline bracketed evidence refs,
a blinking block cursor on the h1, and a tmux-style statusline colophon.
No scanlines, no curvature, no flicker — restraint over cosplay.

## 2. Hard rules (never break these)

1. **Tokens only.** Every colour, space, and font comes from a `--phos-*`
   custom property. Never hard-code a hex value in a component.
2. **System font stacks only, nothing from a CDN.** No webfonts, no
   `@font-face`, no external requests. JavaScript must be inlined/same-origin
   and progressive enhancement — the page must read if scripts never run.
3. **Everything mono.** One family (`--phos-mono`). A proportional font
   anywhere is a defect. Labels are uppercase and letterspaced.
4. **Dark-first, both themes always.** The default token block is dark; the
   `@media (prefers-color-scheme: light)` block and both
   `:root[data-theme=…]` overrides ship with every output. Components are
   never restyled per theme — tokens flip.
5. **Green is a claim.** The phosphor accent is the same colour as `ok`:
   it marks ok / verified / metric values / the one emphasis. It is never
   decoration. Semantic colours are fixed: ok green · warn amber · crit
   coral · info cyan. Charts use `--phos-v1…v6` in order.
6. **One glow.** `--phos-glow` exists for the h1 title only, dark theme
   only. A second glow — on chips, values, borders, anything — is a defect.
7. **Stay on the spacing scale.** 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64
   (`--phos-s1…s8`). Everything is square: no border-radius, no shadows for
   elevation (the metric-grid hairline shadow is a border technique, not
   elevation).
8. **Numbers are tabular.** Any digit column gets `.phos-num`,
   right-aligned in tables.
9. **Evidence is a visual element.** Claims cite their source inline as a
   dim bracketed ref: `<span class="phos-ref">src: FundsRouter.java:214 ·
   2026-07-30</span>` → `[src: … ]`. Brackets come from CSS.
10. **Structure must be true.** Section numbers only when order matters;
    chips only when state exists; a verdict box only when there is a verdict.
11. **No AI attribution** in the output.
12. **Furniture is built, not typed.** Rule-lines and dot-leaders stretch
    via flex + borders; never type runs of `─` or `.` glyphs.

## 3. Choosing a mode

| Output | Mode | Body class |
|---|---|---|
| Investigation, post-mortem, design doc, run-book | **Document** | `phos-doc` |
| Dashboard, risk register, status page, fleet view | **Panel** | `phos-panels` |
| Mixed (report with an embedded dashboard section) | Document base; wrap panel sections in a `phos-panels` container |

Both modes share one ground — a terminal has one screen. Panel mode adds
the TUI cells (htop/k9s energy): bordered panels with reversed-video
headers, metric cards, dense 13px tables.

## 4. Document mode recipe

```html
<body class="phos-doc">
<div class="phos-page">
  <header>
    <div class="phos-eyebrow">Doc type · Project · Context</div>
    <h1 class="phos-title">Headline (cursor and glow come from CSS)</h1>
    <p class="phos-subtitle">Stand-first: the problem and the conclusion.</p>
    <dl class="phos-meta">
      <div><dt>Author</dt><dd>Dexter</dd></div>
      <div><dt>Date</dt><dd>YYYY-MM-DD</dd></div>
      <div><dt>Status</dt><dd>Draft / Final</dd></div>
    </dl>
  </header>

  <section class="phos-section">
    <div class="phos-sec-h"><span class="phos-sec-num">§ 01</span><h2>Section title</h2></div>
    <p>Prose with a claim. <span class="phos-ref">src: FundsRouter.java:214 · 2026-07-30</span></p>
  </section>

  <div class="phos-verdict" data-label="Verdict">
    <h3>The verdict in one sentence.</h3>
    <p>Short rationale.</p>
    <ol><li>Action 1.</li><li>Action 2.</li></ol>
  </div>

  <footer class="phos-statusline">
    <span class="phos-sl-mode">Report</span>
    <span class="phos-sl-item">title-slug</span>
    <span class="phos-sl-fill"></span>
    <span class="phos-sl-item">YYYY-MM-DD</span>
    <span class="phos-sl-item">rev 1</span>
  </footer>
</div>
</body>
```

Components: `.phos-stats` (headline numbers between rules, green values),
`.phos-table` (dense hairline rows, `tr.phos-total` for the accountant's
double rule), `.phos-pull` (green-barred pull line, `<strong>` carries the
bright run), `pre` with `<span class="phos-ps">$</span>` shell prompts,
inline `code`.

Voice: complete sentences; prose ≤ 70ch; the verdict label comes from
`data-label` and renders as `[ LABEL ]` (use "Verdict", "Finding",
"Open question" — whatever is true).

## 5. Panel mode recipe

```html
<body class="phos-panels">
<div class="phos-page">
  <div class="phos-board-h"><h1>Reconciliation board</h1>
    <span class="phos-board-meta">eu-west-1 · updated 14:02Z</span></div>

  <div class="phos-metric-grid">
    <div class="phos-metric"><div class="phos-metric-l">Label</div>
      <div class="phos-metric-v">1,284<span class="phos-unit">unit</span></div></div>
  </div>

  <div class="phos-panel">
    <div class="phos-panel-h"><h3>Panel title</h3><span class="phos-panel-meta">meta</span></div>
    <div class="phos-panel-b">
      <div class="phos-kv"><span>Key</span><i class="phos-leader"></i><b>value</b></div>
      <div class="phos-reg-row"><span class="phos-dot warn"></span><b>Risk title</b>
        <span class="phos-reg-meta">TICKET-123</span></div>
    </div>
  </div>

  <span class="phos-chip ok">[ OK ]</span>
  <span class="phos-chip warn">[WARN]</span>
</div>
</body>
```

Status vocabulary: `ok` = healthy / verified · `warn` = degraded /
in-review · `crit` = failing / stale · `info` = informational · `neutral`
= draft / unknown. Two forms, one idiom each:

- **Bracket chips** for inline labels — you type the brackets, in the
  fixed six-character forms so mono columns align:
  `[ OK ]` `[WARN]` `[CRIT]` `[INFO]` `[ -- ]` (neutral).
- **`▪` dots** (`.phos-dot ok|warn|crit|info|neutral`, glyph from CSS)
  for register rows. Pick one form per context, not both.

## 6. Diagrams

Diagrams stay vector — inline SVG or Mermaid — never ASCII art, however
tempting the terminal aesthetic makes it. Reuse the DDS Tier-1 grammar
(`~/dotfiles/dexteryo.github.io/design-system/`) for architecture and
funds-flow drawings, recoloured with `--phos-*` tokens: node strokes in
ink, money edges in `--phos-ok`, manual in `--phos-warn`, mirror in
`--phos-info`, blocked in `--phos-crit`. Recolour the grammar; never
reinterpret it. For the Mermaid catalogue (sequence, state, ER, gantt…),
pre-render to static SVG with this directory's dark-themed config:

```
npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg --configFile mermaid-config.json
```

Pre-rendered SVG is dark-baked: pin its figure to the dark ground
(`style="background:#0A0F0C"` — the one sanctioned literal hex) so it
survives the light theme. Every diagram carries a caption with revision
date and status, and a legend wherever edge semantics are used.

## 7. Anti-patterns

- **CRT cosplay**: scanline overlays, screen-curvature transforms, flicker
  or boot-sequence animations. The blinking h1 cursor is the entire motion
  budget.
- **ASCII-art diagrams** — boxes drawn from `+--|` glyphs. Diagrams are
  SVG/Mermaid.
- **Proportional fonts sneaking in** (a serif heading, a sans UI label).
  One family, everywhere.
- **Green used for anything not ok / verified / accent** — a green border
  for taste, green prose, a green warn state.
- **More than one glow.** `--phos-glow` is spent on the h1.
- Typed rule glyphs (`────`) or typed dot-leaders (`....`) — furniture
  must stretch, so it is built from borders.
- Rounded corners, drop shadows, gradient anything.
- Webfonts, CDN assets, external images or scripts.

## 8. Changing the system

The system is versioned (`v1.0.0`, header of `phosphor.css`). Change tokens
or components only in this directory; bump the version and revision date in
`phosphor.css`, `index.html`, and this file together. A component that is
not demonstrated on the style-guide page is not in the system. Downstream
copies (inlined styles in old documents) are snapshots; they do not get
retrofitted.

## Lineage

VT220/DEC terminals (palette, paper-terminal light theme) · tmux/vim
statuslines (colophon) · htop/k9s TUI dashboards (panel mode) · Berkeley
Mono specimen culture (mono-everything discipline) · DDS (token and
evidence discipline).
