#!/usr/bin/zsh

set -e

exec 2> >(while read line; do echo -e "\e[01;31m$line\e[0m"; done)

MY_GPG_KEY_ID="0x2653E033C3C07A2C"

script_name="$(basename "$0")"
dotfiles_dir="$(cd "$(dirname "$0")"; pwd)"
cd "$dotfiles_dir"

if (( "$EUID" )); then
    sudo -s "$dotfiles_dir/$script_name" "$@"
    exit 0
fi

if [ "$1" = "-r" ]; then
    >&2 echo "Running in reverse mode!"
    reverse=1
fi

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
  grep rootfs /proc/mounts >/dev/null
}

systemctl_enable() {
    echo "systemctl enable "$1""
    systemctl enable "$1"
}

systemctl_enable_start() {
    echo "systemctl enable --now "$1""
    systemctl enable "$1"
    systemctl start  "$1"
}

echo ""
echo "=========================="
echo "Setting up /etc configs..."
echo "=========================="

copy "etc/makepkg.conf"
copy "etc/mkinitcpio.conf"
copy "etc/systemd/resolved.conf"
copy "etc/conf.d/snapper"
copy "etc/iwd/main.conf"
copy "etc/vnstat.conf"
copy "etc/knot-resolver/kresd.conf"
copy "etc/intel-undervolt.conf"
copy "etc/environment"
copy "etc/pacman.d/hooks"
copy "etc/profile.d/zz_custom.sh"
copy "etc/snap-pac.conf"
copy "etc/snapper/configs/root"
copy "etc/snapper/configs/config"
copy "etc/ssh/ssh_config"
copy "etc/sysctl.d/10-swappiness.conf"
copy "etc/sysctl.d/51-tcp-ip-stack.conf"
copy "etc/sysctl.d/99-idea.conf"
copy "etc/sysctl.d/99-sysctl.conf"
copy "etc/systemd/journald.conf"
copy "etc/systemd/system/paccache.service"
copy "etc/systemd/system/paccache.timer"
copy "etc/systemd/system/reflector.service"
copy "etc/systemd/system/reflector.timer"
copy "etc/systemd/system/system-dotfiles-sync.service"
copy "etc/systemd/system/system-dotfiles-sync.timer"
copy "usr/local/etc/tarsnapper.conf"
copy "usr/local/bin/backitup"
copy "etc/NetworkManager/dispatcher.d/20freewifi"
copy "etc/NetworkManager/dispatcher.d/100vpn"
copy "etc/NetworkManager/dispatcher.d/99refresh-py3status"
copy "etc/NetworkManager/conf.d"
copy "etc/systemd/system/iwd.service.d/90-networkmanager.conf"
copy "etc/updatedb.conf"
copy "etc/bluetooth/main.conf"
copy "etc/pulse/default.pa"
copy "etc/parcimonie.sh.d/cyril.conf"
copy "etc/snapper/configs/home"
copy "etc/audit/auditd.conf"
copy "etc/audit/audit.rules"
copy "etc/modules-load.d/pkcs8.conf"
copy "etc/modules-load.d/zram.conf"
copy "etc/default/grub"
copy "etc/default/tlp"
copy "etc/default/grub-btrfs/config"
copy "etc/nmtrust/trusted_units"
copy "etc/systemd/system/getty@tty1.service.d"
copy "etc/pacman.conf"
copy "etc/pam.d/sudo"
copy "etc/private-internet-access/pia.conf"
copy "etc/sudoers"
copy "etc/systemd/logind.conf"
copy "etc/systemd/system/backup-repo@pkgbuild"
copy "etc/systemd/system/backup-repo@.service"
copy "etc/udev/rules.d/81-ac-battery-change.rules"
copy "etc/udev/rules.d/70-wifi-powersave.rules"
copy "etc/udev/rules.d/50-usb_power_save.rules"
copy "etc/udev/rules.d/99pci_pm.rules"
copy "etc/udev/rules.d/90-hid-eToken.rules"
copy "etc/usbguard/usbguard-daemon.conf" 600
copy "etc/X11/xorg.conf.d/00-keyboard.conf"
copy "etc/X11/xorg.conf.d/30-touchpad.conf"
copy "etc/nmtrust/trusted_units"

(( "$reverse" )) && exit 0

echo ""
echo "================================="
echo "Enabling and starting services..."
echo "================================="

sysctl --system > /dev/null
systemctl daemon-reload
systemctl_enable "backup-repo@pkgbuild.service"
systemctl_enable "docker.service"
systemctl_enable_start "getty@tty1.service"
systemctl_enable_start "macchiato.service"
systemctl_enable_start "fstrim.timer"
systemctl_enable_start "NetworkManager.service"
systemctl_enable_start "NetworkManager-dispatcher.service"
systemctl_enable_start "ModemManager.service"
systemctl_enable_start "kresd.socket"
systemctl_enable_start "kresd@1.service"
systemctl_enable_start "iwd.service"
systemctl_enable_start "linux-modules-cleanup.service"
systemctl_enable_start "systemd-resolved"
systemctl_enable_start "bluetooth.service"
systemctl_enable_start "paccache.timer"
systemctl_enable_start "ufw.service"
systemctl_enable_start "snapper-cleanup.timer"
systemctl_enable_start "system-dotfiles-sync.timer"
systemctl_enable_start "auditd.service"
systemctl_enable_start "vnstat.service"
systemctl_enable_start "usbguard.service"
systemctl_enable_start "usbguard-dbus.service"
systemctl_enable_start "tlp.service"
systemctl_enable_start "tlp-sleep.service"
systemctl_enable_start "systemd-swap.service"

if [ ! -s "/etc/usbguard/rules.conf" ]; then
 >&2 echo "=== Remember to set usbguard rules: usbguard generate-policy >! /etc/usbguard/rules.conf"
fi

if [ -d "$HOME/.ccnet" ]; then
systemctl_enable_start "seaf-cli@cyril.service"
else
>&2 echo "=== Seafile is not initialized, skipping..."
fi

echo ""
echo "==============================="
echo "Creating top level Trash dir..."
echo "==============================="
mkdir --parent /.Trash
chmod a+rw /.Trash
chmod +t /.Trash
echo "Done"

echo ""
echo "======================================="
echo "Finishing various user configuration..."
echo "======================================="

echo "Configuring aurutils"
ln -sf /etc/pacman.conf /usr/share/devtools/pacman-aur.conf
ln -sf /usr/bin/archbuild /usr/local/bin/aur-x86_64-build

echo "Force dns config"
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

echo "Configuring fontconfig"
ln -sf /etc/fonts/conf.avail/75-joypixels.conf /etc/fonts/conf.d/75-joypixels.conf

echo "Configuring firejail"
firecfg
rm -f /usr/local/bin/{i3,conky}

if is_chroot; then
  >&2 echo "=== Running in chroot, skipping firewall, resolv.conf and udev setup..."
else
  echo "=== Configuring firewall rules and dev"
  ufw --force reset > /dev/null
  ufw default allow outgoing
  ufw default deny incoming
  ufw allow ssh
  ufw allow 5000
  ufw enable
  find /etc/ufw -type f -name '*.rules.*' -delete

  echo "Reload udev rules"
  udevadm control --reload
  udevadm trigger

  echo "Force dns config"
  ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

  sleep 1
  xmodmap "$dotfiles_dir/.Xmodmap"
fi

