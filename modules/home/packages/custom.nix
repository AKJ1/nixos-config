{ inputs, pkgs, ... }:
let
  # vicinae = pkgs.callPackage ../../../pkgs/vicinae/vicinae.nix { };
in
{
  home.packages = with pkgs; [
    # vicinae
  ];
}
