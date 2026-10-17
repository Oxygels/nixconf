{ pkgs, username, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "tower";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.05";

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/744d52f8-af93-45ec-bb7b-76a74c400379";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "test";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };
}
