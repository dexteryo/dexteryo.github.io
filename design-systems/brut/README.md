# Brut Design System

**v2.0.0 · 2026-10-07 · Béton brut for engineering documents — engineering edition.**

A neo-brutalist design system for AI-generated engineering HTML: reports,
dashboards, and status boards that shout their structure and whisper their
prose. Loud but disciplined — the grid underneath is strict. Version 2
pours the page full width and adds a native SVG architecture grammar plus
the engineering components a design doc needs.

| Resource | Location |
|---|---|
| Living style guide (view this) | <https://dexteryo.github.io/design-systems/brut/> |
| Canonical stylesheet | [`brut.css`](brut.css) |
| This spec (agent-facing) | `README.md` (this file) |
| Mermaid pre-render config (static SVG) | [`mermaid-config.json`](mermaid-config.json) |
| Local source of truth | `~/dotfiles/dexteryo.github.io/design-systems/brut/` |
| Sibling system (default) | `~/dotfiles/dexteryo.github.io/design-system/` (DDS) |

**If you are an AI agent generating HTML output for Dexter in the Brut
style: this file is your contract.** Read `brut.css` for exact values; this
file tells you which pieces to use and the rules you must not break.

---

## 1. The system in one paragraph

Everything sits in a box, and every box shows its edges: 3px black borders,
hard offset shadows with zero blur (5px for cards, 3px for small elements),
radius 0 everywhere except the sticker-pill chips. One display face —
Helvetica at 800–900 weight, uppercase, tight tracking — does the shouting;
body prose stays at weight 400, 17px/1.65, capped at 72ch. The single accent
is acid yellow `#FFD43A`, used as **fills only** with black text and black
borders on top — yellow never colours type. Semantic colours (ok green,
warn orange, crit red, info blue) are also fills: square status dots and
pale sticker tints whose text stays black. Documents are zines (bordered
frame, chunky rules); dashboards are sticker sheets (discrete slabs on the
cream ground). No gradients, no soft shadows, no grey-on-grey. The page
is fluid full width with a sticky contents rail; prose keeps a 72ch
measure while diagrams, tables and grids take the whole shell. Systems are
drawn, not narrated: architecture, sequence and state diagrams are native
SVG — acid sticker nodes coloured by kind, 3px edges coloured by route,
square packets riding the hot path — and every hue is in the legend.

## 2. Hard rules (never break these)

1. **Tokens only.** Every colour, font, space, and border weight comes from
   a `--brut-*` custom property. Never hard-code a hex in a component.
2. **System font stacks only, nothing from a CDN.** No webfonts, no
   `@font-face`, no external requests. JavaScript must be inlined/same-origin
   and progressive enhancement — the page must read if scripts never run.
3. **Self-contained output.** For a standalone file or artifact, inline the
   whole of `brut.css` into a `<style>` block (all three token blocks).
   Link the stylesheet only for pages hosted next to it.
4. **Both themes.** Light tokens, `@media (prefers-color-scheme: dark)`
   counterpart, and explicit `:root[data-theme=…]` overrides. Never restyle
   components per theme — tokens flip, components stand still.
5. **Yellow is a fill, never a text colour.** The accent carries black text
   (`--brut-accent-ink`) and a black border. One acid-filled hero element
   per context (one hero metric per board, one pull quote per section).
6. **Semantic colours are fills too.** ok green · warn orange · crit red ·
   info blue, each with a pale flat tint for chips. Text on a tint is
   always black. Status colours never set type.
7. **Borders are 3px; hairlines are 1.5px.** Nothing thinner exists.
   Shadows are hard offsets of the shadow token — never blurred, never
   translucent.
8. **Radius 0.** The only rounded element in the system is the chip
   (`--brut-r-chip`). A rounded card is a defect.
9. **Stay on the spacing scale.** 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64
   (`--brut-s1…s8`).
10. **Numbers are tabular.** Digit columns get `.brut-num`, right-aligned
    in tables.
11. **Evidence is a visual element.** Claims cite their source (`file:line`,
    ticket, date verified) as a `.brut-evidence` mono tag straight after the
    claim; in Panel mode the `.brut-reg-meta` column carries it.
