{ unstable, ... }:
{
  programs.opencode = {
    enable = true;
    # Pinned nixpkgs lags the fast-moving opencode releases; pull the
    # package from unstable to stay current.
    package = unstable.opencode;
  };
}
