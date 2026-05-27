{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelPatches = [
    {
      name = "btmtk-func-ctrl";
      patch = ./../../patches/btmtk-func-ctrl.patch;
    }
  ];

  boot.supportedFilesystems = [ "ntfs" ];
}
