%global pkgver 1.5.0

Name:       cyrinux
Version:    %pkgver
Release:    %autorelease
Summary:    Packages installed by cyrinux
License:    ISC
BuildArch:  noarch

Recommends: gawk
Recommends: moreutils

%description
%{summary}.

%posttrans
dnf -y copr enable atim/kakoune
dnf -y copr enable cyrinux/misc
dnf -y copr enable cyrinux/personal
dnf -y copr enable dawid/better_fonts
dnf -y copr enable erikreider/SwayNotificationCenter
dnf -y copr enable lead2gold/nzbget
dnf -y copr enable maximbaz/browserpass
dnf -y copr enable noisycoil/asahi-alpha
dnf -y copr enable nucleo/gocryptfs
dnf -y copr enable useidel/signal-desktop
dnf -y install dnf-plugins-core
dnf -y config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf -y install --nogpgcheck https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf -y install rpmfusion-free-appstream-data rpmfusion-nonfree-appstream-data
dnf -y install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted

for f in /etc/yum.repos.d/_copr*; do
    awk '!/^priority=/ {print} /^priority=/ {print "priority=100"; found=1} END {if (!found) print "priority=100"}' "$f" | sponge "$f"
done

%package    base
Version:    %pkgver
Release:    %autorelease
Summary:    Packages installed by cyrinux
License:    ISC
BuildArch:  noarch


