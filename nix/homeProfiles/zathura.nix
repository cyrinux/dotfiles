{
  programs.zathura = {
    enable = true;
    options = {
      recolor-lightcolor = "#bea58b";
      recolor-darkcolor = "#000000";
    };
    extraConfig = ''
      include "current-mode"
    '';
  };
  home.file.".config/zathura/dark-mode".text = ''
    set recolor true set default-bg \#000000
  '';
  home.file.".config/zathura/light-mode".text = ''
    set recolor false set default-bg \#bea58b
  '';

  services.darkman = {
    darkModeScripts = {
      zathura-theme = ''
        ln -sf "$HOME/.config/zathura/dark-mode" "$HOME/.config/zathura/current-mode"
      '';
    };
    lightModeScripts = {
      zathura-theme = ''
        ln -sf "$HOME/.config/zathura/light-mode" "$HOME/.config/zathura/current-mode"
      '';
    };
  };
}

