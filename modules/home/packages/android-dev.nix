{ pkgs, inputs, ... }:
{
  imports = [ inputs.areofyl-fetch.homeManagerModules.default ];

  home.packages = with pkgs; [
    ## Better core utils
    android-tools
    android-studio-tools
    scrcpy
  ];
}
