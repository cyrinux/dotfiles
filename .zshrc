if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( EUID )) && for f in ~/.zshrc ~/.zsh/*.zsh; do [[ ! -s $f.zwc || $f -nt $f.zwc ]] && zcompile $f; done

# Launch a tmux session
if [[ "$HOST" =~ "onlinux" ]]; then
  . ~/.zsh/autorun-same-tmux.zsh
fi

# Lazy-loading
. ~/.zsh/sandboxd.zsh

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
. ~/.zsh/p10k-transient.zsh

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
