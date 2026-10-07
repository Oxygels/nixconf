{ ... }:
{
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
    ];
  };
}