12. **Loudness lives in furniture, not body text.** Prose is weight 400 and
    never uppercase. Headings, tabs, stamps, and fills do the shouting.
13. **No AI attribution** in the output.
14. **Structure must be true.** Numbered tabs only when order matters; a
    verdict stamp only when there is a verdict; `.brut-tilt` on at most one
    element per page, and only where a wink is appropriate.
15. **Full width, readable measure.** Use `.brut-page` (fluid, gutter
    `--brut-gutter`) and, for anything with more than three sections,
    `.brut-layout` with a `.brut-toc` rail. Never re-centre the page in a
    narrow column. Prose caps at `--brut-measure` (72ch); wide furniture
    spans the shell. No horizontal page scroll at 375px — wide figures and
    tables scroll inside their own frame.
16. **Systems are drawn in the native grammar (§7).** Architecture,
    sequence and state diagrams are hand-authored SVG with `brut-*`
    classes — never ASCII art, screenshots, or Mermaid. Every route and
    node colour used appears in the figure's `.brut-legend`; every figure
    closes with a `.brut-figcap` (source + revision date) and carries
    `role="img"` plus an `aria-label` that states what flows where.
    Diagrams are sized for reading: `viewBox` ≤ ~990 units wide, SVG type
    ≥ 12 units, so the smallest text box is ≥13px at 1440 and ≥10px at 390
    (where the figure scrolls in its frame).
17. **Colour in diagrams is meaning.** Route hues: sync blue · async
    magenta · data green · ctrl violet · ext burnt orange · fail red.
    Node kinds: client pink · edge sky · svc paper · fn lilac · store lime ·
    queue orange · cache mint · ext kraft (dashed). The acid accent marks
    the hot path's slab only. Node stickers and method stickers are
    theme-invariant paper with black type, exactly like chips.
18. **Motion is directional.** `.brut-flow` dashes march with the flow;
    `.brut-pkt` square packets ride one to three key routes. Both stop
    under `prefers-reduced-motion`. Nothing else moves except the button
    press and node hover nudge.

## 3. Layout

```html
<body class="brut-doc"><div class="brut-page">
  <header class="brut-masthead">…</header>
  <div class="brut-layout">
    <nav class="brut-toc" aria-label="Contents">
      <div class="brut-toc-h">Contents</div>
      <ol><li><a href="#context"><span>01</span>Context</a></li>…</ol>
    </nav>
    <main class="brut-frame">
      <section class="brut-section" id="context">…</section>
    </main>
  </div>
  <footer class="brut-colophon">…</footer>
</div>
<script>
  (function () {
    if (!('IntersectionObserver' in window)) return;
    var links = {};
    document.querySelectorAll('.brut-toc a[href^="#"]').forEach(function (a) { links[a.hash.slice(1)] = a; });
    var io = new IntersectionObserver(function (es) { es.forEach(function (e) {
      if (!e.isIntersecting || !links[e.target.id]) return;
      Object.keys(links).forEach(function (k) { links[k].classList.remove('is-active'); });
      links[e.target.id].classList.add('is-active');
    }); }, { rootMargin: '-20% 0px -70% 0px' });
    Object.keys(links).forEach(function (id) { var s = document.getElementById(id); if (s) io.observe(s); });
  })();
</script>
</body>
```

From 1200px the rail sits sticky beside the frame; below that it stacks
above the content as a two-column link list. The rail works as plain
anchors without script; the observer only adds `.is-active`. Short pages
(three sections or fewer) may drop the rail and put `.brut-frame` straight
inside `.brut-page`.

## 4. Choosing a mode

| Output | Mode | Body class |
|---|---|---|
| Investigation, design doc, post-mortem, RFC, wiki export | **Document** | `brut-doc` |
| Dashboard, risk register, status page, run-book summary | **Panel** | `brut-panels` |
| Mixed (report with an embedded dashboard section) | Document base; wrap panel sections in a `brut-panels` container |

## 5. Document mode recipe

