#!/bin/bash

set -e
exec 2> >(while read line; do echo -e "\e[01;31m$line\e[0m"; done)

MY_GPG_KEY_ID="0x2653E033C3C07A2C"

dotfiles_dir="$(
    cd "$(dirname "$0")"
    pwd
)"
cd "$dotfiles_dir"

in_docker() {
    grep -q docker /proc/1/cgroup > /dev/null
}

link() {
    orig_file="$dotfiles_dir/$1"
    dest_file="$HOME/$1"

    mkdir -p "$(dirname "$orig_file")"
    mkdir -p "$(dirname "$dest_file")"

    rm -rf "$dest_file"
    ln -s "$orig_file" "$dest_file"
    echo "$dest_file -> $orig_file"
}

is_chroot() {
    ! cmp -s /proc/1/mountinfo /proc/self/mountinfo
}

systemctl_enable() {
    if ! in_docker; then
        systemctl --user daemon-reload
    fi
    echo "systemctl --user enable \"$1\""
    systemctl --user enable "$1"
}

systemctl_enable_start() {
    if in_docker; then
        echo "systemctl --user enable \"$1\""
        systemctl --user enable "$1"
    else
        systemctl --user daemon-reload
        echo "systemctl --user enable --now \"$1\""
        systemctl --user enable --now "$1"
    fi
}

echo "======================================="
echo "Setting up dotfiles for current user..."
echo "======================================="

link ".config/environment.d"
link ".config/captive-browser.toml"
link ".config/chromium-flags.conf"
link ".config/firejail"
link ".config/firewarden"
link ".config/flashfocus"
link ".config/gsimplecal"
link ".config/gtk-2.0"
link ".config/gtk-3.0"
link ".config/myrepos.conf"
link ".config/htop"
link ".config/imapnotify"
link ".config/kak"
link ".local/share/gpg/gpg.conf"
link ".local/share/gpg/gpg-agent.conf"
link ".config/kanshi"
link ".config/khal"
link ".config/khard"
link ".local/bin"
link ".config/kitty"
link ".config/mako"
link ".config/mimeapps.list"
link ".config/mpv"
link ".config/msmtp"
link ".config/neomutt"
link ".config/pylint"
link ".config/networkmanager-dmenu"
link ".config/nnn/plugins"
link ".config/pacman"
link ".config/qalculate/qalc.cfg"
link ".config/xkb"
link ".config/qutebrowser"
link ".config/gammastep"
link ".config/git/common"
link ".config/git/config"
link ".config/git/home"
link ".config/git/work"
link ".config/git/ignore"
link ".config/repoctl"
link ".config/resticignore"
link ".config/swappy"
link ".config/sway"
link ".config/swaylock"
link ".config/systemd/user/autotiling.service"
link ".config/systemd/user/solaar.service"
link ".config/systemd/user/backup-packages.service"
link ".config/systemd/user/backup-packages.timer"
link ".config/systemd/user/checkmail.service"
link ".config/systemd/user/checkmail.timer"
link ".config/systemd/user/library-repos.service"
link ".config/systemd/user/library-repos.timer"
link ".config/systemd/user/restic-check.service"
link ".config/systemd/user/restic-check.timer"
link ".config/systemd/user/restic.service"
link ".config/systemd/user/restic.timer"
link ".config/systemd/user/tarsnap.service"
link ".config/systemd/user/tarsnap.timer"
link ".config/systemd/user/udiskie.service"
link ".config/systemd/user/urlwatch.service"
link ".config/systemd/user/urlwatch.timer"
link ".config/systemd/user/polkit-gnome.service"
link ".config/systemd/user/sway-autoname-workspaces.service"
link ".config/systemd/user/sway-inactive-window-transparency.service"
link ".config/systemd/user/sway-session.target"
link ".config/systemd/user/systembus-notify.service"
link ".config/systemd/user/udiskie.service"
link ".config/systemd/user/nm-applet.service"
link ".config/systemd/user/swayidle.service"
link ".config/systemd/user/waybar-updates.service"
link ".config/systemd/user/waybar-updates.timer"
link ".config/systemd/user/wluma-als-emulator.service"
link ".config/tig"
link ".config/tmux"
link ".config/transmission/settings.json"
link ".config/udiskie"
link ".config/USBGuard"
link ".config/user-dirs.dirs"
link ".config/vdirsyncer"
link ".config/vifm/vifmrc"
link ".config/vimiv"
link ".config/waybar"
link ".config/wget"
link ".config/wluma"
link ".config/wofi"
link ".config/youtube-dl"
link ".config/zathura"
link ".curlrc"
link ".config/git/message"
link ".ignore"
link ".local/share/applications"
link ".local/share/fonts/taskbar.ttf"
link ".local/share/qutebrowser"
link ".magic"
link ".mrtrust"
link ".p10k.zsh"
link ".p10k.zsh" ".p10k-ascii-8color.zsh"
link ".pandoc"
link ".zprofile"
link ".zsh"
link ".zshenv"
link ".zshrc"

