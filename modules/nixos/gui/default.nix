{ ... }:
{
  imports = [
    ./brave.nix
    ./udev.nix
  ];

  programs.dconf.enable = true;

  hardware.graphics.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Defaults to true before 26.11, will be able to remove when it releases
  boot.zfs.forceImportRoot = false;
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
  };

  # VM setting when built as a VM
  virtualisation.vmVariant.virtualisation = {
    memorySize = 4096;
    cores = 6;
  };
}
