{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnome-themes-extra
    adwaita-qt
    adwaita-qt6
  ];

  # Brave and libadwaita apps read this
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # ----------------------------------------------------------------------
  # Environment
  # ----------------------------------------------------------------------
  wayland.windowManager.hyprland.settings = {
    env = [
      {
        _args = [
          "XCURSOR_SIZE"
          24
        ];
      }
      {
        _args = [
          "HYPRCURSOR_SIZE"
          24
        ];
      }
      {
        _args = [
          "GTK_THEME"
          "Adwaita:dark"
        ];
      }
      {
        _args = [
          "QT_QPA_PLATFORMTHEME"
          "adwaita"
        ];
      }
      {
        _args = [
          "QT_STYLE_OVERRIDE"
          "adwaita-dark"
        ];
      }
    ];
  };
}
