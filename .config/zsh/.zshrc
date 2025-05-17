source $ZDOTDIR/environment.zsh
HISTFILE=$ZSH_CONFIG/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
typeset -ga sources
source "$ZSH_CONFIG/aliases.zsh"
source "$ZSH_CONFIG/keybinds.zsh"

source "$ZSH_CONFIG/zsh-antidote/antidote.zsh"
antidote load

eval "$(starship init zsh)"