```html
<body class="brut-doc">
<div class="brut-page">
  <header class="brut-masthead">
    <div class="brut-eyebrow">Doc type · Project · Context</div>
    <div class="brut-masthead-b">
      <h1 class="brut-title">Headline with <mark>one filled</mark> key word</h1>
      <p class="brut-subtitle">Stand-first: the problem and the conclusion.</p>
    </div>
    <dl class="brut-meta">
      <div><dt>Author</dt><dd>Dexter</dd></div>
      <div><dt>Date</dt><dd>YYYY-MM-DD</dd></div>
      <div><dt>Status</dt><dd>Draft / Final</dd></div>
    </dl>
  </header>

  <div class="brut-frame">
    <section class="brut-section">
      <div class="brut-sec-h"><span class="brut-sec-num">01</span><h2>Section title</h2></div>
      <p>Prose with a claim.
        <span class="brut-evidence">WalletService.java:214 · 2026-07-29</span></p>
      <blockquote class="brut-pull brut-tilt"><strong>The point:</strong> one sentence that earns the fill.</blockquote>
    </section>

    <section class="brut-section">
      <div class="brut-sec-h"><span class="brut-sec-num">02</span><h2>Next section</h2></div>
      <p>…</p>
    </section>
  </div>

  <div class="brut-verdict" data-label="Recommendation">
    <div class="brut-verdict-b">
      <h3>The verdict in one sentence.</h3>
      <p>Short rationale.</p>
      <ol><li>Action 1.</li><li>Action 2.</li></ol>
    </div>
  </div>

  <footer class="brut-colophon"><div>Title · date</div><div>Author</div></footer>
</div>
</body>
```

Components: `.brut-stats` (headline numbers in a divided slab — keep the
cell count able to fill its row), `.brut-table-wrap` + `.brut-table`
(3px header rule, hairline rows, `tr.brut-total` acid-filled closing row),
`pre`/`code` (warm code slab), `.brut-btn` (press-into-shadow, cosmetic).

Voice: complete sentences; prose ≤ 72ch; the stamp label comes from
`data-label` ("Recommendation", "Finding", "Open question" — whatever is
true). The masthead eyebrow is the only full-width yellow strip in the
header.

## 6. Panel mode recipe

```html
<body class="brut-panels">
<div class="brut-page">
  <div class="brut-board-h"><h1>Board title</h1>
    <span class="brut-board-meta">refreshed YYYY-MM-DD HH:MM</span></div>

  <div class="brut-metric-grid">
    <div class="brut-metric brut-hero"><div class="brut-metric-l">Hero metric</div>
      <div class="brut-metric-v">1,284<span class="brut-unit">unit</span></div></div>
    <div class="brut-metric"><div class="brut-metric-l">Label</div>
      <div class="brut-metric-v">99.98<span class="brut-unit">%</span></div></div>
  </div>

  <div class="brut-panel">
    <div class="brut-panel-h"><h3>Panel title</h3><span class="brut-panel-meta">meta</span></div>
    <div class="brut-panel-b">
      <div class="brut-kv"><span>Key</span><b>value</b></div>
      <div class="brut-reg-row"><span class="brut-dot warn"></span><b>Risk title</b>
        <span class="brut-reg-meta">TICKET-123</span></div>
    </div>
  </div>

  <span class="brut-chip ok">verified</span>
  <span class="brut-chip warn">in review</span>
</div>
</body>
```

Status vocabulary: `ok` = verified / healthy · `warn` = in-review /
degraded · `crit` = stale / failing · `info` = informational · `neutral` =
draft / unknown. Square dots for rows, sticker chips for inline labels —
pick one per context, not both. At most one `.brut-hero` metric per board.

## 7. Architecture diagrams (native SVG)

Three frames share one grammar: `.brut-arch` (topology / container view),
`.brut-seq` (sequence), `.brut-state` (lifecycle). Each frame is a slab
that scrolls sideways below its SVG's `min-width` (default 720px; override
per figure with `style="--brut-min-w: 900px"`). Close every frame with a
`.brut-legend` and a `.brut-figcap`.

