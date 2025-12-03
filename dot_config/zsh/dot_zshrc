source ~/.config/zsh/environment.zsh
export GPG_TTY=$(tty)
# This command updates gpg-agent about your current TTY for PIN entry
gpg-connect-agent UPDATESTARTUPTTY /bye >/dev/null 2>&1 || true
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

