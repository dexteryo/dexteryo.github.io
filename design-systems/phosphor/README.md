# Phosphor

**v2.0.0 · 2026-10-07 · Engineering console. Dark-first. Everything mono. Full width, architecture-first.**

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

v2 (engineering edition) makes the page full width with a sticky index
rail, keeps prose at a 76ch measure, and adds the architect's kit: native
SVG architecture, sequence and state diagrams drawn in the ANSI palette —
every hue a declared route or node kind, edges marching in the direction
of travel, square packets riding the hot path — plus service cards, API
endpoint tables, decision records, trade-off matrices, latency budgets,
timelines, callouts and file-headed code blocks.

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
   it marks ok / verified / added (diff `+`) / metric values / the one
   emphasis. It is never decoration and never a route colour. Semantic
   colours are fixed: ok green · warn amber · crit coral · info cyan.
   Charts use `--phos-v1…v6` in order.
6. **One glow.** `--phos-glow` exists for the h1 title only, dark theme
   only. A second glow — on chips, values, borders, anything — is a defect.
   **Motion is directional only:** the h1 cursor, `.phos-flow` marching
   edges, and `.phos-pkt` packets. All three stop under
   `prefers-reduced-motion` and in print.
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
13. **Full width, readable measure.** The shell (`.phos-page`) is fluid with
    a `--phos-gutter` gutter; prose caps at `--phos-measure` (76ch);
    diagrams, tables, grids and code take the full content width. Long
    documents use `.phos-layout` + `.phos-toc`. The page never scrolls
    sideways at 375px — wide figures and tables scroll inside their own
    container.
15. **Diagram text has a legibility floor.** No SVG `<text>` below 12.5
    user units (node names 15), and no diagram renders below ~80% of its
    viewBox: the SVG's `min-width` is `--phos-svg-min` (default 1000px —
    set it per figure to 0.8 × the viewBox width, e.g.
    `style="--phos-svg-min:448px"` for a 560-wide figure). Narrower than
    that, the figure scrolls inside its frame instead of shrinking. Target:
    rendered diagram text ≥ 11px at 1440 and ≥ 9.5px at 390.
14. **Diagram colour is a declared meaning.** Routes and node kinds take the
    ANSI-derived `--phos-route-*` / `--phos-node-*` tokens through classes,
    never inline colour. Every route and kind a figure uses appears in its
    `.phos-legend`; every figure has a `.phos-figcap` provenance line and
    an `aria-label` on the `<svg>` that states the flow in words.

## 3. Layout (v2)

```html
<body class="phos-doc">
<div class="phos-page">
  <header>…eyebrow, title, subtitle, meta…</header>
  <div class="phos-layout">
    <nav class="phos-toc" aria-label="Contents">
      <div class="phos-toc-h">Index</div>
      <ol><li><a href="#context"><span>01</span>Context</a></li> …</ol>
    </nav>
    <main>
      <section class="phos-section">
        <div class="phos-sec-h" id="context"><span class="phos-sec-num">§ 01</span><h2>Context</h2></div>
        <h3 class="phos-h3">Sub-heading</h3> …
      </section>
    </main>
  </div>
  <footer class="phos-statusline">…</footer>
</div>
</body>
```

The rail is sticky beside the content from 1680px (below that it would
squeeze diagrams under their legibility floor) and folds into a bordered
block above it below that. It works as plain links; the optional
active-section marker is this inline script (progressive enhancement):

```html
<script>
(function () {
  if (!("IntersectionObserver" in window)) return;
  var links = document.querySelectorAll(".phos-toc a[href^='#']"), byId = {};
  links.forEach(function (a) { byId[a.getAttribute("href").slice(1)] = a; });
  var io = new IntersectionObserver(function (es) { es.forEach(function (e) {
    if (!e.isIntersecting) return;
    links.forEach(function (a) { a.classList.remove("is-active"); });
    if (byId[e.target.id]) byId[e.target.id].classList.add("is-active");
  }); }, { rootMargin: "0px 0px -70% 0px" });
  Object.keys(byId).forEach(function (id) { var el = document.getElementById(id); if (el) io.observe(el); });
})();
</script>
```

Skip the rail for short pages (fewer than four sections) — the shell is
still full width.

