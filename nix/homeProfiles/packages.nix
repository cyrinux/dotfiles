{ pkgs, ... }:
{
  programs.browserpass.enable = true;

  services.udiskie.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # agenix-rekey
    age-plugin-yubikey
    font-awesome
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    input-fonts
    libnotify
    polkit_gnome
    libreoffice
    zathura

    asahi-bless
    (kakoune.override
      {
        plugins = with kakounePlugins; [ kakoune-lsp ];
      })
    helix
    vscode

    ffmpeg
    android-tools
    android-udev-rules

    wl-clipboard
    kitty

    meld
    pam_u2f
    gnupg
    gcr
    pinentry-gnome3
    firefox-wayland
    #chromium
    qutebrowser

    mysql-client
    dbmate
    pgcli

    notmuch
    neomutt
    khal
    isync
    msmtp
    kdeconnect

    tree
    progress
    inotify-tools
    rsync
    signal-desktop
    ripgrep
    fd
    bat
    bfs
    brightnessctl
    jq
    file
    paperwork
    dfrs
    direnv
    dos2unix
    doggo
    dua
    earlyoom
    editorconfig-core-c
    eza
    ff2mpv
    mpv
    mpvScripts.mpris
    playerctl
    freerdp
    fzf
    git
    ghq
    delta
    gocryptfs
    goimapnotify
    htop
    killall
    p7zip
    pigz
    pass
    pavucontrol
    pwgen
    qalculate-gtk
    qrencode
    sipcalc
    socat
    swappy
    waybar
    swaybg
    swayr
    kanshi
    swaylock
    swaynotificationcenter
    syncthing
    systembus-notify
    git
    tig
    trash-cli
    udiskie
    unrar
    unzip
    usbguard
    vimiv-qt
    w3m
    wireguard-tools
    yt-dlp
    yubikey-touch-detector
    zip
    zsh
    grim
    slurp

    nftables
    iptables-nftables-compat

    arc-theme

    biome
    cargo
    clang-tools
    docker-compose-language-service
    dockerfile-language-server-nodejs
    gcc
    go
    golangci-lint
    golangci-lint-langserver
    gopls
    gotools
    helix-gpt
    marksman
    nil
    nixpkgs-fmt
    nodejs
    nodePackages.bash-language-server
    nodePackages.pnpm
    nodePackages.prettier
    nodePackages.typescript-language-server
    pgformatter
    pkg-config
    (python3.withPackages (p: with p; [
      python-lsp-server
      python-lsp-black
      black
    ]))
    rust-analyzer
    taplo
    taplo-lsp
    terraform-ls
    vscode-langservers-extracted
    yaml-language-server

    glib

    networkmanager_dmenu
    networkmanagerapplet
    networkmanager-openvpn

    exegol

    distrobox

    wayland-pipewire-idle-inhibit

    kubectl
    krew
    stern


    (pkgs.writeShellScriptBin "cglaunch" (builtins.readFile ../../.local/bin/cglaunch))
    (pkgs.writeShellScriptBin "audio" (builtins.readFile ../../.local/bin/audio))
    (pkgs.writeShellScriptBin "backup" (builtins.readFile ../../.local/bin/backup))
    (pkgs.writeShellScriptBin "backup-packages" (builtins.readFile ../../.local/bin/backup-packages))
    (pkgs.writeShellScriptBin "battery-low-notify" (builtins.readFile ../../.local/bin/battery-low-notify))
    (pkgs.writeShellScriptBin "browser" (builtins.readFile ../../.local/bin/browser))
    (pkgs.writeShellScriptBin "bulkrename" (builtins.readFile ../../.local/bin/bulkrename))
    (pkgs.writeShellScriptBin "cggrep" (builtins.readFile ../../.local/bin/cggrep))
    (pkgs.writeShellScriptBin "cgkill" (builtins.readFile ../../.local/bin/cgkill))
    (pkgs.writeShellScriptBin "cglaunch" (builtins.readFile ../../.local/bin/cglaunch))
    (pkgs.writeShellScriptBin "cgtoggle" (builtins.readFile ../../.local/bin/cgtoggle))
    #(pkgs.writeShellScriptBin "checkmail" (builtins.readFile ../../.local/bin/checkmail))
    (pkgs.writeShellScriptBin "chromium-browser" (builtins.readFile ../../.local/bin/chromium-browser))
    (pkgs.writeShellScriptBin "dmenu" (builtins.readFile ../../.local/bin/dmenu))
    (pkgs.writeShellScriptBin "dmenu-wl" (builtins.readFile ../../.local/bin/dmenu))
    (pkgs.writeShellScriptBin "emoji-bootstrap" (builtins.readFile ../../.local/bin/emoji-bootstrap))
    (pkgs.writeShellScriptBin "emoji-dmenu" (builtins.readFile ../../.local/bin/emoji-dmenu))
    (pkgs.writeShellScriptBin "exit-wm" (builtins.readFile ../../.local/bin/exit-wm))
    (pkgs.writeShellScriptBin "git-submodule-remove" (builtins.readFile ../../.local/bin/git-submodule-remove))
    (pkgs.writeShellScriptBin "gitui" (builtins.readFile ../../.local/bin/gitui))
    (pkgs.writeShellScriptBin "gnome-terminal" (builtins.readFile ../../.local/bin/gnome-terminal))
    (pkgs.writeShellScriptBin "kak-man-pager" (builtins.readFile ../../.local/bin/kak-man-pager))
    (pkgs.writeShellScriptBin "mockbuild" (builtins.readFile ../../.local/bin/mockbuild))
    (pkgs.writeShellScriptBin "neomutt-sendmail" (builtins.readFile ../../.local/bin/neomutt-sendmail))
    (pkgs.writeShellScriptBin "pass-gen" (builtins.readFile ../../.local/bin/pass-gen))
    (pkgs.writeShellScriptBin "record-area" (builtins.readFile ../../.local/bin/record-area))
    (pkgs.writeShellScriptBin "screenshot-area" (builtins.readFile ../../.local/bin/screenshot-area))
    (pkgs.writeScriptBin "sway-autoname-workspaces" (builtins.readFile ../../.local/bin/sway-autoname-workspaces))
    (pkgs.writeScriptBin "sway-inactive-window-transparency" (builtins.readFile ../../.local/bin/sway-inactive-window-transparency))
    (pkgs.writeShellScriptBin "sway-unfullscreen" (builtins.readFile ../../.local/bin/sway-unfullscreen))
    (pkgs.writeScriptBin "udiskie-dmenu" (builtins.readFile ../../.local/bin/udiskie-dmenu))
    (pkgs.writeShellScriptBin "waybar-decrypted" (builtins.readFile ../../.local/bin/waybar-decrypted))
    (pkgs.writeShellScriptBin "waybar-dnd" (builtins.readFile ../../.local/bin/waybar-dnd))
    (pkgs.writeShellScriptBin "waybar-eyes" (builtins.readFile ../../.local/bin/waybar-eyes))
    (pkgs.writeShellScriptBin "waybar-mail" (builtins.readFile ../../.local/bin/waybar-mail))
    (pkgs.writeShellScriptBin "waybar-progress" (builtins.readFile ../../.local/bin/waybar-progress))
    (pkgs.writeShellScriptBin "waybar-recording" (builtins.readFile ../../.local/bin/waybar-recording))
    (pkgs.writeShellScriptBin "waybar-systemd" (builtins.readFile ../../.local/bin/waybar-systemd))
    (pkgs.writeShellScriptBin "waybar-updates" (builtins.readFile ../../.local/bin/waybar-updates))
    (pkgs.writeShellScriptBin "waybar-usbguard" (builtins.readFile ../../.local/bin/waybar-usbguard))
    (pkgs.writeShellScriptBin "waybar-vpn-pia" (builtins.readFile ../../.local/bin/waybar-vpn-pia))
    (pkgs.writeShellScriptBin "waybar-vpn-work" (builtins.readFile ../../.local/bin/waybar-vpn-work))
    (pkgs.writeShellScriptBin "waybar-yubikey" (builtins.readFile ../../.local/bin/waybar-yubikey))
    (pkgs.writeScriptBin "when" (builtins.readFile ../../.local/bin/when))
    (pkgs.writeShellScriptBin "wl-clipboard-manager" (builtins.readFile ../../.local/bin/wl-clipboard-manager))
    (pkgs.writeShellScriptBin "xdg-open" (builtins.readFile ../../.local/bin/xdg-open))
  ];
}
