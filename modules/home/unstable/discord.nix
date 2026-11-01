{ unstable, ... }:
{
  home.packages = [
    # The pinned nixpkgs ships 1.0.159, built without the bwrap wrapper, so
    # Chromium cannot dlopen libva.so.2 and hardware video decode never
    # starts at all. The unstable build is bwrap-wrapped and its FHS layout
    # makes libva resolvable.
    #
    # Known limitation either way: Go Live playback is unreliable. Discord's
    # software H.264 decoder is openh264-only and it hardcodes
    # libopenh264-2.5.1-linux64.7.so, which its own live asset manifest
    # replaced with 2.7.0 and now deletes at launch; restoring that file
    # fails regardless of version, dependencies or sandbox. So when the
    # hardware decoder drops out there is no working fallback. Use a browser
    # tab for streams if that bites.
    #
    # No commandLineArgs needed: NIXOS_OZONE_WL in ../hyprland/env.nix is
    # what the wrapper reads to add the Wayland flags.
    unstable.discord
  ];
}
