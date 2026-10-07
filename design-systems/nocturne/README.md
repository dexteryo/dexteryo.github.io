# Nocturne

**v2.0.0 · 2026-10-07 · Dark-first product UI, done with discipline — engineering edition.**

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

Version 2 is built for software architecture work. Pages are **full width**
(fluid shell, sticky contents rail) with prose held to a 72ch measure, and
diagrams are **native SVG** with a fixed grammar: eight node kinds, six
route hues, zones, numbered steps, marching dashes and travelling packets.
It adds engineering components — service cards, API endpoint tables, ADRs,
trade-off matrices, latency budgets, timelines, callouts, titled code.

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
5. **One accent outside figures.** The indigo (`--noct-accent`) marks links,
   section numbers, the verdict bar, focus rings, and at most one key
   emphasis per page. The solid fill variant (`--noct-accent-fill`) is for
   the rare filled element. A second accent colour is a defect. **Inside a
   diagram** the route (`--noct-route-*`) and node-kind (`--noct-node-*`)
   hues are encodings, not accents — allowed only when every hue used is
   declared in the figure's `.noct-legend`.
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
13. **Full width, readable measure.** The shell spans the viewport
    (`--noct-gutter`, cap `--noct-shell-max`). Prose (`p`, lists, pull
    quotes) caps at `--noct-measure` (72ch); diagrams, tables, grids, and
    code use the full column. Documents with four or more sections get the
    `.noct-layout` + `.noct-toc` rail. No horizontal page scroll at 375px —
    wide things scroll inside their own container.
14. **Architecture is native SVG.** Architecture, sequence, and state
    diagrams are hand-authored SVG in `.noct-arch` (§6), with a legend, a
    `.noct-figcap` provenance line, `role="img"`, and an `aria-label` that
    narrates the flow. Mermaid is the fallback only for ER, gantt, and other
    exotic shapes. Never ASCII art, never raster.
15. **Motion is directional.** The only animations are `.noct-flow` marching
    dashes (in the direction data travels) and `.noct-pkt` packets on at
    most three routes per diagram. Both stop under
    `prefers-reduced-motion`. Nothing pulses, glows, or bounces.

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
  <header class="noct-hero noct-dotgrid">
    <div class="noct-eyebrow">Doc type · Project · Context</div>
    <h1 class="noct-title">Headline with <em>one accented</em> key word</h1>
    <p class="noct-subtitle">Stand-first: the problem and the conclusion in two sentences.</p>
    <dl class="noct-meta">
      <div><dt>Author</dt><dd>Dexter</dd></div>
      <div><dt>Date</dt><dd>YYYY-MM-DD</dd></div>
      <div><dt>Status</dt><dd>Draft / Final</dd></div>
    </dl>
  </header>

  <div class="noct-layout">
    <nav class="noct-toc" aria-label="Contents">
      <div class="noct-toc-h">Contents</div>
      <ol>
        <li><a href="#context"><span class="noct-toc-n">01</span>Context</a></li>
        <li><a href="#architecture"><span class="noct-toc-n">02</span>Architecture</a></li>
      </ol>
    </nav>

    <main class="noct-col">
      <section class="noct-section" id="context">
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
    </main>
  </div>
