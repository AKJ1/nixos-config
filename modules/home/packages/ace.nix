{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kicad
    blender
    thunderbird
    openscad-unstable
    fontbakery
    font-manager
    fontpreview
    remmina
    steam
    proton-ge-bin
    (texlive.combine {
      inherit (texlive)
        scheme-full
        luatex
        fontspec
        babel-bulgarian
        babel
        ;
    })
    texlab

  ];
}
