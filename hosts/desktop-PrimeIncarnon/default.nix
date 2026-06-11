{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
    ./../../modules/core/optional/bluetooth.nix
    ./../../modules/core/optional/printers.nix
    ./../../modules/core/optional/amd.nix
    ./../../modules/core/optional/ntfs.nix
    ./../../modules/core/optional/ssh.nix
    ./../../modules/core/optional/keyd.nix
    # ./../../modules/core/optional/mouse-actions.nix

  ];

  powerManagement.cpuFreqGovernor = "performance";
}
