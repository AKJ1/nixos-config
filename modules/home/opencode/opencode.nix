{ pkgs, ... }:
let
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    mcp.nixos = {
      type = "local";
      command = [ "${pkgs.mcp-nixos}/bin/mcp-nixos" ];
      enabled = true;
    };
    mcp.penpot = {
      type = "remote";
      transport.type = "http";
      url = "http://localhost:9001/mcp/stream?userToken=eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2R0NNIn0.Ma1VP-LjwWoAx2Lssrf4mNHfE9B5aIG4D2-o7earlm76sCGF438uBw.FtH3vQZBi0VpAzvz.xYam_FzeptwpIem9eJMytmQfOcYMUZ4cFjc2kO_-6T6bM8OIzjp5YUZMZjJD2-OnEsxvSDIR85yIyUSlZplZvP8v7KmabSucDiVGnl7uBrQYjSt0rlD9_xrIljPkuwBxCef6bWGGP6IiUme9fbWy4gb737iRtMWAdbYNQ1S1lgUsz3okMXHd4ISWrZiICNIbx2arGBQ3trnZ.CGUe9QRi5tPHrNpHNxnnAw";
      enabled = true;
    };
  };
in
{
  home.packages = with pkgs; [
    opencode
    mcp-nixos
  ];

  xdg.configFile."opencode/opencode.json" = {
    text = builtins.toJSON opencodeConfig;
  };

}
