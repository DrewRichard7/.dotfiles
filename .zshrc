# If not running interactively, don't do anything.
[[ -o interactive ]] || return

# Avoid doing expensive/duplicate setup if .zshrc gets sourced repeatedly.
[[ -n "${__HAM_ZSHRC_LOADED:-}" ]] && return
__HAM_ZSHRC_LOADED=1

# ===========================================================
# Environment
# ===========================================================

export PATH="$HOME/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.config/scripts:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
# export PATH="$HOME/Applications/nvim-macos-arm64/bin:$PATH"

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi

# Color man pages with bat
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# History
HISTSIZE=32768
SAVEHIST="$HISTSIZE"
HISTFILE="${HISTFILE:-$HOME/.zsh_history}"

setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ===========================================================
# Aliases
# ===========================================================

# alias cd="z"

alias ls='eza -lh --group-directories-first --git --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias sla='ls -a'

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias fd='fzf'
alias y='yazi'

alias tw='taskwarrior-tui'
alias tl='task list'

alias cl='clear'
alias claer='clear'
alias clare='clear'

alias repo='gh-repo-webapp'
alias c='opencode'

alias python='python3'
alias ei='exit'

alias gs='git status'
alias gss='git status --short'
alias gimme='python3 -c "import uuid; print(uuid.uuid4())"'

alias t='tmux attach || tmux new -s Project'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ===========================================================
# Quick edit/navigation functions
# ===========================================================

shrc() { (cd ~/.dotfiles/ && nvim .zshrc); }

resh() {
  unset __HAM_ZSHRC_LOADED
  source ~/.dotfiles/.zshrc && echo ".zshrc reloaded" && sleep 0.25 && clear
}

tmuxrc() { (cd ~/.config/tmux/ && nvim tmux.conf); }

n() {
  if [[ "$#" -eq 0 ]]; then
    nvim
  else
    nvim "$@"
  fi
}

nvimrc() { (cd ~/.dotfiles/.config/nvim/ && n .); }
nvimrepo() { cd ~/.dotfiles/.config/nvim || return; lsa; }

ghosttyrc() { (cd ~/.dotfiles/.config/ghostty/ && n config); }

obsidianvim() { (cd ~/dev/obsidianvim/ && n home.md); }

gemma() { (ollama run gemma4:12b-mlx); }

# ===========================================================
# Project helpers
# ===========================================================

envrc() {
  if [[ -f .envrc ]]; then
    if grep -qxF "source .venv/bin/activate" .envrc; then
      echo ".envrc already configured"
    else
      echo "source .venv/bin/activate" >> .envrc
      echo "added venv activation to .envrc"
    fi
  else
    echo "source .venv/bin/activate" >> .envrc
    echo "created .envrc"
  fi
}

gc() {
  [[ -n "$*" ]] || {
    echo "Usage: gc <commit message>"
    return 1
  }

  git commit -m "$*"
}

archive-dotfiles() {
  if [[ -d ~/.dotfiles/ ]]; then
    (
      cd ~/.dotfiles || exit 1

      git add .

      local changed_files
      changed_files="$(git diff --cached --name-only)"

      if [[ -z "$changed_files" ]]; then
        echo "No changes to commit"
        exit 0
      fi

      local changed_files_inline
      changed_files_inline="$(echo "$changed_files" | tr '\n' ',' | sed 's/,$//')"

      git commit -m "Automated archiving commit: $changed_files_inline"

      git push origin main
    )
  else
    mkdir -p ~/.dotfiles
    echo ".dotfiles directory created. you need to create github ssh credentials and clone .dotfiles from ham-munculus"
  fi
}

prune-branches() {
    git fetch --prune || return

    git branch -vv |
        awk '/: gone]/{print $1}' |
        while read -r branch; do
            git branch -d "$branch"
        done
}

# ===========================================================
# Platform helpers
# ===========================================================

open() {
  case "$(uname -s)" in
    Darwin)
      command open "$@"
      ;;
    Linux)
      xdg-open "$@" > /dev/null 2>&1 &
      ;;
    *)
      echo "Unsupported OS for open: $(uname -s)"
      return 1
      ;;
  esac
}
# ===========================================================
# Zsh completion
# ===========================================================

autoload -Uz compinit
compinit

# Make completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Only ask if there are more than N matches
LISTMAX=200

# Allow completion in the middle of a word
setopt COMPLETE_IN_WORD

# ===========================================================
# Tool initialization
# ===========================================================

if command -v direnv > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v zoxide > /dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v starship > /dev/null 2>&1 && [[ ${TERM:-} != "dumb" ]]; then
  eval "$(starship init zsh)"
fi

if command -v fzf > /dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -f "$HOME/.local/bin/env" ]]; then
  source "$HOME/.local/bin/env"
fi
