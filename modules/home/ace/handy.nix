{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    handy
    # Handy's "Direct" typing on Wayland; without it it falls back to enigo/X11.
    wtype
    # alsa-plugins
    # inputs.handy.packages.${pkgs.system}.default
  ];
}
