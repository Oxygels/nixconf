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
    git # required by lazygit
    lazygit
    openssl
    lsof
  ];
}
