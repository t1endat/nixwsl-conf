{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nushell-defaultConfig = {
      url = "github:nushell/nushell";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, nushell-defaultConfig, ... }@ inputs: let
	inherit (self) outputs;
  in{
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
	  ./nixos/configuration.nix
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.05";
            wsl.enable = true;
  	    wsl.defaultUser = "nixos";
          }
        ];
      };
    };

    homeConfigurations = {
      # FIXME replace with your username@hostname
      "nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs nushell-defaultConfig;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/home.nix];
      };
    };
  };
}
