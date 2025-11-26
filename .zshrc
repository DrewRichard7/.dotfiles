export EDITOR=nvim
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$HOME/Applications/nvim-macos-arm64/bin:$PATH"

# aliases
# alias cd="z"
alias ls='eza -lh --group-directories-first --git --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias tw='taskwarrior-tui'
alias tl='task list'
alias claer='clear'
alias cl='clear'
alias fd='fzf'
alias python='python3'
alias ei='exit'

# functions
shrc() { (cd ~/.dotfiles/ && nvim .zshrc); }
resh() { source ~/.dotfiles/.zshrc && echo ".zshrc reloaded" && sleep 0.25 && clear; }

envrc() {
    if [[ -f .envrc ]]; then
        echo ".envrc exists"
    else
        echo "source .venv/bin/activate" >>.envrc
    fi
}

archive-dotfiles() {
    if [[ -d ~/.dotfiles/ ]]; then
        (
            cd ~/.dotfiles || exit 1

            git add .

            changed_files=$(git diff --cached --name-only)

            if [[ -z "$changed_files" ]]; then
                echo "No changes to commit"
                exit 0
            fi

            # turn newlines into commas for the commit
            changed_files_inline=$(echo "$changed_files" | tr '\n' ',' | sed 's/,$//')

            git commit -m "Automated archiving commit: $changed_files_inline"

            git push origin main
        )

    else
        mkdir -p ~/.dotfiles
        echo ".dotfiles directory created. you need to create github ssh credentials and clone .dotfiles from ham-munculus"
    fi
}

open() {
  xdg-open "$@" >/dev/null 2>&1 &
}

n() {
  if [ "$#" -eq 0 ]; then
    nvim .
  else
    nvim "$@"
  fi
}

nvimrc() {
    (cd ~/.dotfiles/.config/nvim/

    n .
);
}

ghosttyrc() {
    (cd ~/.dotfiles/.config/ghostty/

    n config
);
}



# Make completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Only ask if there are more than N matches
LISTMAX=200
setopt COMPLETE_IN_WORD    # allow completion in the middle of a word

# ~/.zshrc
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(fzf --zsh)"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

. "$HOME/.local/bin/env"
