{
  imports = [ ./nixosConfigurations ./hardwareProfiles ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.cyril = import ./homeProfiles;
  };
}
