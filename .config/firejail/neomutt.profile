# Firejail profile for neomutt
# Description: Mutt fork with advanced features and better documentation
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include neomutt.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.mail
noblacklist ${HOME}/.config/kak
noblacklist ${HOME}/.config/neomutt
noblacklist ${HOME}/.config/msmtp
noblacklist /var/mail
noblacklist /var/spool/mail

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*

include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.mail
mkdir ${HOME}/.config/neomutt
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/neomutt
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.mail
whitelist ${HOME}/.config/msmtp
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
whitelist /usr/share/neomutt
whitelist /var/mail
whitelist /var/spool/mail
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
shell none
tracelog

# disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,fonts,gcrypt,gnupg,hostname,hosts,hosts.conf,ld.so.cache,ld.so.preload,mail,mailname,Mutt,Muttrc,Muttrc.d,neomuttrc,neomuttrc.d,nntpserver,nsswitch.conf,passwd,pki,resolv.conf,ssl,xdg
private-tmp
writable-run-user
writable-var

dbus-user none
dbus-system none

memory-deny-write-execute
