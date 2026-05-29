{ pkgs, ... }:
{
  home.packages = with pkgs; [
    code-cursor
    godot
    lact
    jetbrains.webstorm
    jetbrains.datagrip
    ungoogled-chromium
    gnome-maps

  ];
}
