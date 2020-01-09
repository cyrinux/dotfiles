bindkey '^T'  fzy-file-widget
bindkey '^R'  fzy-history-widget
bindkey '^P'  fzy-proc-widget

fzy-file-widget-list-files() { rg --files --hidden --smart-case 2>/dev/null }
zstyle :fzy:file command fzy-file-widget-list-files
zstyle :fzy:history lines 25
zstyle :fzy:history show-scores no

__fz_filter() { fzy }
