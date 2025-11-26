{ lib, ... }:

let
  # All entries in ./dotfiles (only directories usually matter)
  dotfiles = builtins.readDir ./dotfiles;

in
{
  xdg.enable = true;

  # Create an xdg.configFile entry for each directory/file in ./dotfiles
  xdg.configFile = lib.genAttrs (builtins.attrNames dotfiles) (name: {
    source = ./dotfiles/${name};
    recursive = true;
    # No 'force' or immutability — symlink is writable because the target is.
  });
}
