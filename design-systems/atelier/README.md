# Atelier

**v2.0.0 · 2026-10-07 · Financial-grade trust through magazine typography — engineering edition.**

A sibling to the Dexter Design System (DDS) for AI-generated engineering
HTML in the editorial-serif idiom: reports set like a literary magazine,
dashboards set like a print data page, architecture drawn as printed plates
in pigment inks.

| Resource | Location |
|---|---|
| Living style guide (view this) | <https://dexteryo.github.io/design-systems/atelier/> |
| Canonical stylesheet | [`atelier.css`](atelier.css) |
| This spec (agent-facing) | `README.md` (this file) |
| Mermaid pre-render config (static SVG) | [`mermaid-config.json`](mermaid-config.json) |
| Local source of truth | `~/dotfiles/dexteryo.github.io/design-systems/atelier/` |

**If you are an AI agent generating Atelier output for Dexter: this file is
your contract.** Read `atelier.css` for exact values; this file tells you
which pieces to use and the rules you must not break.

---

## 1. The system in one paragraph

Atelier is the Stripe Press / literary-magazine lineage: big confident serif
display set at LIGHT weights (lightness is the luxury — bold display is
shouting), Charter body at book sizes, generous whitespace doing the
structural work, hairline rules instead of boxes, one oxblood accent, warm
gallery-white paper. Documents open with a drop cap and an italic
stand-first under a double-ruled masthead; sections are numbered as folios
("№ 01"); evidence gathers in numbered footnote strips at the end of each
section, cited in monospace. Dashboards follow the Economist/FT print-data
idiom — hairline horizontal rules, very large light serif numerals, square
(■) status markers, underlined small-caps chips — on the same warm paper.

Since v2 the page is a broadsheet: a fluid full-width shell with a sticky
contents rail on wide screens, prose held to a 70ch book measure, and every
wide element (diagrams, tables, stat strips, service directories) using the
whole column. Architecture, sequence, and state diagrams are native SVG
plates in a case of pigment inks — one ink per route meaning and per node
kind, declared in a legend — with directional motion on the hot path.

## 2. Hard rules (never break these)

1. **Tokens only.** Every colour, font, space comes from an `--atl-*`
   custom property. Never hard-code a hex value in a component — in SVG,
   colour comes from the `atl-*` classes, never `fill="#…"`.
2. **System font stacks only, nothing from a CDN.** No webfont `<link>`,
   no `@font-face`, no external requests. JavaScript, if any, is inlined
   and progressive enhancement — the page must read if scripts never run.
3. **Self-contained output.** For a standalone file or artifact, inline
   `atelier.css` into a `<style>` block (all three token blocks: light,
   `@media` dark, `data-theme` overrides). Link the stylesheet only for
   pages hosted next to it.
4. **Both themes, token flips only.** Never restyle a component inside a
   media query.
5. **Display type is light.** Titles, section heads, stat numerals, pull
   quotes: `--atl-display` at weight 300, tight leading. Bold display
   weights are forbidden — emphasis comes from size, space, and italics.
6. **One accent, spent sparingly.** Oxblood (`--atl-accent`) appears in the
   drop cap, the hanging quotation mark, at most one emphasised word in the
   title (`<em>`), the verdict label, the active contents link, and the
   outline of a *proposed* diagram node. Never as a background, never as
   decoration. Semantic colours and diagram pigments are not accents.
7. **Rules, not boxes.** Structure is horizontal hairlines (`--atl-rule`)
   and strong single rules (`--atl-ink`); the double rule is reserved for
   the masthead, board header, colophon, and the table total. No cards, no
   borders-as-boxes, no shadows. Radius 0 everywhere. The only boxes are
   diagram nodes inside an SVG plate — square too.
8. **Evidence is a footnote strip.** Claims carry a superscript
   `.atl-fnref`; each section closes with `.atl-footnotes` (short printer's
   rule, numbered notes, monospace `.atl-cite` with file:line / ticket /
   date verified). Never margin sidenotes — sidenotes belong to DDS.
9. **Stay on the spacing scale.** 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64
   (`--atl-s1…s8`).
10. **Numbers are tabular.** Digit columns get `.atl-num`, right-aligned.
    Charts use `--atl-v1…v6` in order.
