#!/bin/sh

BASEDIR="$FIREWARDEN_HOME/basedir"

# Import config file.
mkdir -p "$BASEDIR/config"
cp "$HOME/.config/qutebrowser/config.py" "$BASEDIR/config"
cp "$HOME/.config/qutebrowser/autoconfig.yml" "$BASEDIR/config"
cp -a "$HOME/.config/solarized-everything-css" "$BASEDIR/config"

# Import spellcheck dictionary.
mkdir -p "$BASEDIR/data"
cp -a "$HOME/.local/share/qutebrowser/qtwebengine_dictionaries" "$BASEDIR/data"
