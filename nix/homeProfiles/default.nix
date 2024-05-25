{ pkgs, ... }:
{
  imports = [
    # ./ssh
    ./sway
    ./packages.nix
  ];

  xdg.configFile."sway/config".source = pkgs.lib.mkOverride 0 ../../.config/sway/config;

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
  };

  # TODO doesn't work
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    PATH = "$HOME/.local/bin:$HOME/.local/bin-private:$PATH";

    EDITOR = "hx";
    VISUAL = "hx";
    MANPAGER = "kak-man-pager";
    BAT_THEME = "gruvbox-dark";
    DIFFPROG = "meld";
    DOCKER_BUILDKIT = "1";
    # DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
    MOZ_GMP_PATH = "/var/lib/widevine/gmp-widevinecdm/system-installed:/usr/lib64/mozilla/plugins/gmp-gmpopenh264/system-installed";

    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland-egl";
    QT_STYLE_OVERRIDE = "Adwaita-dark";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";

    DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    MBSYNC_CONFIG = "$XDG_CONFIG_HOME/mbsync/config";
    NOTMUCH_CONFIG = "$XDG_CONFIG_HOME/notmuch/config";
    PYLINTRC = "$XDG_CONFIG_HOME/pylint/config";

    CARGO_HOME = "$XDG_STATE_HOME/cargo";
    GOPATH = "$XDG_STATE_HOME/go";

    npm_config_cache = "$XDG_CACHE_HOME/npm";
    PYLINTHOME = "$XDG_CACHE_HOME/pylint";

    LESSHISTFILE = "-";

    PASSWORD_STORE_CHARACTER_SET = "a-zA-Z0-9~!@#$%^&*()-_=+[]{};:,.<>?";
    PASSWORD_STORE_GENERATED_LENGTH = "40";
  };

  services.darkman = {
    enable = true;
    package = pkgs.darkman;
    darkModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write \
        /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      '';
      zathura-theme = ''
        mkdir -p "$HOME/.local/state/zathura"
        ln -sf "$HOME/.config/zathura/dark-mode" "$HOME/.local/state/zathura/current-mode"
      '';
      kitty-theme = ''
        kitty +kitten themes --reload-in=all "Gruvbox-dark"
      '';
      dmenu-theme = ''
        ln -sf "$HOME/.config/dmenu/dark.conf" "$HOME/.config/dmenu/theme.conf"
      '';
      waybar-theme = ''
        ln -sf "$HOME/.config/waybar/dark.css" "$HOME/.config/waybar/style.css"
      '';
      kak-theme = ''
        ln -sf "$HOME/.config/kak/colors/gruvbox-dark.kak" "$HOME/.config/kak/colors/gruvbox.kak"
      '';
    };
    lightModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write \
        /org/gnome/desktop/interface/color-scheme "'prefer-light'"
      '';
      zathura-theme = ''
        mkdir -p "$HOME/.local/state/zathura"
        ln -sf "$HOME/.config/zathura/light-mode" "$HOME/.local/state/zathura/current-mode"
      '';
      kitty-theme = ''
        kitty +kitten themes --reload-in=all "Gruvbox-light"
      '';
      dmenu-theme = ''
        ln -sf "$HOME/.config/dmenu/light.conf" "$HOME/.config/dmenu/theme.conf"
      '';
      waybar-theme = ''
        ln -sf "$HOME/.config/waybar/light.css" "$HOME/.config/waybar/style.css"
      '';
      kak-theme = ''
        ln -sf "$HOME/.config/kak/colors/gruvbox-light.kak" "$HOME/.config/kak/colors/gruvbox.kak"
      '';
    };
    settings = {
      usegeoclue = true;
    };
  };

  home.stateVersion = "24.05";
}
