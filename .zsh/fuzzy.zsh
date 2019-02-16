bindkey '^T'  fzy-file-widget
bindkey '^R'  fzy-history-widget
bindkey '^P'  fzy-proc-widget
bindkey '^F' fzy-firejail-widget

fzy-file-widget-list-files() { rg --files --hidden --smart-case 2>/dev/null }
zstyle :fzy:file command fzy-file-widget-list-files
zstyle :fzy:history lines 50
zstyle :fzy:history show-scores yes
__fz_filter() { fzy }


function fzy-firejail-default-command
{
	command firemon --list | grep firejail
}
function __fzy_firejail_sel
{
	__fzy_cmd firejail | cut -d ':' -f1
}
function fzy-firejail-widget
{
	emulate -L zsh
	zle	-M '<fzy>'
	LBUFFER="kill $(__fzy_firejail_sel)"
	zle redisplay
}
zle -N fzy-firejail-widget
