{ ... }:
{
  services.udev.extraRules = ''
    # Disable DualSense touchpad acting as mouse
    # USB
    ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
}
