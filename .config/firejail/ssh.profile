quiet

noblacklist ${HOME}/.dotfiles
noblacklist ${HOME}/.dotfiles/.ssh
noblacklist ${HOME}/.cache/ssh_sessions
noblacklist ${HOME}/.ssh_logpoint
#noblacklist ${HOME}/.ansible/cp
mkdir ${HOME}/.ssh
mkdir ${HOME}/.dotfiles/.ssh
mkdir ${HOME}/.cache/ssh_sessions
mkdir ${HOME}/.ssh_logpoint
#mkdir ${HOME}/.ansible/cp
read-write ${HOME}/.dotfiles/.ssh/known_hosts
#read-write ${HOME}/.ansible/cp
whitelist ${HOME}/.ssh
whitelist ${HOME}/.dotfiles
whitelist ${HOME}/.dotfiles/.ssh
whitelist ${HOME}/.cache/ssh_sessions
whitelist ${HOME}/.ssh_logpoint
#whitelist ${HOME}/.ansible/cp

include /etc/firejail/ssh.profile
