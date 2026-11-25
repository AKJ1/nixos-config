{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # code-cursor
    # jetbrains.webstorm // 3gb, no point
    # jetbrains.datagrip // 3gb, no point
    gnome-maps
  ];
}
