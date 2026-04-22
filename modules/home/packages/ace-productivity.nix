{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    opencode
    conda
    tk
    optipng
    thunderbird # email client
    remmina # remote desktop tunnel client
    fontbakery
    font-manager
    fontpreview
    (texlive.combine {
      # full fat Tex environment, contians bulgarian.
      inherit (texlive)
        scheme-full
        luatex
        fontspec
        babel-bulgarian
        babel
        ;
    })
    texlab # Tex

  ];
}
