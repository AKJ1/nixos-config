{ inputs, pkgs, ... }:
let
  _2048 = pkgs.callPackage ../../../pkgs/2048/default.nix { };
  # vicinae = pkgs.callPackage ../../../pkgs/vicinae/vicinae.nix { };
in
{
  home.packages = with pkgs; [
    # vicinae
    _2048
  ];
}
