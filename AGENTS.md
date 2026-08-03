# Talador12 — GitHub Profile Repo

This is the **special profile repository** for `Talador12`. The `README.md` here renders as the profile page at https://github.com/Talador12.

See `claude.md` for current focus and recent changes. This file (`AGENTS.md`) is stable — only edit when the rules or layout themselves change, not for status updates.

## Rules

- **Update `claude.md` with every meaningful commit.** It tracks what's current.
- **Keep this file stable.** Architecture, conventions, and editing rules only — no status, no roadmaps.
- **Capture lessons learned here.** When a session surfaces a specific behavior, tool quirk, or workflow pattern that clearly helps or hurts outcomes, add it to `AGENTS.md` incrementally — in the relevant existing section, not as a status log. Skip one-off context (that belongs in `claude.md`) and vague advice. The bar: would this prevent a repeat mistake or save time on the next similar task?
- **The README is a public artifact.** Anyone visiting github.com/Talador12 sees it. Be thoughtful about wording, employment framing, contact info, and anything personally identifying.
- **Don't add personal info Keith hasn't explicitly approved.** Real name, location, phone, employment status, work history — ask first.
- **No build step, no runtime deps.** Markdown + a Makefile template only. Resist scope creep (no GitHub Actions, badge fetchers, stats cards) unless explicitly asked.
- **`.zshrc` is symlinked from `~/.zshrc`.** The file in this repo IS the live shell config. Never commit secrets or employer-specific config.
- **Secrets go in `~/.zsh/secrets.zsh` only.** Passwords, API keys, tokens — always there, never in repo files, never symlinked. Agents must not put secrets in `.zshrc`, `local.zsh`, or any tracked file.
- **Other local-only files:** `~/.zsh/local.zsh` (work env, second GitHub account), `~/.zsh/laptop.mk` (work make targets). See `secrets.zsh.example` for variable names.
- **No infinite loops.** If a command fails or hangs, retry at most **once** (2 attempts total). After that, stop, report what failed, and ask or suggest a manual next step — do not keep re-running variants, polling subscriptions, or re-trying sudo/auth in a loop.
- **Validate before handoff.** Do not ask Keith to run verification you can run. After meaningful code changes, run the relevant tests yourself — unit tests at minimum, and production-like validation when the change touches integration paths (lab deploys, brownfield APIs, cluster jobs, etc.). Stay within PII and security constraints: no real customer data, no credential exfiltration, no writes to prod without explicit approval. If validation fails, fix or report with the actual output; do not treat unverified code as done.
- **No commit trailers — ever.** Keith-only commit messages unless he explicitly asks for a co-author. Forbidden in any form:
  - `Co-authored-by:` (including `Co-authored-by: Cursor <cursoragent@cursor.com>`)
  - `git commit --trailer=...` or any `--trailer` flag
  - `Signed-off-by:` / `Made-with:` / bot or AI attribution lines injected by tools
  - Do not suggest, add, or leave trailers in commit messages, PR bodies, or amend commands.

## Git commits (agents)

**Policy:** Commit authorship is Keith-only. Tools (Cursor, hooks, CI) must not add trailers.

**Before every push** that includes commits you created or amended:

1. Verify HEAD is clean: `git cat-file -p HEAD | rg -i 'co-authored-by|signed-off-by:.*cursor|made-with' && exit 1 || true`
2. If a trailer is present, rewrite with `git commit-tree` (not `git commit --amend` — Cursor may re-inject trailers through normal commit):
   ```bash
   parent=$(git rev-parse 'HEAD^')
   tree=$(git rev-parse 'HEAD^{tree}')
   msg=$(git log -1 --format='%B' | sed '/^Co-authored-by:/Id' | sed '/^Signed-off-by:.*[Cc]ursor/Id' | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}')
   new=$(printf '%s' "$msg" | git commit-tree "$tree" ${parent:+-p "$parent"})
   git reset --hard "$new"
   ```
3. Re-run the verify command. Do not push until it passes.

**Hooks:** `make setup-git-hooks` installs global hooks from this repo (`git-hooks/`) that strip trailers on commit and reject any that remain. Run once per machine; included in `make setup`.

**Never:** `git commit --trailer`, `--no-verify` to bypass the trailer hook, or push without verifying the commit object.

