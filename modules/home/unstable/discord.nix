{ unstable, ... }:
{
  home.packages = [
    # The pinned nixpkgs ships 1.0.159, built without the bwrap wrapper, so
    # Chromium cannot dlopen libva.so.2 and hardware video decode never
    # starts at all. The unstable build is bwrap-wrapped and its FHS layout
    # makes libva resolvable.
    #
    # Go Live playback: Discord's software H.264 decoder is openh264-only and
    # core.asar hardcodes libopenh264-2.5.1-linux64.7.so, but the web client
    # only keeps 2.7.0 and deletes the rest at launch, so streams fail with
    # error 2012 once the hardware decoder drops out. nixpkgs#581099 renamed
    # it to 2.7.0 in core.asar, but the decoder was built against 2.5.1 and
    # avcodec_open2 still fails. nixpkgs#581475 (Discord 1.0.168, merge
    # 20df208, master 2026-11-01) drops the rename as obsolete; keep
    # nixpkgs-unstable at or past that commit.
    #
    # No commandLineArgs needed: NIXOS_OZONE_WL in ../hyprland/env.nix is
    # what the wrapper reads to add the Wayland flags.
    unstable.discord
  ];
}
