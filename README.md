# ~/.dotfiles

## Installation:

From last archlinux live iso:

```
$ loadkeys fr
$ wifi-menu
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
   # cd /mnt/btrfs-root/
   # mv root root-bak
   # btrfs subvolume snapshot snapshots/NN/snapshot root
   ```

1. Reboot
