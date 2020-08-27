#!/bin/bash
#
# Arch Linux installation
# https://github.com/cyrinux/dotfiles
# https://github.com/maximbaz/dotfiles
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
# - Connect to wifi via: `# iwctl station wlan0 connect WIFI-NETWORK`
#
# bash <(curl -sL https://git.io/cyrinux-install)

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

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

echo -e "\n### Testing if UEFI is supported"
if [ ! -f /sys/firmware/efi/fw_platform_size ]; then
    echo "Sorry your computer doesn't support EFI"
    exit 2
fi

echo -e "\n### Setting up clock"
pacman -Sy --noconfirm ntp
timedatectl set-ntp true
ntpdate fr.pool.ntp.org
timedatectl set-timezone Europe/Paris
hwclock --systohc --utc

echo -e "\n### Installing additional tools"
pacman -Sy --noconfirm --needed git reflector terminus-font dialog wget yubikey-full-disk-encryption bc

echo -e "\n### HiDPI screens"
noyes=("Yes" "The font is too small" "No" "The font size is just fine")
hidpi=$(get_choice "Font size" "Is your screen HiDPI?" "${noyes[@]}") || exit 1
clear
[[ "$hidpi" == "Yes" ]] && font="ter-132n" || font="ter-716n"
setfont "$font"

hostname=$(get_input "Hostname" "Enter hostname") || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

echo -e "\n### Luks screens"
noyes=("Yes" "Use luks Yubikey full disk encryption" "No" "Use standard luks full disk encryption")
fde=$(get_choice "Luks Encryption" "Use Yubikey FDE project?" "${noyes[@]}") || exit 1
clear

[[ "$fde" == "No" ]] && {
    lukspw=$(get_password "LUKS" "Enter luks password") || exit 1
    clear
    : ${lukspw:?"password cannot be empty"}
}

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

echo -e "\n### Setting up fastest mirrors"
reflector --latest 30 --sort rate --save /etc/pacman.d/mirrorlist

echo -e "\n### Setting up partitions"
umount -R /mnt 2> /dev/null || true
cryptsetup luksClose luks 2> /dev/null || true

wipefs --all "${device}"
sgdisk --clear "${device}" --new 1::-551MiB --change-name=1:"luks" -g "${device}"
sgdisk --new 2::0 --type 2:ef00 --change-name=2:"EFI" -g "${device}"

part_root="$(ls ${device}* | grep -E "^${device}p?1$")"
part_boot="$(ls ${device}* | grep -E "^${device}p?2$")"

echo -e "\n### Formatting partitions"
mkfs.vfat -n "EFI" -F32 "${part_boot}"

if [[ "$fde" == "Yes" ]]; then
    ykfde-format --align-payload 8192 --pbkdf argon2id -i 5000 --type luks2 --label=luks "${part_root}"
    ykfde-open -d "${part_root}" -n luks
else
    echo -n ${lukspw} | cryptsetup luksFormat --align-payload 8192 --pbkdf argon2id -i 5000 --type luks2 --label=luks "${part_root}"
    echo -n ${lukspw} | cryptsetup luksOpen "${part_root}" luks
fi

mkfs.btrfs -L btrfs /dev/mapper/luks

echo -e "\n### Setting up BTRFS subvolumes"

mount /dev/mapper/luks /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/pkgs
btrfs subvolume create /mnt/aurbuild
btrfs subvolume create /mnt/archbuild
btrfs subvolume create /mnt/docker
btrfs subvolume create /mnt/logs
btrfs subvolume create /mnt/temp
btrfs subvolume create /mnt/snapshots
umount /mnt

mount -o noatime,nodiratime,compress=zstd,subvol=root /dev/mapper/luks /mnt
mkdir -p /mnt/{mnt/btrfs-root,efi,home,var/{cache/pacman,log,tmp,lib/{aurbuild,archbuild,docker}},.snapshots}
mount "${part_boot}" /mnt/efi
mount -o noatime,nodiratime,compress=zstd,subvol=/ /dev/mapper/luks /mnt/mnt/btrfs-root
mount -o noatime,nodiratime,compress=zstd,subvol=home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress=zstd,subvol=pkgs /dev/mapper/luks /mnt/var/cache/pacman
mount -o noatime,nodiratime,compress=zstd,subvol=aurbuild /dev/mapper/luks /mnt/var/lib/aurbuild
mount -o noatime,nodiratime,compress=zstd,subvol=archbuild /dev/mapper/luks /mnt/var/lib/archbuild
mount -o noatime,nodiratime,compress=zstd,subvol=docker /dev/mapper/luks /mnt/var/lib/docker
mount -o noatime,nodiratime,compress=zstd,subvol=logs /dev/mapper/luks /mnt/var/log
mount -o noatime,nodiratime,compress=zstd,subvol=temp /dev/mapper/luks /mnt/var/tmp
mount -o noatime,nodiratime,compress=zstd,subvol=snapshots /dev/mapper/luks /mnt/.snapshots

