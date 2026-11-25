{ pkgs, ... }: {

  imports = [
    ./rider.nix
  ];

  home.packages = with pkgs; [
    godot
    blender
  ];
}
