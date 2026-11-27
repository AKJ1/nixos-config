{ pkgs, ... }:
{

  # HUD/instrumentation; enabled per-app via MANGOHUD=1 in the game launchers
  # rather than session-wide, so it does not show up in every Vulkan/GL app.
  programs.mangohud.enable = true;

  home.packages = with pkgs; [
    ## Utils
    gamemode
    gamescope

    winetricks
    wineWow64Packages.stable

    umu-launcher
    wowup-cf

    pkgs.unstable.lutris
  ];
}
