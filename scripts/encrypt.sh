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

# ── Output ─────────────────────────────────────────────────────────────────
SIZE_KB=$(($(wc -c <"shared/$OUT_NAME") / 1024))

cat <<EOF

==================================================
GENERATED PASSWORD:  $PASSWORD
==================================================

  Encrypted file: shared/$OUT_NAME  (${SIZE_KB} KB)
  Public URL:     https://dexteryo.github.io/shared/$OUT_NAME

Next steps:
  1. Save the password in 1Password / Slack DM (you cannot recover it).
  2. git add shared/$OUT_NAME .staticrypt.json
  3. git commit -m "share: add ${OUT_NAME%.html}"
  4. git push
  5. Share URL + password with team (separately).

EOF
