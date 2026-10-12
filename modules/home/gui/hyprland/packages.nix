{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprshutdown
    wl-clipboard-rs
    pavucontrol
    cliphist
    wofi
    hyprshot
    playerctl
    brightnessctl
    hyprpolkitagent
  ];
}