11. **No AI attribution** in the output.
12. **Structure must be true.** Folio numbers only when order matters; one
    drop cap per document, on the opening paragraph only; a verdict only
    when there is a verdict.
13. **Full width, book measure.** Wrap the page in `.atl-page` (fluid,
    gutter `--atl-gutter`); never re-impose a 760px centred column. Prose
    stays at `--atl-measure` (70ch). Documents with four or more sections
    use `.atl-layout` with an `.atl-toc` rail. No horizontal page scroll at
    375px — wide plates and tables scroll inside `.atl-plate` /
    `.atl-table-wrap`. Diagram text renders ≥ 11px at 1440px and ≥ 9.5px
    at 390px (§6): plates keep a `min-width` and scroll on phones.
14. **Pigments mean one thing.** Route inks (`--atl-route-*`) and node-kind
    inks (`--atl-node-*`) carry the fixed meanings in §6; every ink used in
    a plate appears in its `.atl-legend`. A pigment used for decoration is
    a defect.
15. **Motion is directional only.** `.atl-flow` marching dashes and
    `.atl-pkt` travelling packets, on the 1–3 routes that matter. Both stop
    under `prefers-reduced-motion` and in print. No other animation.

## 3. Choosing a mode

| Output | Mode | Body class |
|---|---|---|
| Investigation, design essay, post-mortem, RFC, wiki export | **Document** | `atl-doc` |
| Dashboard, risk register, status page, run-book summary | **Panel** | `atl-panels` |
| Mixed (report with an embedded data page) | Document base; wrap panel sections in an `atl-panels` container |

## 4. Document mode recipe

```html
<body class="atl-doc">
<div class="atl-page">
  <header class="atl-masthead">
    <div class="atl-eyebrow">Doc type · Project · Context</div>
    <h1 class="atl-title">Headline with <em>one accented</em> key word</h1>
    <p class="atl-standfirst">Italic stand-first: the problem and the conclusion.</p>
  </header>
  <dl class="atl-meta">
    <div><dt>Author</dt><dd>Dexter</dd></div>
    <div><dt>Date</dt><dd>YYYY-MM-DD</dd></div>
    <div><dt>Status</dt><dd>Draft / Final</dd></div>
  </dl>

  <div class="atl-layout">
  <nav class="atl-toc" aria-label="Contents">
    <div class="atl-toc-t">Contents</div>
    <ol><li><a href="#context"><span>01</span>Section title</a></li></ol>
  </nav>
  <main>

  <section class="atl-section" id="context">
    <div class="atl-sec-h"><span class="atl-folio">№ 01</span><h2>Section title</h2></div>
    <p class="atl-dropcap">Opening paragraph of the piece — the only one
      with a drop cap.<sup class="atl-fnref">1</sup></p>
    <p>Further prose with a claim.<sup class="atl-fnref">2</sup></p>
    <div class="atl-footnotes">
      <p class="atl-fn"><span class="atl-fn-num">1.</span>
        <span class="atl-cite">path/to/File.java:214</span> — verified YYYY-MM-DD.</p>
      <p class="atl-fn"><span class="atl-fn-num">2.</span>
        <span class="atl-cite">TICKET-123</span> — status at YYYY-MM-DD.</p>
    </div>
  </section>

  <div class="atl-verdict" data-label="Recommendation">
    <h3>The verdict in one sentence.</h3>
    <p>Short rationale.</p>
    <ol><li>Action 1.</li><li>Action 2.</li></ol>
  </div>

  </main>
  </div>

  <footer class="atl-colophon"><div>Title · date</div><div>Author</div></footer>
</div>
</body>
```

Components: `.atl-stats` (light display numerals between rules),
`.atl-table` (hairline rows, `tr.atl-total` closes with a double rule),
`.atl-pull` (pull quote with the oversized hanging accent quotation mark),
`pre`/`code` (warm code plate). The drop cap goes on the document's opening
paragraph, once. The footnote strip closes every section that made a claim.
Architecture content adds the §6 plates and §7 components. Short documents
(under four sections) may drop the `.atl-layout` wrapper and the rail.

Contents-rail highlight (optional, inline before `</body>`; the rail works
as plain links without it):