</div>
<script>/* optional: TOC active state + legend focus — copy from index.html */</script>
</body>
```

For short documents (under four sections) drop the `<nav>` and keep
`.noct-layout` with just the `<main>`; the column still runs full width.
The first section's heading drops its top hairline automatically.

Components: `.noct-stats` (mono headline numbers between hairlines),
`.noct-table` (hairline rows, `tr.noct-total` closing rule on a raised
ground), `.noct-pull` (accent-barred pull quote, upright type), `pre`/`code`
(one surface step down), `.noct-code` (titled code block). The dot grid
(`.noct-dotgrid`) belongs on the hero band and the diagram canvas only —
never behind body text.

Voice: complete sentences; prose ≤ 72ch; the verdict label comes from
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

## 6. Architecture diagrams (native SVG)

Structure: `figure.noct-arch > .noct-arch-canvas > svg` + `.noct-legend` +
`figcaption.noct-figcap`. The canvas is a dot-grid ground. Font sizes come
from the classes — never set `font-size`, `fill`, or `stroke` colours
inline.

**Readability rule (measured, not eyeballed).** Diagram text must render at
≥ 10px (an SVG `<text>` box height ≥ 13px) at a 1440px viewport, and ≥ 8px
(box ≥ 10px) at 390px. To get there:

- Author at ~1:1 scale: `viewBox` width **≤ 1000** (the content column
  beside the TOC rail is ~975px at 1440). Wider viewBoxes shrink the type —
  split the diagram instead.
- No SVG text class is below 11 user units (the stylesheet's floor);
  never override it smaller.
- The SVG has `min-width: var(--noct-arch-min, 760px)`, so on narrow
  screens the diagram **scrolls inside its frame** rather than shrinking.
  If you author a viewBox wider than 1000, raise `--noct-arch-min` on that
  figure to ≥ 0.76 × the viewBox width.

**Routes** — `<path class="noct-edge <route>">` with
`marker-end="url(#<id>)"`; define one `<marker class="noct-mk <route>">` per
route used (ids unique per page). Add `noct-flow` for marching dashes.

| Route | Token | Means | Style |
|---|---|---|---|
| `sync` | `--noct-route-sync` | request/response hot path | solid |
| `async` | `--noct-route-async` | events, queues, streams | dashed |
| `data` | `--noct-route-data` | reads/writes to stores | solid |
| `ctrl` | `--noct-route-ctrl` | auth, config, deploy | solid |
| `ext` | `--noct-route-ext` | third-party calls | solid |
| `fail` | `--noct-route-fail` | error, retry, DLQ, lost signal | dashed |
| `ret` | muted | sequence-diagram return | dashed, thin |

**Nodes** — `<g class="noct-node <kind> [is-hot|is-fail|is-new]">` holding a
`rect` (or `path.noct-shape`), `text.noct-nkind` (mono kind tag, top-right,
`x = right − 12`), `text.noct-nlabel` (name), `text.noct-nsub` (mono detail),
optional `text.noct-ntag` (mono emphasis). Kinds: `client`, `edge`, `svc`,
`fn` (rx 14), `store` (cylinder: `path.noct-shape` + `path.noct-lid`),
`queue` (`path.noct-glyph` with three short bars), `cache`, `ext` (dashed
stroke automatically). A node's hue is the route that serves it — store =
data teal, queue = async violet, svc = sync blue — so one palette reads
across the figure. `is-hot` thickens and deepens the hot path; `is-fail`
turns the node crit; `is-new` is a dashed accent outline for proposed
components.

**Zones** — `rect.noct-zone` (VPC, region, bounded context) or
`rect.noct-zone.trust` (security / compliance boundary) followed by
`text.noct-zlabel` (add `.trust` to the label). **Stages** —
`text.noct-stage` column labels across the top. **Steps** —
`<g class="noct-step" transform="translate(x,y)"><circle r="11"/><text>1</text></g>`
on edges, keyed to an `ol.noct-steps` walkthrough under the figure.
**Packets** — `<circle class="noct-pkt <route>" r="4"><animateMotion dur="1.4s"
repeatCount="indefinite" path="<same d as the edge>"/></circle>` on one to
three routes.

```html
<figure class="noct-arch">
  <div class="noct-arch-canvas">
    <svg viewBox="0 0 640 140" role="img" aria-label="wallet-service writes the ledger row on the hot path.">
      <defs>
        <marker id="m-data" class="noct-mk data" viewBox="0 0 10 10" refX="9" refY="5"
                markerWidth="9" markerHeight="9" markerUnits="userSpaceOnUse" orient="auto">
          <path d="M0,0 L10,5 L0,10 z"/></marker>
      </defs>
      <g class="noct-node svc is-hot">
        <rect x="20" y="30" width="200" height="70" rx="8"/>
        <text class="noct-nkind" x="208" y="46">SVC</text>
        <text class="noct-nlabel" x="34" y="62">wallet-service</text>
        <text class="noct-nsub" x="34" y="81">Elixir · p95 120 ms</text>
      </g>
      <g class="noct-node store">
        <path class="noct-shape" d="M400,40 a100,10 0 0 1 200,0 v60 a100,10 0 0 1 -200,0 z"/>
        <path class="noct-lid" d="M400,40 a100,10 0 0 0 200,0"/>
        <text class="noct-nkind" x="588" y="66">DB</text>
        <text class="noct-nlabel" x="414" y="74">ledger-db</text>
        <text class="noct-nsub" x="414" y="93">Postgres 16</text>
      </g>
      <path class="noct-edge data noct-flow" d="M220,65 L400,65" marker-end="url(#m-data)"/>
      <circle class="noct-pkt data" r="4"><animateMotion dur="1.4s" repeatCount="indefinite" path="M220,65 L400,65"/></circle>
    </svg>
  </div>
  <div class="noct-legend">
    <span data-route="data"><i class="data"></i>store write</span>
    <span><i class="node svc"></i>service</span><span><i class="node store"></i>store</span>
  </div>
  <figcaption class="noct-figcap"><b>Fig 1 · Title</b> <span class="noct-ref">source/of/truth.md</span> <span>rev YYYY-MM-DD</span></figcaption>
