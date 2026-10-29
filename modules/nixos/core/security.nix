{ lib, ... }:
let
  blacklistedModules = [
    "ksmbd" # SMB kernel module
    "uvcvideo" # USB webcam
    "gspca_main" # legacy USB webcam
  ];
in
{
  boot.kernelParams = [ "module_blacklist=${lib.concatStringsSep "," blacklistedModules}" ];
}
