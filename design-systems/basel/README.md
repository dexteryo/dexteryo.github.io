# Basel

**v2.0.0 · 2026-10-07 · The grid is the argument. Engineering edition.**

A design system for AI-generated engineering HTML in the Swiss International
Typographic Style: Müller-Brockmann / Ruder rationalism. Type is the only
ornament, one red is the only colour of the page, and everything is ruthlessly
flush-left. Since v2 the page runs full width with a sticky contents rail, and
architecture, sequence and state diagrams are native SVG drawn in a
constructivist primary palette.

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
nothing else inverts, it cannot be missed. Engineering documents get a
second vocabulary inside figures: hand-drawn SVG on the grid — rectangles
with radius 0, orthogonal edges, square packets riding the hot path — where
blue, yellow, green, violet, orange and black name routes and node kinds,
and red still means only failure.

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
   **The diagram palette is the one sanctioned exception:** the
   constructivist primaries (`--bsl-c-*`, surfaced as `--bsl-route-*` and
   `--bsl-node-*`) may colour diagram routes, node kinds, HTTP method tags,
   budget segments and service-card kind bars — and nothing else. Never
   type, never headings, never decoration. Inside a figure red is only
   `fail` (and `is-new`, the proposed change).
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
15. **Full width, readable measure.** Use `.bsl-shell` (alias `.bsl-page`):
    fluid to 1920px with a `clamp(16px, 4vw, 64px)` gutter. Prose caps at
    `--bsl-measure` (72ch); diagrams, tables, grids, code and stat strips
    use the full width. Documents with four or more sections use
    `.bsl-layout` + `.bsl-toc` (sticky rail from 1200px). No horizontal page
    scroll at 375px — wide figures and tables scroll inside their own frame.
16. **Diagrams are native SVG with a legend and a caption, and readable.**
    SVG text classes are ≥ 13 user units, `viewBox` ≤ ≈1250 wide, SVG
    min-width 880px (scrolls in its frame on phones). Architecture,
    sequence and state diagrams use the grammar in §6. Every route and node
    kind drawn appears in `.bsl-legend`; `.bsl-figcap` carries
    `FIG nn · title · source · rev date`; the `<svg>` has `role="img"` and an
    `aria-label` that states the flow. Never ASCII art, never screenshots.
17. **Motion is directional only.** `.bsl-flow` dashes march in the
    direction of travel; square `.bsl-pkt` packets ride at most three
    routes. Both stop under `prefers-reduced-motion`. Nothing else moves.

## 3. Choosing a mode

| Output | Mode | Body class |
|---|---|---|
| Investigation, design doc, post-mortem, RFC, wiki export | **Document** | `bsl-doc` |
| Dashboard, risk register, status page, run-book summary | **Panel** | `bsl-panels` |
| Mixed (report with an embedded dashboard section) | Document base; wrap panel sections in a `bsl-panels` container |
| Design doc, architecture review, RFC with diagrams | **Document** + `.bsl-layout` rail + §6 diagrams + §7 components |

## 4. Document mode recipe

```html
<body class="bsl-doc">
<div class="bsl-shell">
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

  <div class="bsl-layout">
    <nav class="bsl-toc" aria-label="Contents">
      <div class="bsl-toc-h">Contents</div>
      <ol><li><a href="#context"><b>01</b>Context</a></li>
          <li><a href="#design"><b>02</b>Design</a></li></ol>
    </nav>
    <main>
      <section class="bsl-section" id="context">
        <div class="bsl-sec-h" style="margin-top:0"><span class="bsl-sec-num">01</span><h2>Section title</h2></div>
        <p>Prose with a claim.</p>
        <div class="bsl-evidence">WalletService.java:214 · verified YYYY-MM-DD</div>
        <h3 class="bsl-h3">Sub-section</h3>
        <p>…</p>
      </section>

      <div class="bsl-verdict" data-label="Recommendation">
        <h3>The verdict in one sentence.</h3>
        <p>Short rationale.</p>
        <ol><li>Action 1.</li><li>Action 2.</li></ol>
      </div>
    </main>
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

The contents rail highlights the current section with a small inline script
(copy it from `index.html`; it toggles `.is-active` on scroll). Without the
script the rail is still a list of working links.

Voice: complete sentences; prose ≤ 72ch; the verdict label comes from
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

## 6. Diagrams (native SVG — the default)

Architecture, sequence and state diagrams are hand-authored inline SVG. The
grammar is shared by every Dexter system (only the `bsl-` prefix differs);
the Basel geometry is Swiss: **rectangles with radius 0, orthogonal edges
(H/V segments only), square packets and square step markers.**

### 6.1 Frame

```html
<figure class="bsl-arch">          <!-- or bsl-seq / bsl-state -->
  <svg viewBox="0 0 1244 520" role="img" aria-label="What flows where, and where it breaks.">…</svg>
  <div class="bsl-legend">
    <span><i class="sync"></i>sync request</span>
    <span><i class="n-svc"></i>service</span>
  </div>
  <figcaption class="bsl-figcap"><b>FIG 01</b> · Title · source: repo@sha · rev YYYY-MM-DD</figcaption>
