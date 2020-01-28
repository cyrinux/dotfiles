#/usr/bin/env zsh

# vault
[ -x /usr/bin/vault ] && complete -o nospace -C /usr/bin/vault vault

# azure
z4h source -c /etc/bash_completion.d/azure-cli
