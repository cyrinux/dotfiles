unsetopt EXTENDED_GLOB

umask 0027

# Share history across all terminals.
setopt share_history
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt pushd_ignore_dups

# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

