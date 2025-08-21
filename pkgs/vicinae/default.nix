# vicinae.nix
let

  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  pkgs = import nixpkgs {
    config = { };
    overlays = [ ];
  };
  myArgs = {
    inherit (pkgs)
      stdenv
      cpp
      gfm
      rapidfuzz
      kdePackages
      shell
      ;
  };

in

{
  vicinae = pkgs.callPackage ./vicinae.nix { };

}