</figure>
```

The frame opens with a 2px structural bar and scrolls horizontally inside
itself; the SVG keeps an 880px minimum width, so on a phone it scrolls
rather than shrinking. **Readability floor:** every SVG text class is at
least 13 user units (labels 15) and the `viewBox` is at most ≈1250 wide, so
rendered type is ≥ 11px on a 1440px screen and ≥ 9px on a 390px phone. Set
no `font-size` attributes — the classes carry type — and size boxes for the
13px mono sub-lines (≈7.8 user units per character).

### 6.2 Routes (edges)

| Class | Token | Meaning | Stroke |
|---|---|---|---|
| `sync`  | `--bsl-route-sync` (blue)   | request/response hot path | solid |
| `async` | `--bsl-route-async` (yellow) | events, queues, streams | dashed |
| `data`  | `--bsl-route-data` (green)  | reads/writes to stores | solid |
| `ctrl`  | `--bsl-route-ctrl` (ink)    | auth, config, deploy | solid |
| `ext`   | `--bsl-route-ext` (grey)    | third-party calls | solid |
| `fail`  | `--bsl-route-fail` (red)    | error, retry, dead-letter, lost | dotted |
| `warn`  | `--bsl-warn`                | state diagrams only: retry / degraded transition | dotted |
| `ret`   | `--bsl-muted`               | sequence diagrams only: return message | thin dashed |

`<path class="bsl-edge sync" d="M182,222 L234,222" marker-end="url(#a-sync)"/>`
with one `<marker class="bsl-m-sync">` per route used (the class fills the
arrowhead). Add `hot` for the 3px hot-path weight and `bsl-flow` for
marching dashes in the direction of travel. End paths 2px short of the
target box. A `fail` edge stops where the signal dies.

Packets: `<rect class="bsl-pkt sync" x="-4" y="-4" width="8" height="8"><animateMotion dur="1.6s" repeatCount="indefinite" path="…same d…"/></rect>`
— squares, never circles; one to three routes per figure.

### 6.3 Nodes

`<g class="bsl-node <kind> [is-hot|is-fail|is-new]">` wrapping a
`<rect class="bsl-nbox">` plus `.bsl-nlabel` (name, sans 700),
`.bsl-nsub` (mono detail: tech, port, SLO) and optional `.bsl-ntag` (mono
emphasis in the kind colour). The kind sets stroke and tint:

| Kind | Hue | Shape cue |
|---|---|---|
| `client` | grey | — |
| `edge` | ink, 3px stroke | — (gateways/LBs are often tall "walls") |
| `svc` | blue | — |
| `fn` | violet | — |
| `store` | green | `<line class="bsl-nline">` 8px under the top edge |
| `queue` | yellow | three `<line class="bsl-nbar">` verticals at the right end |
| `cache` | orange | — |
| `ext` | grey, dashed stroke | — |

State modifiers: `is-hot` (4px stroke, the path under discussion),
`is-fail` (red), `is-new` (red dashed outline — the proposed change). For
state machines use the semantic kinds `info`, `ok`, `warn`, `crit`,
`neutral` instead of node kinds; terminal states add
`<rect class="bsl-nterm">` inset 5px; the initial state is
`<rect class="bsl-start">` (a filled square).

### 6.4 Zones, stages, steps, labels

- `<rect class="bsl-zone">` dashed boundary + `<text class="bsl-zlabel">`
  (VPC, region, bounded context); `.bsl-zone.trust` (2px ink dashes) +
  `.bsl-zlabel.trust` for security boundaries (PCI, tenant, VPN).
- `<text class="bsl-stage">` uppercase column labels across the top.
- `<g class="bsl-step"><rect …18×18/><text>1</text></g>` sits on an edge
  and keys to a `<ol class="bsl-steps">` walkthrough under the figure.
- `.bsl-elabel` (muted mono) on edges; `.bsl-mlabel` on sequence messages
  (`.muted` for returns, `.fail` for the failure).

### 6.5 Sequence parts

`<line class="bsl-life">` dashed lifelines under node headers;
`<rect class="bsl-act">` 12px activation bars; calls in their route colour,
returns as `ret`; `<rect class="bsl-note">` + `<text class="bsl-ntext">`
for the rule that matters (yellow, at most one or two per diagram).

### 6.6 Copy-paste starter

```html
<figure class="bsl-arch">
  <svg viewBox="0 0 640 140" role="img" aria-label="payments-svc writes to the ledger database; a packet travels the write.">
    <defs>
      <marker id="m-data" class="bsl-m-data" markerWidth="9" markerHeight="9" refX="8" refY="4.5" orient="auto"><path d="M0,0 L9,4.5 L0,9 z"/></marker>
    </defs>
    <text class="bsl-stage" x="20" y="24">Services</text>
    <text class="bsl-stage" x="400" y="24">Data</text>
    <g class="bsl-node svc is-hot"><rect class="bsl-nbox" x="20" y="40" width="180" height="64"/>
      <text class="bsl-nlabel" x="34" y="66">payments-svc</text><text class="bsl-nsub" x="34" y="85">Kotlin · :8443</text></g>
    <g class="bsl-node store"><rect class="bsl-nbox" x="400" y="40" width="180" height="64"/>
      <line class="bsl-nline" x1="400" y1="48" x2="580" y2="48"/>
      <text class="bsl-nlabel" x="414" y="72">Ledger DB</text><text class="bsl-nsub" x="414" y="91">Postgres 16</text></g>
    <path class="bsl-edge data bsl-flow" d="M200,72 L398,72" marker-end="url(#m-data)"/>
    <rect class="bsl-pkt data" x="-4" y="-4" width="8" height="8"><animateMotion dur="1.8s" repeatCount="indefinite" path="M200,72 L398,72"/></rect>
  </svg>
  <div class="bsl-legend"><span><i class="data"></i>store write</span><span><i class="n-svc"></i>service</span><span><i class="n-store"></i>database</span></div>
  <figcaption class="bsl-figcap"><b>FIG 01</b> · Ledger write · source: LedgerRepo.kt · rev YYYY-MM-DD</figcaption>