## 4. Choosing a mode

| Output | Mode | Body class |
|---|---|---|
| Investigation, post-mortem, design doc, run-book | **Document** | `phos-doc` |
| Dashboard, risk register, status page, fleet view | **Panel** | `phos-panels` |
| Mixed (report with an embedded dashboard section) | Document base; wrap panel sections in a `phos-panels` container |

Both modes share one ground — a terminal has one screen. Panel mode adds
the TUI cells (htop/k9s energy): bordered panels with reversed-video
headers, metric cards, dense 13px tables.

## 5. Document mode recipe

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

Voice: complete sentences; prose ≤ 76ch (`--phos-measure`, applied by
CSS); the verdict label comes from `data-label` and renders as
`[ LABEL ]` (use "Verdict", "Finding", "Open question" — whatever is
true). Design docs and architecture reviews add the §7 diagrams and §8
kit; lead with the container diagram, then the walkthrough steps.

## 6. Panel mode recipe

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

## 7. Architecture diagrams (v2)

Native SVG is the default for architecture, sequence and state diagrams.
Hand-author the `<svg>`; the stylesheet supplies every colour, dash and
motion through classes. Three figure containers share one grammar:
`figure.phos-arch` (container / system context), `figure.phos-seq`
(sequence), `figure.phos-state` (state machine). Each holds the `<svg>`,
one or two `.phos-legend` rows, and a `.phos-figcap`.

**Routes** — edge classes, each an ANSI hue *and* a dash pattern:

| Class | Token | Meaning | Line |
|---|---|---|---|
| `sync` | `--phos-route-sync` (cyan) | request / response hot path | solid; long dashes with `.phos-flow` |
| `async` | `--phos-route-async` (magenta) | events, queues, streams | short dashes |
| `data` | `--phos-route-data` (blue) | reads / writes to stores | solid |
| `ctrl` | `--phos-route-ctrl` (yellow) | auth, config, deploy; trust boundaries | solid |
| `ext` | `--phos-route-ext` (bright black) | third-party calls | dotted |
| `fail` | `--phos-route-fail` (red) | error, retry, dead letter, lost signal | sparse dashes |
| `ret` | `--phos-muted` | sequence return / neutral transition | fine dashes |

**Node kinds** — `<g class="phos-node <kind>">`, one hue and one shape each:

| Kind | Token | Shape |
|---|---|---|
| `client` | white | rect |
| `edge` | yellow | rect, heavy stroke |
| `svc` | cyan | rect |
| `fn` | bright magenta | chamfered rect (`path`) |
| `store` | blue | cylinder (`path.phos-shape` + `path.phos-rim`) |
| `queue` | magenta | rect + three `rect.phos-qbar` |
| `cache` | bright blue | rect + inner `line.phos-cbar`, text indented |
| `ext` | bright black | dashed rect |

State machines colour nodes by state instead: `ok` committed, `info` in
flight, `warn` parked, `crit` refused, `neutral` created. Terminal states
add `is-terminal` plus an inner `rect.phos-inner` (double frame); the
initial state is a `rect.phos-initial` square.

Node text: `.phos-nkind` (top-right kind badge, right-anchored),
`.phos-nlabel` (name, 15px), `.phos-nsub` (mono detail: tech, port),
`.phos-ntag` (kind-coloured emphasis: SLO, depth, lag). Modifiers on the
group: `is-hot` (on the hot path — heavier stroke), `is-fail` (red),
`is-new` (proposed — dashed green, tag reads `+NEW · ADR-nnn`).

**Furniture:** `rect.phos-zone` (dashed VPC / region / bounded context) and
`rect.phos-zone.trust` (trust boundary, ctrl hue) with `text.phos-zlabel`;
`text.phos-stage` column headers; `g.phos-step` reversed-video numbered
squares keyed to an `ol.phos-steps` walkthrough under the figure;
`text.phos-elabel` edge labels (add the route class + `is-key` to colour
them); crossings take an 8px hop arc (`A8,8 0 0 1`). Sequence diagrams add
`line.phos-lifeline`, `rect.phos-act <kind>` activation bars and
`g.phos-note`.

