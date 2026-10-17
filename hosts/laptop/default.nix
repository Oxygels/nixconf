{ username, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "laptop";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.05";

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "test";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            grave = "t";
          };
        };
      };
    };
  };
}
