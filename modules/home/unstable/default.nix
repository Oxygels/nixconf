# Single point of contact with the nixpkgs-unstable input.
#
# Everything pulled from unstable lives under this directory, one file per
# package/program, each stating why it cannot come from the pinned nixpkgs.
{ pkgs, nixpkgs-unstable, ... }:
{
  imports = [
    ./discord.nix
    ./claude-code.nix
  ];

  _module.args.unstable = import nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
}
