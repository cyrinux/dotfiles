colorscheme gruvbox

face global Information rgb:ebdbb2,rgb:282828

add-highlighter global/ number-lines -hlcursor
add-highlighter global/ show-matching
add-highlighter global/ wrap -word -indent
add-highlighter global/ regex \h+$ 0:Error
add-highlighter global/ regex \b(TODO|FIXME|XXX|NOTE)\b 0:default+rb

set-option global ui_options  ncurses_assistant=off
set-option global autoreload  yes
set-option global tabstop     4
set-option global indentwidth 4
set-option global scrolloff   2,5

set-option global windowing_modules ''
require-module kitty
alias global popup kitty-terminal

set-option global out_of_view_format '↑ %opt{out_of_view_selection_above_count} | ↓ %opt{out_of_view_selection_below_count}'

set-option global lsp_auto_highlight_references true

hook global BufCreate '^\*scratch\*$' %{
    execute-keys '%d'
}

hook global KakBegin .* %{
    state-save-reg-load colon
    state-save-reg-load pipe
    state-save-reg-load slash
}

hook global KakEnd .* %{
    state-save-reg-save colon
    state-save-reg-save pipe
    state-save-reg-save slash
}

evaluate-commands %sh{
    out_of_view='{yellow}%sh{ [ -n "${kak_opt_out_of_view_status_line}" ] && echo "${kak_opt_out_of_view_status_line} " }{default}'
    cwd='at {cyan}%sh{ pwd | sed "s|^$HOME|~|" }{default}'
    bufname='in {green}%val{bufname}{default}'
    modified='{yellow+b}%sh{ $kak_modified && echo "[+] " }{default}'
    ft='as {magenta}%sh{ echo "${kak_opt_filetype:-noft}" }{default}'
    eol='with {yellow}%val{opt_eolformat}{default}'
    cursor='on {cyan}%val{cursor_line}{default}:{cyan}%val{cursor_char_column}{default}'
    readonly='{red+b}%sh{ [ -f "$kak_buffile" ] && [ ! -w "$kak_buffile" ] && echo "[] " }{default}'
    echo set global modelinefmt "'{{mode_info}} ${out_of_view}${cwd} ${bufname} ${readonly}${modified}${ft} ${eol} ${cursor}'"
}


provide-module change-directory %{
  # Change the working directory to the given buffer directory.
  define-command change-directory-buffer -params 1 -buffer-completion -docstring 'Change the working directory to the given buffer directory' %{
    evaluate-commands -buffer %arg{1} %{
      change-directory %sh(dirname "$kak_buffile")
    }
  }

  # Change the working directory to the current buffer directory.
  define-command change-directory-current-buffer -docstring 'Change the working directory to the current buffer directory' %{
    change-directory-buffer %val{buffile}
  }

  # Change the working directory to the Git root directory.
  define-command change-directory-git-root -docstring 'Change the working directory to the Git root directory' %{
    change-directory-current-buffer
    change-directory %sh(git rev-parse --show-toplevel)
  }

  # Aliases
  alias global cd-buffer change-directory-buffer
  alias global cd-current-buffer change-directory-current-buffer
  alias global cd-git-root change-directory-git-root
  alias global cd! change-directory-git-root
}
