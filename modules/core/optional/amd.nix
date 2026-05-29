{ pkgs, ... }:
{
  hardware.graphics.extraPackages = with pkgs; [
    mesa
    libva
    libva-utils
  ];

  environment.systemPackages = with pkgs; [
    rocmPackages.clr
    clinfo
    lact
    mangohud
    libva
    libva-utils
    ffmpeg-full
  ];

  programs.corectrl.enable = true;
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    LIBVA_DRIVER_NAME = "radeonsi";
  };
}
