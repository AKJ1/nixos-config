{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.herdr.packages.${pkgs.system}.herdr-app
    inputs.herdr.packages.${pkgs.system}.herdr-core
  ];
}