## PR review comments (Keith)

Keith's PR comments always use one of these prefixes:

| Prefix | Meaning |
|--------|---------|
| `nit: …` | Non-blocking suggestion — optional polish |
| `lgtm` | Approved as-is |
| `req: …` | Required change before merge |

When triaging review feedback on Keith's PRs, treat only `req:` items as blocking. `nit:` is optional.

## PR feedback and CI (agents)

When Keith asks to address PR review comments or CI failures:

1. Review PR feedback and CI pipeline status for the PR.
2. Implement all requested fixes. Fix any broken pipelines.
3. Repush.
4. Reply on each addressed thread with a short note (e.g. "fixed with new commit") and resolve those threads.

Review replies stay minimal. See **Writing style** below. Do not write long explanations in GitHub threads unless the reviewer asked a question that needs an answer.

## Commit and push (agents)

When a task is done, commit and push in the same session. Do not leave finished work only on disk for Keith to push later.

1. Commit with a clear message (see **Git commits** and **Commit messages** below).
2. Verify HEAD has no commit trailers before pushing.
3. Push to the remote branch unless Keith explicitly said not to.

**GitHub accounts:** personal repos (`Talador12/*`) need `gh auth switch -u Talador12` before push. Work repos (`geico-private/*`) need `keithadler_geico`. Swap with `gh auth switch` if push returns 403.

If push fails (auth, permissions, hook rejection), report the error and what was committed locally; do not treat "committed but not pushed" as done.

## Quick Reference

```bash
make help              # list targets
make setup             # first-time laptop bootstrap
make status            # shell, toolchains, GitHub health
make symlink-dotfiles  # wire ~/Makefile, ~/.zshrc, etc. → repo
make setup-git-hooks   # block Co-authored-by / commit trailers globally
```

**Edit in the repo; home is symlinks.**

| File | What it is |
|------|------------|
| `Makefile.laptop` | Laptop runbook — **edit this** |
| `Makefile` | Symlink → `Makefile.laptop` (run `make` in-repo) |
| `Makefile.template` | Generic project template — copy to new repos |
| `~/Makefile` | Symlink → repo `Makefile` (run `make` from home) |

Also symlinked: `~/.zshrc`, `~/AGENTS.md`, `~/claude.md`. **Not** symlinked: `~/.zsh/secrets.zsh` (secrets stay local).
Run `make symlink-dotfiles` after clone.

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
| `secrets.zsh.example` | Template of secret variable names — copy to `~/.zsh/secrets.zsh` (local only). |
| `git-hooks/` | Global git hooks (via `make setup-git-hooks`) — strip/reject commit trailers. |
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

---

## Engineering work — code style and team dynamics

These rules apply any time I'm writing code, reviewing PRs, or touching a codebase on Keith's behalf. They exist because AI-assisted code that doesn't follow them gets flagged as "vibe coded" — which signals a loss of trust with the team.

### Do not over-engineer

The most common AI failure mode is adding unnecessary abstraction, indirection, or generality. Before introducing a new file, wrapper, config flag, or layer of indirection, ask: does the team convention here call for this? Could it be inlined and still be clear?

Concrete anti-patterns to avoid:
- Shell scripts called from CI/CD actions when a few inline steps would do
- A new function or file for logic that belongs inline in the caller
- Configuration flags/toggles for behavior that should simply be removed or hardcoded
- Abstraction layers (wrapper types, adapter structs) where the underlying thing is already simple enough to use directly
- Magic variables shared across files with no explanation at the callsite

The bar is: would a senior engineer on this team write it this way, or would they reach for the simpler thing first?

### Match the existing codebase conventions

Before writing any code, read enough of the surrounding code to understand:
- How similar problems are solved elsewhere in the repo
- Where things live (which package, which file, which layer)
- The naming and comment style

Do not introduce a new pattern when an existing pattern handles the problem. Do not move things to a "better" location without a clear reason that maps to a team convention.

**Do not remove comments attributed to a teammate.** If a comment names the author (`zairashaikh: …`, `// Tyler:`, etc.), it was intentional — keep it when refactoring around that code. Reword only if the behavior changed and the note is wrong; do not delete because the code moved or got shorter.

### Explain structural decisions

