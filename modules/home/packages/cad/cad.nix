{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    blender
    openscad-unstable
    # freecad-wayland
    pkgs.unstable.orca-slicer
  ];

  home.sessionVariables = {
    OPENSCADPATH = "${config.home.homeDirectory}/Projects/OpenSCAD/Libraries";
  };
}
