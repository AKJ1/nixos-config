{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # inputs.handy
    inputs.handy.packages.${pkgs.system}.default
  ];
}
