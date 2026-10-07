{ pkgs, username, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "tower";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.05";

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "test";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };
}