echo -e "\n### Importing my public PGP key"
export MY_GPG_KEY_ID="0x2653E033C3C07A2C"
curl -s https://levis.name/pgp_keys.asc | pacman-key -a -
pacman-key --lsign-key "$MY_GPG_KEY_ID"

echo -e "\n### Configuring custom repo"
mkdir /mnt/var/cache/pacman/cyrinux-aur-local

if [[ "${hostname}" == "work-"* ]]; then
    wget -m -q -nH -np --show-progress --progress=bar:force --reject='index.html*' --cut-dirs=2 -P '/mnt/var/cache/pacman/cyrinux-aur-local' 'https://aur.levis.ws/'
    rename -- 'cyrinux-aur.' 'cyrinux-aur-local.' /mnt/var/cache/pacman/cyrinux-aur-local/*
else
    repo-add /mnt/var/cache/pacman/cyrinux-aur-local/cyrinux-aur-local.db.tar
fi

if ! grep cyrinux /etc/pacman.conf > /dev/null; then
    cat >> /etc/pacman.conf << EOF
[cyrinux-aur-local]
Server = file:///mnt/var/cache/pacman/cyrinux-aur-local

[cyrinux-aur]
SigLevel = Required
Server = https://aur.levis.ws/

[options]
CacheDir = /mnt/var/cache/pacman/pkg
CacheDir = /mnt/var/cache/pacman/cyrinux-aur-local
EOF
fi

echo -e "\n### Installing packages"
pacstrap -i /mnt cyrinux

echo -e "\n### Generating base config files"
ln -sfT dash /mnt/usr/bin/sh
echo "cryptdevice=LABEL=luks:luks:allow-discards root=LABEL=btrfs rw rootflags=subvol=root quiet mem_sleep_default=deep pti=on page_alloc.shuffle=1 apparmor=1 security=apparmor mitigations=on loglevel=0 vga=current consoleblank=60 quiet i915.fastboot=1" > /mnt/etc/kernel/cmdline
echo "FONT=$font" > /mnt/etc/vconsole.conf
echo "KEYMAP=fr" >> /mnt/etc/vconsole.conf
genfstab -L /mnt >> /mnt/etc/fstab
echo "${hostname}" > /mnt/etc/hostname
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
echo "fr_FR.UTF-8 UTF-8" >> /mnt/etc/locale.gen
ln -sf /usr/share/zoneinfo/Europe/Paris /mnt/etc/localtime
arch-chroot /mnt locale-gen
cat << EOF > /mnt/etc/mkinitcpio.conf
MODULES=()
BINARIES=(/usr/bin/btrfs)
FILES=()
HOOKS=(base consolefont udev autodetect modconf block encrypt filesystems keyboard shutdown)
COMPRESSION="lz4"
EOF

cat << EOF > /mnt/etc/sudoers
root ALL=(ALL) ALL
%wheel ALL=(ALL) ALL
@includedir /etc/sudoers.d
EOF

echo -e "\n### Setting up Secure Boot with custom keys"
[[ "$fde" == "Yes" ]] && {
    sed -i 's/encrypt/ykfde encrypt/' /mnt/etc/mkinitcpio.conf
    echo YKFDE_CHALLENGE_PASSWORD_NEEDED="1" >> /mnt/etc/ykfde.conf
}
echo KERNEL=linux-hardened > /mnt/etc/arch-secure-boot/config
arch-chroot /mnt mkinitcpio -p linux-hardened
arch-chroot /mnt arch-secure-boot initial-setup || true

echo -e "\n### Creating user"
arch-chroot /mnt useradd -m -s /usr/bin/zsh "$user"
for group in wheel network video plugdev; do
    arch-chroot /mnt groupadd -rf "$group"
    arch-chroot /mnt gpasswd -a "$user" "$group"
done

arch-chroot /mnt chsh -s /usr/bin/zsh
echo "$user:$password" | arch-chroot /mnt chpasswd
arch-chroot /mnt passwd -dl root

echo -e "\n### Settings permissions on the custom repo"
arch-chroot /mnt chown -R "$user:$user" /var/cache/pacman/cyrinux-aur-local/

echo -e "\n### Cloning dotfiles"
arch-chroot /mnt sudo -u $user bash -c 'git clone --recursive https://github.com/cyrinux/dotfiles.git ~/.dotfiles'

echo -e "\n### Running initial setup"
arch-chroot /mnt /home/$user/.dotfiles/setup-system.sh
arch-chroot /mnt sudo -u $user /home/$user/.dotfiles/setup-user.sh
arch-chroot /mnt sudo -u $user zsh -ic true

echo -e "\n### DONE - reboot and re-run both ~/.dotfiles/setup-*.sh scripts"
umount -R /mnt
