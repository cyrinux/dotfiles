#!/bin/bash

set -e
exec 2> >(while read -r line; do echo -e "\e[01;31m$line\e[0m"; done)

MY_GPG_KEY_ID="0x6DB88737C11F5A48"

dotfiles_dir="$(
	cd "$(dirname "$0")"
	pwd
)"
cd "$dotfiles_dir"

in_docker() {
	grep -q docker /proc/1/cgroup > /dev/null
}

in_ci() {
	[ "$ESP" = "/tmp" ]
}

is_chroot() {
	! cmp -s /proc/1/mountinfo /proc/self/mountinfo
}

detectgpu() {
	(lsmod | grep '^i915' || lsmod | grep '^amdgpu' || lsmod | grep '^hid_apple') | awk '{print $1}'
}

copy() {
	if [ -z "$reverse" ]; then
		orig_file="$dotfiles_dir/$1"
		dest_file="$HOME/$1"
	else
		orig_file="$HOME/$1"
		dest_file="$dotfiles_dir/$1"
	fi

	mkdir -p "$(dirname "$orig_file")"
	mkdir -p "$(dirname "$dest_file")"

	rm -rf "$dest_file"

	cp -R "$orig_file" "$dest_file"
	if [ -z "$reverse" ]; then
		[ -n "$2" ] && chmod "$2" "$dest_file"
	else
		chown -R cyril "$dest_file"
	fi
	echo "$dest_file <= $orig_file"
}

link() {
	orig_file="$dotfiles_dir/$1"
	if [ -n "$2" ]; then
		dest_file="$HOME/$2"
	else
		dest_file="$HOME/$1"
	fi

	mkdir -p "$(dirname "$orig_file")"
	mkdir -p "$(dirname "$dest_file")"

	rm -rf "$dest_file"
	ln -s "$orig_file" "$dest_file"
	echo "$dest_file -> $orig_file"
}

systemctl_enable() {
	if ! in_docker && ! in_ci; then
		systemctl --user daemon-reload
	fi
	echo "systemctl --user enable \"$1\""
	systemctl --user enable "$1"
}

systemctl_enable_start() {
	if ! in_docker && ! in_ci; then
		systemctl --user daemon-reload
		echo "systemctl --user enable --now \"$1\""
		systemctl --user enable --now "$1"
	else
		echo "systemctl --user enable \"$1\""
		systemctl --user enable "$1"
	fi
}

echo "======================================="
echo "Setting up dotfiles for current user..."
echo "======================================="

