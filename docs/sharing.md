# Shared protected documents

Documents in this folder are encrypted with [StatiCrypt](https://github.com/robinmoisson/staticrypt) (AES-256 + PBKDF2). Visiting the URL shows a password prompt; without the password, the page contents are unreadable ciphertext — not just hidden behind a JS check.

## How to add a new protected document

From the repo root:

```bash
# Standard usage
./scripts/encrypt.sh /path/to/your/source.html

# Or rename the output:
./scripts/encrypt.sh /path/to/your/source.html my-renamed.html
```

The script:

- Generates a strong random password (32 chars, alphanumeric, ~190 bits of entropy).
- Encrypts the input HTML and writes it to `shared/<filename>`.
- Prints the password **once** on stdout — copy it to 1Password / Slack DM immediately. The password is never stored on disk.

Then commit and push:

```bash
git add shared/<filename>.html .staticrypt.json
git commit -m "share: add <doc-name>"
git push
```

Share the URL `https://dexteryo.github.io/shared/<filename>.html` + the password (via separate channels) with team members.

## Security notes

- **Per-document passwords.** Each `encrypt.sh` invocation generates a fresh password. Don't reuse them across documents.
- **The encrypted file is public.** Anyone can download the ciphertext, but cannot decrypt it without the password. Brute-force resistance is determined entirely by password strength — the 32-char alphanumeric default is well beyond practical attack.
- **`.staticrypt.json` is committed on purpose.** It contains only the salt (an anti-rainbow-table parameter, not secret). Committing it means re-encrypting the same document produces deterministic output and clean diffs.
- **Don't use this for highly sensitive data** (PII, customer data, credentials). It's appropriate for "internal sharing of work-in-progress documents", not for regulated content.
- **Once shared, you cannot revoke access.** Anyone with the password can re-share at will. If a password leaks, re-encrypt with a new password and rotate the URL.

## How to remove / rotate a document

To rotate a document's password:

```bash
./scripts/encrypt.sh /path/to/source.html  # generates a new password, overwrites the file
git add shared/<filename>.html
git commit -m "rotate: <doc-name> password"
git push
```

To remove a document entirely:

```bash
git rm shared/<filename>.html
git commit -m "remove: <doc-name>"
git push
```

Note: cached browser sessions (and any `Remember me` localStorage entries) may still allow team members to view the doc until the cache clears. Consider this when rotating.

## Index of protected documents

| Document | Path | Audience | Added |
|---|---|---|---|
| Problem-First spec structure proposal | [`shared/problem-first-spec-structure.html`](../shared/problem-first-spec-structure.html) | Engineering team — internal proposal | 2026-05-25 |
