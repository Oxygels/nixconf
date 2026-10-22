{ lib, ... }:
let
  blacklistedModules = [
    "ksmbd" # SMB kernel module
  ];
in
{
  boot.kernelParams = [ "module_blacklist=${lib.concatStringsSep "," blacklistedModules}" ];
}
