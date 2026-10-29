{ pkgs, ... }:
{
  imports = [
    ./easyeffects.nix
    ./hyprland.nix
    ./quickshell
  ];

  home.packages = with pkgs; [
    libnotify # notify-send
    setxkbmap
    keepassxc
    chatterino7
    jellyfin-desktop
    qbittorrent
    (discord.override {
      commandLineArgs = "--ozone-platform=wayland --enable-features=UseOzonePlatform,WaylandWindowDecorations";
    })
  ];

  services.hyprsunset = {
    enable = true;
    settings = {
      profile = {
        time = "0:00";
        temperature = 4500;
      };
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = ""; # all monitors
          path = "${../../../wallpaper/unberry_ow.jpg}";
          fit_mode = "cover";
        }
      ];
    };
  };

  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+alt+t" = "new_tab";
      "ctrl+alt+left" = "previous_tab";
      "ctrl+alt+right" = "next_tab";
    };
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "CaskaydiaCove Nerd Font";
      size = 14;
      package = pkgs.nerd-fonts.caskaydia-cove;
    };
    settings = {
      background_opacity = 0.4;
      confirm_os_window_close = 0;
      remember_window_size = false;
    };
  };

  programs.mpv = {
    enable = true;
    bindings = {
      WHEEL_DOWN = "add volume -2";
      DOWN = "add volume -2";
      WHEEL_UP = "add volume 2";
      UP = "add volume 2";
      "Shift+LEFT" = "playlist-prev";
      "Shift+RIGHT" = "playlist-next";
    };
    config = {
      profile = "high-quality";
      # ao=pulse # For Discord screenshare
      # gpu-context=wayland # For iGPU usage
      save-position-on-quit = true;
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform,TouchpadOverscrollHistoryNavigation"
      "--disable-features=HardwareMediaKeyHandling" # To stop bluetooth headphones to try to interact with videos
    ];
  };

  services.pipewire = {
    enable = true;
    wireplumber = {
      enable = true;
      configs.disable-mic-profile = {
        "monitor.bluez.properties" = {
          "bluez5.hw-volume" = [ ];
          "bluez5.roles" = [
            "a2dp_sink"
            "a2dp_source"
            "bap_sink"
            "bap_source"
          ];
        };
      };
    };
  };
}