When code makes a non-obvious structural choice — a new file, a separate goroutine, a specific TTL, a package boundary — it needs an inline comment that explains *why*, not just *what*. "Why did we pull this out?" and "this feels like a magic variable" are review signals that the reasoning wasn't communicated.

The PR description also needs to explain each structural decision briefly. Reviewers should not have to ask why something was moved or refactored.

### Remove things cleanly — don't make them configurable

When the task is to remove something (a dependency, a code path, a feature flag), remove it. Do not wrap it in a feature flag or make it configurable unless Keith explicitly asks. Configurable removal is harder to reason about, harder to test, and signals that the author wasn't confident in the direction.

### PR descriptions: factual, terse, team-oriented

PR descriptions should:
- Explain what changed and why, in plain language
- Map to the actual code (no padding, no restating what the diff already shows)
- Acknowledge known gaps or follow-ons directly ("ADO integration deferred to #2288")
- Be written as if Keith wrote it after understanding the changes

Do not:
- Add verbose bullet-point summaries of every file changed
- Use marketing-style headers ("Performance improvements", "Robustness")
- Include test plans that list commands with checkboxes unless that's the team's convention
- Add reviewer notes as a comment immediately after opening — if context is needed, it belongs in the PR body

### Work in-scope, not maximally

If the task is to fix a performance bug, fix the performance bug. Do not also refactor adjacent code, add new abstractions, fix unrelated linter warnings, or reorganize the package — unless Keith explicitly asks. Each unexplained change is one more thing reviewers have to evaluate and ask about.

Changes outside explicit scope should be called out and confirmed before including them.

### michaelbolot review signal key (hybrid-cloud-fabric)

When reading michaelbolot's review comments, his emoji signal intent:
- 🔴 — Strong objection, likely a req. Needs to be addressed or explicitly discussed.
- 🟡 — Question or concern, but open to discussion. Treat as a nit unless context escalates it.

Map these onto Keith's own prefix system (`req:` / `nit:`) when summarizing review feedback.

### tylerschade review signal key and style (hybrid-cloud-fabric)

Tyler is the distinguished engineer on this team. His reviews carry significant weight and often surface design-level issues that others miss. His signal system uses text emoji (`:red-circle:` / `:yellow-circle:`), not Unicode emoji:
- `:red-circle:` — Strong objection or architectural concern. Treat as `req:`. Needs resolution or a documented decision to defer.
- `:yellow-circle:` — Question, suggestion, or concern. Non-blocking, but requires a real answer — he follows up if the response is thin.

**What Tyler watches for — and what to get right before the PR opens:**

- **"Why does this exist?"** — His most common question. Any new package, file, layer, or abstraction needs a clear reason that can be stated in one sentence. If the answer requires three paragraphs, the design probably needs simplification first. When the reason is good, he asks for it as a package doc or inline comment so the reasoning is preserved in source, not just in a review thread.

- **Environmental assumptions** — He challenges any code that assumes a tool is in `$PATH`, a file is at a relative path, or a context is available. Verify these explicitly. Test paths should resolve from repo root, not CWD. Tooling should have an `install_tools` target or equivalent.

- **Context propagation** — Long-running operations and goroutines must cancel on root context cancellation. He notices when a `context.Background()` is used where the caller's context should be threaded through. Check every `sdk.New()` or similar blocking init.

- **Avoid `go:build` tags** — Tyler considers build tags harmful (he wrote about this). Replace dev/stub implementations with mock interfaces controlled by config or constructor injection, not build constraints.

- **Log formatting** — `%+v` on structs in logs is flagged as "very confusing to read." Use JSON formatting (`json.Marshal`) for structured data in log output.

- **Idempotency of mutating endpoints** — Any endpoint that triggers evaluation, processing, or state transitions should be idempotent once a terminal state is reached. He will ask about it if it isn't obvious.

- **Bootstrap function length** — Long startup/init functions that accumulate initialization steps over time get flagged. Extract logical groups into named helper functions.

- **Architectural design, not just style** — Tyler engages on design questions (fail-closed vs. fail-open, async vs. sync, who owns state). He proposes concrete alternatives and holds a position across multiple replies, but accepts a well-reasoned pushback. When disagreeing with him, state the tradeoffs explicitly — don't just push back, explain why the alternative is worse in this specific context.

---

## Writing style — every word on Keith's behalf

