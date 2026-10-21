{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    kicad
    blender
    openscad-unstable
    freecad-wayland
    inputs.orca-pkgs.legacyPackages.${pkgs.system}.orca-slicer
  ];
}
