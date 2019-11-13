;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layers
   '(;; settings
     better-defaults
     git
     github
     version-control
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom
            shell-default-shell 'eshell
            shell-enable-smart-eshell t)
     syntax-checking
     spell-checking
     (auto-completion :variables
                      auto-completion-enable-snippets-in-popup t
                      auto-completion-enable-help-tooltip t)
     colors
     restclient
     evil-commentary
     ;; languages
     dash
     shell-scripts
     sql
     systemd
     emacs-lisp
     (org :variables
          org-enable-github-support t)
     (markdown :variables
               markdown-live-preview-engine 'vmd
               markdown-command "pandoc")
     elixir
     erlang
     javascript
     haskell
     html
     (latex :variables
            latex-enable-magic t
            latex-enable-folding t
            latex-enable-auto-fill t)
     yaml
     ruby
     perl5
     perl6
     pdf
     lsp
     rust
     (python :variables
             python-formatter 'black)
     racket
     rust
     c-c++
     (go :variables
         go-use-golangci-lint t
         go-linter 'golangci-lint
         godoc-at-point-function 'godoc-gogetdoc
         go-format-before-save t
         gofmt-command "goimports"
         go-backend 'lsp
         go-tab-width 2)
     (elm :variables
          elm-format-command "elm-format-0.18")
     php
     ;; Frameworks
     ruby-on-rails
     react
     ;; Config files
     docker
     ansible
     terraform
     puppet
     ;; Debugger
     dap
     ;; Misc
     (ranger :variables
             ranger-show-preview t)
     emoji
     pass
     (keyboard-layout :variables
                      kl-layout 'azerty)
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
  dotspacemacs-additional-packages '(
                                     gruvbox-theme
                                     ediprolog
                                     aggressive-indent
                                     all-the-icons
                                     beacon
                                     dumb-jump
                                     flycheck-golangci-lint
                                     git-messenger
                                     go-playground
                                     gotest
                                     highlight-indent-guides
                                     prettier-js
                                     projectile
    )
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages '(exec-path-from-shell)
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'. (default t)
   dotspacemacs-delete-orphan-packages t))


