# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# 1. Environment Variables & Core Preferences
# ---------------------------------------------------------------------
export EDITOR="nvim"

# ---------------------------------------------------------------------
# 2. Antidote Plugin Manager (The Optimized Way)
# ---------------------------------------------------------------------
# Instead of hardcoding paths for 4 plugins, let Antidote handle it.
# Ensure your plugins are listed in: ~/.config/zsh/plugins.txt
# Then, you only need these lines to load everything safely:
_antidote_dir="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"
if [[ -d "$_antidote_dir" ]]; then
    source "$_antidote_dir/antidote.zsh"
    antidote load "${ZDOTDIR:-$HOME}/plugins.txt"
fi

# Custom keybinds for plugins
bindkey '^Y' autosuggest-accept

# ---------------------------------------------------------------------
# 3. Dotfile & Config Management Aliases
# ---------------------------------------------------------------------
# Kept clean using $ZDOTDIR as the source of truth
alias zedit="$EDITOR ${ZDOTDIR:-$HOME}/.zshrc; source ${ZDOTDIR:-$HOME}/.zshrc"
alias aedit="$EDITOR ${ZDOTDIR:-$HOME}/aliases.zsh; source ${ZDOTDIR:-$HOME}/aliases.zsh"
alias fedit="$EDITOR ${ZDOTDIR:-$HOME}/functions.zsh; source ${ZDOTDIR:-$HOME}/functions.zsh"
alias pedit="$EDITOR ${ZDOTDIR:-$HOME}/private.zsh; source ${ZDOTDIR:-$HOME}/private.zsh"
alias viedit="$EDITOR $HOME/.vim/vimrc"

# ---------------------------------------------------------------------
# 4. Applications & Enhancements
# ---------------------------------------------------------------------
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias gvim="nvim --listen ~/.cache/nvim/godot.pipe ."
alias sudo="nocorrect sudo -E "

# Modern CLI replacements
alias ls="eza --icons --git-ignore"
alias la="eza --icons -a"
alias wget='wget --hsts-file="${XDG_DATA_HOME:-$HOME/.local/share}/wget-hsts"'

# SSH Escape hatch for Kitty terminal
alias ssh='kitten ssh'

# ---------------------------------------------------------------------
# 5. Quality of Life & Navigation Shortcuts
# ---------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias .2='cd ../../..'
alias .3='cd ../../../..'
alias .4='cd ../../../../../'

alias mkdir='mkdir -p'

# Git
alias gb='git branch'
alias gc='git commit'
alias ga='git add'

# Zellij Session Workflows (Wrapped safely in a check)
if [[ -d "$HOME/Scripts" ]]; then
    alias s='sh $HOME/Scripts/find_and_start_zellij.sh'
    alias f='sh $HOME/Scripts/attach_existing_zellij.sh'
fi
