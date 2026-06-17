{ pkgs, inputs, ... }:
{

  home.packages = with pkgs; [
    conda
    tk
    optipng
    inkscape
    thunderbird # email client
    remmina # remote desktop tunnel client
    fontbakery
    font-manager
    fontpreview
    (inputs.matcha.packages.${pkgs.system}.default.overrideAttrs (old: {
      GOTOOLCHAIN = "local";
      postPatch = (old.postPatch or "") + ''
        sed -i 's/^go 1\.26\.3/go 1.26/' go.mod
      '';
    }))
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
