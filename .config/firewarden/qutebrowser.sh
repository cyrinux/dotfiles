#!/bin/bash

BASEDIR="$FIREWARDEN_HOME/basedir"

# Import config file.
mkdir -p "$BASEDIR/config"
cp "$HOME/.config/qutebrowser/*.py" "$BASEDIR/config"
