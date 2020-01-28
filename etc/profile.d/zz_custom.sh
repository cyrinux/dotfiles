#!/bin/sh
export PATH="$HOME/bin:$PATH:$HOME/.go/bin:/usr/share/sway/scripts/"

# Enable QT apps to have gtk theme
export LPASS_CLIPBOARD_COMMAND="wl-copy -o"
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORM=wayland-egl
export QT_SCALE_FACTOR=1
export QT_WAYLAND_DISABLE_WINDOWDECORATION=0
export QUTE_SKIP_WAYLAND_CHECK=1
export XKB_DEFAULT_LAYOUT="fr-hyper,us"
export NNN_OPTS='Aer'

# Enable VAAPI for gstreamer
export GST_VAAPI_ALL_DRIVERS=1
export LIBVA_DRIVER_NAME=iHD

export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
