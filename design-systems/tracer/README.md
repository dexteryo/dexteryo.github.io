# Tracer

**v2.0.0 · 2026-10-08 · The ops briefing: Carbon-dark, trace flows, verdict first. Engineering edition.**

A sibling to the Dexter Design System for AI-generated engineering HTML that
reads like a mission-control incident briefing — IBM Carbon's dark palette on
a blueprint grid, uppercase display headings, a filled verdict banner, and
the signature: native SVG trace diagrams whose dashed edges animate along
the routes they describe. Since v2 the page is full width with a sticky
contents rail, the grammar covers sequence and state diagrams natively, hops
can carry annotation bubbles ("one PR, at its hop"), and the component kit is
forensic: incident timeline, impact strip, hypothesis table, latency
breakdown, owner checklist.

| Resource | Location |
|---|---|
| Living style guide (view this) | <https://dexteryo.github.io/design-systems/tracer/> |
| Canonical stylesheet | [`tracer.css`](tracer.css) |
| This spec (agent-facing) | `README.md` (this file) |
| Mermaid pre-render config (ER/gantt only) | [`mermaid-config.json`](mermaid-config.json) |
| Local source of truth | `~/dotfiles/dexteryo.github.io/design-systems/tracer/` |

**If you are an AI agent generating HTML output for Dexter in the Tracer
style: this file is your contract.** Read `tracer.css` for exact values; this
file tells you which pieces to use and the rules you must not break.

---

## 1. The system in one paragraph

Tracer is the briefing you hand someone at 23:00 when the release is blocked:
verdict first, evidence hop by hop, one diagram that shows where the signal
dies. Near-black Carbon ground (`#161616`) under a fixed blueprint grid that
fades down the page; IBM Plex voice (locally installed, system fallback);
uppercase 700-weight display headings with one accent-toned key phrase; a
filled mono verdict banner; a bordered stat strip of headline numbers; numbered
sections (`00 /`); severity pills in evidence tables; dark terminal code blocks
in both themes. The signature element is the trace diagram: hand-authored SVG
boxes in columns with stage labels, connected by dashed edges that march in the
direction of data flow — each edge colour is a declared route meaning, every
diagram carries a legend, and since v2 a hop can carry a light annotation
bubble naming the change that lands there. Unlike Nocturne (calm product UI),
Tracer is operational and forensic: several semantic hues may appear on one
page because each one is a route or a state, never decoration.

## 2. Hard rules (never break these)

1. **Tokens only.** Every colour, font, space, and radius comes from a
   `--trc-*` custom property. Never hard-code a hex value in a component.
   Sanctioned literals: the dark code-block ground (`#0d0d0d`) and the two
   ambient gradients (grid mask, diagram halo) defined in the stylesheet.
2. **No external assets.** IBM Plex is preferred but must come from the local
   machine (`"IBM Plex Sans", …system stack` — the stacks in `tracer.css`).
   Never load webfonts from a CDN; no `@font-face`, no external requests.
   JavaScript inlined and progressive enhancement only — the page must read
   fully if scripts never run (the reveal effect keys off a root `.trc-js`
   class added by script for exactly this reason).
3. **Self-contained output.** For a standalone file or artifact, inline
   `tracer.css` into a `<style>` block — all token blocks (dark default,
   `@media` light, both `data-theme` overrides). Link the stylesheet only for
   pages hosted next to it.
4. **Both themes, dark first.** Dark is the identity and the default token
   block; light is the counterpart. Flip tokens, never restyle components in
   media queries. Code blocks stay dark in both themes.
5. **Verdict before evidence.** The hero states the conclusion: kicker →
   uppercase title with one `.trc-lo` accent phrase → stand-first → filled
   `.trc-verdict` banner → `.trc-meta` stat strip. A reader who stops after
   the hero knows the answer.
6. **Colour is meaning.** Accent blue points (links, kickers, section labels,
   the nominal route). Red = failing/lost, green = proven/clean,
   yellow = degraded/attention, teal = secondary/derived route,
   purple = async/out-of-band. A hue that doesn't carry its meaning is a
   defect; never use one for decoration.
