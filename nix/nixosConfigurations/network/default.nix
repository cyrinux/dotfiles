{
  networking = {
    hostName = "home-nixos";
    useDHCP = false;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
  };
  programs.nm-applet.enable = true;
  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    dnsovertls = "true";
  };
}
