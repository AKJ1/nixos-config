{ pkgs, inputs, ... }: {
  home.packages = [
    inputs.stablepkgs.legacyPackages.${pkgs.system}.libreoffice-still
  ];
}