7. **Diagrams are native SVG with a legend.** Trace, sequence, and state
   diagrams are hand-authored `<svg>` inside `.trc-fig > .trc-diagram`,
   using the classes from the stylesheet. Every edge colour used must appear
   in the `.trc-legend`; a `.trc-figcap` provenance line (source + date)
   closes the figure. Never ASCII art, never raster screenshots as the
   delivered diagram.
8. **Motion is directional, not decorative.** The animations are the
   `.trc-flow` marching-dash edges, at most one or two `.trc-pkt` packets on
   the routes that matter, and the scroll reveal. All disabled under
   `prefers-reduced-motion`. Nothing else moves.
9. **Machine truth is mono.** Metrics, timestamps, IDs, queue depths, response
   codes, and evidence are `--trc-mono`; numbers get `.trc-num` tabular
   numerals, right-aligned in table columns.
10. **Evidence is traceable.** Every claim in an evidence table cites its
    source (log stream + timestamp, `file:line`, queue name) in mono, and
    carries a `.trc-sev` verdict pill (`hi`/`med`/`low`).
11. **No AI attribution** in the output. No emoji section markers.
12. **Structure must be true.** Numbered sections only when order matters;
    a verdict banner only when there is a verdict; severity pills only when
    severity was actually assessed; an owner on every next step.
13. **Readability is measured, not eyeballed.** Author diagrams at
    `viewBox` width ≤ 1200; no SVG text class below 11 user units. The SVG
    carries `min-width: var(--trc-arch-min, 760px)`, so narrow screens
    scroll the diagram inside its frame instead of shrinking the type. For a
    viewBox wider than 1200, split the diagram.
14. **Self-check before delivery.** When a rendering tool is available
    (headless browser via Playwright/Puppeteer or similar), render the page,
    screenshot each diagram at `deviceScaleFactor: 2`, and *look at the
    screenshot*: text at or above the floor, no overlapping labels, every
    hue in the legend, the fail edge visibly dying short of the next stage.
    Name it `<page>--diagram-self-check.png`; where a hub page links the
    report, reuse the screenshot as its thumbnail. Without a renderer, state
    that the self-check was skipped.

## 3. Choosing a mode

| Output | Mode |
|---|---|
| Incident analysis, root-cause proof, investigation, post-mortem | **Briefing** (flagship) — full hero, numbered sections, trace diagram, evidence table |
| Status board, ownership matrix, run-book summary | **Board** — hero compressed to title + verdict + `.trc-meta`, then cards/tables/kv rows |

Tracer's flagship is the briefing. If the content argues a conclusion from
evidence, use the full recipe; if it only reports state, compress the hero
and lead with the stat strip and cards.

## 4. Briefing recipe (v2 shell)

