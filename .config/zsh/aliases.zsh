export EDITOR="nvim"
alias aedit="$EDITOR $ZSH_CONFIG/aliases.zsh; source $ZSH_CONFIG/aliases.zsh"
alias fedit="$EDITOR $ZSH_CONFIG/functions.zsh; source $ZSH_CONFIG/functions.zsh"
alias pedit=" $EDITOR $ZSH_CONFIG/private.zsh; source $ZSH_CONFIG/private.zsh"

alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias gvim="nvim --listen ~/.cache/nvim/godot.pipe ."
alias aedit="$EDITOR $ZSH_CONFIG/aliases.zsh; source $ZDOTDIR/aliases.zsh"
alias fedit="$EDITOR $ZSH_CONFIG/functions.zsh; source $ZDOTDIR//functions.zsh"
alias pedit=" $EDITOR $ZSH_CONFIG/private.zsh; source $ZDOTDIR/private.zsh"
alias zedit=" $EDITOR $ZSH_CONFIG/.zshrc; source $ZDOTDIR/.zshrc"
alias viedit=" $EDITOR $HOME/.vim/vimrc"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias sudo="nocorrect sudo -E "

alias ls="eza --icons --git-ignore"
alias la="eza --icons -a"

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .2='cd ../../..'
alias .3='cd ../../../..'
alias .4='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# Fixes "Error opening terminal: xterm-kitty" when using the default kitty term to open some programs through ssh
alias ssh='kitten ssh'

# Git aliases
alias gb='git branch'
alias gc='git commit'
alias ga='git add'

#Connect vpn
alias vpn="$HOME/Scripts/vpn-connect.sh"
