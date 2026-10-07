{ pkgs, ... }:
{
  system.stateVersion = "26.05";
  nixpkgs.config.allowUnfree = true;

  # Defaults to true before 26.11, will be able to remove when it releases
  boot.zfs.forceImportRoot = false;
  boot.loader.systemd-boot.enable = true;

  console.keyMap = "fr";

  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    btop
    fastfetch
    trashy
    file
    eza
    ripgrep
    fd
    fzf
    hexyl
    ffmpegthumbnailer # for lf
  ];

  services.displayManager.ly = {
    enable = false;
    settings = {
      animation = "matrix";
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    localNetworkGameTransfers.openFirewall = false;
  };

  # VM setting when built as a VM
  virtualisation.vmVariant.virtualisation = {
    memorySize = 4096;
    cores = 4;
  };
}
