# Single point of contact with the nixpkgs-unstable input.
#
# Everything pulled from unstable lives here, each entry stating why it
# cannot come from the pinned nixpkgs
{ pkgs, nixpkgs-unstable, ... }:
let
  unstable = import nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  home.packages = [
    # discord: 26.05 ships 1.0.159, built without the bwrap wrapper. Chromium
    # then cannot dlopen libva.so.2, so VaapiWrapper never initialises and
    # Go Live streams fail to decode on the hardware path. The software path
    # is no fallback: it is openh264-only, and Discord hardcodes
    # libopenh264-2.5.1-linux64.7.so while its live asset manifest ships
    # 2.7.0 and prunes the old file. The unstable build is bwrap-wrapped and
    # its FHS layout makes libva resolvable, which fixes decoding.
    (unstable.discord.override {
      commandLineArgs = "--ozone-platform=wayland --enable-features=UseOzonePlatform,WaylandWindowDecorations";
    })
  ];
}
