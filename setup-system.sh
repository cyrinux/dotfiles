#!/bin/bash
set -e

exec 2> >(while read -r line; do echo -e "\e[01;31m$line\e[0m"; done)

script_name="$(basename "$0")"
dotfiles_dir="$(
	cd "$(dirname "$0")"
	pwd
)"
cd "$dotfiles_dir"

if (("$EUID")); then
	sudo -E "$dotfiles_dir/$script_name" "$@"
	exit 0
fi

if [ "$1" = "-r" ]; then
	echo >&2 "Running in reverse mode!"
	reverse=1
fi

in_ci() {
	[ "$ESP" = "/tmp" ]
}

is_chroot() {
	! cmp -s /proc/1/mountinfo /proc/self/mountinfo
}

copy() {
	if [ -z "$reverse" ]; then
		orig_file="$dotfiles_dir/$1"
		dest_file="/$1"
	else
		orig_file="/$1"
		dest_file="$dotfiles_dir/$1"
	fi

	mkdir -p "$(dirname "$orig_file")"
	mkdir -p "$(dirname "$dest_file")"

	rm -rf "$dest_file"

	cp -R "$orig_file" "$dest_file"
	if [ -z "$reverse" ]; then
		[ -n "$2" ] && chmod "$2" "$dest_file"
	else
		# TODO: Remove hardcoded user here
		chown -R cyril "$dest_file"
	fi
	echo "$dest_file <= $orig_file"
}

systemctl_enable() {
	if in_ci; then
		echo "systemctl enable $1 (noop)"
	else
		echo "systemctl enable $1"
		systemctl enable "$1"
	fi
}

systemctl_enable_start() {
	if in_ci; then
		echo "systemctl enable --now $1 (noop)"
	else
		echo "systemctl enable --now $1"
		systemctl daemon-reload
		systemctl enable "$1"
		systemctl start "$1"
	fi
}

systemctl_disable_stop() {
	if in_ci; then
		echo "systemctl disable --now $1 (noop)"
	else
		echo "systemctl disable --now $1"
		systemctl disable "$1"
		systemctl stop "$1"
	fi
}

echo ""
echo "============================"
echo "Setting up /usr/local/bin..."
echo "============================"

copy "usr/local/bin/checkluksheader" 750

in_ci && echo "!!! Running in CI !!!"

echo ""
echo "=========================="
echo "Setting up /etc configs..."
echo "=========================="

copy "etc/apparmor/parser.conf"
copy "etc/firewalld/firewalld.conf" 600
copy "etc/apparmor.d/local"
copy "etc/geoclue/geoclue.conf"
copy "etc/audit/auditd.conf"
copy "etc/conf.d/snapper"
copy "etc/default/earlyoom"
copy "etc/docker/daemon.json"
copy "etc/fwupd/uefi_capsule.conf"
copy "etc/fwupd/remotes.d/lvfs.conf"
copy "etc/iwd/main.conf"
copy "etc/modules-load.d/ddcci.conf"
copy "etc/modules-load.d/pkcs8.conf"
copy "etc/NetworkManager/conf.d"
copy "etc/qemu/bridge.conf"
copy "etc/udev/rules.d/50-yubikey_power_save.rules"
# copy "etc/nftables.conf"
copy "etc/containers"
copy "etc/nmtrust/excluded_networks" 644
copy "etc/nmtrust/trusted_units" 644
copy "etc/pacman.conf" 644
copy "etc/pacman.d/hooks"
copy "etc/pam.d/polkit-1"
copy "etc/pam.d/sudo"
copy "etc/snap-pac.conf"
copy "etc/snapper/configs/root"
copy "etc/modprobe.d/kvm.conf"
copy "etc/ssh/ssh_config"
copy "etc/sysctl.d/10-swappiness.conf"
copy "etc/sysctl.d/51-tcp-ip-stack.conf"
copy "etc/sysctl.d/99-sysrq.conf"
copy "etc/sysctl.d/51-kexec-restrict.conf"
copy "etc/systemd/journald.conf.d/override.conf"
copy "etc/systemd/logind.conf.d/override.conf"
copy "etc/systemd/resolved.conf.d/dnssec.conf"
copy "etc/systemd/system/backup-repo@pkgbuild"
copy "etc/systemd/system/backup-repo@.service"
copy "etc/systemd/system/backup-repo@.timer"
copy "etc/systemd/system/getty@tty1.service.d/override.conf"
copy "etc/systemd/system/reflector.service.d"
copy "etc/systemd/system/reflector.timer"
copy "etc/systemd/system/system-dotfiles-sync.service"
copy "etc/systemd/system/system-dotfiles-sync.timer"
copy "etc/systemd/system/rebind-suspend-failing-device.service"
copy "etc/systemd/system/unbind-suspend-failing-device.service"
copy "etc/systemd/system/usbguard.service.d"
copy "etc/systemd/system/user@.service.d/delegate.conf"
copy "etc/systemd/system.conf.d/kill-fast.conf"
copy "etc/systemd/user.conf.d/kill-fast.conf"
copy "etc/systemd/system/privoxy.service.d/override.conf"
copy "etc/usbguard/usbguard-daemon.conf" 600
copy "etc/vnstat.conf"
copy "etc/bluetooth/main.conf"

