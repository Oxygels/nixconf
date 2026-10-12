{ ... }:
{
  imports = [
    ./hyprland
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";

    settings = {

      # ----------------------------------------------------------------------
      # Gestures
      # ----------------------------------------------------------------------
      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        }
      ];

    };
  };
}
