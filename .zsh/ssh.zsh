zstyle ':z4h:ssh:*' send-extra-files '~/.zsh/aliases.zsh' '~/.zsh/git.zsh' '~/.zsh/docker.zsh'
zstyle ':z4h:term-title:ssh' preexec '%* | %n@%m: ${1//\%/%%}'
zstyle ':z4h:ssh:*' enable 'yes'
zstyle ':z4h:ssh:pbuilder*' enable 'no'
zstyle ':z4h:ssh:package*' enable 'no'
zstyle ':z4h:ssh:*' ssh-command command ssh -S none
zstyle ':z4h:term-title:ssh' preexec '%* | %n@%m: ${1//\%/%%}'
zstyle -e ':z4h:ssh:*' retrieve-history 'reply=($ZDOTDIR/.zsh-history/zsh_history.${(%):-%m}:$z4h_ssh_host)'

[[ -e $ZDOTDIR/.zsh-history ]] || zf_mkdir -p -m 700 $ZDOTDIR/.zsh-history

() {
  local hist
  for hist in ~/.zsh-history/zsh_history*~$HISTFILE(N); do
    fc -RI $hist
  done
}

function z4h-ssh-configure() {
  (( z4h_ssh_enable )) || return 0
  local file
  for file in $ZDOTDIR/.zsh-history/zsh_history.*:$z4h_ssh_host(N); do
    (( $+z4h_ssh_send_files[$file] )) && continue
    z4h_ssh_send_files[$file]='"$ZDOTDIR"/'${file:t}
  done

  ((z4h_ssh_passthrough)) && return

  z4h_ssh_prelude+=(
      "export all_proxy=$PROXY export ALL_PROXY=$PROXY"
  )
  return 0
}

if ! ((P9K_SSH)); then
    zstyle ':z4h:sudo' term ''
fi

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


# Do not check authenticity when using SSH.
alias unsafessh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