```html
<script>
(function () {
  if (!('IntersectionObserver' in window)) return;
  var links = {};
  document.querySelectorAll('.atl-toc a[href^="#"]').forEach(function (a) { links[a.getAttribute('href').slice(1)] = a; });
  var io = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (!e.isIntersecting || !links[e.target.id]) return;
      Object.keys(links).forEach(function (k) { links[k].classList.toggle('is-active', k === e.target.id); });
    });
  }, { rootMargin: '-20% 0px -70% 0px' });
  document.querySelectorAll('main section[id]').forEach(function (s) { io.observe(s); });
})();
</script>
```

Voice: complete sentences; prose ≤ 70ch (`--atl-measure`, applied automatically); the verdict label comes from
`data-label` ("Recommendation", "Finding", "Colophon" — whatever is true).

## 5. Panel mode recipe

```html
<body class="atl-panels">
<div class="atl-page">
  <div class="atl-board-h"><h1>Board title</h1>
    <span class="atl-board-meta">meta · YYYY-MM-DD HH:MM</span></div>

  <div class="atl-metric-strip">
    <div><div class="atl-metric-l">Label</div>
      <div class="atl-metric-v">1,284<span class="atl-unit">unit</span></div></div>
  </div>

  <div class="atl-panel">
    <div class="atl-panel-h"><h3>Panel title</h3><span class="atl-panel-meta">meta</span></div>
    <div class="atl-panel-b">
      <div class="atl-kv"><span>Key</span><b>value</b></div>
      <div class="atl-reg-row"><span class="atl-sq warn"></span><b>Risk title</b>
        <span class="atl-reg-meta">TICKET-123</span></div>
    </div>
  </div>

  <span class="atl-chip ok">verified</span>
  <span class="atl-chip warn">in review</span>
</div>
</body>
```

Status vocabulary: `ok` = verified / healthy · `warn` = in-review /
degraded · `crit` = stale / failing · `info` = informational · `neutral` =
draft / unknown. Squares (`.atl-sq`) for rows, underlined small-caps chips
(`.atl-chip`) for inline labels — one per context, not both. A panel is a
titled run of rows opened by a strong rule; it is never a box.

## 6. Architecture diagrams (native SVG plates)

