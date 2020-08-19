zstyle ':z4h:ssh:*'                               send-extra-files       '~/.zsh/aliases.zsh' '~/.zsh/git.zsh' '~/.zsh/docker.zsh'
zstyle -e ':z4h:ssh:*'                            retrieve-history       'reply=($XDG_DATA_HOME/zsh-history/${z4h_ssh_host##*:})'
zstyle ':z4h:term-title:ssh'                      preexec                '%* | %n@%m: ${1//\%/%%}'

z4h-ssh-configure() {
    z4h_ssh_prelude+=(
        "export all_proxy=$PROXY export ALL_PROXY=$PROXY"
    )

    # file="$XDG_DATA_HOME/zsh-history/$z4h_ssh_host"
    # [ -e "$file" ] && z4h_ssh_send_files[$file]='"$ZDOTDIR"/.zsh_history'

    local file
    for file in $XDG_DATA_HOME/zsh_history/$z4h_ssh_host(N); do
      (( $+z4h_ssh_send_files[$file] )) && continue
      z4h_ssh_send_files[$file]='"$ZDOTDIR"/'${file:t}
    done
}



alias ssh='ssh_with_color_and_term'
# alias ssh='z4h ssh'

ssh-with-privoxy() {
    zstyle ':z4h:ssh:*' ssh-command command ssh -R 9999:localhost:8118
    export PROXY='http://127.0.0.1:9999'
    z4h ssh "$@"
}
compdef ssh-with-privoxy=ssh

cssh() {
    tmux-cssh "$@"
}
compdef cssh=ssh

kssh() {
    kitty +kitten ssh "$@"
}
compdef kssh=ssh

tmux-connect() { ssh "$@" "tmux attach || tmux new"; }

ssh_with_term() {
    z4h ssh "$@"
}

ssh_with_color_and_term() {
    trap 'bg_color_reset' SIGINT
    bg_color_set "$@"
    printf '\033]2;%s\033\\' "$@"
    ssh_with_term "$@"
    retval=$?
    bg_color_reset
    return $retval
}
compdef ssh_with_color_and_term=ssh

bg_color_reset() {
    printf '\033]11;#202020\007'
    trap - SIGINT
}

bg_color_set() {
    color='#202020'
    for arg in "$@"; do
        if [[ "${arg:0:1}" != "-" ]]; then
            if [[ "$arg" =~ '^.*.dc3.*$' ]]; then
                color='#322828'
            elif [[ "$arg" =~ '^.*.(ix7|nyc|sv4|ty4|sg1).*$' ]]; then
                color='#323228'
            fi
        fi
    done
    printf "\033]11;$color\007"
}