</figure>
```

### 6.7 Mermaid (fallback only)

For ER, Gantt and pie — shapes this grammar does not cover — use Mermaid
themed through [`mermaid-config.json`](mermaid-config.json): pre-render
(`npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg --configFile
mermaid-config.json`), inline the SVG, keep the DSL in a `<details>`, and
pin the figure to the light ground (`style="background:#FFFFFF"` — the one
sanctioned literal hex). Charts use `--bsl-v1…v6` in order — red first,
black second.

## 7. Engineering components

| Component | Markup | Rule |
|---|---|---|
| Service cards | `.bsl-svc-grid` > `.bsl-svc[.fn/.store/.queue/.cache/.edge/.ext]` with `.bsl-svc-h` (`h4` + `.bsl-dot`), `.bsl-svc-kind`, `.bsl-kv` rows, `ul.bsl-tech` | Shared 1px rules; a 6px kind bar on top matches the diagram node colour |
| API endpoints | `table.bsl-table.bsl-api`; `.bsl-method.get/post/put/patch/delete`; `td.bsl-path` with `<i>{param}</i>` | Method blocks are flat, radius 0, one hue per verb |
| Decision record | `.bsl-adr` > `.bsl-adr-h` (`.bsl-adr-id`, `h4`, `.bsl-chip.proposed/accepted/superseded`) + `.bsl-adr-body` (Context / Decision / Consequences columns, `ul.bsl-cons` with `li.pro`/`li.con`) | Status is true; consequences list both signs |
| Trade-off matrix | `table.bsl-table.bsl-tradeoff`, cells `td.good/.mid/.bad`, chosen row `tr.bsl-chosen` | Symbol ■ ◧ □ carries the verdict; colour only repeats it |
| Latency budget | `.bsl-budget` > `.bsl-budget-bar` > `.bsl-budget-seg.<kind>` (`style="--w: 39.3%"`, `<span>` label, `<b>` value, `.below` to drop the label under the bar) + `.bsl-budget-target` (`--at`, `data-label`) + `.bsl-budget-scale` + `ul.bsl-budget-key` (`li.<kind>` per segment) | Widths are shares of the scale, not of the total; the key is mandatory — below 720px the in-bar labels hide and the key carries them; give the figure an `aria-label` with the numbers |
| Timeline | `ol.bsl-timeline` > `li.ok/.warn/.crit/.info` with `time`, `b`, `span` | Horizontal from 720px, vertical below |
| Callouts | `.bsl-callout[.warn/.risk/.decision]` with `data-label` | 6px bar, no fill; a risk names an owner and a date |
| Code with file header | `.bsl-code` > `.bsl-code-h` (path, language) + `pre` | Path is the real repo path |
| Walkthrough | `ol.bsl-steps` | Keys to `.bsl-step` markers in a figure |

Inline geometry custom properties (`--w`, `--at`) are the only sanctioned
inline styles; colour always comes from classes.

## 8. Anti-patterns

- **Italics.** In any element, at any size. Weight and size carry emphasis.
- **Centred text.** Titles, captions, table cells, footers — nothing centres.
- **Rounded corners.** Radius 0 is the system; a single `border-radius` is a defect.
- **Shadows.** Rules carry structure; elevation does not exist on paper.
- **A second accent.** There is one red. Semantic ok/warn/info are states,
  not accents, and never decorate.
- **Decorative icons.** No icon fonts, no emoji markers, no pictograms.
  Type, rules, and squares are the entire vocabulary.
- **Diagram palette leaking out of figures** — blue headings, yellow
  highlights, coloured body text. The primaries live in diagrams, method
  tags, budget segments and kind bars only.
- **Curved or diagonal edges, rounded boxes, circular packets.** Edges are
  orthogonal; everything is square.
- A legend that omits a hue the figure uses, or a figure without a caption.
- A fixed 960px column for an engineering document — v2 is full width.
- Webfonts, CDN assets, external images or scripts.
- Off-scale spacing, non-tabular digit columns, prose wider than 72ch.
- A second inversion (any dark-filled block that is not the verdict slab).

## 9. Changing the system

The system is versioned (`v2.0.0`, header of `basel.css`). Change tokens or
components only in this directory, bump the version and revision date in
`basel.css`, `index.html`, and this file, and keep the directory consistent.
New components go into `basel.css` **and** the style guide in the same
change — a component that isn't on the guide isn't in the system. Downstream
copies (inlined styles in old documents) are snapshots; they do not get
retrofitted.

## Changelog

- **v2.0.0 · 2026-10-07** — Engineering edition: full-width shell
  (`.bsl-shell`) with sticky contents rail (`.bsl-layout`, `.bsl-toc`);
  17px body, 72ch measure, 24px section titles; constructivist diagram
  palette and route/node tokens; native SVG grammar for architecture,
  sequence and state diagrams with marching dashes and square packets;
  service cards, API tables, decision records, trade-off matrices, latency
  budgets, timelines, callouts, code headers. v1 class names unchanged.
- **v1.0.0 · 2026-07-30** — Initial release.

## Lineage

Josef Müller-Brockmann grid systems · Emil Ruder typography ·
Akzidenz-Grotesk / Helvetica poster tradition · Massimo Vignelli ·
Bauhaus and constructivist primaries (diagram palette).
