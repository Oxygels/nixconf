{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      lazyvim,
      ...
    }@inputs:
    let
      mkHost =
        {
          hostname,
          system ? "x86_64-linux",
          username,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname username; };
          modules = [
            ./modules/nixos
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.extraSpecialArgs = inputs // {
                inherit username hostname;
              };
              home-manager.users.${username}.imports = [
                ./modules/home
                ./hosts/${hostname}/home.nix
              ];
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        tower = mkHost {
          hostname = "tower";
          username = "oxy";
        };
        laptop = mkHost {
          hostname = "laptop";
          username = "oxy";
        };
      };

      packages.x86_64-linux = {
        tower-vm = self.nixosConfigurations.tower.config.system.build.vm;
        laptop-vm = self.nixosConfigurations.laptop.config.system.build.vm;
      };
    };
}
