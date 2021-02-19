include /etc/firejail/qutebrowser.profile
noblacklist ${HOME}/.local/share/qutebrowser
noblacklist ${HOME}/.local/share/qutebrowser-containers
noblacklist ${HOME}/.pki
noblacklist ${HOME}/.password-store
noblacklist ${HOME}/.dotfiles/.config/qutebrowser
whitelist ${HOME}/.local/share/qutebrowser-containers
whitelist ${HOME}/.pki
whitelist ${HOME}/.password-store
whitelist ${HOME}/.dotfiles/.config/qutebrowser

