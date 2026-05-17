{ pkgs, ... }:
{
  home.packages = [
    (pkgs.tesseract.override {
      scripts = [
        "cyrl"
      ];
      languages = [
        "eng"
        "bul"
      ];
    })
  ];
}