copy ".config/environment.d"
link ".config/environment.d/60-wayland/60-wayland.conf.$(detectgpu)" ".config/environment.d/60-wayland.conf"
link ".config/bat"
link ".config/dmenu"
link ".config/chromium-flags.conf"
link ".config/electron-flags.conf"
link ".config/electron-flags.conf" ".config/electron13-flags.conf"
link ".config/firejail"
link ".config/pipewire"
link ".config/stylua"
link ".config/swaync"
link ".config/swayimg"
link ".config/firewarden"
link ".config/git/common"
link ".config/git/config"
link ".config/git/home"
link ".config/git/ignore"
link ".config/git/message"
link ".config/k9s"
link ".config/git/templates"
link ".config/gsimplecal"
link ".config/modprobed.db"
link ".config/gtk-3.0"
link ".config/gtk-4.0"
link ".config/htop"
link ".config/kak"
link ".config/kak-lsp"
link ".config/kanshi"
link ".config/khal"
link ".config/khard"
link ".config/kitty"
link ".config/mimeapps.list"
link ".config/mpv"
link ".config/msmtp"
link ".config/neomutt"
link ".config/networkmanager-dmenu"
link ".config/pacman"
link ".config/pylint"
link ".config/pythonrc.py"
link ".config/cni"
link ".config/qalculate/qalc.cfg"
link ".config/qalculate/qalculate-gtk.cfg"
link ".config/qutebrowser"
link ".config/repoctl"
link ".config/resticignore"
link ".config/swappy"
link ".config/davmail"
link ".config/hypr"
link ".config/swaylock"
link ".config/systemd/user/waybar-eyes.service"
link ".config/systemd/user/apparmor-notify.service"
link ".config/systemd/user/backup-packages.service"
link ".config/systemd/user/backup-packages.timer"
link ".config/systemd/user/git-annex.service"
link ".config/systemd/user/checkmail.service"
link ".config/systemd/user/checkmail.timer"
link ".config/systemd/user/gocryptfs-automount.service"
link ".config/systemd/user/nm-applet.service"
link ".config/systemd/user/battery-low-notify.service"
link ".config/alacritty"
link ".config/systemd/user/polkit-gnome.service"
link ".config/systemd/user/restic-check.service"
link ".config/systemd/user/restic-check.timer"
link ".config/systemd/user/restic.service"
link ".config/systemd/user/restic.timer"
link ".config/systemd/user/socksproxy.service"
link ".config/systemd/user/solaar.service"
link ".config/systemd/user/swaync.service"
link ".config/systemd/user/waybar.service"
link ".config/systemd/user/swayidle.service"
link ".config/systemd/user/swaylock.service"
link ".config/systemd/user/hyprland-session.target"
link ".config/systemd/user/systembus-notify.service"
link ".config/systemd/user/tarsnap.service"
link ".config/systemd/user/tarsnap.timer"
link ".config/systemd/user/task-sync.service"
link ".config/systemd/user/task-sync.timer"
link ".config/systemd/user/udiskie.service"
link ".config/systemd/user/urlwatch.service"
link ".config/systemd/user/urlwatch.timer"
link ".config/systemd/user/waybar-updates.service"
link ".config/systemd/user/waybar-updates.timer"
link ".config/systemd/user/wlsunset.service"
link ".config/systemd/user/work-unseal.service"
link ".config/systemd/user/signal-desktop.service"
link ".config/systemd/user/system-dotfiles-sync.service"
link ".config/systemd/user/system-dotfiles-sync.timer"
link ".config/tig"
link ".config/tmux"
link ".config/transmission/settings.json"
link ".config/udiskie"
link ".config/USBGuard"
link ".config/user-dirs.dirs"
link ".config/user-tmpfiles.d"
link ".config/helix"
link ".config/vdirsyncer"
link ".config/vimiv"
link ".config/waybar"
link ".config/hyprland-autoname-workspaces"
link ".config/waycorner"
link ".config/wget"
link ".config/todoman"
link ".config/wluma"
link ".config/wofi"
link ".config/wldash"
link ".config/yt-dlp"
link ".config/xdg-desktop-portal-wlr"
link ".config/xkb"
link ".config/xplr"
link ".config/youtube-dl"
link ".config/zathura"
link ".config/gh"
link ".ignore"
link ".local/bin"
link ".local/share/applications"
link ".local/share/dark-mode.d"
link ".local/share/light-mode.d"
link ".local/share/bsod.png"
link ".gnupg/gpg-agent.conf"
link ".gnupg/gpg.conf"
link ".local/share/qutebrowser/greasemonkey"
link ".local/share/flatpak/overrides"
link ".magic"
link ".p10k.zsh"
link ".p10k.zsh" ".p10k-ascii-8color.zsh"
link ".pandoc"
link ".zsh"
link ".zshenv"
link ".zshrc"
link ".ssh/config"
link ".config/sclirc"
link ".config/systemd/user/wl-clipboard-manager.service"
link ".config/systemd/user/geoclue.service"
link ".config/systemd/user/darkman.service.d/want-geoclue-agent.conf"
link ".zprofile"
link ".config/systemd/user/backup-repo@pkgbuild"
link ".config/systemd/user/backup-repo@.service"
link ".config/systemd/user/seaf-cli.service"
link ".config/systemd/user/backup-repo@.timer"

echo ""
echo "================================="
echo "Enabling and starting services..."
echo "================================="

if is_chroot; then
	echo >&2 "!!!! Running in chroot !!!!!!!!!"
else
	echo >&2 "!!!! NOT Running in chroot !!!!!!!!!"
fi

if in_ci; then
	echo >&2 "!!!! Running in CI !!!!!!!!!"
else
	echo >&2 "!!!! NOT Running in CI !!!!!!!!!"
fi

if is_chroot; then
	echo >&2 "=== Running in chroot, skipping user services..."
