#!/bin/sh

ln -sf "$HOME/.config/waybar/dark.css" "$HOME/.config/waybar/style.css"
systemctl --user restart waybar