(("$reverse")) && exit 0

echo ""
echo "==============================="
echo "Creating top level Trash dir..."
echo "==============================="
mkdir --parent /.Trash
chmod a+rw /.Trash
chmod +t /.Trash
echo "Done"

echo ""
echo "================================="
echo "Enabling and starting services..."
echo "================================="

systemctl_enable_start "systemd-oomd.socket"
systemctl_enable_start "power-profiles-daemon.service"
systemctl_enable_start "firewalld.service"
systemctl_enable_start "thermald.service"
systemctl_enable_start "apparmor.service"
systemctl_enable_start "auditd.service"
systemctl_enable_start "nfs-server.service"
systemctl_enable_start "backup-repo@pkgbuild.timer"
systemctl_enable_start "bluetooth.service"
systemctl_enable_start "btrfs-scrub@-.timer"
systemctl_enable_start "earlyoom.service"
systemctl_enable_start "fstrim.timer"
systemctl_enable_start "iwd.service"
systemctl_enable_start "libvirtd.socket"
systemctl_enable_start "linux-modules-cleanup.service"
systemctl_enable_start "ModemManager.service"
systemctl_enable_start "NetworkManager-dispatcher.service"
systemctl_enable_start "NetworkManager.service"
# systemctl_enable_start "nftables.service"
systemctl_disable_stop "pcscd.service"
systemctl_enable_start "privoxy.service"
systemctl_enable_start "snapper-boot.timer"
systemctl_enable_start "snapper-cleanup.timer"
systemctl_enable_start "system-dotfiles-sync.timer"
systemctl_enable_start "systemd-resolved"
systemctl_enable_start "vnstat.service"
systemctl_enable_start "smartd.service"
systemctl_enable "pcscd.socket"
systemctl_enable "apparmor.service"
systemctl_enable "unbind-suspend-failing-device.service"
systemctl_enable "rebind-suspend-failing-device.service"
# if is_chroot; then
# 	echo >&2 "=== Running in chroot, skipping docker service setup..."
# fi
# systemctl_enable_start "usbguard-dbus.service"
# systemctl_enable_start "usbguard.service"

echo ""
echo "======================================="
echo "Finishing various user configuration..."
echo "======================================="

if [ ! -s "/etc/usbguard/rules.conf" ]; then
	echo >&2 "=== Remember to set usbguard rules: usbguard generate-policy >! /etc/usbguard/rules.conf"
fi

echo "Configuring NTP"
in_ci || timedatectl set-ntp true

echo "Configuring aurutils"
ln -sf /etc/pacman.conf /etc/aurutils/pacman-cyrinux-aur-local.conf
ln -sf /etc/pacman.conf /etc/aurutils/pacman-"$(uname -m)".conf

echo "Fixing local AUR repository"
install -o "$USER" -d /var/cache/pacman/cyrinux-aur-local-temp
chmod g+s /var/cache/pacman/cyrinux-aur-local-temp

echo "Regenerating fonts cache"
fc-cache -r

if is_chroot || in_ci; then
	echo >&2 "=== Running in chroot or CI, skipping firewall, resolv.conf and udev setup..."
else
	echo "Sudo config"
	visudo -cf "etc/sudoers.d/override" && copy "etc/sudoers.d/override"

	echo "Applying kernel tuning"
	sysctl --system > /dev/null

	echo "Reload udev rules"
	udevadm control --reload
	udevadm trigger

	echo "Force dns config"
	ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
fi

echo "Install xdg-open firejail wrapper"
sudo gcc -o /usr/local/bin/xdg-open ./src/xdg-open.c
sudo chown root:root /usr/local/bin/xdg-open
sudo chmod 0755 /usr/local/bin/xdg-open

echo "Firejail some apps"
sudo systemctl enable --now apparmor.service || true
# sudo apparmor_parser -r /etc/apparmor.d/firejail-default || true
# sudo firecfg --add-users $user

echo "Setup docker rootless"
sudo touch /etc/{subgid,subuid}
sudo usermod --add-subuids 31072-65536 --add-subgids 31072-65536 "$USER"
