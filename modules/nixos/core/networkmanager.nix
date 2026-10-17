{ ... }:
{
  networking.networkmanager = {
    enable = true;
    # Pin DNS instead of relying on whatever the DHCP lease hands out.
    insertNameservers = [ "1.1.1.1" ];
  };
}