**Size for reading, not for fit.** Beside the contents rail at 1440 the
frame gives an SVG about 915px, so keep the `viewBox` **no wider than
~990 units** (relayout, shorten names, or drop a column rather than
widen) and never set SVG type below **12 units** (`.brut-nlabel` 13). That
renders every text box at ≥13px tall at 1440. On phones the SVG keeps its
720px `min-width` and scrolls inside its frame, which holds text boxes at
≥10px at 390. Check with a headless browser: the smallest
`svg text` bounding-box height must be ≥13 at 1440 and ≥10 at 390, with
no horizontal page scroll.

**Draw order:** zones → edges → packets → nodes → step markers. Packets
then slide *under* the nodes they pass through, which reads as a request
traversing a hop.

**Nodes** — `<g class="brut-node <kind> [is-hot|is-fail|is-new]">` holding
a `.brut-nshape` and up to three text lines (`.brut-nlabel` name,
`.brut-nsub` mono detail, `.brut-ntag` mono emphasis). The standard node
is 128 × 64 on a 168-unit column pitch (six columns in 990). Text x = node
x + 12; label y + 27, sub y + 46 (three lines: +22 / +39 / +55). In a
128-unit node keep `.brut-nlabel` ≤ 12 characters and `.brut-nsub` ≤ 13 —
`wallet-svc`, not `wallet-service`.

| Kind | Sticker | Shape |
|---|---|---|
| `client` | pink | rect |
| `edge` (gateway, CDN, LB) | sky | rect |
| `svc` | paper white | rect |
| `fn` (worker, lambda, job) | lilac | rect |
| `store` | lime | cylinder: `.brut-nshape` silhouette path + `.brut-ncap` front lip |
| `queue` (topic, stream) | orange | rect + `.brut-nbars` (three bars at the right) |
| `cache` | mint | rect |
| `ext` (third party) | kraft | rect, dashed outline |

State: `is-hot` = acid slab (the path that matters) · `is-fail` = red
outline and red slab · `is-new` = proposed, dotted outline, no slab.

**Edges** — `<path class="brut-edge <route>" marker-end="url(#<id>)">`, one
`<marker class="brut-m <route>">` per route used. Routes: `sync`
request/response · `async` events, queues (dashed) · `data` store reads and
writes · `ctrl` auth, config, deploy · `ext` third-party calls · `fail`
error, retry exhausted, dead-letter (dotted) · `ret` sequence returns (thin
grey dashed). End the path 3px short of the target edge; the marker tip
lands on it. Add `brut-flow` for marching dashes. Label edges with
`.brut-elabel` (mono, haloed in the surface colour).

**Packets** — `<rect class="brut-pkt <route>" x="-5" y="-5" width="10"
height="10"><animateMotion dur="3s" repeatCount="indefinite" path="…"/></rect>`.
Square, never round. One to three per figure; stagger with `begin`.

**Zones** — `<rect class="brut-zone">` + `<text class="brut-zlabel">` for a
VPC, region, account or bounded context; `.brut-zone.trust` (red dashes)
for a security boundary.

**Stages and steps** — `.brut-stage` mono labels above the columns;
`<g class="brut-step"><rect width="22" height="22"/><text>n</text></g>`
black squares on edges, keyed to an `<ol class="brut-steps">` walkthrough
under the figure.

**Sequence** — actors reuse `.brut-node` groups across the top;
`.brut-life` dashed lifelines; `.brut-actbar` activation bars; messages
reuse `.brut-edge` (sync / data / ext / async / fail / ret); a
`.brut-note` rect + `.brut-notetext` is the acid post-it.

**State** — `<g class="brut-st [ok|warn|crit|info] [final]">` with a
`.brut-nshape` rect; `ok` money moved / done, `warn` transient, `crit`
rejected, `info` reversed; `final` = terminal (6px outline). The initial
pseudo-state is a `.brut-st-start` black square. Transitions are edges
whose route class carries their meaning (declare it in the legend).

