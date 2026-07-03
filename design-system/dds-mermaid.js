/* ==========================================================================
   DDS ↔ Mermaid theme bridge
   v1.0.0 · 2026-07-03 · pairs with dexter.css and vendor/mermaid.min.js

   Usage (hosted pages):
     <pre class="mermaid">sequenceDiagram …</pre>
     <script src="vendor/mermaid.min.js"></script>
     <script src="dds-mermaid.js"></script>

   Behaviour:
   - Renders every `pre.mermaid` with Mermaid's 'base' theme populated from
     the DDS palette (light or dark, following prefers-color-scheme and any
     explicit data-theme on <html>).
   - Keeps the original DSL source and re-renders when the theme changes.
   - Progressive enhancement: if this script or the library fails to load,
     the DSL remains visible as preformatted text — degraded, never blank.

   For self-contained/emailed documents, prefer PRE-RENDERED static SVG via
   mermaid-cli with mermaid-config.json (see README §6) instead of shipping
   this script.
   ========================================================================== */
(function () {
  'use strict';
  if (typeof mermaid === 'undefined') return;

  /* Values mirror the DDS tokens in dexter.css. Neutral by design: generic
     Mermaid edges are schematic ink; DDS money/mirror semantics stay in the
     native grammar or in explicit classDefs. */
  var LIGHT = {
    background: '#FBFAF3',
    primaryColor: '#FFFFFB',        /* node fill  = doc surface   */
    primaryTextColor: '#1C1B17',
    primaryBorderColor: '#1C1B17',
    secondaryColor: '#F0EDE0',
    tertiaryColor: '#F6F8F7',
    lineColor: '#1C1B17',
    textColor: '#1C1B17',
    fontSize: '13px',
    noteBkgColor: '#F4EBD3',        /* warn-bg — notes are cautions */
    noteTextColor: '#1C1B17',
    noteBorderColor: '#8F6400',
    actorBkg: '#FFFFFB',
    actorBorder: '#1C1B17',
    actorTextColor: '#1C1B17',
    actorLineColor: '#5D5A4F',
    signalColor: '#1C1B17',
    signalTextColor: '#1C1B17',
    labelBoxBkgColor: '#F0EDE0',
    labelBoxBorderColor: '#1C1B17',
    loopTextColor: '#1C1B17',
    activationBkgColor: '#E2EFE8',  /* ok-bg — active = live       */
    activationBorderColor: '#0B6E4F',
    clusterBkg: '#F6F8F7',
    clusterBorder: '#5D5A4F',
    edgeLabelBackground: '#FBFAF3',
    errorBkgColor: '#F5E2DF',
    errorTextColor: '#A63D33',
    pie1: '#0B6E4F', pie2: '#4A5D82', pie3: '#8F6400',
    pie4: '#7B4B94', pie5: '#A63D33', pie6: '#2E7E8C'
  };
  var DARK = {
    background: '#1D1C18',
    primaryColor: '#232219',
    primaryTextColor: '#E9E6DA',
    primaryBorderColor: '#E9E6DA',
    secondaryColor: '#2B2A22',
    tertiaryColor: '#1A1E1C',
    lineColor: '#E9E6DA',
    textColor: '#E9E6DA',
    fontSize: '13px',
    noteBkgColor: '#35290D',
    noteTextColor: '#E9E6DA',
    noteBorderColor: '#D9A93F',
    actorBkg: '#232219',
    actorBorder: '#E9E6DA',
    actorTextColor: '#E9E6DA',
    actorLineColor: '#A5A091',
    signalColor: '#E9E6DA',
    signalTextColor: '#E9E6DA',
    labelBoxBkgColor: '#2B2A22',
    labelBoxBorderColor: '#E9E6DA',
    loopTextColor: '#E9E6DA',
    activationBkgColor: '#17342A',
    activationBorderColor: '#6FBF9F',
    clusterBkg: '#1A1E1C',
    clusterBorder: '#A5A091',
    edgeLabelBackground: '#1D1C18',
    errorBkgColor: '#3B1F1B',
    errorTextColor: '#E08377',
    pie1: '#6FBF9F', pie2: '#93A9CE', pie3: '#D9A93F',
    pie4: '#B78BC9', pie5: '#E08377', pie6: '#6FB4C2'
  };
  var FONTS = '-apple-system, BlinkMacSystemFont, "Segoe UI", system-ui, Helvetica, Arial, sans-serif';

  function mode() {
    var t = document.documentElement.getAttribute('data-theme');
    if (t === 'dark' || t === 'light') return t;
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  var sources = new WeakMap();

  function render() {
    var els = document.querySelectorAll('pre.mermaid, div.mermaid');
    els.forEach(function (el) {
      if (!sources.has(el)) sources.set(el, el.textContent);
      el.removeAttribute('data-processed');
      el.textContent = sources.get(el);
    });
    mermaid.initialize({
      startOnLoad: false,
      theme: 'base',
      themeVariables: mode() === 'dark' ? DARK : LIGHT,
      fontFamily: FONTS,
      securityLevel: 'strict'
    });
    mermaid.run({ nodes: els });
  }

  window.matchMedia('(prefers-color-scheme: dark)')
    .addEventListener('change', render);
  new MutationObserver(function (muts) {
    for (var i = 0; i < muts.length; i++) {
      if (muts[i].attributeName === 'data-theme') { render(); return; }
    }
  }).observe(document.documentElement, { attributes: true });

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', render);
  } else {
    render();
  }
})();
