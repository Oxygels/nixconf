{ pkgs, ... }:
{
  imports = [ ./networkmanager.nix ];

  system.stateVersion = "26.05";
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  time.timeZone = "Europe/Berlin";

  console.keyMap = "fr";

  programs.fish.enable = true;
  services.udisks2.enable = true; # udisksctl + daemon
  environment.systemPackages = with pkgs; [
    killall
    file
  ];

  # Drop new inbound; allow replies to outbound (nftables backend)
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    backend = "nftables";
    allowPing = false;
  };
}
