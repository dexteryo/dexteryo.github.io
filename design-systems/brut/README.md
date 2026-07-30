# Brut Design System

**v1.0.0 · 2026-07-30 · Béton brut for engineering documents.**

A neo-brutalist design system for AI-generated engineering HTML: reports,
dashboards, and status boards that shout their structure and whisper their
prose. Loud but disciplined — the grid underneath is strict.

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
body prose stays at weight 400, 16px/1.55, capped at 70ch. The single accent
is acid yellow `#FFD43A`, used as **fills only** with black text and black
borders on top — yellow never colours type. Semantic colours (ok green,
warn orange, crit red, info blue) are also fills: square status dots and
pale sticker tints whose text stays black. Documents are zines (bordered
frame, chunky rules); dashboards are sticker sheets (discrete slabs on the
cream ground). No gradients, no soft shadows, no grey-on-grey.

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

## 3. Choosing a mode

| Output | Mode | Body class |
|---|---|---|
| Investigation, design doc, post-mortem, RFC, wiki export | **Document** | `brut-doc` |
| Dashboard, risk register, status page, run-book summary | **Panel** | `brut-panels` |
| Mixed (report with an embedded dashboard section) | Document base; wrap panel sections in a `brut-panels` container |

## 4. Document mode recipe

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

Voice: complete sentences; prose ≤ 70ch; the stamp label comes from
`data-label` ("Recommendation", "Finding", "Open question" — whatever is
true). The masthead eyebrow is the only full-width yellow strip in the
header.

## 5. Panel mode recipe

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

## 6. Data visualisation

Charts use `--brut-v1…v6` in order (v1 is the acid yellow — fine as a bar
fill, never as a text label colour). Outline marks in `--brut-border` at
1.5–3px so fills stay flat and honest; no gradients on bars, no soft
drop-shadows on anything.

## 7. Diagrams

Brut does not invent a new diagram grammar — it reuses the DDS two-tier
discipline (see the DDS README §6) and reskins it:

- **Tier 1 (native SVG grammar):** same semantic classes and meanings
  (`.e-money` solid = real/sync · `.e-manual` dotted = human step ·
  `.e-mirror` dashed = information · `.e-blocked` dashed = designed not to
  exist; nodes `.n-svc`/`.n-store`/`.n-ext`/`.n-human`). Recolour edges
  with Brut semantic tokens and stroke nodes in `--brut-border` at 2–3px;
  never reinterpret the grammar. Host inside `.brut-diagram`.
- **Tier 2 (Mermaid):** pre-render to static SVG with this directory's
  `mermaid-config.json` (`npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg
  --configFile mermaid-config.json`), inline the SVG in a `.brut-diagram`
  figure, keep the DSL beside it in a `<details>`. Pre-rendered SVG is
  light-baked: pin the figure to the light ground —
  `style="background:#FBF6EC"` — the one sanctioned literal hex.

Every diagram carries a legend and a title block (revision date +
verification status). A diagram without provenance is a sketch. If prose
narrates a flow step by step, it must also be drawn.

## 8. Anti-patterns

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

## 9. Changing the system

The system is versioned (`v1.0.0`, header of `brut.css`). Change tokens or
components only in this directory; bump the version and revision date in
`brut.css`, `index.html`, and this file in the same change. A component
that is not demoed on the style-guide page is not in the system. Downstream
copies (inlined styles in shipped documents) are snapshots; they do not get
retrofitted.

## Lineage

Brutalist web (Bloomberg circa 2016) · Gumroad/Figma-brut marketing pages ·
risograph zine print (flat spot colour, hard registration) · Memphis group
as the restraint check — energy without chaos.
