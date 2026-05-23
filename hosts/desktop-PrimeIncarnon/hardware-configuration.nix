{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" "amdgpu"];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/70ab9863-5c74-4481-b7e2-6a2a456a1838";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C78E-4DDC";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/65803a41-c8a1-43f8-b166-b58db35a8822"; }
    ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    hardware.amdgpu = {
      intrd.enable = true;
      opencl.enable = true;
    };
    services.xserver.videoDrivers = [ "amdgpu" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  environment.variables.HSA_OVERRIDE_GFX_VERSION = "10.3.0";
}

