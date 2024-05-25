{ config, ... }: {
  age.secrets.wg-cloud-private-key = {
    rekeyFile = ./wg-cloud-private-key.age;
    owner = "systemd-network";
  };
  age.secrets.wg-cloud-preshared-key = {
    rekeyFile = ./wg-cloud-preshared-key.age;
    owner = "systemd-network";
  };

  systemd = {
    network = {
      networks = {
        "90-wg-cloud" = {
          matchConfig.Name = "wg-cloud";
          networkConfig.Address = "0.0.0.0/0";
        };
      };

      netdevs = {
        "90-wg-cloud" = {
          netdevConfig = {
            Name = "wg-cloud";
            Kind = "wireguard";
            MTUBytes = "1280";
          };
          wireguardConfig = {
            PrivateKeyFile = config.age.secrets.wg-cloud-private-key.path;
          };
          wireguardPeers = [{
            wireguardPeerConfig = {
              Endpoint = "0.0.0.0:0";
              PublicKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
              PresharedKeyFile = config.age.secrets.wg-cloud-preshared-key.path;
              AllowedIPs = [ "0.0.0.0/0" ];
            };
          }];
        };
      };
    };
  };
}
