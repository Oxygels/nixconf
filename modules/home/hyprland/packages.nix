{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprshutdown
    wl-clipboard-rs
    pavucontrol
  ];
}
