#!/bin/bash
#
# Arch Linux installation
#
# Bootable USB:
# - [Download](https://archlinux.org/download/) ISO and GPG files
# - Verify the ISO file: `$ pacman-key -v archlinux-<version>-dual.iso.sig`
# - Create a bootable USB with: `# dd if=archlinux*.iso of=/dev/sdX && sync`
#
# UEFI setup:
#
# - Set boot mode to UEFI, disable Legacy mode entirely.
# - Temporarily disable Secure Boot.
# - Make sure a strong UEFI administrator password is set.
# - Delete preloaded OEM keys for Secure Boot, allow custom ones.
# - Set SATA operation to AHCI mode.
#
# Run installation:
#
# - Connect to wifi via: `# wifi-menu`
#
# bash <(curl -sL https://git.io/cyrinux-install)

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

REPO_URL="https://aur.levis.ws/"
export SNAP_PAC_SKIP=y

# Dialog
BACKTITLE="Arch Linux installation"

get_input() {
    title="$1"
    description="$2"

    input=$(dialog --clear --stdout --backtitle "$BACKTITLE" --title "$title" --inputbox "$description" 0 0)
    echo "$input"
}

get_password() {
    title="$1"
    description="$2"

    init_pass=$(dialog --clear --stdout --backtitle "$BACKTITLE" --title "$title" --passwordbox "$description" 0 0)
    : ${init_pass:?"password cannot be empty"}

    test_pass=$(dialog --clear --stdout --backtitle "$BACKTITLE" --title "$title" --passwordbox "$description again" 0 0)
    if [[ "$init_pass" != "$test_pass" ]]; then
        echo "Passwords did not match" >&2
        exit 1
    fi
    echo $init_pass
}

get_choice() {
    title="$1"
    description="$2"
    shift 2
    options=("$@")
    dialog --clear --stdout --backtitle "$BACKTITLE" --title "$title" --menu "$description" 0 0 0 "${options[@]}"
}

echo -e "\n### HiDPI screens"
noyes=("Yes" "The font is too small" "No" "The font size is just fine")
hidpi=$(get_choice "Font size" "Is your screen HiDPI?" "${noyes[@]}") || exit 1
clear
[[ "$hidpi" == "Yes" ]] && font="ter-132n" || font="ter-716n"

hostname=$(get_input "Hostname" "Enter hostname") || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

grubpw=$(get_password "GRUB" "Enter grub password") || exit 1
clear
: ${grubpw:?"password cannot be empty"}

user=$(get_input "User" "Enter username") || exit 1
clear
: ${user:?"user cannot be empty"}

password=$(get_password "User" "Enter password") || exit 1
clear
: ${password:?"password cannot be empty"}

devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac | tr '\n' ' ')
read -r -a devicelist <<< "$devicelist"
device=$(get_choice "Installation" "Select installation disk" "${devicelist[@]}") || exit 1
clear

echo -e "\n### Setting up clock"
sleep 5
ntpdate fr.pool.ntp.org
timedatectl set-ntp true
hwclock --systohc --utc
timedatectl set-timezone Europe/Paris

echo -e "\n### Installing additional tools"
pacman -Sy --noconfirm --needed git reflector terminus-font
setfont "$font"

echo -e "\n### Setting up fastest mirrors"
reflector --latest 30 --sort rate --save /etc/pacman.d/mirrorlist

echo -e "\n### Setting up partitions"
umount -R /mnt 2> /dev/null || true
cryptsetup luksClose luks 2> /dev/null || true

bios=$(if [ -f /sys/firmware/efi/fw_platform_size ]; then echo "gpt"; else echo "msdos"; fi)
part=$(if [[ "$bios" == "gpt" ]]; then echo "ESP"; else echo "primary"; fi)

parted --script "${device}" -- mklabel ${bios} \
    mkpart ${part} fat32 1MiB 101MiB \
    set 1 boot on \
    mkpart primary 101MiB 100%

part_boot="$(ls ${device}* | grep -E "^${device}p?1$")"
part_root="$(ls ${device}* | grep -E "^${device}p?2$")"

echo -e "\n### Formatting partitions"
wipefs "${part_boot}"
wipefs "${part_root}"

mkfs.vfat -n "EFI" -F32 "${part_boot}"
echo -n ${grubpw} | cryptsetup luksFormat --type luks1 "${part_root}"
echo -n ${grubpw} | cryptsetup luksOpen "${part_root}" luks
mkfs.btrfs -L btrfs /dev/mapper/luks

echo -e "\n### Setting up BTRFS subvolumes"
mount /dev/mapper/luks /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/pkgs
btrfs subvolume create /mnt/logs
btrfs subvolume create /mnt/temp
btrfs subvolume create /mnt/aurbuild
btrfs subvolume create /mnt/archbuild
btrfs subvolume create /mnt/snapshots
umount /mnt

mount -o noatime,nodiratime,compress=zstd,subvol=root /dev/mapper/luks /mnt
mkdir -p /mnt/{mnt/btrfs-root,boot/efi,home,var/{cache/pacman,log,tmp,lib/{aurbuild,archbuild}},.snapshots}
mount "${part_boot}" /mnt/boot/efi
mount -o noatime,nodiratime,compress=zstd,subvol=/ /dev/mapper/luks /mnt/mnt/btrfs-root
mount -o noatime,nodiratime,compress=zstd,subvol=home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress=zstd,subvol=pkgs /dev/mapper/luks /mnt/var/cache/pacman
mount -o noatime,nodiratime,compress=zstd,subvol=aurbuild /dev/mapper/luks /mnt/var/lib/aurbuild
mount -o noatime,nodiratime,compress=zstd,subvol=archbuild /dev/mapper/luks /mnt/var/lib/archbuild
mount -o noatime,nodiratime,compress=zstd,subvol=logs /dev/mapper/luks /mnt/var/log
mount -o noatime,nodiratime,compress=zstd,subvol=temp /dev/mapper/luks /mnt/var/tmp
mount -o noatime,nodiratime,compress=zstd,subvol=snapshots /dev/mapper/luks /mnt/.snapshots

