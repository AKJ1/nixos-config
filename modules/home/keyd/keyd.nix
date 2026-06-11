{
  config,
  pkgs,
  lib,
  host,
  ...
}:
let
  keydConfig = builtins.readFile ./config/base.conf;
  keydFile = pkgs.writeText "keyd-default.conf" keydConfig;
in
{
  xdg.configFile."keyd/default.conf" = {
    source = keydFile;
  };
}
