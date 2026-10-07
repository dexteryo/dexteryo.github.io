# Dexter Design System (DDS)

**v2.0.0 · 2026-10-07 · One system, two modes, one grammar — engineering edition.**

A design system for AI-generated engineering HTML: reports, dashboards, and
architecture diagrams that come out consistent no matter which agent produced
them.

| Resource | Location |
|---|---|
| Living style guide (view this) | <https://dexteryo.github.io/design-system/> |
| Canonical stylesheet | [`dexter.css`](dexter.css) |
| This spec (agent-facing) | `README.md` (this file) |
| Mermaid theme bridge (hosted pages) | [`dds-mermaid.js`](dds-mermaid.js) + [`vendor/mermaid.min.js`](vendor/mermaid.min.js) |
| Mermaid pre-render config (static SVG) | [`mermaid-config.json`](mermaid-config.json) |
| Local source of truth | `~/dotfiles/dexteryo.github.io/design-system/` |

**If you are an AI agent generating HTML output for Dexter: this file is your
contract.** Read `dexter.css` for exact values; this file tells you which
pieces to use and the rules you must not break.

### Reference pages (documentation depth — not new sources of truth)

This file plus `dexter.css` are self-sufficient; the pages below add depth
for humans and worked examples for agents. They never define tokens or rules
of their own.

| Page | Covers |
|---|---|
| [`typography.html`](typography.html) | Type roles, full scale for both modes, do/don't pairs |
| [`color.html`](color.html) | All tokens with light/dark values, accent + semantic rules, viz palette |
| [`components.html`](components.html) | Every component, rendered live with copy-paste markup |
| [`diagrams.html`](diagrams.html) | v2 architecture / sequence / state grammars with a copy-paste starter, the v1 funds-flow grammar, C4 zoom, Mermaid fallback |
| [`examples/report.html`](examples/report.html) | Complete conformant Document-mode page — **match this** for reports |
| [`examples/dashboard.html`](examples/dashboard.html) | Complete conformant Panel-mode page — **match this** for dashboards |

---

## 1. The system in one paragraph

Long-form documents are set like Tufte (serif body, sidenote citations,
near-zero decoration). Dashboards are set like instruments (sans-serif, 1px
borders, status dots, monospace machine values — Geist/Linear economy, but
light-first). Pages are full width with a sticky contents rail; prose keeps a
72ch measure while diagrams, tables and grids take the width. Architecture,
sequence and state diagrams are native SVG in which every node kind and every
route owns a hue, dashed edges march in the direction of flow, and every
drawing carries a legend and a provenance title block. Engineering furniture
— service cards, API tables, ADRs, trade-off matrices, latency budgets,
timelines — is built in. Everything shares one token sheet: one accent, one
semantic family, one route/node palette, one spacing scale (Carbon
discipline).

## 2. Hard rules (never break these)

1. **Tokens only.** Every colour, font, space, and radius comes from a
   `--dds-*` custom property. Never hard-code a hex value in a component.
2. **System font stacks only, and nothing from a CDN.** No webfont `<link>`,
   no `@font-face`, no runtime CDN requests. JavaScript is permitted, but it
   must be vendored/same-origin (or inlined) and **progressive enhancement**:
   the document must still read if scripts never run — no blank boxes.
3. **Self-contained output.** When producing a standalone file or artifact,
   inline the contents of `dexter.css` into a `<style>` block, and
   **pre-render** Tier-2 diagrams to static SVG (see §6) rather than shipping
   the 2.6 MB Mermaid library. Link stylesheet/scripts only for pages hosted
   next to them.
4. **Both themes.** The token sheet defines light and dark values plus
   `:root[data-theme=…]` overrides. Include all three token blocks when
   inlining. Never restyle components inside a media query — flip tokens only.
5. **The accent means verified/real.** The viridian accent (`--dds-accent`)
   is reserved: verified facts, real-money edges, `ok` status, and at most
   one key emphasis per document. It is never decoration.
6. **Semantic colours are fixed.** `ok` green · `warn` amber · `crit` red ·
   `info` slate. Diagram edges reuse the same family (see §6). Charts use
   `--dds-v1…v6` in order.
