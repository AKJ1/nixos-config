{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./sops.nix
    ./handy.nix
    ./syncthing
  ];
}
