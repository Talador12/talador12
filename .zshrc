# Enable Powerlevel10k instant prompt. Keep at the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Local-only config (work env, secrets) — never commit these files.
[[ -f ~/.zsh/geico.zsh ]] && source ~/.zsh/geico.zsh
[[ -f ~/.zsh/secrets.zsh ]] && source ~/.zsh/secrets.zsh

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  docker
  kubectl
  brew
  macos
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

##############################################################
#                     GitHub dual-account                    #
##############################################################

export REPOS_PERSONAL=~/repos/talador12
export REPOS_GEICO=~/repos/geico

alias cdp='cd "$REPOS_PERSONAL"'
alias cdg='cd "$REPOS_GEICO"'
alias repos='cd ~/repos'

gh-personal() { gh auth switch -u Talador12; }
gh-geico()    { gh auth switch -u keithadler_geico; }

clone-personal() {
  gh auth switch -u Talador12
  git clone "https://github.com/${1}.git" "$REPOS_PERSONAL/$(basename "$1")"
}

clone-geico() {
  gh auth switch -u keithadler_geico
  git clone "https://github.com/${1}.git" "$REPOS_GEICO/$(basename "$1")"
}

github-keys() {
  echo "=== Personal (Talador12) ==="
  cat ~/.ssh/id_ed25519_personal.pub
  echo ""
  echo "=== GEICO (keithadler_geico) ==="
  cat ~/.ssh/id_ed25519_geico.pub
}

##############################################################
#                     Personal aliases                       #
##############################################################

alias 1pass="op signin"
alias create_venv="uv venv"
alias py="uv run python"
alias pip="uv pip"
alias sync="uv sync"
alias change="git add -A && git commit -m 'hotfix to squash' && git push"
alias latr="ls -latr"
alias venv="source .venv/bin/activate"
alias amend="git add -A && git commit --amend --no-edit && git push --force"

if command -v eza &>/dev/null; then
  alias lsr="eza -abghHliS"
else
  alias lsr="ls -la"
fi

alias talador12='cd "$REPOS_PERSONAL"'
alias adventure='cd "$REPOS_PERSONAL/adventure" 2>/dev/null || cd "$REPOS_PERSONAL"'

##############################################################
#                     Prompt & appearance                    #
##############################################################

if command -v figlet &>/dev/null; then
  GEICO_BLUE="\e[38;5;27m"
  STOPCOLOR="\e[0m"
  printf "${GEICO_BLUE}"
  figlet -c -l "GEICO"
  printf "${STOPCOLOR}"
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

##############################################################
#                     Toolchains                             #
#  Python → uv       (versions, venv, deps, run)
#  Rust   → rustup   (official toolchain manager)
#  Go     → mise     (version pin; projects use go.mod toolchain)
#  Node   → bun      (runtime + packages; use mise node only if needed)
##############################################################

if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

export PATH="$HOME/.local/bin:$PATH"

if command -v uv &>/dev/null; then
  eval "$(uv generate-shell-completion zsh 2>/dev/null)" || true
fi