```html
<figure class="brut-arch">
<svg viewBox="0 0 990 440" role="img" aria-label="What flows where, and where it breaks">
  <defs>
    <marker id="a-sync" class="brut-m sync" viewBox="0 0 10 10" refX="10" refY="5"
      markerWidth="4" markerHeight="4" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z"/></marker>
    <marker id="a-data" class="brut-m data" viewBox="0 0 10 10" refX="10" refY="5"
      markerWidth="4" markerHeight="4" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z"/></marker>
  </defs>
  <rect class="brut-zone" x="160" y="36" width="670" height="388"/>
  <text class="brut-zlabel" x="172" y="55">eu-west-1 · prod VPC</text>

  <path class="brut-edge sync brut-flow" d="M306,116 H343" marker-end="url(#a-sync)"/>
  <path class="brut-edge data" d="M410,148 V329" marker-end="url(#a-data)"/>
  <rect class="brut-pkt sync" x="-5" y="-5" width="10" height="10">
    <animateMotion dur="3s" repeatCount="indefinite" path="M306,116 H410 V329"/></rect>

  <g class="brut-node svc is-hot">
    <rect class="brut-nshape" x="346" y="84" width="128" height="64"/>
    <text class="brut-nlabel" x="358" y="111">payments-api</text>
    <text class="brut-nsub" x="358" y="130">Kotlin · 180ms</text></g>
  <g class="brut-node store">
    <path class="brut-nshape" d="M346,340 A64,8 0 0 1 474,340 V388 A64,8 0 0 1 346,388 Z"/>
    <path class="brut-ncap" d="M346,340 A64,8 0 0 0 474,340"/>
    <text class="brut-nlabel" x="358" y="368">wallet-db</text>
    <text class="brut-nsub" x="358" y="386">Postgres 16</text></g>

  <g class="brut-step"><rect x="315" y="87" width="22" height="22"/><text x="326" y="98">1</text></g>
</svg>
<div class="brut-legend">
  <span><i class="sync"></i>request / response</span>
  <span><i class="data"></i>store write</span>
  <span><i class="node"></i>service</span><span><i class="node store"></i>store</span>
  <span><i class="hot"></i>hot path</span><span><i class="zone"></i>network zone</span>
</div>
<figcaption class="brut-figcap"><span>Fig. 1 · Title</span><span>Source: path/to/truth · rev YYYY-MM-DD</span></figcaption>
</figure>
<ol class="brut-steps"><li>What step 1 does.</li></ol>
```

Cylinder for a store at (x, y, w, h): silhouette
`M x,y+8 A w/2,8 0 0 1 x+w,y+8 V y+h-8 A w/2,8 0 0 1 x,y+h-8 Z`, lip
`M x,y+8 A w/2,8 0 0 0 x+w,y+8`. Legend swatches: `<i class="<route>">`
for edges, `<i class="node <kind>">` for nodes (`node new` dotted),
`<i class="hot">`, `<i class="state ok|warn|crit|info">`,
`<i class="zone">`, `<i class="zone trust">`.

