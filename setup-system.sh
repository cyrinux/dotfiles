#!/bin/bash

set -e

exec 2> >(while read line; do echo -e "\e[01;31m$line\e[0m"; done)

MY_GPG_KEY_ID="0x2653E033C3C07A2C"

script_name="$(basename "$0")"
dotfiles_dir="$(
    cd "$(dirname "$0")"
    pwd
)"
cd "$dotfiles_dir"

if (("$EUID")); then
    sudo -s "$dotfiles_dir/$script_name" "$@"
    exit 0
fi

if [ "$1" = "-r" ]; then
    echo >&2 "Running in reverse mode!"
    reverse=1
fi

in_docker() {
    grep -q docker /proc/1/cgroup > /dev/null
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
        chown -R cyril "$dest_file"
    fi
    echo "$dest_file <= $orig_file"
}

is_chroot() {
    grep rootfs /proc/mounts > /dev/null
}

systemctl_enable() {
    echo "systemctl enable "$1""
    systemctl enable "$1"
}

systemctl_enable_start() {
    echo "systemctl enable --now "$1""
    systemctl enable "$1"
    systemctl start "$1"
}

echo ""
echo "=========================="
echo "Setting up /etc configs..."
echo "=========================="

copy "etc/systemd/system/getty@tty1.service.d/override.conf"
copy "etc/systemd/system/disable-turbo-boost.service"
copy "etc/bluetooth/main.conf"
copy "etc/makepkg.conf"
copy "etc/default/grub-btrfs/config"
copy "etc/mkinitcpio.conf"
copy "etc/systemd/resolved.conf"
copy "etc/conf.d/snapper"
copy "etc/iwd/main.conf"
copy "etc/vnstat.conf"
copy "etc/intel-undervolt.conf"
copy "etc/modules-load.d/v4l2loopback.conf"
copy "etc/modprobe.d/v4l2loopback.conf"
copy "etc/pacman.d/hooks"
copy "etc/snap-pac.conf"
copy "etc/snapper/configs/root"
copy "etc/snapper/configs/config"
copy "etc/ssh/ssh_config"
copy "etc/sysctl.d/10-swappiness.conf"
copy "etc/sysctl.d/51-tcp-ip-stack.conf"
copy "etc/sysctl.d/99-sysrq.conf"
copy "etc/systemd/journald.conf"
copy "etc/systemd/system/paccache.service"
copy "etc/systemd/system/paccache.timer"
copy "etc/systemd/system/reflector.service"
copy "etc/systemd/system/reflector.timer"
copy "etc/systemd/system/system-dotfiles-sync.service"
copy "etc/systemd/system/system-dotfiles-sync.timer"
copy "usr/local/etc/tarsnapper.conf"
copy "bin/backitup"
copy "etc/NetworkManager/dispatcher.d/100vpn"
copy "etc/NetworkManager/conf.d"
copy "etc/systemd/system/iwd.service.d/90-networkmanager.conf"
copy "etc/updatedb.conf"
copy "etc/pulse/default.pa" 644
copy "etc/parcimonie.sh.d/cyril.conf"
copy "etc/audit/auditd.conf"
copy "etc/audit/audit.rules"
copy "etc/modules-load.d/pkcs8.conf"
copy "etc/tlp.conf" 644
copy "etc/nmtrust/trusted_units" 644
copy "etc/nmtrust/excluded_networks" 644
copy "etc/systemd/system/updatedb.timer.d/updatedb.timer.conf"
copy "etc/systemd/system/man-db.timer.d/man-db.timer.conf"
copy "etc/pacman.conf" 644
copy "etc/pam.d/sudo"
copy "etc/usbguard/usbguard-daemon.conf" 600
copy "etc/systemd/system/usbguard.service.d"
copy "etc/systemd/logind.conf"
copy "etc/systemd/system/backup-repo@pkgbuild"
copy "etc/systemd/system/backup-repo@.service"
copy "etc/smartd.conf"
copy "usr/local/bin/cpu"

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

if in_docker; then
    echo >&2 "=== Running in docker, skipping services configuration..."
else
    systemctl daemon-reload
    systemctl_enable "backup-repo@pkgbuild.service"
    systemctl_enable "docker.service"
    systemctl_enable_start "fstrim.timer"
    systemctl_enable_start "NetworkManager.service"
    systemctl_enable_start "NetworkManager-dispatcher.service"
    # systemctl_enable_start "ModemManager.service"
    systemctl_enable_start "iwd.service"
    systemctl_enable_start "linux-modules-cleanup.service"
    systemctl_enable_start "systemd-resolved"
    systemctl_enable_start "bluetooth.service"
    systemctl_enable_start "ufw.service"
    systemctl_enable_start "snapper-cleanup.timer"
    systemctl_enable_start "system-dotfiles-sync.timer"
    systemctl_enable_start "auditd.service"
    systemctl_enable_start "vnstat.service"
    systemctl_enable_start "usbguard.service"
    systemctl_enable_start "usbguard-dbus.service"
    systemctl_enable_start "tlp.service"
    systemctl_enable_start "thermald.service"
    systemctl_enable_start "privoxy.service"
    systemctl_enable "smartd.service"
    systemctl_enable "btrfs-scrub@-.timer"
    systemctl_enable "btrfs-scrub@mnt-btrfs\x2droot.timer"
    systemctl_enable "btrfs-scrub@home.timer"
    systemctl_enable "btrfs-scrub@var-cache-pacman.timer"
    systemctl_enable "btrfs-scrub@var-log.timer"
    systemctl_enable "btrfs-scrub@var-tmp.timer"
    systemctl_enable "btrfs-scrub@\x2esnapshots.timer"

    echo ""
    echo "======================================="
    echo "Finishing various user configuration..."
    echo "======================================="

    if [ ! -s "/etc/usbguard/rules.conf" ]; then
        echo >&2 "=== Remember to set usbguard rules: usbguard generate-policy >! /etc/usbguard/rules.conf"
    fi

    if [ -d "$HOME/.ccnet" ]; then
        systemctl_enable_start "seaf-cli@cyril.service"
    else
        echo >&2 "=== Seafile is not initialized, skipping..., run seafile-applet"
    fi

    echo "Configuring NTP"
    timedatectl set-ntp true

    echo "Configuring aurutils"
    ln -sf /etc/pacman.conf /usr/share/devtools/pacman-aur.conf
    ln -sf /usr/bin/archbuild /usr/local/bin/aur-x86_64-build

    if is_chroot && in_docker; then
        echo >&2 "=== Running in chroot, skipping firewall, resolv.conf and udev setup..."
    else
        echo "Sudo config"
        copy "etc/sudoers.d/override"

        echo "Applying kernel tuning"
        sysctl --system > /dev/null

        echo "Configuring firewall rules and dev"
        ufw --force reset > /dev/null
        ufw default allow outgoing
        ufw default deny incoming
        ufw enable
        find /etc/ufw -type f -name '*.rules.*' -delete

        echo "Reload udev rules"
        udevadm control --reload
        udevadm trigger

        echo "Force dns config"
        ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
    fi
fi
