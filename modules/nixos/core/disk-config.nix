# Disk layout. The target disk is given when partitioning:
#
#   sudo nix run github:nix-community/disko -- \
#     --mode destroy,format,mount \
#     ./modules/nixos/core/disk-config.nix \
#     --argstr device /dev/nvme0n1
#   sudo nixos-install --flake .#<host>
#
# `destroy` wipes the disk. The generated fileSystems use partition labels,
# so the NixOS config itself never needs the real device (placeholder below).
{
  device ? "/dev/disk/by-id/PLACEHOLDER",
  ...
}:
{
  disko.devices.disk.main = {
    inherit device;
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            # No passwordFile: disko prompts for the passphrase when formatting.
            # Non-interactive: add `--disk-encryption-keys /tmp/luks.key /tmp/luks.key`
            # to the disko command and `passwordFile = "/tmp/luks.key";` here.
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
