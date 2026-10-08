{ pkgs, ... }:
{
  system.stateVersion = "26.05";
  nixpkgs.config.allowUnfree = true;

  hardware.graphics.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Defaults to true before 26.11, will be able to remove when it releases
  boot.zfs.forceImportRoot = false;
  boot.loader.systemd-boot.enable = true;

  console.keyMap = "fr";

  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    killall
    file
  ];

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

  services.dunst = {
    enable = true;
    enableWayland = true;
    enableX11 = false;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    localNetworkGameTransfers.openFirewall = false;
  };

  # VM setting when built as a VM
  virtualisation.vmVariant.virtualisation = {
    memorySize = 4096;
    cores = 6;
  };
}
