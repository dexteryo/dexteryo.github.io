#!/usr/bin/env bash
# scripts/encrypt.sh — encrypt an HTML document for password-protected sharing
#                      on dexteryo.github.io (GitHub Pages, static hosting).
#
# Usage:
#   ./scripts/encrypt.sh <source-html-path> [<output-name>]
#
# Examples:
#   ./scripts/encrypt.sh ~/projects/foo/docs/proposal.html
#   ./scripts/encrypt.sh ~/projects/foo/docs/proposal.html my-renamed.html
#
# What it does:
#   1. Generates a strong random password (32 chars, [A-Za-z0-9], ~190 bits entropy).
#   2. Encrypts the input HTML with StatiCrypt (AES-256 + PBKDF2).
#   3. Writes the encrypted file to shared/<filename>.
#   4. Prints the password ONCE. The password is never stored on disk.
#
# Hygiene:
#   - Save the password in 1Password / Slack DM immediately. You cannot recover it.
#   - The encrypted output is safe to commit. The plaintext source is NOT.
#   - One password per document (re-running this script generates a fresh password).

set -euo pipefail

# ── Args ────────────────────────────────────────────────────────────────────
SRC="${1:-}"
if [[ -z "$SRC" ]]; then
  echo "Usage: $0 <source-html-path> [<output-name>]" >&2
  exit 1
fi
OUT_NAME="${2:-$(basename "$SRC")}"

if [[ ! -f "$SRC" ]]; then
  echo "Error: source file not found: $SRC" >&2
  exit 1
fi

# ── Move to repo root ──────────────────────────────────────────────────────
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"
mkdir -p shared

# ── Generate password (in-process; never written to disk) ──────────────────
PASSWORD="$(openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 32)"
export STATICRYPT_PASSWORD="$PASSWORD"

# ── Encrypt ────────────────────────────────────────────────────────────────
./node_modules/.bin/staticrypt "$SRC" \
  -d shared \
  --short \
  --template-instructions "This document is shared internally with the team. Enter the password to view it." \
  --template-button "VIEW DOCUMENT" \
  >/dev/null

unset STATICRYPT_PASSWORD

# ── Rename if requested ────────────────────────────────────────────────────
SRC_BASENAME="$(basename "$SRC")"
if [[ "$OUT_NAME" != "$SRC_BASENAME" ]]; then
  mv "shared/$SRC_BASENAME" "shared/$OUT_NAME"
fi

# ── Inject noindex meta so the password-gate page stays out of search ──────
# StatiCrypt's output is safe (ciphertext), but the wrapper page itself can
# still be indexed by crawlers that find the URL. robots.txt covers honest
# crawlers; this is the belt-and-braces inside the document.
#
# Uses -i.bak + a literal newline in the replacement so the same invocation
# works under both BSD sed (macOS) and GNU sed (Linux/CI).
sed -i.bak -e 's|<meta charset="utf-8" />|<meta charset="utf-8" />\
        <meta name="robots" content="noindex, nofollow" />|' "shared/$OUT_NAME"
rm -f "shared/$OUT_NAME.bak"

URL="https://dexteryo.github.io/shared/$OUT_NAME"

# ── Append a row to the Notion tracking table (best-effort) ────────────────
# Needs NOTION_TOKEN + NOTION_DATABASE_ID in .env (gitignored). The target
# table must be a Notion *database* (Page=Title, Pass=Text, Shared=Checkbox)
# with the integration connected to it. If .env is absent (e.g. CI), this is
# skipped silently and sharing is unaffected.
NOTION_LOGGED=""
[[ -f "$REPO_ROOT/.env" ]] && {
  set -a
  . "$REPO_ROOT/.env"
  set +a
}

if [[ -n "${NOTION_TOKEN:-}" && -n "${NOTION_DATABASE_ID:-}" ]]; then
  BODY=$(jq -n \
    --arg db "$NOTION_DATABASE_ID" \
    --arg name "$OUT_NAME" \
    --arg url "$URL" \
    --arg pw "$PASSWORD" \
    '{ parent: { database_id: $db },
       properties: {
         "Page":   { title:     [ { text: { content: $name, link: { url: $url } } } ] },
         "Pass":   { rich_text: [ { text: { content: $pw }, annotations: { code: true } } ] },
         "Shared": { checkbox:  false }
       } }')
  if curl -fsS -X POST https://api.notion.com/v1/pages \
    -H "Authorization: Bearer $NOTION_TOKEN" \
    -H "Notion-Version: 2022-06-28" \
    -H "Content-Type: application/json" \
    --data "$BODY" >/dev/null; then
    NOTION_LOGGED="yes"
  else
    echo "  ⚠ Notion append failed — log it manually (link & password are still valid)." >&2
  fi
fi

# ── Output ─────────────────────────────────────────────────────────────────
SIZE_KB=$(($(wc -c <"shared/$OUT_NAME") / 1024))

cat <<EOF

==================================================
GENERATED PASSWORD:  $PASSWORD
==================================================

  Encrypted file: shared/$OUT_NAME  (${SIZE_KB} KB)
  Public URL:     https://dexteryo.github.io/shared/$OUT_NAME

Next steps:
  1. Save the password (also logged to Notion LinksDB — you cannot recover it otherwise).
  2. Share URL + password with team (separately).

EOF

# ── Commit & push the encrypted file ───────────────────────────────────────
# Stages only the encrypted output + salt (never the script or .env), commits,
# and pushes to the current branch (main).
git add "shared/$OUT_NAME" .staticrypt.json
if git diff --cached --quiet; then
  echo "  ℹ Nothing to commit — encrypted file unchanged."
else
  git commit -q -m "share: add ${OUT_NAME%.html}"
  if git push -q; then
    echo "  ✓ Committed & pushed to $(git rev-parse --abbrev-ref HEAD)."
  else
    echo "  ⚠ Commit made but push failed — run 'git push' manually." >&2
  fi
fi
