{ pkgs, inputs, ... }:
{

  home.packages = with pkgs; [
    ## Better core utils
    android-tools
    android-studio-tools
    scrcpy
  ];
}
