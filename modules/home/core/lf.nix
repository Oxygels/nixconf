{ pkgs, ... }:
let
  cleaner = pkgs.writeShellScript "cleaner" ''
    #!/bin/bash
    command -v kitty >/dev/null || exit 0
    kitty +kitten icat --clear --stdin no --silent --transfer-mode memory </dev/null >/dev/tty
  '';
in
{
  # Used by the previewer and keybindings below
  home.packages = with pkgs; [
    trashy
    hexyl
    ffmpegthumbnailer
  ];

  programs.lf = {
    enable = true;
    keybindings = {
      d = "";
      x = "cut";
      D = "trash";
      a = "push :mkdir<space>";
      "." = "set hidden!";
    };
    commands = {
      trash = ''%trash put "$fx"'';
      mkdir = ''%mkdir "$@"'';
    };
    settings = {
      drawbox = true;
      period = 2;
      "cleaner" = "${cleaner}";
    };
    previewer = {
      source = pkgs.writeShellScript "previewer" ''
        #!/bin/bash

        draw_picture() {
            command -v kitty >/dev/null || exit 0
            kitty +kitten icat --silent --stdin no --transfer-mode memory \
                --place "''${2}x''${3}@''${4}x''${5}" "$1" </dev/null >/dev/tty
            exit 1
        }

        case "$1" in
        *.jpg | *.jpeg | *.png | *.gif | *.webp | *.bmp)
            draw_picture "$@"
            ;;

        *.avi | *.mp4 | *.mkv | *.webm | *.mov)
            ffmpegthumbnailer -i "$1" -s 0 -q 5 -o "/tmp/thumbnail.png"
            draw_picture "/tmp/thumbnail.png" "''${@:2}"
            ;;
        *)
            if file "$1" | grep -q "text"; then
                bat --color=always --style=numbers "$1"
            else
                hexyl -n 500 "$1"
            fi
            ;;
        esac
      '';
    };
  };
}
