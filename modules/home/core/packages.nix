{ pkgs, ... }:
{
  # General user CLI tools
  home.packages = with pkgs; [
    fastfetch
    eza
    ripgrep
    fd
    fzf
    lazygit
    openssl
    lsof
  ];
}
