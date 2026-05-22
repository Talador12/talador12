MAKEFLAGS += --no-print-directory --warn-undefined-variables --output-sync=target

################################################################################
#                                 Variables                                    #
################################################################################

SHELL := /bin/bash

# Project identity — override per-project.
PROJECT_NAME := my-project

# Flip to true when ready to deploy production. Guards all prod targets.
PRODUCTION_RELEASE := false

# Ports — adjust to your stack. One port is enough for most projects.
PORT_DEV := 5173

# Version from package.json (Node). For other stacks, swap the shell expression:
#   Python:  $(shell python -c "import tomllib; print(tomllib.load(open('pyproject.toml','rb'))['project']['version'])")
#   Cargo:   $(shell grep '^version' Cargo.toml | head -1 | cut -d'"' -f2)
#   Static:  $(shell cat VERSION 2>/dev/null || echo "0.0.0")
VERSION := $(shell node -p "require('./package.json').version" 2>/dev/null || echo "0.0.0")

# Per-command knobs. Override here once and the targets below pick them up.
INSTALL_CMD   := npm install
DEV_CMD       := npx vite --port $(PORT_DEV)
BUILD_CMD     := npm run build
TEST_CMD      := npm test
FORMAT_CMD    := npx prettier --write .
LINT_CMD      := npx prettier --check .
TYPECHECK_CMD := npx tsc --noEmit
CLEAN_DIRS    := node_modules dist .vite .turbo .next

################################################################################
#                                 Functions                                    #
################################################################################

# Gate macro — aborts if PRODUCTION_RELEASE is not true.
define require_production_release
	@if [ "$(PRODUCTION_RELEASE)" != "true" ]; then \
		echo ""; \
		echo "  PRODUCTION_RELEASE is false. Set to true in Makefile"; \
		echo "  to enable production deployments."; \
		echo ""; \
		exit 1; \
	fi
endef

################################################################################
#                                 Meta                                         #
################################################################################

.DEFAULT_GOAL := help
.PHONY: help list-targets makeinfo

# Prevent Make from trying to remake Makefile via pattern rule.
Makefile: makeinfo ;

################################################################################
#                             Development                                      #
################################################################################

dev: makeinfo kill ## [Dev] Start dev server (foreground)
	@echo "Starting dev server..."
	@$(DEV_CMD) & \
	sleep 2 && \
	echo "" && \
	echo "  Dev: http://localhost:$(PORT_DEV)" && \
	echo "" && \
	wait

dev-bg: makeinfo kill ## [Dev] Start dev server (background)
	@nohup $(DEV_CMD) > /tmp/$(PROJECT_NAME)-dev.log 2>&1 &
	@sleep 2
	@echo ""
	@echo "  Dev: http://localhost:$(PORT_DEV)"
	@echo "  Logs: tail -f /tmp/$(PROJECT_NAME)-dev.log"
	@echo "  Stop: make kill"
	@echo ""

dev-logs: ## [Dev] Tail background dev server logs
	@tail -f /tmp/$(PROJECT_NAME)-dev.log 2>/dev/null || echo "No background logs found. Run 'make dev-bg' first."

start: makeinfo ## [Dev] Quick start: kill, build, dev
	$(MAKE) kill
	$(MAKE) build
	$(MAKE) dev

fresh: makeinfo ## [Dev] Full reset: clean, install, format, build, dev
	$(MAKE) kill
	$(MAKE) clean
	$(MAKE) install
	$(MAKE) format
	$(MAKE) build
	$(MAKE) dev

open: makeinfo ## [Dev] Open dev server in browser
	@open http://localhost:$(PORT_DEV) 2>/dev/null || xdg-open http://localhost:$(PORT_DEV) 2>/dev/null || echo "Open manually: http://localhost:$(PORT_DEV)"

################################################################################
#                                Build                                         #
################################################################################

build: makeinfo ## [Build] Build the project
	$(BUILD_CMD)

################################################################################
#                                 Test                                         #
################################################################################

test: makeinfo ## [Test] Run the test suite
	$(TEST_CMD)

test-watch: makeinfo ## [Test] Run tests in watch mode (override TEST_WATCH_CMD if needed)
	$(or $(TEST_WATCH_CMD),npx vitest)

################################################################################
#                                Deploy                                        #
################################################################################

# Wire these up per-project. The staging target is open; the prod target is gated.

deploy: makeinfo ## [Deploy] Deploy to staging (override per project)
	@echo "  TODO: wire up 'deploy' for $(PROJECT_NAME)"

deploy-prod: makeinfo ## [Deploy] Deploy to production (gated by PRODUCTION_RELEASE)
	$(require_production_release)
	@echo "  TODO: wire up 'deploy-prod' for $(PROJECT_NAME)"

################################################################################
#                                Release                                       #
################################################################################