else
	systemctl_enable_start "apparmor-notify.service"
	systemctl_enable_start "backup-packages.timer"
	systemctl_enable_start "backup-repo@pkgbuild.timer"
	systemctl_enable_start "battery-low-notify.service"
	systemctl_enable_start "geoclue.service"
	systemctl_enable_start "gocryptfs-automount.service"
	systemctl_enable_start "gotify-dunst.service"
	systemctl_enable_start "hyprland-autoname-workspaces.service"
	systemctl_enable_start "kanshi.service"
	systemctl_enable_start "nm-applet.service"
	systemctl_enable_start "polkit-gnome.service"
	systemctl_enable_start "signal-desktop.service"
	systemctl_enable_start "socksproxy.service"
	systemctl_enable_start "solaar.service"
	systemctl_enable_start "swayidle.service"
	systemctl_enable_start "swaync.service"
	systemctl_enable_start "systembus-notify.service"
	systemctl_enable_start "systemd-autoreload.service"
	systemctl_enable_start "systemd-lock-handler.service"
	systemctl_enable_start "system-dotfiles-sync.timer"
	systemctl_enable_start "systemd-tmpfiles-setup.service"
	systemctl_enable_start "udiskie.service"
	systemctl_enable_start "waybar.service"
	systemctl_enable_start "waybar-updates.timer"
	systemctl_enable_start "wl-clipboard-manager.service"
	systemctl_enable_start "wlsunset.service"
	systemctl_enable_start "work-unseal.service"
	systemctl_enable_start "yubikey-touch-detector.socket"
	systemctl_enable "swaylock.service"

	if [ ! -d "$HOME/.mail" ]; then
		mkdir -p "$HOME/.mail/"{personal,work}
		echo >&2 -e "
        === Mail is not configured, skipping...
        === Consult ~/.config/mbsync/config for initial setup, and then sync everything using:
        === while ! mbsync -a -c ~/.config/mbsync/config; do sleep 1; echo 'restarting...'; done
        "
	fi
fi

echo ""
echo "======================================="
echo "Finishing various user configuration..."
echo "======================================="

echo "Create zsh history dir"
mkdir -p ~/.zsh-history/

echo "Configuring MIME types"
file --compile --magic-file ~/.magic || true

echo "Configuring GPG key"
if ! gpg -k | grep "$MY_GPG_KEY_ID" > /dev/null; then
	echo "Importing my public PGP key"
	curl -s https://levis.name/pgp_keys.asc | gpg --import
	printf "5\ny\n" | gpg --command-fd 0 --no-tty --batch --edit-key "$MY_GPG_KEY_ID" trust
fi
find "$HOME/.gnupg" -type f -not -path "*#*" -exec chmod 600 {} \;
find "$HOME/.gnupg" -type d -exec chmod 700 {} \;

echo "Configuring password-store"
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
git update-index --assume-unchanged ".config/transmission/settings.json" || true

if is_chroot || in_ci; then
	echo >&2 "=== Running in chroot, skipping YubiKey configuration..."
else
	if [[ ! -e "$HOME/.config/Yubico/u2f_keys" ]]; then
		echo "Configuring YubiKey for sudo access (touch it now)"
		mkdir -p "$HOME/.config/Yubico"
		pamu2fcfg -u"$USER" > "$HOME/.config/Yubico/u2f_keys"
	fi
fi

if is_chroot || in_ci; then
	echo >&2 "=== Running in chroot, skipping private dotiles configuration..."
else
	if [ ! -d "$HOME/.dotfiles-private" ]; then
		mkdir -p ~/.cache/ssh_sessions
		git clone ssh://git@git.levis.ws:10022/cyril/dotfiles-private.git "$HOME/.dotfiles-private"
		"$HOME/.dotfiles-private/setup.sh"
	fi
fi

echo "Configure repo-local git settings"
git config user.email "git@levis.name"
git config user.signingkey "$MY_GPG_KEY_ID"
git config commit.gpgsign true
git remote set-url origin "git@github.com:cyrinux/dotfiles.git"
pre-commit install-hooks

# flatpak
flatpak install -y --noninteractive com.rtosta.zapzap org.telegram.desktop md.obsidian.Obsidian dev.k8slens.OpenLens
flatpak override --user --env=OBSIDIAN_USE_WAYLAND=1 md.obsidian.Obsidian

# asdf (asdf plugin list | xargs)
for s in awscli direnv flux2 gcloud helm helmfile k3d kind kubectl kustomize minikube python rust sops terraform vault azure-cli; do
	asdf plugin-add $s
	asdf install $s latest
	asdf global $s latest
done

# pomo
go install github.com/rwxrob/pomo/cmd/pomo@latest
