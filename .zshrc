#!/usr/bin/env zsh

zstyle ':z4h:'                                    auto-update            no
zstyle ':z4h:*'                                   channel                stable
zstyle ':z4h:'                                    cd-key                 alt
zstyle ':z4h:autosuggestions'                     forward-char           partial-accept
zstyle ':fzf-tab:*'                               continuous-trigger     tab
zstyle ':zle:(up|down)-line-or-beginning-search'  leave-cursor           no
zstyle ':z4h:term-title:local'                    preexec                '%* | ${1//\%/%%}'
zstyle ':z4h:zsh-syntax-highlighting'             channel                stable

z4h install romkatv/archive || return

z4h init || return

fpath+=($Z4H/romkatv/archive)
autoload -Uz archive lsarchive unarchive edit-command-line

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
bindkey '^Z' my-ctrl-z

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
bindkey '^[s' toggle-sudo

zle -N edit-command-line
bindkey '^V^V' edit-command-line

command -v direnv &> /dev/null && eval "$(direnv hook zsh)"

setopt GLOB_DOTS

[ -z "$EDITOR" ] && export EDITOR='vim'
[ -z "$VISUAL" ] && export VISUAL='vim'

export GPG_TTY=$TTY
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export DIRENV_LOG_FORMAT=
export SYSTEMD_LESS=FRXMK
export FZF_DEFAULT_OPTS="--reverse --multi"
export LPASS_CLIPBOARD_COMMAND='wl-copy -o'

z4h source -c /usr/share/LS_COLORS/dircolors.sh
z4h source -c /usr/share/nnn/quitcd/quitcd.bash_zsh
z4h source -c ~/.zsh/aliases.zsh
z4h source -c ~/.zsh/pacman.zsh
z4h source -c ~/.zsh/git.zsh
z4h source -c ~/.zsh/ssh.zsh
z4h source -c ~/.zsh/kubectl.zsh
z4h source -c ~/.zsh/pentest.zsh
z4h source -c ~/.zsh/docker.zsh
z4h source -c ~/.zshrc-private/personal.zsh
z4h source -c ~/.zshrc-private/work.zsh
z4h source -c ~/.zsh/server.zsh # its on remote servers only
z4h source -c ~/.zsh/completion.zsh

# default mapping are unusable in azerty layout
bindkey '^[r' redo # alt+r
bindkey '^[z' undo # alt+z
bindkey '^H'      z4h-backward-kill-word
bindkey '^[[1;7C' z4h-forward-zword
bindkey '^[[1;7D' z4h-backward-zword
bindkey '^[[3;7~' z4h-kill-zword
bindkey '^[^H'    z4h-backward-kill-zword

command -v patch > /dev/null && patch -Np1 -i ~/.dotfiles/z4h.patch -r /dev/null -d $Z4H/zsh4humans/ > /dev/null

return 0
