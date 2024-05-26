{ pkgs, ... }: {

  xdg.configFile."sway/config".source = pkgs.lib.mkOverride 0 ../../.config/sway/config;
  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    package = pkgs.sway;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
  };
} 