**Motion:** `.phos-flow` on an edge marches its dashes in the path's
direction; `rect.phos-pkt <route>` with `<animateMotion>` on the same `d`
sends a square packet along it. Use packets on one to three routes — the
ones the reader must follow. Both stop under reduced motion.

**Layout:** columns = stages left to right, rows on a fixed pitch (the
guide uses 140px rows, 80px nodes). `viewBox` ≈ 1200–1320 wide; all SVG
text is ≥ 12.5 user units (classes set this — never override smaller).
The SVG's `min-width` comes from `--phos-svg-min` (1000px default; set
0.8 × viewBox width on smaller figures), so phones scroll the figure
rather than shrink it. Draw order: zones → stage labels →
edges → nodes → edge labels → steps → packets. Mono text is ≈0.6em per
character — size boxes to fit the longest `nsub`.

Copy-paste skeleton (one service, one store, one animated edge, a packet):

```html
<figure class="phos-arch" style="--phos-svg-min:448px">
  <svg viewBox="0 0 560 140" role="img"
       aria-label="topup-api writes ledger rows to ledger-db over a data route.">
    <defs>
      <marker id="x-data" class="phos-mk data" viewBox="0 0 10 10" refX="10" refY="5"
              markerWidth="10" markerHeight="10" markerUnits="userSpaceOnUse"
              orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z"/></marker>
    </defs>
    <path class="phos-edge data phos-flow" d="M200,70 L340,70" marker-end="url(#x-data)"/>
    <g class="phos-node svc is-hot">
      <rect class="phos-shape" x="12" y="30" width="188" height="80"/>
      <text class="phos-nkind" x="190" y="46">SERVICE</text>
      <text class="phos-nlabel" x="26" y="66">topup-api</text>
      <text class="phos-nsub" x="26" y="84">Elixir · :4000</text>
      <text class="phos-ntag" x="26" y="100">SLO 99.95%</text>
    </g>
    <g class="phos-node store">
      <path class="phos-shape" d="M340,30 A88,9 0 0 1 516,30 V110 A88,9 0 0 1 340,110 Z"/>
      <path class="phos-rim" d="M340,30 A88,9 0 0 0 516,30"/>
      <text class="phos-nkind" x="506" y="55">DATABASE</text>
      <text class="phos-nlabel" x="354" y="75">ledger-db</text>
      <text class="phos-nsub" x="354" y="93">Postgres 16</text>
    </g>
    <rect class="phos-pkt data" x="-4" y="-4" width="8" height="8">
      <animateMotion dur="1.8s" repeatCount="indefinite" path="M200,70 L340,70"/>
    </rect>
  </svg>
  <div class="phos-legend">
    <span><i class="data"></i>data · ledger write</span>
    <span><i class="n svc"></i>service</span>
    <span><i class="n store"></i>database</span>
  </div>
  <figcaption class="phos-figcap">[src: platform/topology.yaml · rev YYYY-MM-DD]</figcaption>
</figure>
```

Marker ids are document-global: prefix them per figure (`a-sync`,
`s-sync`, …). Legend swatches: `<i class="<route>">` draws a line sample in
the route's dash pattern; `<i class="n <kind>">` a tinted square;
`<i class="n is-new">`, `<i class="note">`, `<i class="pkt">` cover the
modifiers.

**Mermaid fallback** — for ER, gantt, class and journey diagrams only,
pre-render to static SVG with this directory's dark-themed config:

```
npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg --configFile mermaid-config.json
```

Pre-rendered SVG is dark-baked: pin its figure to the dark ground
(`style="background:#0A0F0C"` — the one sanctioned literal hex) and keep the
DSL in a `<details>` beside it. Never ASCII art.

## 8. Engineering kit (v2)

