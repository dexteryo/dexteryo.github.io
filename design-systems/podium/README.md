# Podium

**v1.0.0 · 2026-10-08 · The deck system: one idea per slide, the ask at the end.**

A sibling to the Dexter Design System for AI-generated **presentation decks**:
16:9 HTML slides for presenting architecture, proposals, and results to a CTO,
an engineering manager, or an engineering all-hands. Where every other sibling
is a document someone reads alone, Podium is a surface someone talks over —
type sized for the back of the room, a fixed set of slide archetypes, and a
structure that always opens with the verdict and closes with the ask.

| Resource | Location |
|---|---|
| Living style guide (view this) | <https://dexteryo.github.io/design-systems/podium/> |
| Canonical stylesheet | [`podium.css`](podium.css) |
| This spec (agent-facing) | `README.md` (this file) |
| Local source of truth | `~/dotfiles/dexteryo.github.io/design-systems/podium/` |
| Sibling system (documents) | `../../design-system/` (DDS) — use for anything meant to be read, not presented |

**If you are an AI agent generating Podium output for Dexter: this file is
your contract.** Read `podium.css` for exact values; this file tells you
which pieces to use and the rules you must not break.

---

## 1. The system in one paragraph

Podium is a deck, not a document: a vertical scroll-snap stack of full-viewport
slides, each one a single claim stated in type large enough to read from the
back of a meeting room. Dark "Stage" is the default theme (near-black ground, a
spotlight-gold accent, mono machine values); light "Boardroom" is the
counterpart for exec rooms and print — the author fixes the theme per deck, it
never follows the viewer's OS. Hierarchy comes from a strict archetype set:
title, agenda, section divider, statement, points, diagram, metrics,
comparison, timeline, code, and the closing ask. Diagrams reuse the sibling SVG
grammar — one hue per route meaning, one per node kind, every figure carries a
legend — redrawn at slide scale, where the text floor is higher and the node
count is lower. Bullets are rationed (at most four per slide, twelve words
each); anything that needs more words is a document, and DDS or Atelier exists
for that. A deck opens with the verdict by slide three and ends with the ask:
the decision requested, from whom, by when.

## 2. Hard rules (never break these)

1. **Tokens only.** Every colour, font, space, and size comes from a
   `--pod-*` custom property. Never hard-code a hex value in a component —
   in SVG, colour comes from the `pod-*` classes, never `fill="#…"`.
2. **System font stacks only, nothing from a CDN.** No webfonts, no
   `@font-face`, no external requests. JavaScript (keyboard navigation,
   progress counter) is inlined and progressive enhancement — with scripts
   off the deck must still read as a scrolling page.
3. **Self-contained output.** A deck is one HTML file with `podium.css`
   inlined in a `<style>` block (both token blocks: Stage dark default and
   the `data-theme` overrides). Link the stylesheet only for pages hosted
   next to it.
4. **The theme is fixed per deck, by the author.** Stage (dark) is the
   default; Boardroom (light) is set with `<html data-theme="light">`.
   Unlike the document siblings there is **no `prefers-color-scheme`
   dependence**: a presented deck must render identically on every machine
   and projector it touches. Both token blocks still ship in every file.
