{ ... }:
{
  home.file.".ssh/control/.keep".text = "";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # Host-specific entries (IPs, users, keys) live outside the repo.
    includes = [ "~/.ssh/config.local" ];
    settings."*" = {
      ForwardAgent = false;
      ServerAliveInterval = 10;
      HashKnownHosts = false;
      ControlMaster = "auto";
      ControlPath = "~/.ssh/control/%r@%h:%p";
      ControlPersist = "10m";
    };
  };
}
