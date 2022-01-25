source /usr/share/kak-lsp/rc/lsp.kak
lsp-enable
lsp-auto-hover-insert-mode-enable
#set-option global lsp_auto_highlight_references true
#set-option global lsp_hover_anchor true

set-option global grepcmd 'rg --hidden --follow --smart-case --with-filename --column'

hook global ModuleLoaded kitty %{ set-option global kitty_window_type 'os-window' }

# Commands

define-command disable-autolint -docstring 'disable auto-lint' %{
    lint-hide-diagnostics
    unset-option buffer lintcmd
    remove-hooks buffer lint
}

define-command disable-autoformat -docstring 'disable auto-format' %{
    unset-option buffer formatcmd
    remove-hooks buffer format
}

define-command detect-indentwidth -docstring 'detect indentwidth' %{
    try %{
        evaluate-commands -draft %{
            expandtab
            execute-keys 'gg' '/' '^\h+' '<ret>'

            try %{
                execute-keys '<a-k>' '\t' '<ret>'
                noexpandtab
            } catch %{
                set-option buffer indentwidth %val{selection_length}
            }
        }
    }
}

define-command  github-link -docstring 'return github permalink' %{
   evaluate-commands echo %sh{get-github-permalink ${kak_buffile} ${kak_cursor_line}}
}

define-command leading-spaces-to-tabs -docstring "Convert all leading spaces to tabs" %{ execute-keys -draft %{%s^\h+<ret><a-@>} }
define-command leading-tabs-to-spaces -docstring "Convert all leading tabs to spaces" %{ execute-keys -draft %{%s^\h+<ret>@} }

# Hooks

hook global BufOpenFile  .* modeline-parse
hook global BufOpenFile  .* %{ editorconfig-load; set buffer eolformat lf }
hook global BufNewFile   .* %{ editorconfig-load; set buffer eolformat lf }
hook global BufWritePre  .* %{ nop %sh{ mkdir -p $(dirname "$kak_hook_param") }}
hook global BufWritePost .* %{ git show-diff }
hook global BufReload    .* %{ git show-diff }
hook global BufOpenFile  .* detect-indentwidth
hook global BufWritePost .* detect-indentwidth
hook global WinDisplay   .* %{ evaluate-commands %sh{
    cd "$(dirname "$kak_buffile")"
    project_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
    [ -n "$project_dir" ] && dir="$project_dir" || dir="${PWD%/.git}"
    printf "cd %%{%s}\n" "$dir"
    [ -n "$project_dir" ] && [ "$kak_buffile" = "${kak_buffile#\*}" ] && printf "git show-diff"
} }

hook global WinSetOption filetype=.* %{
    disable-autoformat
    disable-autolint

    hook buffer -group format BufWritePre .* %{
        try %{ execute-keys -draft '%s\h+$<ret>d' }
        try %{ execute-keys -draft '%s\u000d<ret>d' }
    }
}

hook global WinSetOption filetype=python %{
    set-option buffer formatcmd 'isort -q - | black -q -'

    hook buffer -group format BufWritePre .* format

    set-option buffer lintcmd 'pylint --msg-template="{path}:{line}:{column}: {category}: {msg}" -rn -sn'
    lint
    hook buffer -group lint BufWritePost .* lint
}

hook global WinSetOption filetype=go %{
    hook buffer -group format BufWritePre .* lsp-formatting-sync

    set-option buffer lintcmd "run() { revive $1; go vet $1 2>&1 | sed -E 's/: /: error: /'; staticcheck $1; } && run"
    lint
    hook buffer -group lint BufWritePost .* lint
}

hook global WinSetOption filetype=rust %{
    hook buffer -group format BufWritePre .* lsp-formatting-sync

    hook window -group rust-inlay-hints BufReload .* rust-analyzer-inlay-hints
    hook window -group rust-inlay-hints NormalIdle .* rust-analyzer-inlay-hints
    hook window -group rust-inlay-hints InsertIdle .* rust-analyzer-inlay-hints
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window rust-inlay-hints
    }

    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window semantic-tokens
    }
}

hook global WinSetOption filetype=markdown %{
  spell
}

hook global WinSetOption filetype=(javascript|typescript|css|scss|json|markdown|yaml|html) %{
    set-option buffer formatcmd "prettier --stdin-filepath=%val{buffile}"
    hook buffer -group format BufWritePre .* format
}

hook global WinSetOption filetype=sh %{
    set-option buffer formatcmd "shfmt -i %opt{indentwidth} -ci -sr"
    hook buffer -group format BufWritePre .* format

    set-option buffer lintcmd 'shellcheck -x -fgcc'
    lint
}

hook global WinSetOption filetype=terraform %{
    hook buffer -group format BufWritePre .* lsp-formatting-sync
}

hook global WinSetOption filetype=lua %{
    set-option buffer formatcmd 'stylua --config-path ~/.config/stylua/stylua.toml -- -'
    hook buffer -group format BufWritePre .* format
}

hook global WinSetOption filetype=(asciidoc|fountain|html|latex|markdown) %{
    require-module pandoc
    set-option global pandoc_options ''
}