release: makeinfo ## [Release] Tag, push, and create GitHub release
	@echo "  Releasing v$(VERSION)"
	@if git tag -l "v$(VERSION)" | grep -q "v$(VERSION)"; then \
		echo "ERROR: Tag v$(VERSION) already exists. Bump version first."; \
		exit 1; \
	fi
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "ERROR: Working tree is dirty. Commit or stash first."; \
		exit 1; \
	fi
	git tag -a "v$(VERSION)" -m "Release v$(VERSION)"
	git push origin "v$(VERSION)"
	gh release create "v$(VERSION)" \
		--title "v$(VERSION)" \
		--notes-file - <<< "$$(git log $$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || git rev-list --max-parents=0 HEAD)..HEAD --oneline --no-decorate)"
	@echo "  Released v$(VERSION)"

release-patch: makeinfo ## [Release] Bump patch (0.1.0 -> 0.1.1), commit, release
	@$(MAKE) _bump-version BUMP=patch
	@$(MAKE) release

release-minor: makeinfo ## [Release] Bump minor (0.1.0 -> 0.2.0), commit, release
	@$(MAKE) _bump-version BUMP=minor
	@$(MAKE) release

_bump-version: makeinfo
	@old=$(VERSION); \
	IFS='.' read -r major minor patch <<< "$$old"; \
	if [ "$(BUMP)" = "patch" ]; then patch=$$((patch + 1)); \
	elif [ "$(BUMP)" = "minor" ]; then minor=$$((minor + 1)); patch=0; \
	elif [ "$(BUMP)" = "major" ]; then major=$$((major + 1)); minor=0; patch=0; \
	fi; \
	new="$$major.$$minor.$$patch"; \
	node -e "const p=require('./package.json');p.version='$$new';require('fs').writeFileSync('package.json',JSON.stringify(p,null,2)+'\n')"; \
	git add package.json; \
	git commit -m "chore: bump version to v$$new"; \
	echo "Bumped $$old -> $$new"

################################################################################
#                                 Status                                       #
################################################################################

status: makeinfo ## [Monitor] Show port usage, branch, last commit, release gate
	@echo ""
	@pid=$$(lsof -ti :$(PORT_DEV) 2>/dev/null); \
	if [ -n "$$pid" ]; then echo "  :$(PORT_DEV)  active (PID $$pid)"; else echo "  :$(PORT_DEV)  free"; fi
	@echo ""
	@echo "  Branch: $$(git branch --show-current 2>/dev/null || echo 'not a git repo')"
	@echo "  Last commit: $$(git log -1 --oneline 2>/dev/null || echo 'no commits')"
	@echo "  Version: v$(VERSION)"
	@echo "  PRODUCTION_RELEASE = $(PRODUCTION_RELEASE)"
	@echo ""

################################################################################
#                                Cleanup                                       #
################################################################################

clean: makeinfo kill ## [Cleanup] Kill servers + remove generated files and deps
	rm -rf $(CLEAN_DIRS)

kill: makeinfo ## [Cleanup] Kill the dev server port
	@pid=$$(lsof -ti :$(PORT_DEV) 2>/dev/null); \
	if [ -n "$$pid" ]; then echo "Killing port $(PORT_DEV) (pid: $$pid)"; echo $$pid | xargs kill -9 2>/dev/null; fi
	@rm -f /tmp/$(PROJECT_NAME)-dev.log
	@echo "Dev server stopped."

################################################################################
#                                Utility                                       #
################################################################################

install: makeinfo ## [Utility] Install dependencies
	$(INSTALL_CMD)

format: makeinfo ## [Utility] Format the codebase
	$(FORMAT_CMD)

lint: makeinfo ## [Utility] Check formatting / lint
	$(LINT_CMD)

typecheck: makeinfo ## [Utility] Type-check (no emit)
	$(TYPECHECK_CMD)

ci: makeinfo ## [Utility] Full CI pipeline: typecheck + lint + build + test
	@echo "Running CI pipeline..."
	$(MAKE) typecheck
	$(MAKE) lint
	$(MAKE) build
	$(MAKE) test

commit: makeinfo ## [Git] Format + commit + push: make commit M='message'
	@msg="$(M)"; \
	if [ -z "$$msg" ]; then echo "Usage: make commit M='your message'"; exit 1; fi; \
	$(MAKE) format; \
	git add .; \
	git commit -m "$$msg"; \
	git push

tree: makeinfo ## [Utility] Print directory tree (ignores common build artifacts)
	tree -I 'node_modules|.git|dist|.next|.turbo|.vite|public|venv|__pycache__|target' -L 5

################################################################################
#                              Help & Info                                     #
################################################################################

help: # Help command — lists targets with descriptions, sorted, colorized.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "} {printf "%s %03d:## %s\n", $$1, length($$1), $$2}' | sort -k1,1 -k2,2n | awk -F':## ' '{split($$1, parts, " "); printf "\033[36m%-22s\033[0m %s\n", parts[1], $$2}'

list-targets: ## [Utility] List ALL targets (including private)
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$$@$$'

MAKECMDGOALS ?=

makeinfo: # Banner — prints "Running: <goal>" before each target.
	@goal="$(MAKECMDGOALS)"; \
	if [ "$$goal" = "" ] || [ "$$goal" = "makeinfo" ] || [ "$$goal" = "help" ]; then exit 0; fi; \
	echo "" 1>&2; \
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" 1>&2; \
	echo "  Running: $$goal" 1>&2; \
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" 1>&2; \
	echo "" 1>&2
