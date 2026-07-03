# Dexter Design System (DDS)

**v1.0.0 · 2026-07-03 · One system, two modes, one grammar.**

A design system for AI-generated engineering HTML: reports, dashboards, and
architecture diagrams that come out consistent no matter which agent produced
them.

| Resource | Location |
|---|---|
| Living style guide (view this) | <https://dexteryo.github.io/design-system/> |
| Canonical stylesheet | [`dexter.css`](dexter.css) |
| This spec (agent-facing) | `README.md` (this file) |
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
| [`diagrams.html`](diagrams.html) | Full grammar + worked C4 Context/Container/Component examples |
| [`examples/report.html`](examples/report.html) | Complete conformant Document-mode page — **match this** for reports |
| [`examples/dashboard.html`](examples/dashboard.html) | Complete conformant Panel-mode page — **match this** for dashboards |

---

## 1. The system in one paragraph

Long-form documents are set like Tufte (serif body, sidenote citations,
near-zero decoration). Dashboards are set like instruments (sans-serif, 1px
borders, status dots, monospace machine values — Geist/Linear economy, but
light-first). Architecture diagrams use a Swiss-schematic grammar in which
line style carries meaning and every diagram carries a provenance title
block. All three share one token sheet: one accent, one semantic colour
family, one spacing scale (Carbon discipline).

## 2. Hard rules (never break these)

1. **Tokens only.** Every colour, font, space, and radius comes from a
   `--dds-*` custom property. Never hard-code a hex value in a component.
2. **System font stacks only.** No webfont `<link>`, no `@font-face`, no CDN
   anything. Output must work in a sandboxed viewer, an email, and offline.
3. **Self-contained output.** When producing a standalone file or artifact,
   inline the contents of `dexter.css` into a `<style>` block. Link the
   stylesheet only for pages hosted next to it.
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

## 3. Choosing a mode

| Output | Mode | Body class |
|---|---|---|
| Investigation, design doc, post-mortem, RFC, wiki export | **Document** | `dds-doc` |
| Dashboard, risk register, status page, run-book summary | **Panel** | `dds-panels` |
| Mixed (report with an embedded dashboard section) | Document base; wrap panel sections in a `dds-panels` container |

Architecture diagrams (`.dds-diagram`) work inside either mode.

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

  <section class="dds-section">
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

  <footer class="dds-colophon"><div>Title · date</div><div>Author</div></footer>
</div>
</body>
```

Components: `.dds-stats` (headline numbers between rules), `.dds-table`
(hairline rows, `tr.dds-total` for an accountant's total rule), `.dds-pull`
(accent-barred pull quote), `pre`/`code` (warm code background).

Voice: complete sentences; prose ≤ 66ch; no emoji section markers; the
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
for inline labels — pick one per context, not both.

## 6. Diagram grammar

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

**Always inline SVG** — never ASCII art, never raster screenshots of
diagrams, never Canvas for static diagrams.

## 7. Anti-patterns

- Webfonts, CDN assets, external images or scripts.
- Dark inverted "verdict slabs", purple-to-blue gradient heroes, emoji as
  section markers, `rounded-lg`-everywhere — the generic AI look this system
  exists to prevent.
- Green used decoratively (the accent is a claim: verified/real).
- A second accent colour. Semantic colours are not accents.
- Shadows in Panel mode (1px borders carry elevation).
- Diagrams without a legend or title block.
- Off-scale spacing, non-tabular number columns, prose wider than 66ch.

## 8. Changing the system

The system is versioned (`v1.0.0`, header of `dexter.css`). Change tokens or
grammar only in this directory, bump the version and revision date in
`dexter.css`, `index.html`, and this file, and keep the whole directory
(including reference pages and examples) consistent. New components go into
`dexter.css` **and** `components.html` in the same change — a component that
isn't on the components page isn't in the system. Downstream copies (inlined
styles in old documents) are snapshots; they do not get retrofitted.

## Lineage

Tufte/Gwern (document typography, sidenotes) · Vercel Geist and Linear
(panel economy) · Swiss schematic / engineering drawings (diagram grammar,
title block) · IBM Carbon (token and spacing discipline) · C4 model
(diagram zoom levels).