Recommends: ImageMagick
Recommends: NetworkManager-openvpn
Recommends: NetworkManager-openvpn-gnome
Recommends: NetworkManager-wifi
Recommends: ShellCheck
Recommends: SwayNotificationCenter
Recommends: abattis-cantarell-fonts
Recommends: acpi
Recommends: adw-gtk3-theme
Recommends: adwaita-gtk2-theme
Recommends: adwaita-qt5
Recommends: adwaita-qt6
Recommends: android-tools
Recommends: apanov-heuristica-fonts
Recommends: asahi-btsync
Recommends: asahi-wifisync
Recommends: asdf-vm
Recommends: aspell-da
Recommends: aspell-en
Recommends: aspell-fr
Recommends: aspell-ru
Recommends: autovdirsyncer
Recommends: bat
Recommends: bfs
Recommends: sd
Recommends: rgr
Recommends: localtime-git
Recommends: nautilus
Recommends: kdeconnectd
Recommends: firewall-config
Recommends: openssl
Recommends: binwalk
Recommends: box64-asahi
Recommends: brightnessctl
Recommends: browserpass
Recommends: browserpass-chromium
Recommends: browserpass-firefox
Recommends: burnout-detector
Recommends: calibre
Recommends: cargo
Recommends: chromium
Recommends: clang
Recommends: code
Recommends: community-mysql
Recommends: copr-cli
Recommends: courier-prime-fonts
Recommends: curlie
Recommends: cyrinux
Recommends: cyrinux-meta
Recommends: darkman
Recommends: dash
Recommends: dbmate
Recommends: dejavu-fonts-all
Recommends: dfrs
Recommends: direnv
Recommends: dnf
Recommends: docker-ce
Recommends: docker-compose-plugin
Recommends: doggo
Recommends: dos2unix
Recommends: dracut-kbd-backlight
Recommends: dua-cli
Recommends: earlyoom
Recommends: editorconfig
Recommends: efi-filesystem
Recommends: efivar-libs
Recommends: eza
Recommends: fd-find
Recommends: fedora-asahi-remix-scripts
Recommends: ff2mpv
Recommends: ffmpeg-freeworld
Recommends: filesystem
Recommends: firefox
Recommends: flatpak
Recommends: fontawesome-fonts-all
Recommends: fping
Recommends: freerdp
Recommends: fzf
Recommends: gcr3
Recommends: gdisk
Recommends: geoclue2-demos
Recommends: gh
Recommends: ghq
Recommends: gimp
Recommends: git
Recommends: localtime
Recommends: git-delta
Recommends: gitui
Recommends: glibc-all-langpacks
Recommends: gnome-keyring
Recommends: go2rpm
Recommends: gocryptfs
Recommends: goimapnotify
Recommends: golang
Recommends: golang-honnef-tools
Recommends: golang-x-tools-gopls
Recommends: google-droid-fonts-all
Recommends: google-noto-sans-fonts
Recommends: google-noto-serif-cjk-fonts
Recommends: google-noto-serif-fonts
Recommends: graphviz
Recommends: hddtemp
Recommends: helix
Recommends: helvum
Recommends: highcontrast-icon-theme
Recommends: htop
Recommends: sway
# Recommends: hyprland-autoname-workspaces
Recommends: initial-setup
Recommends: inkscape
Recommends: inotify-tools
Recommends: iptables-nft
Recommends: isync
Recommends: iwd
Recommends: jq
Recommends: kak-lsp
Recommends: kakoune
Recommends: kernel-16k
Recommends: kernel-16k-modules-extra
Recommends: khal
Recommends: kitty
Recommends: knot-resolver
Recommends: krita
Recommends: lapce
Recommends: lato-fonts
Recommends: lbzip2
Recommends: lftp
Recommends: liberation-fonts
Recommends: libgnome-keyring
Recommends: libreoffice
Recommends: meld
Recommends: meson
Recommends: microsocks
Recommends: mock
Recommends: moreutils
Recommends: mpv
Recommends: mpv-mpris
Recommends: msmtp
Recommends: neomutt
Recommends: network-manager-applet
Recommends: networkmanager-dmenu-git
Recommends: nextcloud-client
Recommends: nftables
Recommends: nmap
Recommends: nmap-ncat
Recommends: nmtrust
Recommends: nodejs
Recommends: nodejs-bash-language-server
Recommends: notmuch
Recommends: obs-studio
Recommends: open-sans-fonts
Recommends: openssl-devel
Recommends: p7zip
Recommends: pam-u2f
Recommends: pamu2fcfg
Recommends: paperwork
Recommends: pass
Recommends: passmenu
Recommends: pavucontrol
Recommends: perl
Recommends: pgFormatter
Recommends: pgcli
Recommends: pigz
Recommends: pinentry-gnome3
Recommends: pipewire-utils
Recommends: playerctl
Recommends: polkit-gnome
Recommends: postgresql
Recommends: prettier
Recommends: privoxy
Recommends: progress
Recommends: proxychains-ng
Recommends: pulseaudio-utils
Recommends: push2talk
Recommends: pwgen
Recommends: pylint
Recommends: pyp2rpm
Recommends: python-unversioned-command
Recommends: python3-dnf-plugin-snapper
Recommends: python3-lsp-server
Recommends: python3-lsp-server+all
Recommends: python3-pip
Recommends: qalculate-gtk
Recommends: qemu
Recommends: qrencode
Recommends: repgrep
Recommends: restic
Recommends: ripgrep
Recommends: rpm-git-tag-sort
Recommends: rpmconf
Recommends: rpmdevtools
Recommends: rpmlint
Recommends: rsync
Recommends: rust-analyzer
Recommends: rust2rpm
Recommends: rustfmt
Recommends: setroubleshoot
Recommends: shfmt
Recommends: signal-desktop
Recommends: sipcalc
Recommends: snapper
Recommends: socat
Recommends: songrec
Recommends: speedtest-cli
Recommends: sqlite
Recommends: strace
Recommends: supertuxkart
Recommends: swappy
Recommends: swaybg
Recommends: swayidle
Recommends: swaylock
Recommends: syncthing
Recommends: systembus-notify
Recommends: systemd-autoreload
Recommends: systemd-lock-handler
Recommends: systemd-oomd-defaults
Recommends: tarsnap
Recommends: teehee
Recommends: terminus-fonts-console
Recommends: tig
Recommends: tiny-dfr
Recommends: tito
Recommends: tlp
Recommends: tmux
Recommends: topgrade
Recommends: tor
Recommends: torsocks
Recommends: trash-cli
Recommends: trippy
Recommends: typetogether-literata-fonts
Recommends: udiskie
Recommends: udiskie-dmenu
Recommends: unrar
Recommends: unzip
Recommends: uosc
Recommends: update-m1n1
Recommends: usbguard
Recommends: usbguard-dbus
Recommends: vault-kv-mv
Recommends: vault-kv-search
Recommends: vdirsyncer
Recommends: vimiv-qt
Recommends: w3m
Recommends: waybar
Recommends: wev
Recommends: widevine-installer
Recommends: wireguard-tools
Recommends: wkhtmltopdf
Recommends: wl-clipboard
Recommends: wldash
Recommends: wldash-git
Recommends: wlsunset
Recommends: wormhole-rs
Recommends: yarnpkg
Recommends: yq
Recommends: yt-dlp
Recommends: yubikey-manager
Recommends: yubikey-touch-detector
Recommends: zathura-pdf-mupdf
Recommends: zip
Recommends: zsh



%description base
%{summary}.

%package    asahi
Version:    %pkgver
Release:    %autorelease
Summary:    Required Asahi packages
License:    ISC
BuildArch:  noarch

Recommends: asahi-platform-metapackage
Recommends: asahi-repos
Recommends: fedora-asahi-remix-scripts
Recommends: grub2-efi-aa64
Recommends: grub2-efi-aa64-modules
Recommends: shim-aa64

%description asahi
%{summary}.

%prep

%build

%files

%install

%files base

%files asahi

%changelog
%autochangelog
