{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kicad
    blender
    openscad-unstable
    freecad-wayland
    orca-slicer
  ];
}
