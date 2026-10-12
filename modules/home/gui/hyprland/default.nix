{ lib, ... }:
{
  imports = [
    ./animation.nix
    ./bind.nix
    ./env.nix
    ./event.nix
    ./hyprlock.nix
    ./misc.nix
    ./packages.nix
    ./window.nix
  ];

  options.vars.hyprland = {
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
    };
    uwsm = lib.mkOption {
      type = lib.types.str;
      default = "uwsm app -- ";
    };
    launcher = lib.mkOption {
      type = lib.types.str;
      default = "quickshell ipc call launcher toggle";
    };
    fileManager = lib.mkOption {
      type = lib.types.str;
      default = "lf";
    };
  };

}
