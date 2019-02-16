#!/usr/bin/env zsh

alias ssh='ssh_with_color_and_term'

ssh_with_term() {
  if [[ "$@" =~ "(.*bastion.*|.*isilon*|.*wat-sw.*|.*uli-sw.*|nasux|10.105.*)" ]]; then
    TERM=xterm-256color /usr/bin/ssh -q "$@"
  else
    kitty +kitten ssh "$@"
  fi
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
  printf '\033]11;#282828\007'
  trap - SIGINT
}

bg_color_set() {
  color='#282828'
  for arg in "$@"; do
    if [[ "${arg:0:1}" != "-" ]]; then
      if [[ "$arg" =~ '^.*prod[0-9]{2}$' ]]; then
        color='#322828'
      elif [[ "$arg" =~ '^.*prep[0-9]{2}$' ]]; then
        color='#323228'
      elif [[ "$arg" =~ '^.*bastion.*$' ]]; then
        color='#2B4044'
      elif [[ "$arg" =~ '^mep.*' ]]; then
        color='#076678'
      elif [[ "$arg" =~ '^isilon.*$' ]]; then
        color='#d65d0e'
      fi
    fi
  done
  printf "\033]11;$color\007"
}