5. **One idea per slide.** The headline is a claim in sentence form ("The
   queue is the bottleneck"), never a label ("Performance"). At most four
   bullet points, twelve words each. Content that doesn't fit gets a second
   slide, an appendix slide, or a linked DDS document — never smaller type.
6. **Back-of-the-room floor.** No text below `--pod-min` (20px) on a slide
   except the footer strip and evidence refs (14px mono). Inside diagram
   SVGs: no text class below 16 user units at a 1600-wide stage; at most
   seven nodes per slide diagram — split anything bigger.
7. **One accent.** The spotlight gold marks the key phrase of the deck's
   title, section-divider numerals, the ask, and at most one emphasis per
   slide. Semantic colours (ok · warn · crit · info) are state, never
   decoration. Inside a figure, route hues carry the sibling meanings
   (sync · async · data · ctrl · ext · fail) and every hue appears in the
   legend.
8. **Verdict early, ask last.** The recommendation appears by slide three
   (a `pod-statement` slide). The final slide is always `pod-ask`: the
   decision requested, who decides, by when, and what happens next.
9. **No builds, no transitions.** Movement between slides is the scroll
   snap; nothing animates in. The one sanctioned motion is the diagram
   grammar's marching dashes / packets, on at most one diagram per deck.
10. **Provenance.** Every slide carries the footer strip: deck title ·
    section · slide number. Claims that rest on evidence cite it in a mono
    ref (`FundsRouter.java:214`), same voice as the siblings.

## 3. Choosing Podium at all

| Output | System |
|---|---|
| Something presented live in a meeting (proposal, review, all-hands) | **Podium** |
| The pre-read sent before that meeting | Atelier (exec) or DDS (engineering) |
| The design doc / RFC the deck summarises | DDS |
| A dashboard that stays on a screen | Nocturne or DDS Panel |

A deck summarises and persuades; it never replaces the document. When a deck
exists, its ask slide should reference the full document.

### Slide archetypes

A conformant deck uses only these. The order below is also the default
skeleton of a proposal deck.

| # | Archetype | Class | Job |
|---|---|---|---|
| 1 | Title | `pod-title` | Deck name, one accented key phrase, author · date · audience |
| 2 | Statement | `pod-statement` | The verdict in one huge sentence (rule 8) |
| 3 | Agenda | `pod-agenda` | Numbered contents, ≤ 6 entries |
| — | Divider | `pod-divider` | Section break: ghost numeral + section title |
| — | Points | `pod-points` | A claim + ≤ 4 supporting bullets |
| — | Diagram | `pod-diagram` | One SVG figure in the sibling grammar + legend |
| — | Metrics | `pod-metrics` | 2–4 stat tiles, mono values, delta chips |
| — | Comparison | `pod-compare` | Trade-off table (`good/mid/bad` cells, chosen row) or two options side by side |
| — | Timeline | `pod-timeline` | Roadmap / rollout: mono dates, status dots |
| — | Code | `pod-code` | One titled snippet, ≤ 12 lines |
| n | Ask | `pod-ask` | Decision requested · decider · deadline · next steps + doc link |

## 4. Deck recipe

```html
<!doctype html>
<html lang="en"> <!-- data-theme="light" for a Boardroom deck -->
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Deck title</title><style>/* podium.css inlined */</style></head>
<body class="pod-deck">
<main class="pod-slides">

  <section class="pod-slide pod-title">
    <p class="pod-kicker">Proposal · CleverBoard · 2026-10-08</p>
    <h1>Split the ledger <em>before</em> it splits us</h1>
    <p class="pod-sub">Why the settlement pipeline needs its own service, and what it costs.</p>
    <dl class="pod-meta">
      <div><dt>Author</dt><dd>Dexter</dd></div>
      <div><dt>Audience</dt><dd>CTO · EM · Platform team</dd></div>
      <div><dt>Status</dt><dd>For decision</dd></div>
    </dl>
  </section>

  <section class="pod-slide pod-statement">
    <p class="pod-kicker">Recommendation</p>
    <h2>Extract settlement into its own service this quarter — <em>two engineers, six weeks</em>.</h2>
  </section>

  <section class="pod-slide pod-points">
    <p class="pod-kicker">01 · Context</p>
    <h2>Three incidents in two months share one root cause.</h2>
    <ul>
      <li>Settlement batch locks the ledger table <span class="pod-ref">INC-2041</span></li>
      <li>p95 card auth rose 180 ms during batches</li>
      <li>Rollbacks couple two unrelated release trains</li>
    </ul>
  </section>

  <!-- pod-diagram / pod-metrics / pod-compare / pod-timeline slides … -->

  <section class="pod-slide pod-ask">
    <p class="pod-kicker">The ask</p>
    <h2>Approve the extraction for Q1.</h2>
    <dl class="pod-ask-grid">
      <div><dt>Decision by</dt><dd>CTO · 2026-10-15</dd></div>
      <div><dt>Cost</dt><dd>2 engineers · 6 weeks</dd></div>
      <div><dt>First milestone</dt><dd>Shadow writes · wk 2</dd></div>
    </dl>
    <p class="pod-docref">Full design: <span class="pod-ref">clevercards-engineering-hub/rfcs/settlement-service.md</span></p>
  </section>

</main>
<footer class="pod-foot" aria-hidden="true">
  <span>Split the ledger</span><span class="pod-foot-n"><!-- script fills “04 / 12” --></span>
</footer>
<script>/* arrow-key / space navigation + slide counter — progressive enhancement */</script>
</body>
</html>
```

Mechanics: `.pod-slides` is a `scroll-snap-type: y mandatory` stack; each
`.pod-slide` is `min-height: 100svh` with its content held in a centred
stage capped at `--pod-stage-max` (1600px) so type doesn't balloon on huge
monitors. The footer strip is fixed; the script keeps the slide counter
honest and adds arrow-key / space navigation. Without the script the deck is
simply a scrolling page — nothing breaks.

Speaker notes go in `<aside class="pod-notes">` inside a slide: invisible on
screen, printed beneath the slide only when the root carries
`data-notes="print"`.

## 5. Diagrams on slides

The grammar is the sibling grammar — routes, node kinds, zones, legend,
marching dashes — with `pod-` classes and slide-scale sizes. The differences
are all about distance:

- **Author at `viewBox` width ≤ 1200** for a full-bleed diagram slide.
- **Text floor 16 user units** (vs 11 in the document siblings).
- **≤ 7 nodes, ≤ 8 edges.** A slide diagram shows one mechanism; the full
  topology belongs in the DDS document the deck links to.
- The figure takes the whole stage; the legend sits in the slide footer
  area, horizontal; the headline above the figure states what the diagram
  proves ("Every failure crosses this hop"), not what it depicts.

Route meanings and node kinds are identical to the siblings: `sync` · `async`
· `data` · `ctrl` · `ext` · `fail`; `client` `edge` `svc` `fn` `store`
`queue` `cache` `ext`. Mermaid is not used on slides — if it can't be drawn
in the grammar at seven nodes, it isn't a slide.

## 6. Print / PDF export

`@media print` lays each slide on its own landscape page
(`size: 1280px 720px`), exact colours, footer repeated, snap and fixed
positioning removed. "Export the deck" = print to PDF from any browser;
no toolchain. With `data-notes="print"` on the root, each slide page is
followed by its notes in document type.

## 7. Anti-patterns

The conference-slop deck this system exists to prevent:

- **Label headlines.** "Architecture", "Problem", "Next steps" — a headline
  with no claim is a wasted slide.
- **Wall-of-bullets.** More than four bullets, nested bullets, or bullets
  that wrap twice. Split the slide or write the document.
- **Shrunk diagrams.** Pasting a document-scale SVG onto a slide produces
  unreadable 9px labels; redraw at ≤ 7 nodes.
- **Builds, fades, slide transitions.** The snap is the transition.
- **Decorative gradients, stock-photo heroes, emoji section markers.**
- **A second accent.** Gold is the only emphasis; semantic hues are state.
- **The missing ask.** A deck that ends on "Questions?" has no slide n.
- **Theme following the viewer.** A deck that flips with OS dark mode will
  surprise its presenter; the author fixes the theme.
- Webfonts, CDN assets, prose paragraphs on slides, non-tabular number
  columns, type below the floor.

## 8. Changing the system

The system is versioned (`v1.0.0`, header of `podium.css`). Change tokens or
components only in this directory; bump the version and revision date in
`podium.css`, `index.html`, and this file together. A component that is not
demonstrated on the style guide page is not in the system — the style guide
is itself a deck, and every slide in it is the specimen of its own archetype.

### Changelog

- **v1.0.0 · 2026-10-08** — First release. Living style guide
  (`index.html`, a self-demonstrating deck), gallery card in `../index.html`,
  routing via the `dexter-design-systems` skill. Reduced-motion guard on
  marching dashes; legend node glyphs; footer repeats per printed page.
- **v0.1.0 · 2026-10-08** — Draft spec: deck shell (snap stack, stage,
  footer, print), eleven slide archetypes, slide-scale diagram rules,
  Stage/Boardroom token blocks.

## Lineage

Takahashi / Lessig density (one idea, huge type) · Duarte's one-claim-per-
slide discipline · the sibling SVG diagram grammar (DDS v2) · Nocturne's
surface and route tokens, warmed with a stage-gold accent · Atelier's
Boardroom paper for the light theme.
