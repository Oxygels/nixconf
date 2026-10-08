{ pkgs, ... }:
{
  home.packages = [
    pkgs.quickshell
    pkgs.nerd-fonts.caskaydia-cove
    pkgs.papirus-icon-theme
  ];

  home.sessionVariables.QS_ICON_THEME = "Papirus-Dark";

  xdg.configFile."quickshell/default".source = ./qml;
}
