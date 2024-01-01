{ pkgs, ... }:
{
  home.packages = with pkgs; [
    code-cursor
    godot
    jetbrains.webstorm
    jetbrains.datagrip
  ];
}
