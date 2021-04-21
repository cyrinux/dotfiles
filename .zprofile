#!/usr/bin/env zsh

[[ "$TTY" == /dev/tty* ]] || return 0

export $(systemctl --user show-environment)

export GPG_TTY="$TTY"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"

systemctl --user import-environment GPG_TTY SSH_AUTH_SOCK DBUS_SESSION_BUS_ADDRESS
# systemctl --user import-environment
# hash dbus-update-activation-environment 2> /dev/null &&
#     dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK SSH_AUTH_SOCK XDG_CURRENT_DESKTOP

if [[ -z $DISPLAY && "$TTY" == "/dev/tty1" ]]; then
    systemd-cat -t sway sway
    systemctl --user stop sway-session.target
    systemctl --user unset-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
fi