7. **Stay on the spacing scale.** 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64
   (`--dds-s1…s8`). Off-scale spacing is a defect.
8. **Numbers are tabular.** Any column of digits gets `.dds-num`
   (`font-variant-numeric: tabular-nums`), right-aligned in tables.
9. **Evidence is a visual element.** Claims cite their source
   (`file:line`, ticket, URL, date verified) in monospace — in Document mode
   as margin sidenotes, in Panel mode as the `.dds-reg-meta` column.
10. **Diagrams always ship with their legend and a title block** (revision
    date + verification status). A diagram without provenance is a sketch.
11. **No AI attribution** in the output (no "generated with…" footers).
12. **Structure must be true.** Section numbers only when order matters;
    chips only when state exists; a verdict box only when there is a verdict.
13. **Full width, readable measure (v2).** The `.dds-page` shell is fluid
    (gutter `--dds-gutter`, cap 1920px). Prose, lists and callouts stay at
    `--dds-measure` (72ch); diagrams, tables, stat strips, card grids and
    panels take the full width. Documents with three or more sections use
    `.dds-layout` + `.dds-toc` (sticky contents rail ≥1200px). No horizontal
    page scroll at 375px — wide figures and tables scroll inside their own
    frame.
14. **Native SVG diagrams by default (v2).** Architecture, sequence and state
    diagrams are hand-authored SVG with the §6 grammar. Every node kind,
    route and state hue used appears in the figure's legend; colour is never
    decoration. Motion (`.dds-flow` marching dashes, `.dds-pkt` packets) is
    directional only, at most three packet routes per figure, and stops
    under `prefers-reduced-motion`.
15. **Diagram text has a readability floor (v2).** Author every native SVG
    `viewBox` at most ≈1000 units wide so it renders ~1:1 beside the
    contents rail, and never set SVG text below 12 units (`.dds-nkind`,
    `.dds-nsub`, `.dds-elabel`, `.dds-stage`, `.dds-zlabel` 12; names 15;
    messages and notes 13). The stylesheet gives `.dds-arch/.dds-seq/
    .dds-state svg` a `min-width: 860px` (`.dds-diagram svg` 720px), so on
    phones the figure scrolls inside its frame instead of shrinking. Target:
    every rendered SVG `<text>` box ≥13px tall at 1440 wide and ≥10px at
    390. If a drawing does not fit in 1000 units, split it or shorten labels
    — never widen the viewBox or shrink the type.

## 3. Choosing a mode

| Output | Mode | Body class |
|---|---|---|
| Investigation, design doc, post-mortem, RFC, wiki export | **Document** | `dds-doc` |
| Dashboard, risk register, status page, run-book summary | **Panel** | `dds-panels` |
| Mixed (report with an embedded dashboard section) | Document base; wrap panel sections in a `dds-panels` container |
| Design doc, RFC, service review, architecture decision | **Document** + the §6 diagrams + §7 engineering components | `dds-doc` |

Diagrams and engineering components work inside either mode: they read
mode-resolved aliases (`--dds-ink`, `--dds-muted`, `--dds-surface`,
`--dds-rule`, `--dds-strong`, `--dds-r`), so the same markup renders square on
warm paper in Document mode and rounded on the cool ground in Panel mode.

## 4. Document mode recipe

Skeleton (see the style guide for a live version):

