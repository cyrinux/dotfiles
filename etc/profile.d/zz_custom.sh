#!/bin/sh

# Disable bell
setterm -blength 0
xset -b

export TERMINAL='kitty'
export EDITOR='nvim'
export VISUAL='nvim'
export DIFFPROG='nvim -d'
export MANPAGER="kak-man-pager"
export WORDCHARS='*?_.[]~&!#$%^(){}<>'
export BROWSER='browser'

# Ssh agent support
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"

# Better VA-API driver (rollbacked for the moment)
# export LIBVA_DRIVER_NAME=iHD

# My own binaries
export PATH="$HOME/bin:$PATH"

export FZ_CMD=j
export FZ_SUBDIR_CMD=jj


export XSECURELOCK_FONT="-*-open sans-medium-r-*-*-30-*-*-*-*-*-*-uni"
export XSECURELOCK_SHOW_HOSTNAME=0
export XSECURELOCK_SHOW_USERNAME=0
export XSECURELOCK_WANT_FIRST_KEYPRESS=1

export WEECHAT_HOME="$HOME/.config/weechat"


# Pass configuration
export PASSWORD_STORE_CHARACTER_SET='a-zA-Z0-9~!@#$%^&*()-_=+[]{};:,.<>?'
export PASSWORD_STORE_GENERATED_LENGTH=40

# Android configuration
export ANDROID_SDK_ROOT="$HOME/.android/sdk"

# Haskell configuration
export PATH="$HOME/.cabal/bin:$PATH"

# Ruby configuration
if hash ruby 2>/dev/null; then
  export GEM_HOME="$(ruby -e 'print Gem.user_dir')"
  export PATH="$GEM_HOME/bin:$PATH"
fi

export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"
export GRAALVM_HOME=/usr/lib/jvm/java-8-graal
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk"
export PATH="$HOME/.node_modules/bin:$PATH"
