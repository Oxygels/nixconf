{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-26.05";
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
      disko,
      nixos-wsl,
      lazyvim,
      ...
    }@inputs:
    let
      mkHost =
        {
          hostname,
          system ? "x86_64-linux",
          username,
          gui ? true,
          disk ? true,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname username; };
          modules = [
            ./modules/nixos/core
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
                ./modules/home/core
                ./hosts/${hostname}/home.nix
              ]
              ++ nixpkgs.lib.optional gui ./modules/home/gui;
            }
          ]
          ++ nixpkgs.lib.optionals gui [
            ./modules/nixos/gui
          ]
          ++ nixpkgs.lib.optionals disk [
            disko.nixosModules.disko
            # Called with `{ }` so `device` stays the placeholder here; the
            # real value comes only from `--argstr device` on the disko CLI.
            (import ./modules/nixos/core/disk-config.nix { })
          ]
          ++ extraModules;
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
        wsl = mkHost {
          hostname = "wsl";
          username = "oxy";
          gui = false;
          disk = false;
          extraModules = [ nixos-wsl.nixosModules.default ];
        };
      };
      packages.x86_64-linux = {
        tower-vm = self.nixosConfigurations.tower.config.system.build.vm;
        laptop-vm = self.nixosConfigurations.laptop.config.system.build.vm;
      };
    };
}
