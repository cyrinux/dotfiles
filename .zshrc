if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load environment variables
. /usr/share/LS_COLORS/dircolors.sh

# Load plugins
. ~/.zsh/prezto.zsh
. ~/.zsh/zsh-notify.zsh
. ~/.zsh/antigen.zsh
. ~/.zsh/prezto-patches.zsh

# Load terminal configuration
. ~/.zsh/title.zsh
. ~/.zsh/prompt.zsh

# Load custom configurations
. ~/.zsh/opts.zsh
. ~/.zsh/keybindings.zsh
. ~/.zsh/aliases.zsh
. ~/.zsh/pacman.zsh
. ~/.zsh/kubectl.zsh
. ~/.zsh/functions.zsh
. ~/.zsh/git.zsh
. ~/.zsh/fuzzy.zsh
. ~/.zsh/ssh.zsh
. ~/.zsh/docker.zsh
. ~/.zsh/pentest.zsh

# Load python mkvirtualenv
[ -f /usr/bin/virtualenvwrapper_lazy.sh ]  && . /usr/bin/virtualenvwrapper_lazy.sh >/dev/null

# Load todoist functions
[ -f /usr/share/todoist/todoist_functions.sh ] && . /usr/share/todoist/todoist_functions.sh >/dev/null

# Load azure-cli completions
[ -f /opt/azure-cli/bin/az.completion.sh ] && . /opt/azure-cli/bin/az.completion.sh >/dev/null

# Bash completion for some tools
. ~/.zsh/complete.zsh

# Make Ctrl-D work with p10k instant prompt
function my-ctrl-d() {
    zle || exit 0
    [[ -n $BUFFER ]] && return
    typeset -g precmd_functions=(my-ctrl-d)
    zle accept-line
}
zle -N my-ctrl-d
bindkey '^D' my-ctrl-d
setopt ignore_eof
