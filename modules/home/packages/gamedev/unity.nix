{ pkgs, ... }: {
  imports = [
    ./rider.nix
  ];

  home.packages = with pkgs; [
    unityhub
    blender
  ];
}
