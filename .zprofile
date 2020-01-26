#!/usr/bin/env zsh
if [ "$(tty)" = "/dev/tty2"  ]; then
        exec sway
fi

