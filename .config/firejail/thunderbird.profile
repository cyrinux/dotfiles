# Firejail profile for thunderbird
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/thunderbird.local
# Persistent global definitions
include /etc/firejail/globals.local

# Users have thunderbird set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

noblacklist ${HOME}/.cache/thunderbird
noblacklist ${HOME}/.gnupg
# noblacklist ${HOME}/.icedove
noblacklist ${HOME}/.thunderbird

mkdir ${HOME}/.cache/thunderbird
mkdir ${HOME}/.gnupg
# mkdir ${HOME}/.icedove
mkdir ${HOME}/.thunderbird
whitelist ${HOME}/.cache/thunderbird
whitelist ${HOME}/.gnupg

# whitelist ${HOME}/.icedove
whitelist ${HOME}/.thunderbird

# We need the real /tmp for data exchange when xdg-open handles email attachments on KDE
ignore private-tmp
# machine-id breaks audio in browsers; enable it when sound is not required
# machine-id
read-only ${HOME}/.config/mimeapps.list
# writable-run-user is needed for signing and encrypting emails
writable-run-user

# allow browsers
# Redirect
# include ${HOME}/.config/firejail/chromium.profile

noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.pki
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

apparmor
caps.keep net_bind_service
netfilter
#nodbus
nodvd
nogroups
notv
shell none

disable-mnt
private-dev
# problems with multiple browser sessions
# private-tmp

noexec ${HOME}
noexec /tmp
