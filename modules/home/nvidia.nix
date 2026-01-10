{ pkgs, ... }:
{

  home.packages = with pkgs; [
    nvidia-vaapi-driver
    nvidia-modprobe
    nvidia-docker
    # nvtopPackages.nvidia
  ];

}