The default for architecture, sequence, and state diagrams. Wrap the SVG in
`.atl-plate` (scroll container) inside a figure: `.atl-arch` (container /
system context), `.atl-seq` (sequence), or `.atl-state` (state machine).
Follow it with `.atl-legend` and `.atl-figcap` ("Fig. № 1 — title. Source:
… , verified YYYY-MM-DD"). `role="img"` and an `aria-label` that narrates
the flow on every `<svg>`. `viewBox` ≈ `0 0 1200 H`, no `width` attribute.

**Route inks** — `<path class="atl-edge <route>">` + `marker-end`:

| Route | Ink | Meaning |
|---|---|---|
| `sync` | indigo | request/response hot path |
| `async` | plum, dashed | events, queues, streams |
| `data` | verdigris | reads/writes to stores |
| `ctrl` | ochre | control plane: auth, config, deploy |
| `ext` | slate | third-party calls |
| `fail` | red, dotted | error, retry, dead-letter, lost signal |
| `ret` | muted, dashed | sequence return message |

Add `atl-flow` for marching dashes in the direction of travel. Define one
`<marker class="atl-m <route>">` per route used, with ids unique per page
(prefix per figure: `a-sync`, `s-sync`…). Packets:
`<circle class="atl-pkt <route>" r="4"><animateMotion …/></circle>` on at
most three routes. Edge labels: `<text class="atl-elabel">` (add `fail` to
recolour).

**Node kinds** — `<g class="atl-node <kind>">` containing an
`.atl-nbox` shape and up to three text lines: `.atl-nlabel` (name),
`.atl-nsub` (mono tech/port), `.atl-ntag` (mono emphasis in the kind's ink).

| Kind | Ink | Shape |
|---|---|---|
| `client` | slate-blue | rect |
| `edge` | ochre | rect (gateway, CDN, LB) |
| `svc` | indigo | rect |
| `fn` | plum | rect (lambda, worker, job) |
| `store` | verdigris | cylinder: `.atl-nbox` body + `.atl-nline` lip |
| `queue` | sienna | rect + three `.atl-nline` bars at the right |
| `cache` | moss | rect |
| `ext` | warm grey | rect, dashed |

State modifiers on the group: `is-hot` (heavier stroke — the hot path),
`is-fail` (red), `is-new` (dashed oxblood — a proposed change). State
machines reuse `atl-node` with `ok` / `warn` / `crit` / `info` /
`neutral` and centre an `.atl-stname`; `.atl-init` / `.atl-final` circles
mark entry and exit.

**Structure:** `.atl-stage` column labels across the top; `.atl-zone`
dotted boundaries (VPC, region, bounded context) and `.atl-zone.trust`
dashed ink boundaries (security), each with an `.atl-zlabel`;
`<g class="atl-step"><circle r="11"/><text>1</text></g>` numbered markers
on edges, keyed to an `<ol class="atl-steps">` walkthrough under the
figure. Sequence parts: `.atl-life` lifelines, `.atl-act` activation bars
inside an `atl-node <kind>` group, `.atl-note` + `.atl-note-t`.

Snippet (one service, one store, one animated data edge):

```html
<figure class="atl-arch">
  <div class="atl-plate">
  <svg viewBox="0 0 520 140" role="img" aria-label="wallet-service writes the wallets database.">
    <defs>
      <marker id="a-data" class="atl-m data" viewBox="0 0 10 10" refX="9" refY="5"
              markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z"/></marker>
    </defs>
    <path class="atl-edge data atl-flow" d="M210,70 H318" marker-end="url(#a-data)"/>
    <circle class="atl-pkt data" r="4"><animateMotion dur="2.2s" repeatCount="indefinite" path="M210,70 H318"/></circle>
    <g class="atl-node svc is-hot">
      <rect class="atl-nbox" x="20" y="30" width="190" height="80"/>
      <text class="atl-nlabel" x="34" y="56">wallet-service</text>
      <text class="atl-nsub" x="34" y="76">Kotlin · :8080</text>
      <text class="atl-ntag" x="34" y="96">p95 180 ms</text>
    </g>
    <g class="atl-node store">
      <path class="atl-nbox" d="M320,30 A90,10 0 0 1 500,30 V110 A90,10 0 0 1 320,110 Z"/>
      <path class="atl-nline" d="M320,30 A90,10 0 0 0 500,30"/>
      <text class="atl-nlabel" x="334" y="64">wallets</text>
      <text class="atl-nsub" x="334" y="84">Postgres 16</text>
    </g>
  </svg>
  </div>
  <div class="atl-legend">
    <span><i class="data"></i><b>data</b> writes</span>
    <span><i class="n svc"></i>service</span><span><i class="n store"></i>store</span>
  </div>
  <figcaption class="atl-figcap">Fig. № 1 — Write path. Source: repo @ sha, verified YYYY-MM-DD.</figcaption>
</figure>
```

**Legibility (hard requirement):** diagram text must render at ≥ 11px on
a 1440px screen and ≥ 9.5px on a 390px phone. The stylesheet sizes text in
viewBox units for a ~1200-wide plate (labels 14px sans, sub/tag/edge
labels 13px mono, stages 12.5px, state names 14px) and gives plates a
`min-width` (940px architecture/sequence, 860px state, 560px charts) so on
phones they scroll inside their frame instead of shrinking. Never set SVG
`font-size` below 13 viewBox units for a ~1200-wide `viewBox`; for a
narrower `viewBox`, scale it down proportionally. At 13px mono a node fits
about (width − 28) ÷ 7.8 characters per line — a 190-wide node ≈ 20.
Check every label fits its box before delivering.

**Charts** stay hand-authored inline SVG in `.atl-figure` using
`--atl-v1…v6` in order. **Mermaid** is now the fallback only for shapes the
grammar does not cover (ER, gantt): pre-render with
`npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg --configFile mermaid-config.json`,
inline it, keep the DSL in a `<details>`, and pin the light-baked figure to
`style="background:#FAF7F2"` — the one sanctioned literal hex. Never ASCII
art, never raster screenshots.

## 7. Engineering components

| Component | Markup | Rule |
|---|---|---|
| Contents rail | `.atl-layout` > `nav.atl-toc` (`.atl-toc-t` + `ol` of `a[href="#id"]` with `<span>01</span>`) + `main` | Sticky ≥1200px, in-flow list below. Optional inline IntersectionObserver toggles `.is-active`; links work without JS |
| Service directory | `.atl-svc-grid` > `article.atl-svc <kind>` (`.atl-svc-h` with `.atl-sq` + `.atl-svc-kind` + `.atl-svc-owner`, `h4.atl-svc-name`, `p.atl-svc-desc`, `.atl-kv` rows, `.atl-tags` spans) | Opened by a 2px rule in the kind's ink; `is-new` dashes it. Never a box |
| API table | `table.atl-table.atl-api`, `.atl-method get/post/put/patch/delete`, `td.atl-path` with `<i>{param}</i>` | Methods: get verdigris · post indigo · put ochre · patch plum · delete red |
| Decision record | `article.atl-adr` > `header.atl-adr-h` (`.atl-folio`, `.atl-adr-status proposed/accepted/rejected/superseded`, `h3`) + `.atl-adr-body` sections (`h4` Context / Decision / Consequences, `ul.atl-conseq` with `li.pro` / `li.con`) | One decision per record |
| Trade-off matrix | `table.atl-table.atl-tradeoff`, cells `td.good/.mid/.bad`, `tr.is-chosen` | Symbol + ink (● ◐ ○), never colour alone |
| Latency budget | `.atl-budget` > `.atl-budget-h`, `.atl-budget-bar[style="--scale:500"]` with `span.atl-budget-seg <kind>[style="--ms:18"]` and `span.atl-budget-target[style="--at:400"][data-label]`, `.atl-budget-axis`, `ul.atl-budget-key` (`li.<kind>` > `i` + name + `b` ms) | Segments in node-kind inks; target as an ink tick; `role="img"` + `aria-label` on the bar |
| Timeline | `ol.atl-timeline` > `li.ok/warn/crit/info` > `time` + `div` (`b` title, `p`) | Dates in the gutter, square markers on a hairline spine |
| Callout | `div.atl-callout note/warn/risk/decision[data-label]` | A 2px pigment rule and a small-caps label — never a tinted box |
| Code with header | `.atl-code` > `.atl-code-h` (`span` filename, `span` language) + `pre` | Token spans `.c` comment · `.k` keyword · `.s` string, sparingly |

## 8. Anti-patterns

- **Bold display weights.** The display face is light; a bold headline in
  this system reads as shouting.
- **Boxed cards.** Panels, metrics, verdicts, figures — all of them are
  rules and whitespace. A 1px-bordered card is DDS, not Atelier.
- **Coloured backgrounds behind prose.** Text sits on the paper; the pale
  semantic tints are for rare filled treatments in data, never prose.
- **More than one accent.** Oxblood is the only accent; semantic colours
  are status, not accents.
- **Sidenotes.** Margin citations belong to DDS. Atelier evidence is the
  end-of-section footnote strip.
- **A narrow centred column on a wide screen.** v1's 760px page is gone;
  the shell is full width and only prose keeps the measure.
- **Pigment confetti.** A diagram ink with no legend entry, a node kind
  coloured by taste, or two meanings for one ink.
- **Decorative motion.** Packets on every edge, pulsing nodes, animation
  that does not point the way data flows.
- **Prose-only architecture.** If the text walks through a flow step by
  step, draw the plate and number the steps.
- Rounded corners, shadows, gradient heroes, emoji section markers,
  webfonts, CDN assets — the generic AI look this system exists to prevent.

## 9. Changing the system

The system is versioned (`v2.0.0`, header of `atelier.css`). Change tokens
or components only in this directory; bump the version and revision date in
`atelier.css`, `index.html`, and this file together. A component that is
not demonstrated on the style-guide page is not in the system. Downstream
copies (inlined styles in old documents) are snapshots; they do not get
retrofitted.

### Changelog

- **v2.0.0 · 2026-10-07** — engineering edition: full-width shell with
  sticky contents rail and 70ch prose measure; route and node-kind pigment
  tokens; native SVG grammar for architecture, sequence, and state
  diagrams with directional motion; service directory, API table, ADR,
  trade-off matrix, latency budget, timeline, callouts, code header.
- **v1.0.0 · 2026-07-30** — initial release.

## Lineage

Stripe Press (serif display, book confidence) · The Paris Review / FT
Weekend (stand-firsts, folios, footnotes) · Economist print charts
(hairline data pages, big light numerals) · classic book design
(Tschichold's Penguin rules: symmetry of means, double rules, restraint) ·
architectural monograph plates (pigment inks, numbered keys).
