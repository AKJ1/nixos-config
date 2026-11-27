{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    libreoffice-stable
  ];
}