| Component | Markup | Rule |
|---|---|---|
| Service cards | `.phos-svc-grid > .phos-svc <kind>` with `.phos-svc-h` (dot, `<b>` name, `.phos-svc-kind`), `.phos-svc-owner`, `.phos-kv` rows, `.phos-tags > .phos-tag`, `.phos-svc-deps` (`→` calls, `←` called by) | Top rule takes the node-kind colour — same hue as in the diagrams |
| API table | `table.phos-table.phos-api`; `.phos-method get\|post\|put\|patch\|delete`; path params in `.phos-param` | Columns: Method · Path · Auth · Idempotency · p95 · Status |
| Decision record | `article.phos-adr > header.phos-adr-h` (`.phos-adr-id`, `h4`, status chip) + `.phos-adr-b > .phos-adr-sec` (Context / Decision / Consequences) | Status chip: `[PROPOSED]` warn · `[ACCEPTED]` ok · `[SUPERSEDED]` neutral · `[REJECTED]` crit. Consequences are `ul.phos-diff` with `li.plus` / `li.minus` / `li.tilde` |
| Trade-off matrix | `table.phos-table.phos-tradeoff`; cells `td.good\|mid\|bad`; chosen row `tr.is-chosen` | Glyph (`+ ~ -`) and tint both carry the score — never colour alone |
| Latency budget | `.phos-budget > .phos-budget-h` + `.phos-budget-bar > span.<kind>[style="--w:N%"]` + `i.phos-budget-target[style="--at:N%"][data-label]` + a `.phos-legend` | Right edge = the SLO; segment widths are data (inline `--w` is allowed); label only segments ≥ 4% wide, put the rest in `title` + legend |
| Timeline | `ol.phos-timeline > li.phos-tl-item.<ok\|warn\|crit\|info>` with `<time>`, `span.phos-tl-mark`, `<div><b>…</b><p>…</p></div>` | Absolute timestamps, oldest first |
| Callout | `.phos-callout` (note) · `.warn` · `.risk` · `.decision` | Label comes from CSS; one idea per callout |
| File-headed code | `.phos-code > .phos-code-h` (`<b>path</b><span>lang</span>`) + `pre`; tokens `.k` keyword · `.s` string · `.n` number · `.c` comment | Highlight sparingly |

## 9. Anti-patterns

- **CRT cosplay**: scanline overlays, screen-curvature transforms, flicker
  or boot-sequence animations. Motion is the h1 cursor plus directional
  diagram flow — nothing else moves.
- **ASCII-art diagrams** — boxes drawn from `+--|` glyphs. Diagrams are
  SVG (Mermaid only as the fallback).
- **Rainbow diagrams** — a hue that isn't a route, node kind or state in the
  legend. Green as a route colour. Packets on every edge.
- **A centred 880px column** — v2 is full width; only prose is measured.
- **Proportional fonts sneaking in** (a serif heading, a sans UI label).
  One family, everywhere.
- **Green used for anything not ok / verified / accent** — a green border
  for taste, green prose, a green warn state.
- **More than one glow.** `--phos-glow` is spent on the h1.
- Typed rule glyphs (`────`) or typed dot-leaders (`....`) — furniture
  must stretch, so it is built from borders.
- Rounded corners, drop shadows, gradient anything.
- Webfonts, CDN assets, external images or scripts.

## 10. Changing the system

The system is versioned (`v2.0.0`, header of `phosphor.css`). Change tokens
or components only in this directory; bump the version and revision date in
`phosphor.css`, `index.html`, and this file together. A component that is
not demonstrated on the style-guide page is not in the system. Downstream
copies (inlined styles in old documents) are snapshots; they do not get
retrofitted.

## Changelog

- **v2.0.0 · 2026-10-07** — engineering edition: full-width shell
  (`--phos-gutter`, `--phos-measure`), `.phos-layout` + `.phos-toc` index
  rail (≥1680px), 15px body, SVG text floor 12.5 + `--phos-svg-min`, `.phos-h3`; ANSI palette tokens with derived
  `--phos-route-*` / `--phos-node-*`; native SVG diagram grammar
  (`.phos-arch`, `.phos-seq`, `.phos-state`, nodes, edges, flow, packets,
  zones, steps, legend, figcap); service cards, API table, ADR, trade-off
  matrix, latency budget, timeline, callouts, file-headed code. v1 classes
  unchanged.
- **v1.0.0 · 2026-07-30** — initial release.

## Lineage

VT220/DEC terminals (palette, paper-terminal light theme) · tmux/vim
statuslines (colophon) · htop/k9s TUI dashboards (panel mode) · ANSI-16
terminal palette (diagram routes and node kinds) · C4 model (diagram levels) · Berkeley
Mono specimen culture (mono-everything discipline) · DDS (token and
evidence discipline).
