{ pkgs, ... }:
{
  system.stateVersion = "26.05";
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  time.timeZone = "Europe/Berlin";

  console.keyMap = "fr";

  programs.fish.enable = true;
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
