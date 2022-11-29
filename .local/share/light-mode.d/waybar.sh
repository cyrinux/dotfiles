#!/bin/sh

ln -sf "$HOME/.config/waybar/light.css" "$HOME/.config/waybar/style.css"
systemctl --user restart waybar
