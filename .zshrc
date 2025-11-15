export EDITOR=nvim

# aliases
alias cd="z"
alias ls='eza --long --icons=always --color=always --git'
alias lsa='eza --all --color=always --long --icons=always --git'
alias tw='taskwarrior-tui'
alias tl='task list'
alias claer='clear'
alias cl='clear'
alias n='nvim'
alias fd='fzf'

# functions
shrc() { (cd ~/.dotfiles/ && nvim .zshrc); }
rez() { source ~/.dotfiles/.zshrc && echo ".zshrc reloaded" && sleep 0.25 && clear; }


# ~/.zshrc
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(fzf --zsh)"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