echo ""
echo "================================="
echo "Enabling and starting services..."
echo "================================="

if is_chroot; then
    echo >&2 "=== Running in chroot, skipping user services..."
else
    systemctl_enable_start "backup-packages.timer"
    systemctl_enable_start "wluma-als-emulator.service"
    systemctl_enable_start "udiskie.service"
    systemctl_enable_start "flashfocus.service"
    systemctl_enable_start "gammastep.service"
    systemctl_enable_start "polkit-gnome.service"
    systemctl_enable_start "sway-autoname-workspaces.service"
    systemctl_enable_start "sway-inactive-window-transparency.service"
    systemctl_enable_start "systembus-notify.service"
    systemctl_enable_start "udiskie.service"
    systemctl_enable_start "nm-applet.service"
    systemctl_enable_start "waybar.service"
    systemctl_enable_start "waybar-updates.timer"
    systemctl_enable_start "wl-clipboard-manager.service"
    systemctl_enable_start "swayidle.service"
    systemctl_enable_start "solaar.service"
    systemctl_enable_start "wluma.service"
    systemctl_enable_start "autotiling.service"
    systemctl_enable_start "yubikey-touch-detector.socket"

    if [ ! -d "$HOME/.mail" ]; then
        echo >&2 -e "
        === Mail is not configured, skipping...
        === Consult ~/.config/mbsync/config for initial setup, and then sync everything using:
        === while ! mbsync -a; do echo 'restarting...'; done
        "
    fi
fi

echo ""
echo "======================================="
echo "Finishing various user configuration..."
echo "======================================="

echo "Create zsh history dir"
mkdir -p ~/zsh-history/

echo "Configuring MIME types"
file --compile --magic-file ~/.magic

if ! gpg -k | grep "$MY_GPG_KEY_ID" > /dev/null; then
    echo "Importing my public PGP key"
    curl -s https://levis.name/pgp_keys.asc | gpg --import
    gpg --trusted-key "$MY_GPG_KEY_ID" > /dev/null
fi

find "$HOME/.gnupg" -type f -path "*#*" -delete
find "$HOME/.gnupg" -type f -not -path "*#*" -exec chmod 600 {} \;
find "$HOME/.gnupg" -type d -exec chmod 700 {} \;

if [[ -e "$HOME/.password-store" ]]; then
    echo "Configuring automatic git push for pass"
    echo -e "#!/usr/bin/zsh\n\npass git push" > "$HOME/.password-store/.git/hooks/post-commit"
    chmod +x "$HOME/.password-store/.git/hooks/post-commit"
fi

if is_chroot; then
    echo >&2 "=== Running in chroot, skipping GTK file chooser dialog configuration..."
else
    echo "Configuring GTK file chooser dialog"
    gsettings set org.gtk.Settings.FileChooser sort-directories-first true
fi

echo "Ignoring further changes to often changing config"
git update-index --assume-unchanged ".config/transmission/settings.json"

if is_chroot; then
    echo >&2 "=== Running in chroot, skipping YubiKey configuration..."
else
    if [[ ! -e "$HOME/.config/Yubico/u2f_keys" ]]; then
        echo "Configuring YubiKey for sudo access (touch it now)"
        mkdir -p "$HOME/.config/Yubico"
        pamu2fcfg -ucyril > "$HOME/.config/Yubico/u2f_keys"
    fi
fi

if is_chroot; then
    echo >&2 "=== Running in chroot, skipping private dotiles configuration..."
else
    if [ ! -d "$HOME/.dotfiles-private" ]; then
        mkdir -p ~/.cache/ssh_sessions
        git clone ssh://git@git.levis.ws:10022/cyril/dotfiles-private.git $HOME/.dotfiles-private
        $HOME/.dotfiles-private/setup.sh
    fi
fi

echo "Configure repo-local git settings"
git config user.email "cyril@levis.name"
git config user.signingkey "$MY_GPG_KEY_ID"
git config commit.gpgsign true
git remote set-url origin "git@github.com:cyrinux/dotfiles.git"

echo "Configure pendock"
if is_chroot; then
    echo >&2 "=== Running in chroot, skipping pendock configuration..."
else
    if [ ! -d $HOME/pendock ]; then
        git clone https://github.com/drtychai/pendock.git $HOME/pendock
    fi
fi
