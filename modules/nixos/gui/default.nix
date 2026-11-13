{ pkgs, ... }:
{
  imports = [
    ./brave.nix
    ./udev.nix
  ];

  programs.dconf.enable = true;

  hardware.graphics.enable = true;

  # ntsync kernel driver: Wine/Proton sync primitives (lower latency than esync/fsync).
  # Device node is 0666 by default, so no udev rule needed.
  # TODO: hardware.ntsync.enable once PR #516311 lands.
  boot.kernelModules = [ "ntsync" ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    localNetworkGameTransfers.openFirewall = false;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # VM setting when built as a VM
  virtualisation.vmVariant.virtualisation = {
    memorySize = 4096;
    cores = 6;
  };
}
