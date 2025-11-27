{ pkgs, services, ... }:
{
  services.xserver.videoDriver = [
    "nvidia"
    "modesetting"
  ];

  home.packages = with pkgs; [
    nvidia-vaapi-driver
    nvidia-modprobe
    nvidia-docker
    nvtopPackages.nvidia
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = false;

    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0"; # example, run `lspci`
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
