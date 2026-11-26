{
  config,
  pkgs,
  lib,
  host,
  ...
}:
let
  keydConfig = (
    if (host == "xps9340") then
      builtins.readFile ./config/xps9340.conf
    else
      builtins.readFile ./config/base.conf
  );
  keydFile = pkgs.writeText "keyd-default.conf" keydConfig;
in
{
  xdg.configFile."keyd/default.conf" = {
    source = keydFile;
  };
}
