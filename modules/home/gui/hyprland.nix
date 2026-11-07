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
    # uwsm owns the session; hyprland-session.target would stop graphical-session.target.
    systemd.enable = false;

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
