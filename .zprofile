#!/usr/bin/env zsh

export LANG=en_US.UTF-8
export LANGUAGE=en_US
export LC_MONETARY=fr_FR.utf8
export LC_TIME=fr_FR.utf8

export GOPATH="$HOME/.go"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export LIBVA_DRIVER_NAME=iHD
export LPASS_CLIPBOARD_COMMAND="wl-copy -o"
export MOZ_ENABLE_WAYLAND=1
export PATH="$HOME/bin:$PATH:$HOME/.go/bin"
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORM=wayland-egl
export QT_SCALE_FACTOR=1
export QT_WAYLAND_DISABLE_WINDOWDECORATION=0
export QUTE_SKIP_WAYLAND_CHECK=1
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"
export WGETRC="$HOME/.config/wget/wgetrc"
export WLR_DRM_NO_MODIFIERS=1
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export XKB_DEFAULT_LAYOUT="fr-hyper,us"

[[ -z $DISPLAY && "$(tty)" == "/dev/tty1" ]] && systemd-cat -t sway sway
