# Atelier

**v1.0.0 · 2026-07-30 · Financial-grade trust through magazine typography.**

A sibling to the Dexter Design System (DDS) for AI-generated engineering
HTML in the editorial-serif idiom: reports set like a literary magazine,
dashboards set like a print data page.

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

## 2. Hard rules (never break these)

1. **Tokens only.** Every colour, font, space comes from an `--atl-*`
   custom property. Never hard-code a hex value in a component.
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
   title (`<em>`), and the verdict label. Never as a background, never as
   decoration. Semantic colours are not accents.
7. **Rules, not boxes.** Structure is horizontal hairlines (`--atl-rule`)
   and strong single rules (`--atl-ink`); the double rule is reserved for
   the masthead, board header, colophon, and the table total. No cards, no
   borders-as-boxes, no shadows. Radius 0 everywhere.
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

  <section class="atl-section">
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

  <footer class="atl-colophon"><div>Title · date</div><div>Author</div></footer>
</div>
</body>
```

Components: `.atl-stats` (light display numerals between rules),
`.atl-table` (hairline rows, `tr.atl-total` closes with a double rule),
`.atl-pull` (pull quote with the oversized hanging accent quotation mark),
`pre`/`code` (warm code plate). The drop cap goes on the document's opening
paragraph, once. The footnote strip closes every section that made a claim.

Voice: complete sentences; prose ≤ 66ch; the verdict label comes from
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

## 6. Diagrams and figures

Every chart or diagram sits in an `.atl-figure` (hairline rules top and
bottom, like a plate in a book) with an `.atl-figcap` caption — number
figures "Fig. № 1 — Title" and reference them from the prose.

- **Charts:** hand-authored inline SVG using `--atl-v1…v6` in order; labels
  in `--atl-sans`, values in `--atl-mono`.
- **Diagrams (sequence, state, ER, flow, gantt…):** author Mermaid DSL,
  pre-render to static SVG with
  `npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg --configFile mermaid-config.json`,
  inline the SVG, and keep the DSL beside it in a `<details>`. Pre-rendered
  SVG is light-baked: pin its figure to the light paper —
  `<figure class="atl-figure" style="background:#FAF7F2">` — the one
  sanctioned literal hex.
- Prose that narrates a flow or lifecycle step by step must also draw it.
  Diagrams are vector, never ASCII art, never raster screenshots.

Atelier has no native diagram grammar of its own; if the content needs the
money/mirror/blocked edge semantics, that is a DDS job — use DDS.

## 7. Anti-patterns

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
- Rounded corners, shadows, gradient heroes, emoji section markers,
  webfonts, CDN assets — the generic AI look this system exists to prevent.

## 8. Changing the system

The system is versioned (`v1.0.0`, header of `atelier.css`). Change tokens
or components only in this directory; bump the version and revision date in
`atelier.css`, `index.html`, and this file together. A component that is
not demonstrated on the style-guide page is not in the system. Downstream
copies (inlined styles in old documents) are snapshots; they do not get
retrofitted.

## Lineage

Stripe Press (serif display, book confidence) · The Paris Review / FT
Weekend (stand-firsts, folios, footnotes) · Economist print charts
(hairline data pages, big light numerals) · classic book design
(Tschichold's Penguin rules: symmetry of means, double rules, restraint).
