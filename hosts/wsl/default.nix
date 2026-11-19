{ username, pkgs, ... }:
{
  networking.hostName = "wsl";

  wsl.enable = true;
  wsl.defaultUser = username;

  system.stateVersion = "26.05";

  users.users.${username} = {
    shell = pkgs.fish;

    # Neeeded for creating /run/user/1000 w/o initial login
    linger = true;
  };

  networking.networkmanager = {
    enable = false;
  };

}
