# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Avoid doing expensive/duplicate setup if .bashrc gets sourced repeatedly.
[[ -n "${__HAM_BASHRC_LOADED:-}" ]] && return
__HAM_BASHRC_LOADED=1

# ===========================================================
# Omarchy defaults
# ===========================================================

[[ -f ~/.local/share/omarchy/default/bash/rc ]] &&
  source ~/.local/share/omarchy/default/bash/rc

# ===========================================================
# Environment
# ===========================================================

export PATH="$HOME/.local/bin:$HOME/.config/scripts:$PATH"

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi

# Color man pages with bat
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# History
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=32768
HISTFILESIZE="$HISTSIZE"

# Ensure command hashing is off for mise
set +h

# ===========================================================
# Aliases
# ===========================================================

alias ls='eza -lh --group-directories-first --git --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias sla='ls -a'

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias y='yazi'

alias tw='taskwarrior-tui'
alias tl='task list'

alias cl='clear'
alias claer='clear'
alias clare='clear'

alias repo='gh-repo-webapp'

alias gss='git status --short'
alias gimme='python3 -c "import uuid; print(uuid.uuid4())"'

alias t='tmux attach || tmux new -s Project'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ===========================================================
# Quick edit/navigation functions
# ===========================================================

shrc() { (cd ~/ && nvim .bashrc); }

resh() {
  unset __HAM_BASHRC_LOADED
  source ~/.bashrc && echo ".bashrc reloaded" && sleep 0.25 && clear
}

tmuxrc() { (cd ~/.config/tmux/ && nvim tmux.conf); }

nvimrc() { (cd ~/.config/nvim/ && n .); }
nvimrepo() { cd ~/.config/nvim/ || return; lsa; }

hyprc() { (cd ~/.config/hypr/ && n .); }
waybarc() { (cd ~/.config/waybar/ && n .); }

todo() { (cd ~/projects && nvim todo.md); }
qn() { (cd ~/projects && nvim quicknote.md); }

projects() { cd ~/projects || return; lsa; }

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

proj() {
  local repo="$1"
  local name
  name="$(basename "$repo" .git)"

  local GREEN='\033[1;32m'
  local RESET='\033[0m'

  printf "Navigating to ~/projects/ and cloning new project ${GREEN}%s${RESET}\n" \
    "$name"

  cd ~/projects || return
  git clone "$repo" || return

  printf "\nProjects Directory\n"
  printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"

  local item
  for item in ./*; do
    item="${item##*/}"

    if [[ "$item" == "$name" ]]; then
      printf "${GREEN}%s${RESET}\n" "$item"
    else
      printf "%s\n" "$item"
    fi
  done

  printf "\n"
}

# Create a new worktree and branch from within current git directory.
ga() {
  if [[ -z "$1" ]]; then
    echo "Usage: ga [branch name]"
    return 1
  fi

  local branch="$1"
  local base
  local wt_path

  base="$(basename "$PWD")"
  wt_path="../${base}--${branch}"

  git worktree add -b "$branch" "$wt_path" || return
  mise trust "$wt_path"
  cd "$wt_path" || return
}

# Remove worktree and branch from within active worktree directory.
gd() {
  if gum confirm "Remove worktree and branch?"; then
    local cwd worktree root branch

    cwd="$(pwd)"
    worktree="$(basename "$cwd")"

    root="${worktree%%--*}"
    branch="${worktree#*--}"

    if [[ "$root" != "$worktree" ]]; then
      cd "../$root" || return
      git worktree remove "$cwd" --force || return
      git branch -D "$branch"
    fi
  fi
}

# Create a tmux dev layout with editor, AI, and terminal.
# Usage: tdl <c|cx|codex|other_ai> [<second_ai>]
tdl() {
  [[ -z "$1" ]] && {
    echo "Usage: tdl <c|cx|codex|other_ai> [<second_ai>]"
    return 1
  }

  [[ -z "$TMUX" ]] && {
    echo "You must start tmux to use tdl."
    return 1
  }

  local current_dir="$PWD"
  local editor_pane="$TMUX_PANE"
  local ai_pane ai2_pane
  local ai="$1"
  local ai2="$2"

  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
  ai_pane="$(
    tmux split-window \
      -h \
      -p 30 \
      -t "$editor_pane" \
      -c "$current_dir" \
      -P \
      -F '#{pane_id}'
  )"

  if [[ -n "$ai2" ]]; then
    ai2_pane="$(
      tmux split-window \
        -v \
        -t "$ai_pane" \
        -c "$current_dir" \
        -P \
        -F '#{pane_id}'
    )"
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi

  tmux send-keys -t "$ai_pane" "$ai" C-m
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
  tmux select-pane -t "$editor_pane"
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
# Bash completion
# ===========================================================

if [[ ! -v BASH_COMPLETION_VERSINFO &&
  -f /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
fi

if command -v fzf &> /dev/null; then
  [[ -f /usr/share/fzf/completion.bash ]] &&
    source /usr/share/fzf/completion.bash
  [[ -f /usr/share/fzf/key-bindings.bash ]] &&
    source /usr/share/fzf/key-bindings.bash
fi

if [[ -n "${OMARCHY_PATH:-}" &&
  -f "$OMARCHY_PATH/default/bash/completions" ]]; then
  source "$OMARCHY_PATH/default/bash/completions"
fi

# ===========================================================
# Tool initialization
# ===========================================================

if command -v mise &> /dev/null; then
  eval "$(mise activate bash)"
fi

if command -v starship &> /dev/null && [[ ${TERM:-} != "dumb" ]]; then
  eval "$(starship init bash)"
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init bash)"
fi

if command -v direnv &> /dev/null; then
  eval "$(direnv hook bash)"
fi

if command -v try &> /dev/null; then
  try() {
    unset -f try
    eval "$(SHELL=/bin/bash command try init ~/Work/tries)"
    try "$@"
  }
fi

# Optional tool environments
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
