{ pkgs, inputs, ... }:
{

  home.packages = with pkgs; [
    ## Utils
    gamemode
    gamescope

    winetricks
    wineWow64Packages.stable

    umu-launcher
    wowup-cf
  ];
}