```html
<body class="dds-doc">
<div class="dds-page">
  <header>
    <div class="dds-eyebrow">Doc type · Project · Context</div>
    <h1 class="dds-title">Headline with <em>one accented</em> key word</h1>
    <p class="dds-subtitle">Italic stand-first: the problem and the conclusion.</p>
    <dl class="dds-meta">
      <div><dt>Author</dt><dd>Dexter</dd></div>
      <div><dt>Date</dt><dd>YYYY-MM-DD</dd></div>
      <div><dt>Status</dt><dd>Draft / Final</dd></div>
    </dl>
  </header>

  <div class="dds-layout">
  <nav class="dds-toc" aria-label="Contents">
    <div class="dds-toc-h">Contents</div>
    <ol><li><a href="#s1">01 Section title</a></li></ol>
  </nav>
  <main class="dds-main">

  <section class="dds-section" id="s1">
    <div class="dds-sec-h"><span class="dds-sec-num">§ 01</span><h2>Section title</h2></div>
    <div class="dds-row">
      <div>
        <p>Prose with a claim.<span class="dds-snref">1</span></p>
      </div>
      <aside class="dds-sidenote"><span class="dds-sn-num">1.</span>
        <span class="dds-evidence">path/to/File.java:214</span> — verified YYYY-MM-DD.</aside>
    </div>
  </section>

  <div class="dds-verdict" data-label="Recommendation">
    <h3>The verdict in one sentence.</h3>
    <p>Short rationale.</p>
    <ol><li>Action 1.</li><li>Action 2.</li></ol>
  </div>

  </main>
  </div>

  <footer class="dds-colophon"><div>Title · date</div><div>Author</div></footer>
</div>
</body>
```

