# Enable Powerlevel10k instant prompt. Keep at the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Local-only config — never commit (work env, secrets, second GitHub account).
[[ -f ~/.zsh/local.zsh ]] && source ~/.zsh/local.zsh
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
#                     GitHub (personal)                      #
##############################################################

export REPOS_PERSONAL=~/repos/talador12

alias repos='cd ~/repos'
alias cdp='cd "$REPOS_PERSONAL"'
alias talador12='cd "$REPOS_PERSONAL"'
alias adventure='cd "$REPOS_PERSONAL/adventure" 2>/dev/null || cd "$REPOS_PERSONAL"'

gh-personal() { gh auth switch -u Talador12; }

clone-personal() {
  gh auth switch -u Talador12
  git clone "https://github.com/${1}.git" "$REPOS_PERSONAL/$(basename "$1")"
}

github-keys() {
  cat ~/.ssh/id_ed25519_personal.pub
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

##############################################################
#                     Prompt                                 #
##############################################################

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

##############################################################
#                     Toolchains                             #
#  Python → uv    Rust → rustup    Go → mise    Node → bun
##############################################################

if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

export PATH="$HOME/.local/bin:$PATH"

if command -v uv &>/dev/null; then
  eval "$(uv generate-shell-completion zsh 2>/dev/null)" || true
fi
