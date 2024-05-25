{
  description = "cyrinux";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";
    apple-silicon-support.url = "github:flokli/nixos-apple-silicon/89a8f646019c6990bca14b55104afa1817dca7d5";
    apple-silicon-support.inputs.nixpkgs.follows = "nixpkgs";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, apple-silicon-support, agenix, agenix-rekey, ... }: {
    nixosConfigurations = {
      home-nixos =
        let system = "aarch64-linux";
        in nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            apple-silicon-support.nixosModules.apple-silicon-support
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            agenix-rekey.nixosModules.default
            ./nix/default.nix
          ];
        };
    };

    agenix-rekey = agenix-rekey.configure {
      userFlake = self;
      nodes = self.nixosConfigurations;
    };
  };

}
