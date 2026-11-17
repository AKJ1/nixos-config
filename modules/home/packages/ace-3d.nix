{
  pkgs,
  inputs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    kicad
    blender
    openscad-unstable
    freecad-wayland
    inputs.orca-pkgs.legacyPackages.${pkgs.system}.orca-slicer
  ];

  home.sessionVariables = {
    OPENSCADPATH = "${config.home.homeDirectory}/Projects/OpenSCAD/Libraries";
  };
}
