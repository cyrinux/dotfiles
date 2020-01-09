#!/bin/sh

# Disable bell
setterm -blength 0
xset -b

export TERMINAL='kitty'
export EDITOR='kak'
export VISUAL='kak'
export MANPAGER='kak-man-pager'
export DIFFPROG='meld'
export WORDCHARS='*?_.[]~&!#$%^(){}<>'
export BROWSER='browser'

# Ssh agent support
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"

# Better VA-API driver (rollbacked for the moment)
export LIBVA_DRIVER_NAME=iHD

# My own binaries
export PATH="$HOME/bin:$PATH"

# Fuzzy searching
export FZ_CMD=j
export FZ_SUBDIR_CMD=jj

# Video Acceleration
export LIBVA_DRIVER_NAME=iHD

# Secure lock
export XSECURELOCK_FONT="-*-open sans-medium-r-*-*-30-*-*-*-*-*-*-uni"
export XSECURELOCK_SHOW_HOSTNAME=0
export XSECURELOCK_SHOW_USERNAME=0
export XSECURELOCK_WANT_FIRST_KEYPRESS=1
export XSECURELOCK_PASSWORD_PROMPT=time_hex
export XSECURELOCK_AUTH_BACKGROUND_COLOR="#222222"

# Pass configuration
export PASSWORD_STORE_CHARACTER_SET='a-zA-Z0-9~!@#$%^&*()-_=+[]{};:,.<>?'
export PASSWORD_STORE_GENERATED_LENGTH=40


export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"
# export JAVA_HOME="/usr/lib/jvm/java-8-openjdk"
# export PATH="$HOME/.node_modules/bin:$PATH"

# Nnn files browser settings
export NNN_BMS='d:~/Vault/Documents;D:~/Downloads/'
export NNN_TRASH=1
export NNN_PLUG='d:dragdrop;r:remove;p:paperwork;c:croc;m:mkchromecast'
