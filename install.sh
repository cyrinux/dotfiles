#!/bin/bash
#
# WARNING: this script will destroy data on the selected disk.
#
# Arch Linux installation
# https://github.com/cyrinux/dotfiles
# https://github.com/maximbaz/dotfiles
#
# Install minimal Asahi, choose option 2 for minimal:
# - curl https://alx.sh | sh
# - then boot on it and start this script
#
# Run installation:
#
# - Connect to wifi via: `# iwctl station wlan0 connect WIFI-NETWORK`
#
# bash <(curl -sL https://git.io/cyrinux-install)

set -euf -o pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log" >&2)

export SNAP_PAC_SKIP=y

# Dialog
BACKTITLE="Asahi Arch Linux installation"

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
pacman -Sy --noconfirm --needed git terminus-font dialog wget bc dosfstools kakoune iwd

echo -e "\n### HiDPI screens"
noyes=("Yes" "The font is too small" "No" "The font size is just fine")
hidpi=$(get_choice "Font size" "Is your screen HiDPI?" "${noyes[@]}") || exit 1
clear
[[ "$hidpi" == "Yes" ]] && font="ter-132n" || font="ter-716n"
setfont "$font"

hostname=$(get_input "Hostname" "Enter hostname") || exit 1
clear
: "${hostname:?"hostname cannot be empty"}"

lukspw=$(get_password "LUKS" "Enter luks password") || exit 1
clear
: "${lukspw:?"password cannot be empty"}"

user=$(get_input "User" "Enter username") || exit 1
clear
: "${user:?"user cannot be empty"}"

password=$(get_password "User" "Enter password") || exit 1
clear
: "${password:?"password cannot be empty"}"

devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac | tr '\n' ' ')
read -r -a devicelist <<< "$devicelist"
device=$(get_choice "Installation" "Select installation disk" "${devicelist[@]}") || exit 1
clear

echo -e "\n### Setting up partitions"
umount -R /mnt 2> /dev/null || true
cryptsetup luksClose luks 2> /dev/null || true

# sgdisk --clear "${device}" --new 1::-551MiB "${device}" --new 2::0 --typecode 2:ef00 "${device}"
# sgdisk --change-name=1:primary --change-name=2:ESP "${device}"
# findmnt -n -o SOURCE / ...
## findfs ...
part_root="$(ls ${device}* | grep -E "^${device}p?1$")"
part_boot="$(ls ${device}* | grep -E "^${device}p?2$")"
# TODO: do sgdisk --change-name and dosfstools

echo -e "\n### Formatting partitions"
echo -n "${lukspw}" | cryptsetup luksFormat --type luks2 --pbkdf argon2id --label luks0 "${part_root}"
echo -n "${lukspw}" | cryptsetup luksOpen "${part_root}" luks

mkfs.btrfs -L main0 /dev/mapper/luks

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
btrfs subvolume create /mnt/swap
btrfs subvolume create /mnt/snapshots
umount /mnt

mount -o noatime,nodiratime,compress=zstd,subvol=root /dev/mapper/luks /mnt
mkdir -vp /mnt/{mnt/btrfs-root,efi,home,var/{cache/pacman,log,tmp,lib/{aurbuild,archbuild}},swap,.snapshots}
mount "${part_boot}" /mnt/boot/efi
mount -o noatime,nodiratime,compress=zstd,subvol=/ /dev/mapper/luks /mnt/mnt/btrfs-root
mount -o noatime,nodiratime,compress=zstd,subvol=home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress=zstd,subvol=pkgs /dev/mapper/luks /mnt/var/cache/pacman
mount -o noatime,nodiratime,compress=zstd,subvol=aurbuild /dev/mapper/luks /mnt/var/lib/aurbuild
mount -o noatime,nodiratime,compress=zstd,subvol=archbuild /dev/mapper/luks /mnt/var/lib/archbuild
mount -o noatime,nodiratime,compress=zstd,subvol=logs /dev/mapper/luks /mnt/var/log
mount -o noatime,nodiratime,compress=zstd,subvol=temp /dev/mapper/luks /mnt/var/tmp
mount -o noatime,nodiratime,compress=zstd,subvol=swap /dev/mapper/luks /mnt/swap
mount -o noatime,nodiratime,compress=zstd,subvol=snapshots /dev/mapper/luks /mnt/.snapshots

echo -e "\n### Importing my public PGP key"
export MY_GPG_KEY_ID="0x6DB88737C11F5A48"
curl -s https://levis.name/pgp_keys.asc | pacman-key -a -
pacman-key --lsign-key "$MY_GPG_KEY_ID"

