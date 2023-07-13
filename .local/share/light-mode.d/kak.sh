#!/bin/sh

ln -sf "$HOME/.config/kak/colors/gruvbox-light.kak" "$HOME/.config/kak/colors/gruvbox.kak"

for sess in $(kak -l | awk '{print $1}'); do
    echo "colorscheme gruvbox-light" | kak -p "$sess"
done
