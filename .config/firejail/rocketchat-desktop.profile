# Firejail profile for signal-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/rocketchat.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Rocket.Chat+/

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

mkdir ${HOME}/.config/Rocket.Chat+/
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Rocket.Chat+/
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