</figure>
```

**Sequence** (`.noct-arch` with the same canvas): `g.noct-actor <kind>`
header boxes (centred text, `text-anchor="middle"`), `line.noct-life`
dashed lifelines, `rect.noct-actbar` activation bars, messages as
`.noct-edge sync|data|ext|async|fail|ret` horizontal paths with
`text.noct-mlabel` (add `.muted` for returns, `.crit` for failures) 8px
above the arrow, and `g.noct-note` (rect + text) for annotations.

**State machine**: `g.noct-state [ok|warn|crit|info|accent]` pills
(`rx` = half height) with a centred name and `text.noct-ssub`; start
pseudo-state `circle.noct-pseudo`, final = `circle.noct-pseudo-ring` +
`circle.noct-pseudo`; transitions `.noct-edge st-ok|st-warn|st-crit|st-info`
with `text.noct-elabel` (has a ground-coloured halo for legibility).

**Legend** — one `span` per route (`<i class="<route>">`, add
`data-route="<route>"` to enable hover isolation) and per node kind
(`<i class="node <kind>">`); `.noct-legend-sep` between groups. Every hue in
the figure must appear. **Optional script** (progressive enhancement):
hovering a `[data-route]` legend item sets `data-focus` on the figure,
dimming other routes — copy it from `index.html`.

**Fallback** — Mermaid only for ER, gantt, pie, and other shapes the grammar
does not cover. Pre-render to static SVG with the dark config
(`npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg --configFile mermaid-config.json`),
pin the figure to the dark ground `#0E1015` (the one sanctioned literal hex),
keep the DSL in a `<details>`. Charts use `--noct-v1…v6` in order.

## 7. Engineering components

