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

}