(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. (default t)
   dotspacemacs-check-for-update t
   ;; One of `vim', `emacs' or `hybrid'. Evil is always enabled but if the
   ;; variable is `emacs' then the `holy-mode' is enabled at startup. `hybrid'
   ;; uses emacs key bindings for vim's insert mode, but otherwise leaves evil
   ;; unchanged. (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'.
   ;; (default '(recents projects))
   dotspacemacs-startup-lists '(recents projects)
   ;; Number of recent files to show in the startup buffer. Ignored if
   ;; `dotspacemacs-startup-lists' doesn't include `recents'. (default 5)
   dotspacemacs-startup-recent-list-size 5
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(gruvbox-dark-medium
                         gruvbox-dark-hard
                         gruvbox-light-medium
                         gruvbox-light-soft
                        )
   ;; If non nil the cursor color matches the state color.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 14
                               :weight normal
                               :width normal
                               :powerline-scale 1.4)

   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m)
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; (Not implemented) dotspacemacs-distinguish-gui-ret nil
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key ":"
   ;; If non nil `Y' is remapped to `y$'. (default t)
   dotspacemacs-remap-Y-to-y$ t
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
   ;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
   dotspacemacs-use-ido nil
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-micro-state t
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup  nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
   ;; derivatives. If set to `relative', also turns on relative line numbers.
   ;; (default nil)
   dotspacemacs-line-numbers 'relative
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil advises quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server t
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)

   ;; Mode line theme
   dotspacemacs-mode-line-theme 'all-the-icons

   ;; LateX preview configuration
   dotspacemacs-whitespace-cleanup 'changed
   TeX-view-program-selection '((output-pdf "PDF Tools"))
   TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
   TeX-source-correlate-start-server t
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."
  (setq powerline-default-separator 'alternate)
  (spaceline-compile)

  (setq blink-matching-paren nil)
  (setq sp-highlight-pair-overlay nil)

  (setq alchemist-hooks-compile-on-save nil)
  (setq alchemist-test-status-modeline nil)

  (push '("*alchemist test report*" :position bottom :noselect t)
        popwin:special-display-config)
  (setq popwin:reuse-window 'visible)

  (spacemacs|diminish alchemist-mode)
  (spacemacs|diminish alchemist-phoenix-mode)

  (setq-default web-mode-markup-indent-offset 2
                web-mode-css-indent-offset 2
                web-mode-code-indent-offset 2
                css-indent-offset 2)

  (setq c-default-style "k&r"
        c-basic-offset 4)

  (setq-default json-reformat:indent-width 2
                js-indent-level 2
                js2-basic-offset 2)

  (setq mac-option-key-is-meta t)
  (setq mac-right-option-modifier nil)

  (setq org-catch-invisible-edits 'smart)

  ; Prolog
  (autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
  (setq prolog-system 'swi) ; prolog-system below for possible values
  (add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))
  (require 'ediprolog)
  (global-set-key [f10] 'ediprolog-dwim)

  ;; RestClient loading
  (require 'restclient)

  ;; Evil-Escape key
  (setq-default evil-escape-key-sequence "fd")

  ;; Replace ag by ripgrep
  (setq helm-ag-base-command "rg --vimgrep --no-heading --smart-case")

  ;; Inibit startup screen
  (setq inhibit-startup-screen t)

  (evil-leader/set-key "/" 'spacemacs/helm-project-do-ag)

  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (bind-key bind-map powerline rake spinner hydra auto-complete company iedit highlight git-gutter request skewer-mode gh pcre2el ediprolog auctex-latexmk go-guru rust-mode ob-elixir org minitest multiple-cursors hide-comnt docker-tramp auctex anzu elixir-mode ht inflections inf-ruby dash phpunit phpcbf php-extras php-auto-yasnippets drupal-mode php-mode go-mode anaconda-mode smartparens undo-tree flyspell-correct yasnippet helm helm-core haskell-mode flycheck magit-popup async projectile f js2-mode pug-mode magit git-commit with-editor evil-unimpaired zenburn-theme yapfify yaml-mode xterm-color ws-butler window-numbering which-key web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package toml-mode toc-org tagedit spacemacs-theme spaceline solarized-theme smeargle slim-mode shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe reveal-in-osx-finder restart-emacs rbenv rainbow-mode rainbow-identifiers rainbow-delimiters racket-mode racer quelpa pyvenv pytest pyenv-mode py-isort projectile-rails popwin pip-requirements persp-mode pbcopy paradox ox-gfm osx-trash osx-dictionary orgit org-projectile org-present org-pomodoro org-plus-contrib org-download org-bullets open-junk-file neotree mwim multi-term move-text mmm-mode markdown-toc magit-gitflow magit-gh-pulls macrostep lorem-ipsum livid-mode live-py-mode linum-relative link-hint less-css-mode launchctl js2-refactor js-doc jinja2-mode jade-mode intero info+ indent-guide ido-vertical-mode hy-mode hungry-delete htmlize hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers highlight-indentation help-fns+ helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make helm-hoogle helm-gitignore helm-flx helm-descbinds helm-dash helm-css-scss helm-company helm-c-yasnippet helm-ag haskell-snippets google-translate golden-ratio go-eldoc gnuplot github-search github-clone github-browse-file gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe git-gutter-fringe+ gist gh-md flyspell-correct-helm flycheck-rust flycheck-pos-tip flycheck-mix flycheck-haskell flx-ido fill-column-indicator feature-mode fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu eshell-z eshell-prompt-extras esh-help erlang emmet-mode elisp-slime-nav dumb-jump dockerfile-mode docker disaster diff-hl dash-at-point cython-mode company-web company-tern company-statistics company-go company-ghci company-ghc company-cabal company-c-headers company-auctex company-anaconda column-enforce-mode color-identifiers-mode coffee-mode cmm-mode cmake-mode clean-aindent-mode clang-format chruby cargo bundler auto-yasnippet auto-highlight-symbol auto-dictionary auto-compile ansible-doc ansible alchemist aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-want-Y-yank-to-eol t)
 '(package-selected-packages
   (quote
    (pdf-tools bind-key bind-map powerline rake spinner hydra auto-complete company iedit highlight git-gutter request skewer-mode gh pcre2el ediprolog auctex-latexmk go-guru rust-mode ob-elixir org minitest multiple-cursors hide-comnt docker-tramp auctex anzu elixir-mode ht inflections inf-ruby dash phpunit phpcbf php-extras php-auto-yasnippets drupal-mode php-mode go-mode anaconda-mode smartparens undo-tree flyspell-correct yasnippet helm helm-core haskell-mode flycheck magit-popup async projectile f js2-mode pug-mode magit git-commit with-editor evil-unimpaired zenburn-theme yapfify yaml-mode xterm-color ws-butler window-numbering which-key web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package toml-mode toc-org tagedit spacemacs-theme spaceline solarized-theme smeargle slim-mode shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe reveal-in-osx-finder restart-emacs rbenv rainbow-mode rainbow-identifiers rainbow-delimiters racket-mode racer quelpa pyvenv pytest pyenv-mode py-isort projectile-rails popwin pip-requirements persp-mode pbcopy paradox ox-gfm osx-trash osx-dictionary orgit org-projectile org-present org-pomodoro org-plus-contrib org-download org-bullets open-junk-file neotree mwim multi-term move-text mmm-mode markdown-toc magit-gitflow magit-gh-pulls macrostep lorem-ipsum livid-mode live-py-mode linum-relative link-hint less-css-mode launchctl js2-refactor js-doc jinja2-mode jade-mode intero info+ indent-guide ido-vertical-mode hy-mode hungry-delete htmlize hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers highlight-indentation help-fns+ helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make helm-hoogle helm-gitignore helm-flx helm-descbinds helm-dash helm-css-scss helm-company helm-c-yasnippet helm-ag haskell-snippets google-translate golden-ratio go-eldoc gnuplot github-search github-clone github-browse-file gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe git-gutter-fringe+ gist gh-md flyspell-correct-helm flycheck-rust flycheck-pos-tip flycheck-mix flycheck-haskell flx-ido fill-column-indicator feature-mode fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu eshell-z eshell-prompt-extras esh-help erlang emmet-mode elisp-slime-nav dumb-jump dockerfile-mode docker disaster diff-hl dash-at-point cython-mode company-web company-tern company-statistics company-go company-ghci company-ghc company-cabal company-c-headers company-auctex company-anaconda column-enforce-mode color-identifiers-mode coffee-mode cmm-mode cmake-mode clean-aindent-mode clang-format chruby cargo bundler auto-yasnippet auto-highlight-symbol auto-dictionary auto-compile ansible-doc ansible alchemist aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)
