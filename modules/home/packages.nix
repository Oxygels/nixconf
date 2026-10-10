{ pkgs, ... }:
{
  # General user CLI tools
  home.packages = with pkgs; [
    fastfetch
    eza
    ripgrep
    fd
    fzf
    libnotify # notify-send
    lazygit
    openssl
    lsof
    keepassxc
    (discord.override {
      commandLineArgs = "--ozone-platform=wayland --enable-features=UseOzonePlatform,WaylandWindowDecorations";
    })
  ];
}
