{ pkgs, ... }: {
  imports = [
    ./rider.nix
    ../android.nix
  ];

  home.packages = with pkgs; [
    unityhub
    blender
  ];
}
