[![Dotfiles CI](https://github.com/cyrinux/dotfiles/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/cyrinux/dotfiles/actions/workflows/ci.yml)

# ~/.dotfiles

## Installation:

From last archlinux live iso:

```
$ loadkeys fr
$ iwctl
$ bash <(curl -sL git.io/cyrinux-install)
```

```
$ git clone https://github.com/cyrinux/dotfiles.git ~/.dotfiles
$ ~/.dotfiles/setup
```

## System recovery

In case system doesn't boot:

1. Boot in a recent snapshot that works
1. Make it the default snapshot

   ```
   # iwctl station wlan0 scan
   # iwctl station wlan0 connect SSID
   # pacman -Sy && pacman -S yubikey-full-disk-encryption
   # ykfde-open -d /dev/nvme0n1p2 -n luks
   # mkdir /mnt/btrfs-root/
   # mount -o subol=root /mnt/btrfs-root/
   # cd /mnt/btrfs-root/
   # mv root root-bak
   # btrfs subvolume snapshot snapshots/NN/snapshot root
   ```

1. Reboot
