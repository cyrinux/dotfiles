#!/bin/sh

mkdir -p "$HOME/.local/state/zathura"
ln -sf "$HOME/.config/zathura/dark-mode" "$HOME/.local/state/zathura/current-mode"
