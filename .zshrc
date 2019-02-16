# Umask
umask 0027

# Lazy-loading
. ~/.zsh/sandboxd.zsh

# Load environment variables
. /usr/share/LS_COLORS/dircolors.sh

# Load plugins
. ~/.zsh/prezto.zsh
. ~/.zsh/zsh-notify.zsh
. ~/.zsh/antigen.zsh
. ~/.zsh/prezto-patches.zsh

# Load terminal configuration
. ~/.zsh/title.zsh
. ~/.zsh/prompt.zsh

# Load custom configurations
. ~/.zsh/opts.zsh
. ~/.zsh/keybindings.zsh
. ~/.zsh/aliases.zsh
. ~/.zsh/pacman.zsh
. ~/.zsh/kubectl.zsh
. ~/.zsh/functions.zsh
. ~/.zsh/git.zsh
. ~/.zsh/fuzzy.zsh
. ~/.zsh/ssh.zsh

# Load azure-cli completions
[ -f /usr/bin/az.completion.sh ] && . /usr/bin/az.completion.sh >/dev/null
# ~/.zsh/autorun-startx.zsh


# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/cyril/.cache/aurutils/sync/nodejs-serverless-git/src/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/cyril/.cache/aurutils/sync/nodejs-serverless-git/src/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/cyril/.cache/aurutils/sync/nodejs-serverless-git/src/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /home/cyril/.cache/aurutils/sync/nodejs-serverless-git/src/serverless/node_modules/tabtab/.completions/sls.zsh

export PINBOARD_USER=cyrinux
export PINBOARD_KEY=B488001A626BDCA3B6D5

