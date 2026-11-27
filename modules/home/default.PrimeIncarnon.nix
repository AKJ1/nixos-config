{ ... }:
{
  imports = [
    ./default.nix
    ./unity.nix
    ./vicinae.nix
    # ./rider.nix                     # C# JetBrain editor
    # ./unity.nix

    ./packages/tex
    ./packages/cad
    ./packages/gaming
    ./packages/gamedev
    ./packages/office
    ./packages/webdev
  ];
}
