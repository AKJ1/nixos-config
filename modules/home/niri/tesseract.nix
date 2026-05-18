{ pkgs, ... }:
{
  home.packages = [
    (pkgs.tesseract.override {
      enableLanguages = [
        "eng"
        "bul"
      ];
    })
  ];
}