Components: `.dds-stats` (headline numbers between rules), `.dds-table`
(hairline rows, `tr.dds-total` for an accountant's total rule), `.dds-pull`
(accent-barred pull quote), `pre`/`code` (warm code background).

**Long headline? Use `.dds-hero`.** A long title with `text-wrap: balance`
leaves the right margin empty — that void reads as a defect. Do **not** widen
the title. Instead wrap the title+subtitle and a `.dds-statuscard` in a
`.dds-hero` grid, so the reserved sidenote gutter carries something useful
(status + gates, or key facts) rather than sitting blank. Eyebrow above the
hero, `.dds-meta` bar below — both full-measure. The status card's rows are
dot + `.dds-sc-k` + `.dds-sc-v`, closed by a one-line `.dds-sc-foot`.

The contents rail works as plain links. To highlight the current section,
copy the small inline IntersectionObserver script from `index.html` (it adds
`.is-active` to the matching `.dds-toc a`); it is progressive enhancement.

Voice: complete sentences; prose ≤ 72ch; no emoji section markers; the
verdict label comes from `data-label` (use "Recommendation", "Finding",
"Open question" — whatever is true).

## 5. Panel mode recipe

```html
<body class="dds-panels">
<div class="dds-page">
  <div class="dds-metric-grid">
    <div class="dds-metric"><div class="dds-metric-l">Label</div>
      <div class="dds-metric-v">1,284<span class="dds-unit">unit</span></div></div>
  </div>

  <div class="dds-panel">
    <div class="dds-panel-h"><h3>Panel title</h3><span class="dds-panel-meta">meta</span></div>
    <div class="dds-panel-b">
      <div class="dds-kv"><span>Key</span><b>value</b></div>
      <div class="dds-reg-row"><span class="dds-dot warn"></span><b>Risk title</b>
        <span class="dds-reg-meta">TICKET-123</span></div>
    </div>
  </div>

  <span class="dds-chip ok">verified</span>
  <span class="dds-chip warn">in review</span>
</div>
</body>
```

Status vocabulary (aligned with the wiki trust signal): `ok` = verified /
healthy · `warn` = in-review / degraded · `crit` = stale / failing ·
`info` = informational · `neutral` = draft / unknown. Dots for rows, chips
for inline labels — pick one per context, not both. The `pending` **dot**
variant (`.dds-dot.pending`, a hollow ring) marks *not-started / blocked /
awaiting* — it is dot-only and has no chip form.

## 6. Diagrams

| Tier | Use for | Source | Rendering |
|---|---|---|---|
| **1 · Architecture grammar (v2, default)** | Container / system views, pipelines (`.dds-arch`), sequences (`.dds-seq`), state machines (`.dds-state`) | Inline SVG, §6.1 classes | Static SVG; CSS + SMIL motion, off under reduced motion |
| **1 · Funds-flow grammar (v1)** | Money movement with money / manual / mirror / blocked semantics (`.dds-diagram`) | Inline SVG, §6.2 classes | Static, no JS |
| **2 · Mermaid** | ER, class, gantt, pie, journey, git graph, mindmap, timeline — what the native grammars do not cover | Mermaid DSL in `<pre class="mermaid">` (the DSL ships in the page — it is the reviewable artefact) | Hosted pages: `vendor/mermaid.min.js` + `dds-mermaid.js` (theme-adaptive, progressive enhancement). Self-contained/emailed output: **pre-render** to static SVG: `npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg --configFile mermaid-config.json` (single-theme light), then inline the SVG and keep the DSL beside it in a `<details>` |

Both tiers carry the **title block**; the grammar legend applies wherever
grammar classes are used. Sequence arrows echo the grammar for free: solid
`->>` = synchronous, dashed `-->>` = asynchronous. Never override the theme
per diagram.

### Coverage — plan the diagram set before you draw

**Under-diagramming is a defect.** A single simplified overview is never
enough for an investigation or a design document. Before writing, inventory
the content against this table and plan the full set:

| The content contains… | Then draw… | Tier |
|---|---|---|
| An end-to-end flow told across sections | A **detailed container view** (`.dds-arch`) as the centrepiece, plus a zoom-in for each load-bearing section | 1 |
| Money moving between parties | A funds-flow drawing (`.dds-diagram`) | 1 |
| A step-by-step interaction (webhooks, API calls, retries) | A sequence diagram (`.dds-seq`) | 1 |
| A lifecycle or status machine | A state diagram (`.dds-state`) | 1 |
| An ordered pipeline (ETL, batch, CI) | A left-to-right `.dds-arch` with `.dds-stage` labels | 1 |
| Where the latency goes | A `.dds-budget` bar (§7) | component |
| Entities and their relations | An ER diagram | 2 |
| Phases, schedules, deadlines | A gantt chart | 2 |
| Proportions or breakdowns | Pie / bar using `--dds-v1…v6` | 2 |
| A hierarchy or decomposition | Mindmap / flowchart | 2 |

Rules of the set:

- If prose narrates a flow, sequence, or lifecycle step by step, it **must
  also be drawn** — narration is not a substitute for a diagram.
- Number every drawing (`DWG XX-01…`) and reference it from the prose.
- One diagram = one zoom level = one type. When a diagram gets crowded,
  simplify by **splitting** into more diagrams — never by merging or by
  dropping information the prose depends on.
- Pre-rendered (single-theme) Tier-2 diagrams pin their figure to the light
  paper ground — `<figure class="dds-diagram" style="background:#FBFAF3">` —
  so they stay readable in dark mode. This literal hex is the one sanctioned
  exception to the tokens-only rule, because the SVG's own colours are
  already baked.

### 6.1 Architecture grammar (v2)

Container: `<figure class="dds-arch">` (or `dds-seq` / `dds-state`) holding
the `<svg>`, one or two `.dds-legend` rows, and the `.dds-titleblock` as the
caption. The figure brings the frame, surface and horizontal scroll; the SVG
has `min-width: 860px`. Size the `viewBox` to the content and keep it
**≤ ≈1000 units wide** (hard rule 15) — five stage columns of 136–170-unit
nodes fit a container view; a sequence fits six lifelines 160 apart.

**Node kinds** — `<g class="dds-node KIND">` + `.dds-shape` + text lines.
Each kind owns a stroke hue on a tinted fill (`--dds-node-KIND`,
`--dds-node-KIND-bg`):

| Kind | Shape | Use for |
|---|---|---|
| `client` | rect `rx=14` | Browser, mobile app, CLI |
| `edge` | rect `rx=4` | CDN, gateway, load balancer |
| `svc` | sharp rect | A deployed service you own |
| `fn` | rect `rx=10` | Lambda, worker, cron, batch job |
| `store` | cylinder (path + ellipse rim) | Database, ledger |
| `queue` | rect + three `.dds-qbar` rects | Topic, queue, DLQ, stream |
| `cache` | sharp rect | Redis, Memcached |
| `ext` | dashed rect | Third party |

Text: `.dds-nkind` (mono 12px uppercase, kind hue) at +20 · `.dds-nlabel`
(sans 15px 600) at +41 · `.dds-nsub` (mono 12px muted) at +59 · optional
`.dds-ntag` (mono 12px, kind hue) at +75; x = box x + 14. Stores shift down
16 for the rim. **Label budget:** `.dds-nsub` ≈7.2px per character, the name
≈8px — a 200-wide node holds ≈24 detail / ≈21 name characters. Shorten or
widen; never overflow.

Modifiers on the node group: `is-hot` (heavier stroke, the hot path),
`is-fail` (red stroke, crit fill — where it breaks), `is-new` (dashed
outline; write the kind line as `CACHE · PROPOSED` — CSS pseudo-elements do
not render on SVG text).

**Routes** — `<path class="dds-edge ROUTE">` with `marker-end` pointing at a
`<marker class="dds-mk ROUTE">` (one per route used; `markerUnits=
"userSpaceOnUse"`, 10×10). Meanings are fixed:

| Route | Stroke | Meaning |
|---|---|---|
| `sync` | solid 2.5, viridian (= accent) | Request/response on the hot path |
| `async` | dashed, blue | Events, queues, streams |
| `data` | solid, purple | Reads/writes to stores and caches |
| `ctrl` | dotted, amber | Auth, config, deploy, timers |
| `ext` | solid, cyan | Calls to third parties |
| `fail` | dashed, red | Errors, retries, dead letters, lost signals |

**Motion:** add `.dds-flow` to an edge to march its dashes in the direction
of travel. Add a packet on the same path for the 1–3 most important routes:
`<circle class="dds-pkt ROUTE" r="4.5"><animateMotion dur="2.4s"
repeatCount="indefinite" path="…same d…"/></circle>`. Both stop under
`prefers-reduced-motion` (packets are hidden).

**Furniture:** `<rect class="dds-zone">` (+ `.trust` for security
boundaries) with a `.dds-zlabel`; `.dds-stage` column labels across the top;
`<g class="dds-step"><circle r="12"/><text>N</text></g>` badges on edges,
keyed to an `<ol class="dds-steps">` walkthrough under the figure;
`.dds-elabel ROUTE` edge labels (surface halo built in).

**Sequence (`.dds-seq`):** actors are `.dds-node` groups (kind classes, so
colours match the container view); `line.dds-life` lifelines;
`rect.dds-act KIND` activation bars; `path.dds-msg ROUTE` messages, or
`.dds-msg.ret` for returns; `.dds-mlabel` labels 8 units above the arrow;
`g.dds-note` (rect + text) for the non-obvious. Messages 35–45 units apart.

**State machine (`.dds-state`):** states are `g.dds-node.dds-st SEM` pills
(`rx` = half height) where SEM is the status vocabulary — `neutral` pending,
`info` in flight, `ok` done, `warn` reversed/lapsed, `crit` failed.
Transitions are `.dds-edge` with the route naming the trigger: `sync` API
command, `async` webhook/event, `ctrl` timer, `fail` failure.
`.dds-st-init` start dot; `.dds-st-final` + `.dds-st-final-dot` end.

**Legend:** `.dds-legend` with `<span><i class="ROUTE"></i>meaning</span>`
for routes and `<i class="node KIND">` for node kinds (also `i.zone`,
`i.zone.trust`, `i.pkt`). Only what the drawing uses.

Starter (one service, one store, one data edge with a packet):

```html
<figure class="dds-arch">
<svg viewBox="0 0 520 150" style="min-width:520px" role="img" aria-label="wallet-service writes to ledger-db over a data route.">
  <defs>
    <marker id="mk-data" class="dds-mk data" viewBox="0 0 10 10" refX="9" refY="5"
      markerWidth="10" markerHeight="10" markerUnits="userSpaceOnUse" orient="auto"><path d="M0,0 L10,5 L0,10 z"/></marker>
  </defs>
  <path class="dds-edge data dds-flow" d="M230,75 L318,75" marker-end="url(#mk-data)"/>
  <circle class="dds-pkt data" r="4.5"><animateMotion dur="1.6s" repeatCount="indefinite" path="M230,75 L318,75"/></circle>
  <g class="dds-node svc is-hot">
    <rect class="dds-shape" x="20" y="40" width="210" height="70"/>
    <text class="dds-nkind" x="34" y="60">SVC</text>
    <text class="dds-nlabel" x="34" y="81">wallet-service</text>
    <text class="dds-nsub" x="34" y="99">Java 21 · p95 120ms</text>
  </g>
  <g class="dds-node store">
    <path class="dds-shape" d="M320,36 v78 a95,9 0 0 0 190,0 v-78 a95,9 0 0 0 -190,0 z"/>
    <ellipse class="dds-shape" cx="415" cy="36" rx="95" ry="9"/>
    <text class="dds-nkind" x="334" y="63">STORE</text>
    <text class="dds-nlabel" x="334" y="84">ledger-db</text>
    <text class="dds-nsub" x="334" y="102">Postgres 16 · RDS</text>
  </g>
</svg>
<div class="dds-legend"><span><i class="node svc"></i>service</span><span><i class="node store"></i>database</span><span><i class="data"></i>data write</span></div>
<div class="dds-titleblock"><div><b>Title</b>source</div><div><b>Rev YYYY-MM-DD</b><span class="dds-tb-status verified">verified</span></div><div><b>DWG 01</b>sheet 1/1</div></div>
</figure>
```

Worked examples of all three (container view with zones, steps and packets;
retry-safe sequence; payment-intent state machine) are in `index.html` §06
and `diagrams.html`; `examples/report.html` has a sequence in context.

### 6.2 Funds-flow grammar (v1)

Semantic, skin-independent. A restyle may recolour the grammar; it may never
reinterpret it.

**Edges** (class on SVG `line`/`path`; matching arrowheads `a-*`):

| Class | Style | Meaning |
|---|---|---|
| `.e-money` | solid, heaviest, accent green | Real money moves, or a synchronous call |
| `.e-manual` | dotted, amber | A manual / human step — not guaranteed |
| `.e-mirror` | dashed, slate | Ledger mirror or async event — information, never money |
| `.e-blocked` | dashed, red | A path designed **not** to exist |

**Nodes** (shape carries meaning):

| Class | Shape | Meaning |
|---|---|---|
| `.n-svc` | sharp rectangle | A system you own |
| `.n-store` | rounded rectangle (`rx="10"`) | Database, queue, ledger |
| `.n-ext` | dashed rectangle | A system you don't control |
| `.n-human` | pill (`rx` = half height) | A person / manual role |

Labels: `.n-label` (sans, 11px, 600) + `.n-sub` (mono, 9.5px, muted).
**Label budget — text must fit its node:** the mono sub-label runs ≈5.8px per
character, so a 120-wide node holds ≈20 characters (name label: ≈6.2px/char,
≈19 characters). Shorten the label or widen the node; never let text overflow
the box. Detail belongs in prose or a table, not in the node.

**Mandatory furniture**: the legend (`.dds-legend` with `.dds-leg-line`
samples) and the title block:

```html
<div class="dds-titleblock">
  <div><b>Diagram title</b>source page / repo</div>
  <div><b>Rev YYYY-MM-DD</b><span class="dds-tb-status verified">verified</span></div>
  <div><b>DWG 001</b>sheet 1/1</div>
</div>
```

`dds-tb-status` values: `verified` · `in-review` · `stale` — matching the
wiki's page-trust vocabulary.

**Zoom**: follow the C4 model — Context → Container → Component. One diagram,
one level. Use `.dds-grid-paper` on the diagram frame for working drawings;
omit it for final documents.

**Diagrams are vector** — Tier-1 inline SVG or Tier-2 Mermaid-rendered SVG.
Never ASCII art, never raster screenshots of diagrams. Canvas is reserved
for data visualisation past ~10,000 marks; it is never a diagram medium
(it cannot participate in the token system and dies in email/print).

## 7. Engineering components (v2)

All read the mode-resolved aliases; see `components.html` for live demos and
markup.

| Component | Markup | Notes |
|---|---|---|
| Service card | `.dds-svc-grid` > `article.dds-svc KIND` with `.dds-svc-kind`, `.dds-svc-h` (`h4` + `.dds-dot`), `.dds-svc-own`, `.dds-svc-tags` (`.dds-tag`), `dl.dds-svc-facts` | Kind class colours the top bar, same hue as the diagram node |
| API table | `table.dds-table.dds-api`; method cell `span.dds-method get\|post\|put\|patch\|delete` | Path column mono, never wraps; add auth, idempotency, p95 |
| Decision record | `article.dds-adr` > `.dds-adr-h` (`.dds-adr-id`, `h3`, `.dds-adr-status accepted\|proposed\|superseded\|rejected`, `.dds-adr-date`) + `.dds-adr-b` of `.dds-adr-sec` (`.dds-adr-l` label) | Consequences as `ul.dds-pros` / `ul.dds-cons` |
| Trade-off matrix | `table.dds-table.dds-tradeoff`; cells `td.good\|mid\|bad`; `tr.chosen` | Glyph + colour (▲ ◆ ▼), never colour alone |
| Latency budget | `.dds-budget` > `.dds-budget-h`, `.dds-budget-bar` of `span.vN style="--w:X%"` + `i.dds-budget-target style="--at:Y%"`, `ul.dds-budget-keys` | `--w` is share of the scale; keys carry the numbers |
| Timeline | `ol.dds-timeline` > `li.ok\|warn\|crit\|info` with `time`, `i`, `b`, `p` | No class = pending |
| Callout | `.dds-callout.note\|warn\|risk\|decision` > `.dds-callout-t` + `p` | Sparingly |
| Code with filename | `.dds-code` > `.dds-code-h` (`span` path, `span` lang) + `pre` | For code from a real file |
| Walkthrough | `ol.dds-steps` | Counters match `.dds-step` badges |

HTTP method hues alias the route/node tokens (`--dds-m-get` service blue,
`post` edge cyan, `put` control amber, `patch` job purple, `delete` failure
red).

## 8. Anti-patterns

- Webfonts, CDN assets, external images or scripts. (Vendored/same-origin
  JavaScript with progressive enhancement is fine; runtime CDN calls are not.)
- Dark inverted "verdict slabs", purple-to-blue gradient heroes, emoji as
  section markers, `rounded-lg`-everywhere — the generic AI look this system
  exists to prevent.
- Green used decoratively (the accent is a claim: verified/real).
- A second accent colour. Semantic colours are not accents.
- Shadows in Panel mode (1px borders carry elevation).
- Diagrams without a legend or title block; a hue in a diagram that the
  legend does not explain.
- Decorative motion: packets on every edge, animation that does not show
  direction, motion that ignores `prefers-reduced-motion`.
- A fixed narrow page column (the v1 960px page) — the shell is full width.
- Off-scale spacing, non-tabular number columns, prose wider than 72ch.

## 9. Changing the system

The system is versioned (`v2.0.0`, header of `dexter.css`). Change tokens or
grammar only in this directory, bump the version and revision date in
`dexter.css`, `index.html`, and this file, and keep the whole directory
(including reference pages and examples) consistent. New components go into
`dexter.css` **and** `components.html` in the same change — a component that
isn't on the components page isn't in the system. Downstream copies (inlined
styles in old documents) are snapshots; they do not get retrofitted.

## Changelog

- **v2.0.0 · 2026-10-07** — engineering edition. Full-width shell with
  sticky contents rail and a 72ch prose measure; mode-resolved aliases;
  route (`--dds-route-*`) and node-kind (`--dds-node-*`) tokens; native SVG
  architecture, sequence and state grammars with zones, numbered steps,
  marching-dash flows and packets; service cards, API tables, ADRs,
  trade-off matrices, latency budgets, timelines, callouts, code headers.
  Sequence and state move from Mermaid to native SVG. v1 classes unchanged.
- **v1.1.0 · 2026-07-04** — hero header + status card; Mermaid Tier 2.

## Lineage

Tufte/Gwern (document typography, sidenotes) · Vercel Geist and Linear
(panel economy) · Swiss schematic / engineering drawings (diagram grammar,
title block) · IBM Carbon (token and spacing discipline) · C4 model
(diagram zoom levels) · network-diagram marching ants (animated routes) ·
Nygard ADRs (decision records).
