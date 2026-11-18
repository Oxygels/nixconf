{ username, pkgs, ... }:
{
  networking.hostName = "wsl";

  wsl.enable = true;
  wsl.defaultUser = username;
  wsl.wslConf.network.generateResolvConf = false;

  system.stateVersion = "26.05";

  users.users.${username}.shell = pkgs.fish;

  networking.networkmanager = {
    enable = false;
  };

}
