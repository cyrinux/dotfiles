{ pkgs, config, ... }:
{
  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+YjFIEjwwtNHH3xnun5NjREL5dbB55ornRnG6hY7sA";
    masterIdentities = [ ../age-yubikey-5c.pub ];
    storageMode = "local";
    localStorageDir = ../../.secrets/${config.networking.hostName};
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    extraModprobeConfig = ''
      options hid_apple swap_opt_cmd=1 swap_fn_leftctrl=1 iso_layout=1
    '';
    initrd.systemd.enable = true;
  };

  sound.enable = true;
  time.timeZone = "Europe/Paris";
  console.keyMap = "azerty";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
    ];
  };

  networking = {
    hostName = "home-nixos";
    useDHCP = false;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
    };
    overlays = [ (import ./overlays.nix) ];
  };

  users.users.cyril = {
    password = "cyrinux";
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
    shell = pkgs.zsh;
  };

  environment = {
    systemPackages = with pkgs; [
      git
      helix
      curl
      wget
    ];

    etc.crypttab.text = ''
      backup_sandisk  LABEL=backup_sandisk    none    noauto,fido2-device=auto
      backup_wd       LABEL=backup_wd         none    noauto,fido2-device=auto
    '';

    sessionVariables.NIXOS_OZONE_WL = "1";

    variables.EDITOR = "hx";
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };
  programs.yubikey-touch-detector.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.waybar.enable = false;
  programs.zsh.enable = true;
  programs.adb.enable = true;

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam = {
      services.sudo.u2fAuth = true;
      services.polkit-1.u2fAuth = true;
      u2f.cue = true;
    };
  };

  services = {
    getty.autologinUser = "cyril";
    upower.enable = true;
    timesyncd.enable = true;
    udisks2.enable = true;
    geoclue2.enable = true;
    localtimed.enable = true;
    pcscd.enable = true;
    openssh.enable = true;
    #   fstrim.enable = true;
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 4 * 1024;
  }];


  zramSwap = {
    enable = false;
    memoryPercent = 100;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };


  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;


  system.stateVersion = "24.05";
}