```html
<body class="trc">
<div class="trc-topbar"><div class="trc-topbar-inner">
  <a href="#summary">Verdict</a><a href="#trace">Trace</a><a href="#detail">Evidence</a><a href="#next">Next steps</a>
</div></div>

<div class="trc-shell">
  <header class="trc-hero">
    <div class="trc-kicker"><span class="trc-kicker-bar"></span>INCIDENT ANALYSIS · STAGING · TICKET-123</div>
    <h1>Declined shows successful<br><span class="trc-lo">the decline never becomes an event</span></h1>
    <p class="trc-sub">Stand-first: what broke, what was traced, what the verdict is — three sentences.</p>
    <div class="trc-verdict bad">APP-SIDE — EVENT EMISSION GAP</div>
    <div class="trc-meta impact">
      <div class="trc-cell"><div class="trc-lab">Decline events emitted</div>
        <div class="trc-val bad">0<small>whole day, both txns</small></div></div>
      <div class="trc-cell"><div class="trc-lab">Pipeline defects</div>
        <div class="trc-val ok">0<small>SQS 0 · DLQ 0</small></div></div>
    </div>
  </header>

  <div class="trc-layout">
    <nav class="trc-toc" aria-label="Contents">
      <div class="trc-toc-h">Contents</div>
      <ol>
        <li><a href="#summary"><span class="trc-toc-n">00</span>Executive verdict</a></li>
        <li><a href="#trace"><span class="trc-toc-n">01</span>Trace</a></li>
      </ol>
    </nav>

    <main class="trc-col">
      <section id="summary" class="trc-rv">
        <div class="trc-seclabel"><span class="trc-n">00 /</span> Executive verdict</div>
        <h2>One-line conclusion as a heading</h2>
        <p class="trc-lead">The finding, self-contained. <code>Identifiers</code> in mono,
           tickets as a <span class="trc-chip">CHIP-123</span>.</p>
        <div class="trc-grid g3">
          <div class="trc-card"><span class="trc-corner">CLEAN</span><h3 class="ok">What's proven fine</h3><p>…</p></div>
          <div class="trc-card"><span class="trc-corner">GAP</span><h3 class="bad">Where it dies</h3><p>…</p></div>
          <div class="trc-card"><span class="trc-corner">CONTROL</span><h3 class="alt">The control case</h3><p>…</p></div>
        </div>
      </section>

      <!-- trace diagram: §6 · timeline / hypotheses / budget: §7 · evidence table: .trc-tbl -->

      <section id="next" class="trc-rv">
        <div class="trc-seclabel"><span class="trc-n">04 /</span> Ownership &amp; next steps</div>
        <div class="trc-callout bad"><div class="trc-t">Root gap — service name</div>
          <p>The one fix that matters, stated as an instruction.</p></div>
        <ol class="trc-next">
          <li>Add the decline emission in <code>TokenService</code> <span class="trc-owner">payments · wk 1</span></li>
        </ol>
      </section>

      <footer class="trc-foot">
        <strong>Title</strong> — TICKET-123 · <span class="trc-mono">env · 2026-10-08</span><br/>
        Verdict restated in one line.
      </footer>
    </main>
  </div>
</div>

<script>
  document.documentElement.classList.add('trc-js');
  // scroll reveal + TOC active state + legend focus — copy from index.html
</script>
</body>
```

The v1 single-column shell (`.trc-wrap` directly under `body`) still works;
new documents use `.trc-shell > .trc-layout` with the sticky rail. Short
documents (under four sections) drop the `<nav>` and keep `.trc-layout` with
just the `<main>`. Voice: complete sentences; the stand-first and every
`.trc-lead` must be readable in isolation. Section labels count from `00 /`
(the verdict is section zero). Verdict banner variants: default accent =
finding, `ok` = cleared, `warn` = degraded/undetermined, `bad` = defect
confirmed.

## 5. Evidence tables

Wrap tables in `.trc-tbl`. Columns for a hop-by-hop trace: Hop · Source ·
Observed · Verdict. The Source cell is mono (log stream, queue name,
`file:line`); the Verdict cell is a `.trc-sev` pill: `hi` (the gap),
`med` (works-as-designed but contributing), `low` (clean/verified). Code
evidence goes in `.trc-code` blocks — header strip naming the log stream,
file, or command, then the dark `pre` with the four token classes: `.c`
comment, `.k` keyword, `.s` string, `.r` alarm — highlight sparingly, the
alarm class marks the exact failing line only.

## 6. Trace diagrams (the signature)

Hand-authored SVG inside `figure.trc-fig > .trc-diagram`, followed by
`.trc-legend` and `.trc-figcap`. Grammar:

- **Layout:** left-to-right columns = stages of the system; `.trc-stage`
  uppercase labels across the top; `viewBox` ≤ 1200 wide (rule 13),
  `width="100%"`.
- **Nodes:** `<rect class="trc-box" rx="9">` + up to three text lines:
  `.trc-nlabel` (name), `.trc-nsub` (mono detail), `.trc-ntag` (mono
  emphasis), plus an optional `.trc-nkind` mono kind tag anchored top-right
  (`text-anchor: end`). **State variants** (what it did): `src` (accent
  border, entry/source), `bad` (red border, where it fails), `ok`
  (green-tinted, proven clean). **Kind variants** (what it is, v2): `svc`,
  `queue`, `cache`, `client`, `ext` (dashed). A store is a cylinder:
  `path.trc-shape` + `path.trc-lid`. State wins over kind visually.
