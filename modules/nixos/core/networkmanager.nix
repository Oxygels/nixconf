{ lib, ... }:
{
  networking.networkmanager = {
    enable = lib.mkDefault true;
    # Pin DNS instead of relying on whatever the DHCP lease hands out.
    insertNameservers = lib.mkDefault [ "1.1.1.1" ];
  };
}
