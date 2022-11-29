#!/bin/sh

mkdir -p "$HOME/.local/state/zathura"
ln -sf "$HOME/.config/zathura/light-mode" "$HOME/.local/state/zathura/current-mode"
