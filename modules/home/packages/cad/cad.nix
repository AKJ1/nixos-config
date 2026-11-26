{
  pkgs,
  inputs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    blender
    openscad-unstable
    # freecad-wayland
    inputs.unstable.legacyPackages.${pkgs.system}.orca-slicer
  ];

  home.sessionVariables = {
    OPENSCADPATH = "${config.home.homeDirectory}/Projects/OpenSCAD/Libraries";
  };
}
