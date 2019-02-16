# Firejail profile for nyx
# Description: Command-line status monitor for tor
# This file is overwritten after every install/update
# Persistent local customizations
include nyx.local
# Persistent global definitions
include globals.local

noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

noblacklist ${HOME}/.nyx
mkdir ${HOME}/.nyx
whitelist ${HOME}/.nyx

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
