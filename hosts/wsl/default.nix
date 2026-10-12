{ username, pkgs, ... }:
{
  networking.hostName = "wsl";

  wsl.enable = true;
  wsl.defaultUser = username;

  system.stateVersion = "26.05";

  users.users.${username}.shell = pkgs.fish;
}
