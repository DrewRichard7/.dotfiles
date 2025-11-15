# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
alias tw='taskwarrior-tui'
alias tl='task list'
alias claer='clear'
alias repo='gh-repo-webapp'
alias cl='clear'

# functions
mybashrc() { (cd ~/.dotfiles/ && nvim .bashrc); }
reb() { source ~/.dotfiles/.bashrc && echo ".bashrc reloaded" && sleep 0.25 && clear; }
envrc() {
    if [[ -f .envrc ]]; then
        echo ".envrc exists"
    else
        echo "source .venv/bin/activate" >>.envrc
    fi
}

archive-nvim() {
    if [[ -d ~/dev/archive/nvim ]]; then
        (cp -r ~/.dotfiles/.config/nvim ~/dev/archive/ && cd ~/dev/archive/nvim/ && git add . && git commit -m 'automated commit from archive' && git push origin main && echo "nvim config backed up to ~/dev/archive/")
    else
        mkdir -p ~/dev/archive && (cp -r ~/.dotfiles/.config/nvim ~/dev/archive/ && cd ~/dev/archive/nvim/ && git add . && git commit -m 'automated commit from archive' && git push origin main && echo "nvim config backed up to ~/dev/archive/")
    fi
}

archive-dotfiles() {
    if [[ -d ~/.dotfiles/ ]]; then
        (cd ~/.dotfiles && git add . && git commit -m "automated archiving commit" && git push origin main)
    else
        mkdir -p ~/.dotfiles && echo ".dotfiles directory created. you need to create github ssh credentials and clone .dotfiles from ham-munculus"
    fi
}

export PATH="$HOME/.config/scripts:$PATH"

eval "$(direnv hook bash)"
. "$HOME/.local/share/../bin/env"
. "$HOME/.cargo/env"
