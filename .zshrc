zstyle    ':z4h:'                                              auto-update            no
zstyle    ':z4h:'                                              start-tmux             no
zstyle    ':z4h:'                                              term-shell-integration yes
zstyle    ':z4h:'                                              propagate-cwd          yes
zstyle    ':z4h:*'                                             channel                stable
zstyle    ':z4h:autosuggestions'                               end-of-line            partial-accept
zstyle    ':z4h:autosuggestions'                               forward-char           partial-accept
zstyle    ':z4h:fzf-complete'                                  fzf-command            my-fzf
zstyle    ':z4h:(fzf-complete|fzf-dir-history|fzf-history)'    fzf-flags              --no-exact --color=hl:14,hl+:14
zstyle    ':z4h:(fzf-complete|fzf-dir-history)'                fzf-bindings           'tab:repeat'
zstyle    ':z4h:fzf-complete'                                  find-flags             -name '.git' -prune -print -o -print
zstyle    ':zle:(up|down)-line-or-beginning-search'            leave-cursor           yes
zstyle    ':z4h:term-title:local'                              preexec                '%* | ${1//\%/%%}'
zstyle    ':z4h:direnv'                                        enable                 yes

if ! (( P9K_SSH )); then
    zstyle ':z4h:sudo' term ''
fi

##

[ ! -f /etc/motd ] || cat /etc/motd

##

z4h install romkatv/archive || return
z4h init || return

##

zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}" "l:|=* r:|=*"

##

fpath+=($Z4H/romkatv/archive)
autoload -Uz archive lsarchive unarchive edit-command-line

zle -N edit-command-line

my-fzf () {
    emulate -L zsh -o extended_glob
    local MATCH MBEGIN MEND
    fzf "${@:/(#m)--query=?*/$MATCH }"
}

my-ctrl-z() {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line -w
    else
        zle push-input -w
        zle clear-screen -w
    fi
}
zle -N my-ctrl-z

###

z4h bindkey z4h-backward-kill-word  Ctrl+Backspace
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace
z4h bindkey z4h-kill-zword          Ctrl+Alt+Delete

z4h bindkey backward-kill-line      Ctrl+U
z4h bindkey kill-line               Alt+U
z4h bindkey kill-whole-line         Alt+I

z4h bindkey z4h-forward-zword       Ctrl+Alt+Right
z4h bindkey z4h-backward-zword      Ctrl+Alt+Left

z4h bindkey z4h-cd-back             Alt+H
z4h bindkey z4h-cd-forward          Alt+L
z4h bindkey z4h-cd-up               Alt+K
z4h bindkey z4h-fzf-dir-history     Alt+J

z4h bindkey my-ctrl-z               Ctrl+Z

z4h bindkey edit-command-line       Alt+E

z4h bindkey z4h-eof                 Ctrl+D

###

setopt GLOB_DOTS
setopt IGNORE_EOF

# setopt glob_dots magic_equal_subst no_multi_os no_local_loops
# setopt rm_star_silent rc_quotes glob_star_short

###

if (( $+commands[wl-copy] && $#DISPLAY )); then
  alias v='wl-paste'
  function copy-buffer-to-clipboard() {
    print -rn -- "$PREBUFFER$BUFFER" | wl-copy
  }
  zle -N copy-buffer-to-clipboard
  bindkey '^Y' copy-buffer-to-clipboard
fi

[ -z "$EDITOR" ] && export EDITOR='vim'
[ -z "$VISUAL" ] && export VISUAL='vim'

export DIRENV_LOG_FORMAT=
export SYSTEMD_LESS="${LESS}S"
export FZF_DEFAULT_OPTS='--reverse --multi'
export LPASS_CLIPBOARD_COMMAND='wl-copy -o'

###
z4h source -- /etc/bash_completion.d/azure-cli
z4h source -- /usr/share/LS_COLORS/dircolors.sh
z4h source -- /opt/asdf-vm/asdf.sh
z4h source -- ~/.zsh/{aliases,pacman,git,ssh,docker,kubectl,server,pentest}.zsh
z4h source -- ~/.zshrc-private/{personal,work}.zsh