- **Zones (v2):** `rect.trc-zone` (deployment boundary — account, VPC,
  provider) or `rect.trc-zone.trust` (security/compliance boundary), with a
  `text.trc-zlabel` (add `.trust` to match).
- **Edges:** `<path class="trc-edge trc-flow main|fail|ctrl|alt|async">` with
  a matching `marker-end`. Define one `<marker class="trc-m-<route>">` per
  route used. Route meanings are fixed:
  `main` = nominal path · `fail` = the failing/lost signal ·
  `ctrl` = the proven control path · `alt` = secondary/derived/store read ·
  `async` = out-of-band. The `fail` edge terminates at the box where the
  signal dies — visibly short of the next stage.
- **Steps (v2):** `<g class="trc-step" transform="translate(x,y)">
  <circle r="11"/><text dy="3.5">1</text></g>` on edges, keyed to an
  `ol.trc-steps` walkthrough under the figure.
- **Packets (v2):** `<circle class="trc-pkt <route>" r="4"><animateMotion
  dur="1.4s" repeatCount="indefinite" path="<same d as the edge>"/></circle>`
  — on the one or two routes the argument turns on, never all of them.
- **Annotation bubbles (v2):** the voice-over layer — a light card anchored
  to the hop where a change lands ("one PR, at its hop"):
  `<g class="trc-bubble accent|ok|warn|bad|async">` holding
  `rect.trc-bb` (the card, rx 10), `path.trc-tail` (a small filled triangle
  touching the hop), `rect.trc-bubble-idbg` + `text.trc-bubble-id` (the
  inverse tag: `PR 2`, `CONFIG`, `DECISION`), `text.trc-bubble-t` (title),
  `text.trc-bubble-li` lines (mono, `+ `-prefixed changes), optional
  `text.trc-bubble-mut` (muted note). The variant class states what kind of
  change it is, matching the route/semantic hues. At most one bubble per
  hop; a diagram drowning in bubbles is a table.
- **Legend:** one `.trc-legend span` per route used, `<i class="<route>">`
  swatch + a phrase stating what that route *means in this diagram*. Add
  `data-route="<route>"` to enable hover focus (script stamps `data-focus`
  on the figure and other routes dim — copy from `index.html`).
- **Caption:** `.trc-figcap` with source of truth and revision date.
- **Motion:** `.trc-flow` dashes march along each edge; reduced-motion turns
  them into plain dashed lines. Accessibility: `role="img"` +
  `aria-label` describing the flow and where it breaks.

**Sequence diagrams (v2):** same `.trc-fig` wrapper. Actor header boxes
reuse `.trc-box` with a centred `.trc-nlabel` (`text-anchor="middle"`);
`line.trc-life` dashed lifelines; `rect.trc-actbar` activation bars;
messages are horizontal `.trc-edge main|ctrl|alt|async|fail` paths with
`text.trc-mlabel` 8px above the arrow (`.mut` for returns, `.bad` for
failures); returns are `.trc-edge.ret` with `marker.trc-m-ret`. The failing
message dies mid-lane, exactly like a trace.

