#!/usr/bin/env zsh

zstyle ':z4h:' start-tmux no
zstyle ':z4h:'                                    auto-update            no
zstyle ':z4h:*'                                   channel                stable
zstyle ':z4h:autosuggestions'                     forward-char           partial-accept
zstyle ':z4h:fzf-complete'                        fzf-command            my-fzf
zstyle ':z4h:(fzf-complete|cd-down|fzf-history)'  fzf-flags              --no-exact --color=hl:14,hl+:14
zstyle ':z4h:(fzf-complete|cd-down)'              fzf-bindings           'tab:repeat'
zstyle ':fzf-tab:*'                               continuous-trigger     tab
zstyle ':z4h:(fzf-complete|cd-down)'              find-flags             -name '.git' -prune -print -o -print
zstyle ':z4h:term-title:local'                    preexec                '%* | ${1//\%/%%}'
zstyle ':zle:(up|down)-line-or-beginning-search'  leave-cursor           yes
zstyle ':z4h:zsh-syntax-highlighting'             channel                stable
zstyle ':completion:*:ssh:argument-1:'            tag-order hosts users
zstyle ':completion:*:scp:argument-rest:'         tag-order hosts files users
zstyle ':completion:*:(ssh|scp|rdp):*:hosts'      hosts
###

z4h install romkatv/archive || return
z4h init || return

####

zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}" "l:|=* r:|=*"

####

fpath+=($Z4H/romkatv/archive)
autoload -Uz archive lsarchive unarchive edit-command-line hist

zle -N edit-command-line

my-fzf () {
    emulate -L zsh -o extended_glob
    local MATCH MBEGIN MEND
    fzf "${@:/(#m)--query=?*/$MATCH }"
}

my-ctrl-z() {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line -w
    else
        zle push-input -w
        zle clear-screen -w
    fi
}
zle -N my-ctrl-z

###

z4h bindkey z4h-backward-kill-word  Ctrl+Backspace
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace
z4h bindkey z4h-kill-zword          Ctrl+Alt+Delete

z4h bindkey z4h-forward-zword       Ctrl+Alt+Right
z4h bindkey z4h-backward-zword      Ctrl+Alt+Left

z4h bindkey z4h-cd-back             Alt+H
z4h bindkey z4h-cd-forward          Alt+L
z4h bindkey z4h-cd-up               Alt+K
z4h bindkey z4h-cd-down             Alt+J

z4h bindkey my-ctrl-z               Alt+Z

z4h bindkey edit-command-line       Alt+E

###

setopt GLOB_DOTS

###

[ -z "$EDITOR" ] && export EDITOR='vim'
[ -z "$VISUAL" ] && export VISUAL='vim'

export DIRENV_LOG_FORMAT=
export SYSTEMD_LESS=FRXMK
export FZF_DEFAULT_OPTS='--reverse --multi --color="bg+:-1"'
export LPASS_CLIPBOARD_COMMAND='wl-copy -o'

###

command -v direnv &> /dev/null && eval "$(direnv hook zsh)"

z4h source -- ~/.zsh/{aliases,pacman,git,ssh,docker,kubectl,completion,server,pentest}.zsh
z4h source -- ~/.zshrc-private/{personal,work}.zsh
z4h source -- ~/.zsh/you-should-use.plugin.zsh
z4h source -- /etc/bash_completion.d/azure-cli
z4h compile -- $ZDOTDIR/{.zshenv,.zprofile,.zshrc,.zlogin,.zlogout}