**Mermaid fallback** — only for shapes the grammar does not cover (Gantt,
ER, mind map, class diagrams): pre-render to static SVG with this
directory's `mermaid-config.json` (`npx -y @mermaid-js/mermaid-cli -i d.mmd
-o d.svg --configFile mermaid-config.json`), inline it in a `.brut-diagram`
slab, keep the DSL beside it in a `<details>`. Pre-rendered SVG is
light-baked: pin the figure to `style="background:#FBF6EC"` — the one
sanctioned literal hex.

## 8. Engineering components

| Need | Component | Notes |
|---|---|---|
| Who owns what | `.brut-svc-grid` > `article.brut-svc <kind>` | Header strip `.brut-svc-h` (status `.brut-dot`, `h3`, `.brut-svc-kind`) wears the node-kind fill; body `.brut-svc-b` with `.brut-tags` > `.brut-tag` and `.brut-kv` rows; footer `.brut-svc-f` lists deps (`→` calls, `←` called by). Fill rows of the grid — six cards, not four. |
| What the API promises | `table.brut-table.brut-api` | `.brut-method get|post|put|patch|delete` stickers; `.brut-path` mono with `<i>{param}</i>`; columns Method · Path · Auth · Idempotency · p95. |
| What was decided | `article.brut-adr` | `.brut-adr-h` = `.brut-adr-id` tab + `h3` + status chip (`.brut-chip proposed|accepted|rejected|superseded`); `.brut-adr-b` cells with `.brut-adr-k` labels for Context / Decision / Consequences; consequences in `ul.brut-cons` (`li` = pro `+`, `li.meh` `~`, `li.con` `−`). |
| Options compared | `table.brut-table.brut-tradeoff` | Cells `td.good|meh|bad` (tint + symbol); `th.is-chosen` takes the acid fill. |
| Where the milliseconds go | `.brut-budget` | `.brut-budget-bar` of `.brut-seg <kind>` with `style="--w:NN%"` (share of the scale), `b` hop + `span` ms; `.brut-seg.slack` for headroom; `.brut-budget-target style="--at:75%" data-label="SLO 300ms"`; `.brut-budget-scale` ticks. |
| What happened when | `ol.brut-timeline` > `li.brut-tl-item ok|warn|crit|info|accent` | `.brut-tl-time`, `.brut-tl-title`, optional `p`. |
| Asides | `.brut-callout [warn|risk|decision]` > `.brut-callout-b` > `.brut-callout-t` + `p` | Default is a note (info stripe); decision uses the acid stripe. |
| Code with provenance | `.brut-code` > `.brut-code-h` (`span` filename, `span` language) + `pre` | Filenames keep their case; the language tag is uppercase. |

## 9. Data visualisation

Charts use `--brut-v1…v6` in order (v1 is the acid yellow — fine as a bar
fill, never as a text label colour). Outline marks in `--brut-border` at
1.5–3px so fills stay flat and honest; no gradients on bars, no soft
drop-shadows on anything.

## 10. Anti-patterns

- **Gradients.** Anywhere, of any kind. Fills are flat.
- **Blur or soft shadows.** Shadows are hard offsets of the shadow token.
- **Low-contrast grey-on-grey.** Ink on ground or nothing.
- **Yellow text.** The accent is a fill under black type, full stop.
- **Rounded cards.** Radius 0; only chips round.
- **More than one display face.** Helvetica shouts and talks; mono attests.
- **Borders thinner than 1.5px.** A 1px hairline is another system.
- **Decoration replacing hierarchy.** A fill or tilt never substitutes for
  a real heading, a real number, or a real verdict.
- Uppercase body prose, more than one tilt per page, more than one hero
  fill per context, shadows in print.
- **A centred 900px column.** v2 pours full width; only prose keeps a
  measure.
- **A diagram hue without a legend entry,** packets on every edge,
  ASCII-art or screenshot topology, Mermaid where the native grammar fits.
- **Colliding marker IDs.** Prefix them per figure (`a-sync`, `s-sync`).

## 11. Changing the system

The system is versioned (`v2.0.0`, header of `brut.css`). Change tokens or
components only in this directory; bump the version and revision date in
`brut.css`, `index.html`, and this file in the same change. A component
that is not demoed on the style-guide page is not in the system. Downstream
copies (inlined styles in shipped documents) are snapshots; they do not get
retrofitted.

## Changelog

- **v2.0.0 · 2026-10-07** — engineering edition. Fluid full-width shell
  with a sticky contents rail; body 17px/1.65 at a 72ch measure; route,
  node-kind and HTTP-method tokens; reading-size rule for diagrams
  (viewBox ≤ ~990 units, SVG type ≥ 12 units); native SVG grammar for architecture,
  sequence and state diagrams (sticker nodes, route edges, marching
  dashes, square packets, zones, step markers); service cards, API tables,
  ADRs, trade-off matrices, latency budgets, timelines, callouts,
  captioned code. v1 class names are unchanged; `.brut-diagram` stays as
  the Mermaid fallback frame.
- **v1.0.0 · 2026-07-30** — initial release.

## Lineage

Brutalist web (Bloomberg circa 2016) · Gumroad/Figma-brut marketing pages ·
risograph zine print (flat spot colour, hard registration) · Memphis group
as the restraint check — energy without chaos.
