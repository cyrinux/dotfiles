zstyle ':z4h:ssh:*'                               send-extra-files       '~/.zsh/aliases.zsh' '~/.zsh/git.zsh' '~/.zsh/docker.zsh'
zstyle ':z4h:term-title:ssh'                      preexec                '%* | %n@%m: ${1//\%/%%}'
zstyle ':z4h:ssh:*'                               enable 'yes'
zstyle ':z4h:ssh:*'                               ssh-command             command ssh -S none
zstyle -e ':z4h:ssh:*'                            retrieve-history 'reply=($ZDOTDIR/.zsh_history.${(%):-%m}:$z4h_ssh_host)'
zstyle    ':z4h:term-title:ssh'                   preexec                '%* | %n@%m: ${1//\%/%%}'

if ! (( P9K_SSH )); then
    zstyle ':z4h:sudo' term ''
fi

# zstyle -e ':z4h:ssh:*'                            retrieve-history       'reply=($XDG_DATA_HOME/zsh-history/${z4h_ssh_host##*:})'

z4h-ssh-configure() {
    (( z4h_ssh_passthrough )) && return

    z4h_ssh_prelude+=(
        "export all_proxy=$PROXY export ALL_PROXY=$PROXY"
    )

    # file="$XDG_DATA_HOME/zsh-history/$z4h_ssh_host"
    # [ -e "$file" ] && z4h_ssh_send_files[$file]='"$ZDOTDIR"/.zsh_history'

    # local file
    # for file in $XDG_DATA_HOME/zsh_history/$z4h_ssh_host(N); do
    #   (( $+z4h_ssh_send_files[$file] )) && continue
    #   z4h_ssh_send_files[$file]='"$ZDOTDIR"/'${file:t}
    # done

    return 0
}

sshproxy() {
    zstyle ':z4h:ssh:*' ssh-command command ssh -S none -R 9999:localhost:8118
    export PROXY='http://127.0.0.1:9999'
    ssh "$@"
}
compdef sshproxy=ssh

cssh() {
    tmux-cssh "$@"
}
compdef cssh=ssh

kssh() {
    kitty +kitten ssh "$@"
}
compdef kssh=ssh

tmux-connect() { ssh "$@" "tmux attach || tmux new"; }