| Component | Markup | Rule |
|---|---|---|
| Service card | `.noct-svc-grid > article.noct-svc[.fn/.store/.queue/.edge]` with `.noct-svc-h` (dot + `h4` + `.noct-svc-kind`), `.noct-svc-desc`, `.noct-tags > .noct-tag`, `.noct-kv` rows, `.noct-deps` with ref pills | Top border in the kind hue; status dot is health |
| API table | `table.noct-table.noct-api`; `span.noct-method get|post|put|patch|delete`; path params in `span.noct-path-param` | Method hue is fixed: GET blue · POST green · PUT amber · PATCH violet · DELETE red |
| ADR | `article.noct-adr > header.noct-adr-h` (`.noct-adr-id`, `h4`, status chip, `.noct-adr-meta`) + `.noct-adr-b` with Context / Decision / Consequences (`ul.noct-pros`, `ul.noct-cons`) | Status chip: `ok` accepted · `warn` proposed · `neutral` superseded · `crit` rejected |
| Trade-off matrix | `table.noct-table.noct-tradeoff`; cells `td.good|mid|bad`; chosen row `tr.is-chosen` | Glyph + tint (✓ ~ ✕), never colour alone |
| Latency budget | `.noct-budget > .noct-budget-h` + `.noct-budget-bar` of `span.noct-seg[.v2…v6|.over]` with `style="--w:NN%"`, `span.noct-budget-target` with `style="--at:NN%"` + `data-label`; `.noct-budget-legend` | Widths are proportions of a stated scale; the over-budget segment is `.over` |
| Timeline | `ol.noct-timeline > li` = `time` + `.noct-dot <state>` + `div` (`b` title, `p` detail) | Mono timestamps, one state dot per event |
| Callout | `.noct-callout[.warn|.risk|.decision]` with `.noct-callout-t` | Risks name an owner |
| Titled code | `.noct-code > .noct-code-h` (filename, language) + `pre`; token spans `.tk-k .tk-s .tk-c .tk-n .tk-f` | Highlight sparingly |
| Walkthrough | `ol.noct-steps` | Numbers match the `.noct-step` markers in the figure |

## 8. Anti-patterns

The generic AI dark mode this system exists to prevent:

- **Gradient text and purple-to-blue gradient heroes.** The hero is type,
  space, and at most the dot grid.
- **Glassmorphism / `backdrop-filter: blur`.** Surfaces are opaque.
- **Drop shadows for elevation.** Borders carry elevation; the inset top
  highlight is the only shadow.
- **Light-weight thin display type on dark.** 550–650 or nothing.
- **More than one accent outside a figure.** Semantic colours are state,
  not accents.
- **Rainbow diagrams.** A hue without a legend entry is decoration; two
  routes that mean the same thing share a colour.
- **Decorative motion.** Packets on every edge, pulsing or glowing nodes.
- **Shrunken diagrams.** A 1400-wide viewBox squeezed into the column
  renders 7px labels; author at ≤ 1000 wide and let narrow screens scroll.
- **Full-width prose.** Lines stop at 72ch on any screen; only diagrams,
  tables, grids, and code go wide.
- **Decorative glow** — no `box-shadow` halos around accent elements, no
  neon.
- Webfonts, CDN assets, emoji section markers, off-scale spacing,
  non-tabular number columns, prose wider than 72ch.

## 9. Changing the system

The system is versioned (`v2.0.0`, header of `nocturne.css`). Change tokens
or components only in this directory; bump the version and revision date in
`nocturne.css`, `index.html`, and this file together. A component that is
not demonstrated on the style guide page is not in the system. Downstream
copies (inlined styles in old documents) are snapshots; they do not get
retrofitted.

### Changelog

- **v2.0.0 · 2026-10-07** — Engineering edition. Full-width shell with
  sticky `.noct-toc` rail and 72ch prose measure; body 16px. Route and
  node-kind tokens; native SVG architecture, sequence, and state grammar
  with zones, steps, marching flows, packets, and legend focus. Service
  cards, API tables, ADRs, trade-off matrices, latency budgets, timelines,
  callouts, titled code. Backwards compatible with v1 class names
  (`.noct-page > .noct-col` still works, now full width).
- **v1.0.0 · 2026-07-30** — Initial release.

## Lineage

Linear (hairline borders, neutral restraint) · Vercel/Geist (mono values,
dot grid) · Stripe dashboard density · Radix Colors dark-scale thinking ·
sibling to the Dexter Design System (token discipline, evidence-first).
