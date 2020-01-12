#!/usr/bin/zsh

set -e

exec 2> >(while read line; do echo -e "\e[01;31m$line\e[0m"; done)

MY_GPG_KEY_ID="0x2653E033C3C07A2C"

script_name="$(basename "$0")"
dotfiles_dir="$(cd "$(dirname "$0")"; pwd)"
cd "$dotfiles_dir"

assign() {
  op="$1"
  if [[ "$op" != "link" && "$op" != "copy" ]]; then
    echo "Unknown operation: $op"
    exit 1
  fi

  orig_file="$2"
  dest_file="$3"

  mkdir -p "$(dirname "$orig_file")"
  mkdir -p "$(dirname "$dest_file")"

  rm -rf "$dest_file"

  if [[ "$op" == "link" ]]; then
    ln -s "$orig_file" "$dest_file"
    echo "$dest_file -> $orig_file"
  else
    cp -R "$orig_file" "$dest_file"
    echo "$dest_file <= $orig_file"
  fi
}

link() {
  assign "link" "$dotfiles_dir/$1" "$HOME/$1"
}

copy() {
  assign "copy" "$dotfiles_dir/$1" "/$1"
  [ -z "$2" ] || chmod "$2" "/$1"
}

is_chroot() {
  grep rootfs /proc/mounts >/dev/null
}

systemctl_enable_start() {
    echo "systemctl --user enable --now "$name""
    systemctl --user enable "$name"
    systemctl --user start  "$name"
}


if [ "$(whoami)" != "root" ]; then
  echo "======================================="
  echo "Setting up dotfiles for current user..."
  echo "======================================="

  link "bin"
  link ".config/user-dirs.dirs"
  link ".gnupg/gpg.conf"
  link ".gnupg/sks-keyservers.netCA.pem"
  link ".config/pulse/daemon.conf"
  link ".config/htop"
  link ".pandoc"
  link ".config/kak"
  link ".config/teiler"
  link ".config/nvim"
  link ".config/pacman"
  link ".config/rofi"
  link ".config/qalculate/qalc.cfg"
  link ".config/vifm/vifmrc"
  link ".config/imapnotify"
  link ".config/systemd/user/backup-packages.service"
  link ".config/systemd/user/backup-packages.timer"
  link ".config/tig"
  link ".config/vimiv"
  link ".gitconfig"
  link ".mdlrc"
  link ".magic"
  link ".pylintrc"
  link ".tmux.conf"
  link ".zsh"
  link ".zshrc"
  link ".vmdrc"
  link ".gemrc"
  link ".visidatarc"
  link ".gnupg/gpg-agent.conf"
  link ".gnupg/pinentry-dmenu.conf"
  link ".config/chromium-flags.conf"
  link ".config/captive-browser.toml"
  link ".config/picom"
  link ".config/dunst"
  link ".config/gsimplecal"
  link ".config/gtk-3.0/settings.ini"
  link ".config/i3"
  link ".config/py3status"
  link ".config/kitty"
  link ".config/mimeapps.list"
  link ".config/msmtp"
  link ".config/mpv/config"
  link ".zprofile"
  link ".gitignore"
  link ".ignore"
  link ".xinitrc"
  link ".config/youtube-dl/config"
  link ".config/neomutt"
  link ".config/redshift"
  link ".config/repoctl"
  link ".config/transmission/settings.json"
  link ".config/USBGuard"
  link ".config/nnn/plugins"
  link ".config/khard"
  link ".config/khal"
  link ".mbsyncrc"
  link ".config/vdirsyncer"
  link ".config/firejail"
  link ".cheat"
  link ".wgetrc"
  link ".gitmessage"
  link ".config/PulseEffects"
  link ".config/systemd/user/tarsnap.timer"
  link ".config/systemd/user/tarsnap.service"
  link ".config/systemd/user/library-repos.service"
  link ".config/systemd/user/library-repos.timer"
  link ".config/systemd/user/restic.timer"
  link ".config/systemd/user/restic.service"
  link ".config/systemd/user/restic-check.service"
  link ".config/systemd/user/restic-check.timer"
  link ".config/systemd/user/checkmail.service"
  link ".config/systemd/user/checkmail.timer"
  link ".config/systemd/user/urlwatch.service"
  link ".config/systemd/user/urlwatch.timer"
  link ".config/udiskie"
  link ".config/qutebrowser"
  link ".config/firewarden"
  link ".local/share/rofi-json-dicts"
  link ".local/share/fonts/taskbar.ttf"
  link ".local/share/applications/neomutt.desktop"
  link ".local/share/applications/browser.desktop"
  link ".hidden"
  link ".gtkrc-2.0"
  link ".taskrc"
  link ".xsession"
  link ".Xresources"
  link ".curlrc"
  link ".config/autorandr"
  link ".config/twitchy3/twitchy.cfg"

  echo ""
  echo "================================="
  echo "Enabling and starting services..."
  echo "================================="

  if is_chroot; then
    >&2 echo "=== Running in chroot, skipping user services..."
  else
      systemctl --user daemon-reload
      systemctl_enable_start "backup-packages.timer"
      systemctl_enable_start "dunst.service"
      systemctl_enable_start "redshift.service"
      systemctl_enable_start "urlwatch.timer"
      systemctl_enable_start "yubikey-touch-detector.service"

        if [ -d "$HOME/.mail" ]; then
            systemctl_enable_start "mbsync.timer"
            systemctl_enable_start "goimapnotify@personal.service"
        else
            >&2 echo -e "
            === Mail is not configured, skipping...
            === Consult ~/.mbsyncrc for initial setup, and then sync everything using:
            === while ! mbsync -a; do echo 'restarting...'; done
            "
        fi
   fi

  echo ""
  echo "======================================="
  echo "Finishing various user configuration..."
  echo "======================================="

  echo "Configuring MIME types"
  file --compile --magic-file ~/.magic

  if ! gpg -k | grep "$MY_GPG_KEY_ID" > /dev/null; then
    echo "Importing my public PGP key"
    curl -s https://levis.name/pgp_keys.asc| gpg --import
    gpg --trusted-key "$MY_GPG_KEY_ID" > /dev/null
  fi

  find ~/.gnupg -type f -exec chmod 600 {} \;
  find ~/.gnupg -type d -exec chmod 700 {} \;


  if is_chroot; then
    >&2 echo "=== Running in chroot, skipping YubiKey configuration..."
  else
      if [[ ! -a "$HOME/.config/Yubico/u2f_keys" ]]; then
        echo "Configuring YubiKey for sudo access (touch it now)"
        mkdir -p "$HOME/.config/Yubico"
        pamu2fcfg -ucyril > "$HOME/.config/Yubico/u2f_keys"
      fi
  fi

  if [[ -a "$HOME/.password-store" ]]; then
    echo "Configuring automatic git push for pass"
    echo "#!/usr/bin/zsh\n\npass git push" >! "$HOME/.password-store/.git/hooks/post-commit"
    chmod +x "$HOME/.password-store/.git/hooks/post-commit"
  fi

  echo "Configuring GTK file chooser dialog"
  gsettings set org.gtk.Settings.FileChooser sort-directories-first true

  echo "Ignoring further changes to often changing config"
  git update-index --assume-unchanged ".config/transmission/settings.json"

  if is_chroot; then
    >&2 echo "=== Running in chroot, skipping private dotiles configuration..."
  else
        if [ ! -d "$HOME/.dotfiles-private" ]; then
            git clone ssh://git@git.levis.ws:10022/cyril/dotfiles-private.git ~/.dotfiles-private
            ~/.dotfiles-private/setup
        fi
  fi
fi