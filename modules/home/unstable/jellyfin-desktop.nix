{ unstable, ... }:
{
  # Pinned nixpkgs' jellyfin-desktop 2.0.0 cannot play video (libmpv "No render
  # context set", web UI reports "client can't decode"); the unstable build
  # (2.0.0-unstable-2026-08-31) works.
  home.packages = [ unstable.jellyfin-desktop ];
}
