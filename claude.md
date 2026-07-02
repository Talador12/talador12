# Talador12 Profile Repo — Current Focus

See `AGENTS.md` for rules and editing style. This file is rolling status — update on every meaningful commit.

## Right Now

New laptop setup (2026-07-01). Profile repo is dotfiles source of truth — home files are symlinks. Work-specific config lives in local-only `~/.zsh/local.zsh` and `~/.zsh/laptop.mk`.

**Status:** `make setup` / `make status` / `make github-test` pass. Toolchains installed (uv, rustup, mise, bun). p10k wizard pending.

**Manual:** Set terminal font to **MesloLGS Nerd Font**; run `p10k configure` once.

## Recent Changes

### 2026-07-01 (e)
- **secrets.zsh** — established as the only place for credentials (`~/.zsh/secrets.zsh`, local-only, never symlinked). Added `secrets.zsh.example` to repo. Secrets load before `local.zsh`.

### 2026-07-01 (d)
- **Privacy** — removed all employer references from public repo. Work GitHub, kubectl, banner → `~/.zsh/local.zsh` + `~/.zsh/laptop.mk` (local only).

### 2026-07-01 (c)
- **`Makefile.laptop`** — slimmed to laptop-only targets; `symlink-dotfiles` wires home symlinks.

### 2026-07-01
- **`.zshrc`** — oh-my-zsh + p10k, personal GitHub helpers.
- **`Makefile.laptop`** — laptop runbook; `Makefile.template` for new projects.
- **Toolchains** — uv, rustup, mise, bun.
- **GitHub** — dual account; personal in repo, work account local-only.

### 2026-05-21
- Profile repo bootstrap.

## Open Questions

- p10k config: wizard vs copy from old machine
- Dotfiles scope: `.p10k.zsh`, `.gitconfig` — here or separate repo?

## Ideas for Next Iteration

1. Save `~/.p10k.zsh` once wizard is done.
2. Pin repos on GitHub profile UI.
3. Starter template from AGENTS.md + Makefile.template.
