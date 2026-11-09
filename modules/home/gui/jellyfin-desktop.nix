{ pkgs, ... }:
{
  # jellyfin-desktop 2.0.0 cannot play video (libmpv "No render context
  # set", web UI reports "client can't decode"); needs 2.0.0-unstable or
  # newer, which nixos-unstable has.
  home.packages = [ pkgs.jellyfin-desktop ];
}