Applies to comments, commit messages, PR bodies, review replies, docs, chat. Teammates have flagged AI-sounding text on shared work. The tell is volume: a paragraph of comments, explanation, and filler wrapped around every change, where an engineer would write nothing. Default fix: write less.

### Hard rules (read first)

- **Never use an em dash (`—`) or en dash (`–`).** Use a comma, a period, parentheses, or a spaced hyphen (` - `) if you need a break.
- **No AI openers or closers:** "Great question", "Sure!", "Let's dive in", "Hope this helps", "Let me know if you need anything else".
- **No benefit-selling around code:** "This ensures", "This allows", "This provides", "robust", "seamless", "comprehensive", "streamlined".
- **No diff narration in PRs:** if the body lists every file you touched, delete it and write two to six sentences on what changed and why.
- **Comments explain non-obvious constraints only.** If the comment restates what the name already says, delete the comment or rename the thing.
- **Match the repo's voice**, not a blog post. Short sentences. Fragments OK in notes. No emoji outside the profile README.

### Voice reference

Keith's register (see `git log`, `claude.md`): short declarative sentences. Fragments fine in notes. Concrete nouns, no adjective that doesn't change meaning. One sentence where one sentence works. Commit subjects imperative and specific: `Cache PATH system catalog lookups to cut NSR eval latency.`

### Banned — these read as AI

- Filler: "Note that", "It's worth noting", "Additionally", "Furthermore", "Importantly", "Essentially", "In order to", "As mentioned".
- Benefit-selling: "This ensures…", "This allows…", "This provides…", "…for better X". Code changes don't get sales copy.
- Marketing adjectives: comprehensive, robust, seamless, elegant, powerful, crucial, streamlined, production-ready.
- Triads ("fast, reliable, and secure") and "not just X, but Y" constructions.
- Openers and sign-offs: "Great question", "Sure!", "Let's", "Hope this helps", "Let me know if…". In review replies: no "You're absolutely right" — say "good catch, fixed" or just fix it.
- Headers, bold-lead bullet lists, or tables for anything that fits in a sentence or two. No "Summary"/"Overview"/"Key changes" sections.
- Emoji outside the profile README. None in code, commits, PRs, docs.
- Hedged claims: "should now work", "likely fixes". Verify, then state it plainly — or state that it's unverified and why.
- Restating the diff. If the PR body describes each file changed, delete the body and start over.

### The code speaks for itself

- If a comment explains what something is or does, the name failed — rename the thing and delete the comment. `retryBudget` needs no comment; `n2` with a paragraph does.
- Names follow the repo's conventions and say what the thing is for: no `data`, `result`, `helper`, `util`, `mgr`, `tmp`, no abbreviations a reader has to decode. A function name should make its call sites read as intent.
- A single succinct line is fine where it matches the repo style — but be cautious. When in doubt, follow the style of the repo, the file, and the language you're working in.
- No narration ("First we…", "Now that…"), no reviewer-directed comments ("this is deliberate", "note this preserves…"), no doc-comment essays. If a function needs a paragraph of justification, simplify the function instead.

### Commit messages

Imperative subject ≤72 chars, specific, work-item ref when one exists (`AB#…`). Body only when the subject can't carry it — a few plain sentences, never bullets. Match the repo's log before writing.

### PR bodies and review replies

Two to six sentences, written like Keith typed them after understanding the change. What changed, why, known gaps. Review replies answer the question asked, in one or two sentences, with a sha when the fix is pushed.

### Docs

- Only the docs the repo convention expects. No unprompted design docs, READMEs, or migration notes.
- Editing an existing doc: match its section style, add the minimum, no "see also" cross-references unless the doc already uses them.
- Cut the last paragraph of any draft — it's usually a restatement.

### Stay inside the repo

Use the repo's vocabulary. Don't import blog-speak, pattern names, or context paragraphs about things the team already knows. Don't leave breadcrumbs about the working session ("as discussed", "per the earlier change") — the artifact has to stand alone as team work.

### Self-check

Before submitting, diff the change and count the words that aren't code. A three-line fix with a paragraph of comments, a long commit body, and a PR essay is the tell — nobody annotates their own work that much. For every sentence ask: would Keith have bothered to write this? Usually no. Delete until what's left is only what a teammate actually needs.
