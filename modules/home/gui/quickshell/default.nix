{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quickshell
    nerd-fonts.caskaydia-cove
    papirus-icon-theme
    noto-fonts
    noto-fonts-color-emoji
  ];

  home.sessionVariables.QS_ICON_THEME = "Papirus-Dark";

  xdg.configFile."quickshell/default".source = ./qml;
}
