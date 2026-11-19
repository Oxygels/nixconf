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
    extraGroups = [ "docker" ];
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      log-level = "error";
      bip = "10.171.0.1/24";
      default-address-pools = [
        {
          base = "10.172.0.0/14";
          size = 24;
        }
      ];
    };
  };

  networking.networkmanager = {
    enable = false;
  };

  systemd.services.wsl-vpnkit = {
    description = "wsl-vpnkit";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      # Use local wsl-vpnkit binary when available, otherwise fall back to distro invocation.
      ExecStart = pkgs.writeShellScript "wsl-vpnkit" ''
        if command -v wsl-vpnkit >/dev/null 2>&1; then
          exec wsl-vpnkit
        else
          exec /mnt/c/Windows/system32/wsl.exe -d wsl-vpnkit --cd /app wsl-vpnkit
        fi
      '';
      Restart = "always";
      KillMode = "mixed";
    };
  };

}
