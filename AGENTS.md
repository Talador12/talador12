# Talador12 — GitHub Profile Repo

This is the **special profile repository** for `Talador12`. The `README.md` here renders as the profile page at https://github.com/Talador12.

See `claude.md` for current focus and recent changes. This file (`AGENTS.md`) is stable — only edit when the rules or layout themselves change, not for status updates.

## Rules

- **Update `claude.md` with every meaningful commit.** It tracks what's current.
- **Keep this file stable.** Architecture, conventions, and editing rules only — no status, no roadmaps.
- **The README is a public artifact.** Anyone visiting github.com/Talador12 sees it. Be thoughtful about wording, employment framing, contact info, and anything personally identifying.
- **Don't add personal info Keith hasn't explicitly approved.** Real name, location, phone, employment status, work history — ask first.
- **No build step, no runtime deps.** Markdown + a Makefile template only. Resist scope creep (no GitHub Actions, badge fetchers, stats cards) unless explicitly asked.
- **`.zshrc` is symlinked from `~/.zshrc`.** The file in this repo IS the live shell config. Never commit secrets or employer-specific config. Local-only files: `~/.zsh/local.zsh` (work env, second GitHub account), `~/.zsh/laptop.mk` (work make targets), `~/.zsh/secrets.zsh`.

## Quick Reference

```bash
make help              # list targets
make setup             # first-time laptop bootstrap
make status            # shell, toolchains, GitHub health
make symlink-dotfiles  # wire ~/Makefile, ~/.zshrc, etc. → repo
```

**Edit in the repo; home is symlinks.**

| File | What it is |
|------|------------|
| `Makefile.laptop` | Laptop runbook — **edit this** |
| `Makefile` | Symlink → `Makefile.laptop` (run `make` in-repo) |
| `Makefile.template` | Generic project template — copy to new repos |
| `~/Makefile` | Symlink → repo `Makefile` (run `make` from home) |

Also symlinked: `~/.zshrc`, `~/AGENTS.md`, `~/claude.md`. Run `make symlink-dotfiles` after clone.

## Toolchain philosophy

One fast tool per language:

| Language | Tool | Not |
|----------|------|-----|
| Python | **uv** | pyenv, pip, poetry |
| Rust | **rustup** | — |
| Go | **mise** | — |
| Node | **bun** | nvm, npm |

`make setup-dev-tools` installs all. `make dev-tools-update` upgrades.

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
