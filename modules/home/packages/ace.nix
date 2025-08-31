{ pkgs, ... }:
{

  home.packages = with pkgs; [
    kicad
    blender
    openscad-unstable
    fontbakery
    font-manager
    fontpreview
  ];
}
