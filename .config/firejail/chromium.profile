# Firejail profile for chromium
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/chromium.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/chromium
noblacklist ${HOME}/.config/chromium
noblacklist ${HOME}/.config/chromium-flags.conf

mkdir ${HOME}/.cache/chromium
mkdir ${HOME}/.config/chromium
whitelist ${HOME}/.cache/chromium
whitelist ${HOME}/.config/chromium
whitelist ${HOME}/.config/chromium-flags.conf

# private-bin chromium,chromium-browser,chromedriver

# Redirect
include ${HOME}/.config/firejail/chromium-common.profile
