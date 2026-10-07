{ ... }:
{
  home.stateVersion = "26.05";

  # Disable subpixel rendering for the OLED screen
  fonts.fontconfig = {
    enable = true;
    subpixelRendering = "none";
  };

}
