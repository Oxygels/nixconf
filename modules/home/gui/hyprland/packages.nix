{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprshutdown
    wl-clipboard
    pavucontrol
    cliphist
    hyprshot
    playerctl
    brightnessctl
    hyprpolkitagent
  ];
}
