{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    handy
    # alsa-plugins
    # inputs.handy.packages.${pkgs.system}.default
  ];
}