echo -e "\n### Setting up an encrypted key for booting"
dd bs=512 count=4 if=/dev/urandom of=/mnt/crypto_keyfile.bin
chmod 000 /mnt/crypto_keyfile.bin
echo -n "${grubpw}" | cryptsetup luksAddKey "${part_root}" /mnt/crypto_keyfile.bin

echo -e "\n### Importing my public PGP key"
export MY_GPG_KEY_ID="0x2653E033C3C07A2C"
curl -s https://levis.name/pgp_keys.asc | pacman-key -a -
pacman-key --lsign-key "$MY_GPG_KEY_ID"

echo -e "\n### Adding blackarch repo"
curl -sL https://blackarch.org/strap.sh | bash

echo -e "\n### Downloading custom repo"
mkdir /mnt/var/cache/pacman/cyrinux-aur
wget -m -q -nH -np --show-progress --progress=bar:force --reject='index.html*' --cut-dirs=2 -P '/mnt/var/cache/pacman/cyrinux-aur' $REPO_URL

cat >> /etc/pacman.conf << EOF
[cyrinux-aur]
SigLevel = Required
Server = file:///mnt/var/cache/pacman/cyrinux-aur/

[maximbaz]
Server = https://pkgbuild.com/~maximbaz/repo/
SigLevel = Required

[options]
CacheDir = /var/cache/pacman/pkg
CacheDir = /mnt/var/cache/pacman/cyrinux-aur
EOF

echo -e "\n### Installing packages"
pacstrap -i /mnt cyrinux

echo -e "\n### Generating base config files"
ln -sfT dash /mnt/usr/bin/sh
echo "FONT=$font" > /mnt/etc/vconsole.conf
echo "KEYMAP=fr" >> /mnt/etc/vconsole.conf
genfstab -U /mnt >> /mnt/etc/fstab
echo "${hostname}" > /mnt/etc/hostname
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
echo "fr_FR.UTF-8 UTF-8" >> /mnt/etc/locale.gen
ln -sf /usr/share/zoneinfo/Europe/Paris /mnt/etc/localtime
arch-chroot /mnt locale-gen
cat << EOF > /mnt/etc/mkinitcpio.conf
MODULES=()
BINARIES=()
FILES=(/crypto_keyfile.bin)
HOOKS=(base consolefont udev autodetect modconf block encrypt filesystems keyboard)
COMPRESSION="lz4"
EOF
arch-chroot /mnt mkinitcpio -p linux-hardened
cat << EOF > /mnt/etc/sudoers
root ALL=(ALL) ALL
%wheel ALL=(ALL) ALL
EOF

echo -e "\n### Installing GRUB"
chmod 600 /mnt/boot/initramfs-linux*
cat << EOF > /mnt/etc/default/grub
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="Arch"
GRUB_CMDLINE_LINUX_DEFAULT="apparmor=1 security=apparmor quiet loglevel=0 vga=current udev.log_priority=0 vt.global_cursor_default=0 consoleblank=60 mem_sleep_default=deep cgroup_enable=memory mitigations=off"
GRUB_CMDLINE_LINUX="cryptdevice=${part_root}:luks:allow-discards"
GRUB_PRELOAD_MODULES="part_gpt part_msdos"
GRUB_ENABLE_CRYPTODISK=y
GRUB_TIMEOUT_STYLE=menu
GRUB_TERMINAL_INPUT=console
GRUB_GFXMODE=1280x1024x32,1024x768x32,auto
GRUB_DISABLE_RECOVERY=true
EOF
arch-chroot /mnt grub-install "${device}"
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
cat << EOF > /mnt/boot/grub/update.sh
#!/bin/sh
grub-install ${device}
cryptboot-efikeys sign /boot/efi/EFI/arch/grubx64.efi
EOF
chmod +x /mnt/boot/grub/update.sh

echo -e "\n### Creating user"
arch-chroot /mnt useradd -m -s /usr/bin/zsh "$user"
for group in wheel network video audit plugdev informant; do
    arch-chroot /mnt groupadd -rf "$group"
    arch-chroot /mnt gpasswd -a "$user" "$group"
done

arch-chroot /mnt chsh -s /usr/bin/zsh
echo "$user:$password" | chpasswd --root /mnt
arch-chroot /mnt passwd -dl root

echo -e "\n### Fixing local  repository perms"
arch-chroot /mnt chown -R "$user:$user" /var/cache/pacman/cyrinux-aur/

echo -e "\n### Setting up Secure Boot for GRUB with custom keys"
echo MB | arch-chroot /mnt cryptboot-efikeys create
arch-chroot /mnt cryptboot-efikeys enroll
arch-chroot /mnt cryptboot-efikeys sign /boot/efi/EFI/arch/grubx64.efi
arch-chroot /mnt cryptboot-efikeys sign /boot/efi/EFI/arch/fwupdx64.efi

echo -e "\n### Cloning dotfiles"
arch-chroot /mnt sudo -u $user bash -c 'git clone --recursive https://github.com/cyrinux/dotfiles.git ~/.dotfiles'

echo -e "\n### Running initial setup"
arch-chroot /mnt /home/$user/.dotfiles/setup-system.sh
arch-chroot /mnt sudo -u $user /home/$user/.dotfiles/setup-user.sh

echo -e "\n### DONE - reboot and re-run both ~/.dotfiles/setup-*.sh scripts"
umount -R /mnt
