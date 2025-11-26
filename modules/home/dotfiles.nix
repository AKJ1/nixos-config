{ lib, ... }:

let
  # All entries in ./dotfiles (only directories usually matter)
  homefiles = builtins.readDir ./dotfiles/home;
  # configfiles = builtins.readDir ./dotfiles/config;
in
{
  xdg.enable = true;

  # Create an xdg.configFile entry for each directory/file in ./dotfiles
  # xdg.home = lib.genAttrs (builtins.attrNames configfiles) (name: {
  #   source = ./dotfiles/config/${name};
  #   recursive = true;
  #   # No 'force' or immutability — symlink is writable because the target is.
  # });

  home.mutableFile = lib.genAttrs (builtins.attrNames homefiles) (name: {
    source = ./dotfiles/home/${name};
    recursive = true;
  });
}
