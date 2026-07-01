# Talador12 — GitHub Profile Repo

This is the **special profile repository** for `Talador12`. The `README.md` here renders as the profile page at https://github.com/Talador12.

See `claude.md` for current focus and recent changes. This file (`AGENTS.md`) is stable — only edit when the rules or layout themselves change, not for status updates.

## Rules

- **Update `claude.md` with every meaningful commit.** It tracks what's current.
- **Keep this file stable.** Architecture, conventions, and editing rules only — no status, no roadmaps.
- **The README is a public artifact.** Anyone visiting github.com/Talador12 sees it. Be thoughtful about wording, employment framing, contact info, and anything personally identifying.
- **Don't add personal info Keith hasn't explicitly approved.** Real name, location, phone, employment status, work history — ask first.
- **No build step, no runtime deps.** Markdown + a Makefile template only. Resist scope creep (no GitHub Actions, badge fetchers, stats cards) unless explicitly asked.
- **`.zshrc` is symlinked from `~/.zshrc`.** The file in this repo IS the live shell config — editing it changes Keith's shell on next sourced load. Never commit secrets, API tokens, or anything you wouldn't push to a public repo. Work-specific config (GEICO kubectl, Azure tokens) belongs in `~/.zsh/geico.zsh`; other secrets in `~/.zsh/secrets.zsh` — both sourced conditionally, neither tracked.

## Quick Reference

```bash
make help        # list all targets
make status      # branch, last commit, version, port usage
make commit M='message'   # format + add + commit + push
```

The laptop runbook lives in **`Makefile.laptop`** — that is the single source of truth. `make` works from `~` or from this repo:

| File | Purpose |
|------|---------|
| `Makefile.laptop` | Laptop runbook (GitHub, shell, toolchains) — **edit this** |
| `Makefile` | Symlink → `Makefile.laptop` (so `make` works in-repo) |
| `Makefile.template` | Generic project template — copy into new repos |
| `~/Makefile` | Symlink → `Makefile.laptop` (so `make` works from home) |

Run `make symlink-home` after clone to wire up `~/Makefile`, `~/.zshrc`, `~/AGENTS.md`, `~/claude.md`.

Copy **`Makefile.template`** (not `Makefile.laptop`) when starting a new project.

## Toolchain philosophy

One fast, purpose-built tool per language — no pyenv/pip/poetry, no nvm/npm, no asdf catch-all:

| Language | Tool | Use for |
|----------|------|---------|
| Python | **uv** | versions, venv, deps, `uv run` |
| Rust | **rustup** | toolchains, `cargo` |
| Go | **mise** | global version pin (projects use `go.mod` toolchain) |
| Node | **bun** | runtime + packages |

`make setup-dev-tools` / `make dev-tools-status` / `make dev-tools-update`

## Layout

| File | Purpose |
|------|---------|
| `README.md` | Renders on the GitHub profile page. Keep it tasteful. |
| `AGENTS.md` | This file — stable rules and SOP for agents. |
| `claude.md` | Rolling status: current focus, recent changes, ideas for next iteration. Update every commit. |
| `Makefile.template` | Generic Makefile template (copy into new repos as `Makefile`). |
| `Makefile.laptop` | Laptop runbook — source of truth; symlinked as `Makefile` and `~/Makefile`. |
| `.zshrc` | Symlinked from `~/.zshrc`. The repo file IS the live shell config — public. |
| `LICENSE` | MIT, © Keith Adler. |

## Editing the README

The profile README appears at https://github.com/Talador12 above the pinned repos and contribution graph. GitHub Flavored Markdown applies; basic HTML (`<h1 align="center">`, `<p align="center">`, anchor tags) is allowed and useful for layout.

**Style:**
- Tasteful, professional, friendly. Not aspirational marketing copy.
- Lead with the work, not credentials. Link to one or two real projects rather than listing every repo.
- One personal sentence is plenty — this is a profile, not a bio.
- Emoji is fine but sparing. Use as section markers, not decoration.

**Don't:**
- Add stats/streak/trophy cards from third-party badge services — they look templated and add an external dependency.
- Add employment status framing ("open to opportunities", "currently between things") without asking. This is a real signal and should be Keith's call.
- Add a contact form, calendar embed, or analytics pixel. Plain markdown only.

## Editing claude.md

- Date new entries (YYYY-MM-DD). Most recent first.
- Trim or summarize entries older than a few months — claude.md is rolling status, not a permanent log. Git history is the permanent log.
- "Ideas for next iteration" stays short (~5 items). Don't let it become a roadmap.

## Response Format

- Reference `file_path:line_number` when pointing to specific edits.
- For README changes, summarize *what changed* and *why the wording* — wording carries more weight than mechanics on a public profile.
- After meaningful changes, update `claude.md` (or remind to) before considering work done.
