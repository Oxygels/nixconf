{ lib, ... }:

let
  uwsm = "uwsm app -- ";
  lua = lib.generators.mkLuaInline;

  # ----------------------------------------------------------------------
  # Autostart
  #
  # Hyprland 0.55+ uses an event for startup commands. Home Manager's
  # Lua backend supports this through the `on` setting.
  # ----------------------------------------------------------------------
in
{
  wayland.windowManager.hyprland.settings = {

    # Local state used by the Chromium fullscreen event handler.
    # The variable must exist before the callback is registered.

    # `fs_prev` is a Lua variable rather than a Hyprland config option.
    # Home Manager's `_var` support emits it as a local variable.
    fs_prev = {
      _var = "nil";
    };

    on = [
      {
        _args = [
          "hyprland.start"
          (lua ''
            function()
              hl.exec_cmd("${uwsm}hyprpaper")
              hl.exec_cmd("${uwsm}waybar")
              hl.exec_cmd("${uwsm}hyprsunset -t 4500")
              hl.exec_cmd("${uwsm}wl-paste --type text --watch cliphist store")
              hl.exec_cmd("${uwsm}wl-paste --type image --watch cliphist store")
              hl.exec_cmd("systemctl --user start hyprpolkitagent")
              hl.exec_cmd("tmux kill-server")
            end
          '')
        ];
      }

      # Chromium's bogus fullscreen/maximize event workaround.
      {
        _args = [
          "window.fullscreen"
          (lua ''
            function(w)
              local cur = w.fullscreen
              local prev = fs_prev
              fs_prev = cur

              if prev == 2 and cur == 0 then
                hl.timer(function()
                  fs_prev = nil
                end, { timeout = 1, type = "oneshot" })
              elseif cur == 1 and fs_prev then
                fs_prev = nil
                hl.dispatch(hl.dsp.window.fullscreen_state({
                  internal = 0,
                  client = 0,
                  action = "set",
                  window = w,
                }))
              end
            end
          '')
        ];
      }
    ];
  };
}
