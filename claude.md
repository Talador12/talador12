# Talador12 Profile Repo — Current Focus

See `AGENTS.md` for rules and editing style. This file is rolling status — update on every meaningful commit.

## Right Now

Repo is freshly bootstrapped (2026-05-21) as part of personal-machine re-setup. All four scaffolding files are in a publishable state, the Makefile has been genericized into a template for reuse across new repos, and `.zshrc` is symlinked from `~/.zshrc` so the live shell config is version-controlled here.

**Status:** Publishable. `make help` works. Profile README renders cleanly. Ready to commit and push.

## Recent Changes

### 2026-05-21
- **README.md** — rewrote from default GitHub template. Centered intro, top-line LinkedIn + Repositories links, "Currently" section highlighting `adventure`, short tech list. No employment framing (neutral by default).
- **AGENTS.md** — established as stable SOP. Rules cover public-artifact treatment of README, the symlinked `.zshrc` (no secrets), no scope creep into deps/Actions/badges, claude.md update cadence, response format.
- **claude.md** — established as rolling status (this file).
- **Makefile** — replaced verbatim 485-line copy from `adventure` with a 253-line generic template. Preserved style: section banner separators, `## [Category] Description` per target, `makeinfo` "Running: <goal>" banner, `PRODUCTION_RELEASE` gate macro, colorized sorted `help` output. Stripped Cloudflare-specific (wrangler/D1/R2/Discord) and adventure-specific (play/dm-guide/tpk) targets. Hoisted language commands (`INSTALL_CMD`, `BUILD_CMD`, `TEST_CMD`, etc.) to top-of-file variables so the template adapts to any stack with one block of edits.
- **.zshrc** — replaced the `derp` placeholder with the real `~/.zshrc` content (oh-my-zsh + p10k + personal aliases + nvm + pyenv). `~/.zshrc` is now a symlink to this file, so editing the system shell config writes back into the repo. `~/.zshrc.bak` exists locally as a one-time backup.
- **.zshrc aliases** — added directory shortcuts named after the folders: `repos`, `github`, `talador12`, and refreshed `adventure` to point to the new `~/repos/github/talador12/adventure` location (was the old `/mnt/c/Users/talad/Documents/repos/adventure` Windows path).

## Open Questions / Decisions Pending

- **Employment framing in README** — currently neutral. Revisit if Keith wants to signal "open to opportunities" publicly.
- **GitHub stats / activity cards** — deliberately not included (look templated, add a third-party dependency). Reconsider if Keith specifically wants one.
- **Secrets handling in `.zshrc`** — none today, but any future API tokens or signing keys should source from a non-tracked `~/.zsh/secrets.zsh` rather than live in this file. Worth establishing the pattern before the first one lands.

## Ideas for Next Iteration

1. Pin `adventure` and one or two other repos on the GitHub profile via the github.com UI (not in this repo). Pins drive discovery — the README link is good but not enough.
2. Distill `AGENTS.md` + `claude.md` here into a minimum-viable starter template for brand-new repos. Keith spins up enough projects that a 30-second scaffold pays off quickly.
3. Decide what else belongs in this repo as part of the dotfiles story (e.g. `.gitconfig`, `.tmux.conf`, `.p10k.zsh`) — or split dotfiles into their own repo if this profile repo should stay strictly profile.
4. Once a real `~/.zsh/secrets.zsh` pattern is needed, add a `source ~/.zsh/secrets.zsh 2>/dev/null` line to `.zshrc` so the conditional load is already wired up.
