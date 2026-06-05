{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./sops.nix
    ./syncthing/syncthing.nix
  ];
}
