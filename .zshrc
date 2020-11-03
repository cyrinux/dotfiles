#!/usr/bin/env zsh

zstyle ':z4h:'                                    auto-update            no
zstyle ':z4h:*'                                   channel                stable
zstyle ':z4h:autosuggestions'                     forward-char           partial-accept
zstyle ':z4h:fzf-complete'                            fzf-command            my-fzf
zstyle ':z4h:(fzf-complete|cd-down|fzf-history)'      fzf-flags              --no-exact --color=hl:14,hl+:14
zstyle ':z4h:(fzf-complete|cd-down)'                  fzf-bindings           'tab:repeat'
zstyle ':fzf-tab:*'                               continuous-trigger     tab
zstyle ':z4h:(fzf-complete|cd-down)'                  find-flags             -name '.git' -prune -print -o -print
zstyle ':z4h:term-title:local'                    preexec                '%* | ${1//\%/%%}'
zstyle ':zle:(up|down)-line-or-beginning-search'      leave-cursor           yes
zstyle ':z4h:zsh-syntax-highlighting'             channel                stable
zstyle -e ':z4h:ssh:*' retrieve-history 'reply=($ZDOTDIR/.zsh_history.${(%):-%m}:$z4h_ssh_host)'
zstyle ':z4h:sudo' term ''



###

z4h install romkatv/archive || return
z4h init || return

###

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

toggle-sudo() {
    [[ -z "$BUFFER" ]] && zle up-history -w
    if [[ "$BUFFER" != "sudo "* ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR + 5 ))
    else
        BUFFER="${BUFFER#sudo }"
    fi
}
zle -N toggle-sudo

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

z4h bindkey toggle-sudo             Alt+S
z4h bindkey my-ctrl-z               Alt+Z

z4h bindkey edit-command-line       Alt+E

###

setopt GLOB_DOTS

###

[ -z "$EDITOR" ] && export EDITOR='vim'
[ -z "$VISUAL" ] && export VISUAL='vim'

export DIRENV_LOG_FORMAT=
export SYSTEMD_LESS=FRXMK
export FZF_DEFAULT_OPTS="--reverse --multi"
export LPASS_CLIPBOARD_COMMAND='wl-copy -o'
export NNN_BMS='d:~/Vault/Documents;D:~/Downloads/;r:/run/media/cyril;'
export NNN_PLUG='j:jump;r:remove;p:paperwork;c:croc;'

###

command -v direnv &> /dev/null && eval "$(direnv hook zsh)"

z4h source -- /etc/bash_completion.d/azure-cli
z4h source -- /usr/share/LS_COLORS/dircolors.sh
z4h source -- /usr/share/nnn/quitcd/quitcd.bash_zsh
z4h source -- ~/.zsh/{aliases,pacman,git,ssh,docker,kubectl,completion,server,pentest}.zsh
z4h source -- ~/.zshrc-private/{personal,work}.zsh
z4h compile   -- $ZDOTDIR/{.zshenv,.zprofile,.zshrc,.zlogin,.zlogout}

# command -v patch > /dev/null && patch -Np1 -i ~/.dotfiles/z4h.patch -r /dev/null -d $Z4H/zsh4humans/ > /dev/null
