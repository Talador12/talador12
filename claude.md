# Talador12 Profile Repo — Current Focus

See `AGENTS.md` for rules and editing style. This file is rolling status — update on every meaningful commit.

## Right Now

New GEICO laptop setup (2026-07-01). Dual GitHub accounts wired (`Talador12` + `keithadler_geico`), shell tooling installed, `~/Makefile` is the laptop runbook. `~/.zshrc` symlinked to this repo.

**Status:** Shell loads clean. Toolchains installed (`make dev-tools-status`). p10k wizard still pending.

**One manual step:** Set terminal font to **MesloLGS Nerd Font** (installed via `make setup-shell`) for p10k icons to render correctly.

## Recent Changes

### 2026-07-01 (b)
- **Toolchains** — uv-style stack: **uv** (Python 3.14), **rustup** (Rust 1.96), **mise** (Go 1.26 only), **bun** (Node). `make setup-dev-tools` / `dev-tools-status` / `dev-tools-update`. Dropped pyenv/nvm/asdf.
- **AGENTS.md** — toolchain philosophy table added.

### 2026-07-01
- **`.zshrc`** — macOS rewrite: oh-my-zsh + powerlevel10k + plugins (git, docker, kubectl, brew, macos, z, autosuggestions, syntax-highlighting). GitHub dual-account helpers (`gh-personal`, `clone-personal`, etc.). GEICO work config moved to local `~/.zsh/geico.zsh`. Removed Cloudflare/Linux cruft (wrangler, exa paths, `/home/talador`).
- **`Makefile.laptop`** — laptop runbook symlinked from `~/Makefile` (GitHub, shell, toolchains). Generic `Makefile` stays a project template.
- **GitHub** — HTTPS via `gh` on corp network (Zscaler blocks SSH). SSH keys + `~/.ssh/config` (port 443) kept for off-VPN use.
- **AGENTS.md** — documented `~/.zsh/geico.zsh` pattern for work-specific local config.

### 2026-05-21
- **README.md** — profile README rewrite (centered intro, LinkedIn, adventure highlight).
- **Makefile template** — genericized from adventure repo for reuse across projects.
- **`.zshrc`** — initial symlink from live shell config.

## Open Questions / Decisions Pending

- **p10k configure** — run wizard once in a new terminal, or copy a saved `~/.p10k.zsh` from old machine.
- **Employment framing in README** — currently neutral.
- **Dotfiles scope** — `.gitconfig`, `.p10k.zsh`, `.tmux.conf` — keep in profile repo or split?

## Ideas for Next Iteration

1. Save configured `~/.p10k.zsh` into dotfiles once wizard is done.
2. Pin repos on GitHub profile UI.
3. Starter template distilling AGENTS.md + Makefile for new repos.