**State machines (v2):** `g.trc-state [ok|warn|bad|accent]` pills
(`rx` = half height) with a centred name and optional `text.trc-ssub`;
start pseudo-state `circle.trc-pseudo`, final = `circle.trc-pseudo-ring` +
`circle.trc-pseudo`; transitions are thin `.trc-edge` routes with
`text.trc-elabel` (halo'd against the panel so labels survive crossings).

**Fallback:** Mermaid only for ER, gantt, and shapes none of the three
grammars cover. Pre-render to static SVG with `mermaid-config.json`
(`npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg --configFile
mermaid-config.json --backgroundColor transparent`), pin the figure to the
dark ground, keep the DSL in a `<details>`.

## 7. Forensic components (v2)

| Component | Markup | Rule |
|---|---|---|
| Incident timeline | `ol.trc-timeline > li` = `time` + `.trc-dot <state>` + content; the turning points get `class="trc-mark"` (`DETECTED` / `MITIGATED` / `RESOLVED`) | Mono UTC timestamps; one dot per event; marks in caps |
| Impact strip | `.trc-meta.impact` with the usual `.trc-cell`s | Blast radius up front: customers · transactions · duration · MTTR |
| Hypothesis table | `.trc-tbl`; columns Hypothesis · Test · Observed · Verdict; verdict cells `td.hyp-true\|hyp-false\|hyp-open` | Glyph + tint, never colour alone; every hypothesis shows its test |
| Latency breakdown | `.trc-budget > .trc-budget-h` + `.trc-budget-bar` of `span.trc-seg.s1…s4\|.over` with `style="--w:NN%"`, `span.trc-budget-target` with `style="--at:NN%"` + `data-label`; `.trc-budget-legend` | Widths are proportions of a stated scale; the overrun is `.over` |
| Next steps | `ol.trc-next > li` with a trailing `span.trc-owner` | Every action has an owner and a horizon (rule 12) |
| Titled code | `.trc-code > .trc-code-h` (source, meta) + `pre` | The header names the log stream / file / command the block came from |

## 8. Anti-patterns

- **Rainbow abuse.** Five hues are available; a page that uses one it can't
  justify semantically has failed rule 6. Most briefings need three.
- **Decorative animation.** Nothing pulses, glows, or bounces. If a dash
  animation doesn't communicate flow direction, remove it. Packets on every
  edge are noise.
- **Verdict-free heroes.** A Tracer page without a conclusion in the hero is
  the wrong system — use Nocturne or DDS for neutral documentation.
- **Bubble overgrowth.** More than one annotation bubble per hop, or bubbles
  restating what the node already says. Bubbles carry *changes and
  decisions*, not descriptions.
- **Shrunken diagrams.** A 1600-wide viewBox squeezed into a column renders
  unreadable labels; author ≤ 1200 and let narrow screens scroll (rule 13).
- **Screenshot diagrams, ASCII art, Mermaid where a native grammar fits.**
- **CDN fonts** (the original inspiration loaded Google Fonts — Tracer does
  not), gradient text, glassmorphism beyond the topbar's backdrop blur,
  drop shadows, emoji, off-token colours.
- **Content hidden without JS** — the reveal effect must stay keyed to
  `.trc-js`.
- **Actions without owners.** A next-steps list where any row lacks an
  owner chip is unfinished.

## 9. Changing the system

The system is versioned (`v2.0.0`, header of `tracer.css`). Change tokens or
components only in this directory; bump the version and revision date in
`tracer.css`, `index.html`, and this file together. A component that is not
demonstrated on the style guide page is not in the system. Downstream copies
(inlined styles in old documents) are snapshots; they do not get retrofitted.

### Changelog

- **v2.0.0 · 2026-10-08** — Engineering edition. Full-width shell
  (`.trc-shell` + `.trc-layout`) with sticky contents rail and 72ch prose
  measure; v1 `.trc-wrap` kept working. Trace grammar grows node kinds,
  store cylinders, zones/trust boundaries, numbered steps + walkthrough,
  route packets, legend hover focus, and annotation bubbles ("one PR, at its
  hop" — learnt from a teammate's report in the same Carbon idiom). Native
  sequence and state grammars; Mermaid retreats to ER/gantt. Forensic kit:
  incident timeline, impact strip, hypothesis table, latency breakdown,
  owner checklist, titled code. Measured readability rule (13) and the
  diagram self-check loop (14).
- **v1.0.0 · 2026-07-30** — Initial release.

## Lineage

IBM Carbon Design System (palette, Plex voice, grid discipline) · NASA/ops
mission-control briefings (verdict-first structure) · network-diagram
marching-ants convention (animated flows) · a colleague's peak-readiness
report (annotation bubbles, render-and-screenshot self-check) · sibling to
Nocturne (dark restraint) and the Dexter Design System (token discipline,
evidence-first).
