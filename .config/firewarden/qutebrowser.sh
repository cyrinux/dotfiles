#!/bin/bash

mkdir -p "$FIREWARDEN_HOME/.config/qutebrowser"
for f in config.py gruvbox.py qutepreview.py; do
    cp "$HOME/.config/qutebrowser/${f}" "$FIREWARDEN_HOME/.config/qutebrowser"
done
