{ ... }:
{
  # ----------------------------------------------------------------------
  # Misc
  # ----------------------------------------------------------------------
  wayland.windowManager.hyprland.settings = {
    config = {
      input = {
        kb_layout = "fr, us";
        kb_variant = "";
        kb_model = "";
        kb_options = "grp:win_space_toggle";
        kb_rules = "";

        repeat_delay = 300;
        repeat_rate = 50;

        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
        };
      };
      general = {
        gaps_in = 5;
        gaps_out = {
          top = 10;
          right = 20;
          bottom = 10;
          left = 20;
        };
        border_size = 2;
        col = {
          active_border = {
            colors = [
              "rgba(cba6f7ee)" # mauve
              "rgba(b4befeee)" # lavender
            ];
            angle = 45;
          };
          inactive_border = "rgba(45475aaa)";
        };
        resize_on_border = false;
        allow_tearing = true;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        # inactive_opacity = 0.9;

        shadow = {
          enabled = false;
          range = 4;
          render_power = 3;
          color = "rgba(ee1a1a1a)";
        };

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
      };

      dwindle = {
        preserve_split = true;
      };

      misc = {
        render_unfocused_fps = 144;
        # Plain background until hyprpaper has loaded the wallpaper.
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        background_color = "0xff1e1e2e";
      };
    };
  };
}