echo -e "\n### Configuring custom repo"
mkdir /mnt/var/cache/pacman/cyrinux-aur-local
march="$(uname -m)"
wget -m -q -nH -np --show-progress --progress=bar:force --reject="${march}*" --cut-dirs=3 --include-directories="${march}" -P "/mnt/var/cache/pacman/cyrinux-aur-local" "https://aur.levis.ws/${march}"
rename -- 'cyrinux-aur.' 'cyrinux-aur-local.' /mnt/var/cache/pacman/cyrinux-aur-local/*
# TODO: do I still need this? repo-add /mnt/var/cache/pacman/cyrinux-aur-local/cyrinux-aur-local.db.tar

if ! grep cyrinux /etc/pacman.conf > /dev/null; then
	cat >> /etc/pacman.conf << EOF
[cyrinux-aur-local]
Server = file:///mnt/var/cache/pacman/cyrinux-aur-local

[cyrinux-aur]
Server = https://aur.levis.ws/${march}

[options]
CacheDir = /mnt/var/cache/pacman/pkg
CacheDir = /mnt/var/cache/pacman/cyrinux-aur-local
EOF
fi

echo -e "\n### Installing packages"
pacstrap /mnt posix base man-pages cyrinux-base cyrinux-"$(uname -m)"

echo -e "\n### Generating base config files"
ln -sfT dash /mnt/usr/bin/sh

echo "FONT=$font" > /mnt/etc/vconsole.conf
echo "KEYMAP=fr" >> /mnt/etc/vconsole.conf
genfstab -L /mnt > /mnt/etc/fstab
echo "${hostname}" > /mnt/etc/hostname
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
echo "fr_FR.UTF-8 UTF-8" >> /mnt/etc/locale.gen
ln -sf /usr/share/zoneinfo/Europe/Paris /mnt/etc/localtime
arch-chroot /mnt locale-gen

cat << EOF > /mnt/etc/mkinitcpio.conf
MODULES=()
BINARIES=(/usr/bin/btrfs)
FILES=()
HOOKS=(base asahi systemd autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems resume fsck)
EOF

cat << EOF > /mnt/etc/sudoers
root ALL=(ALL) ALL
%wheel ALL=(ALL) ALL
@includedir /etc/sudoers.d
EOF

echo -e "\n### Setting up Secure Boot with custom keys"
arch-chroot /mnt mkinitcpio -P
cat << EOF > /mnt/etc/default/update-m1n1
echo "chosen.bootargs=rd.luks.name=$(findfs LABEL=luks0 | xargs blkid -o value -s UUID)=luks root=/dev/mapper/luks rd.luks.options=allow-discards rootflags=subvol=root rootwait rw quiet loglevel=3 apparmor=1 lsm=landlock,lockdown,yama,apparmor,bpf rd.emergency=halt systemd.unified_cgroup_hierarchy=1"
cat /lib/asahi-boot/m1n1.bin \
<(echo "chosen.bootargs=rd.luks.name=$(findfs LABEL=luks0 | xargs blkid -o value -s UUID)=luks root=/dev/mapper/luks rd.luks.options=allow-discards rootflags=subvol=root rootwait rw quiet loglevel=3 apparmor=1 lsm=landlock,lockdown,yama,apparmor,bpf rd.emergency=halt systemd.unified_cgroup_hierarchy=1") \
/lib/modules/*-edge-ARCH/dtbs/*.dtb \
/boot/initramfs-linux-asahi-edge.img \
<(gzip -c /boot/vmlinuz-linux-asahi-edge) \
> /boot/efi/m1n1/boot.bin

M1N1_UPDATE_DISABLED=1
EOF
arch-chroot /mnt update-m1n1

echo -e "\n### Configuring swap file"
btrfs filesystem mkswapfile --size 4G /mnt/swap/swapfile
echo "/swap/swapfile none swap defaults 0 0" >> /mnt/etc/fstab

echo -e "\n### Creating user"
arch-chroot /mnt useradd -m -s /usr/bin/zsh "$user"
for group in wheel network video render plugdev i2c libvirt kvm audit input wireshark rfkill; do
	arch-chroot /mnt groupadd -rf "$group"
	arch-chroot /mnt gpasswd -a "$user" "$group"
done

arch-chroot /mnt chsh -s /usr/bin/zsh
echo "$user:$password" | arch-chroot /mnt chpasswd
arch-chroot /mnt passwd -dl root

echo -e "\n### Settings permissions on the custom repo"
arch-chroot /mnt chown -R "$user:$user" /var/cache/pacman/cyrinux-aur-local

echo -e "\n### Cloning dotfiles"
if [ "${user}" = "cyril" ]; then
	arch-chroot /mnt sudo -u "$user" bash -c 'git clone --recursive https://github.com/cyrinux/dotfiles.git --branch=macbook ~/.dotfiles '
	echo -e "\n### Running initial setup"
	arch-chroot /mnt "/home/$user/.dotfiles/setup-system.sh"
	arch-chroot /mnt sudo -u "$user" "/home/$user/.dotfiles/setup-user.sh"
	arch-chroot /mnt sudo -u "$user" zsh -ic true

	echo -e "\n### DONE - reboot and re-run both ~/.dotfiles/setup-*.sh scripts"
else
	echo -e "\n### DONE - read POST_INSTALL.md for tips on configuring your setup"
fi

umount -R /mnt
cryptsetup luksClose luks

echo -e "\n### DONE - reboot and re-run both ~/.dotfiles/setup-*.sh scripts"
echo -e "\n### Reboot now, and after power off remember to unplug the installation USB"
