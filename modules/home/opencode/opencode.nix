{ pkgs, ... }:
let
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    mcp.nixos = {
      type = "local";
      command = [ "${pkgs.mcp-nixos}/bin/mcp-nixos" ];
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
