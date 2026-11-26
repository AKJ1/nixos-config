{ pkgs, inputs, ... }:
let
  wow = "Program Files (x86)/World of Warcraft";
  addonFolder = "Interface/Addons";
in
{
  programs.battlenet-umu = {
    enable = true;
    games = [
      { name = "Battle.net"; }
      {
        name = "World of Warcraft";
        path = "${wow}/_forever_/Wow.exe";
      }
    ];
    addons = {
      enable = true;
      tokens = {
        wagoAddons = "SECRET";
      };
      versions = [
        {
          name = "era";
          addonDir = "${wow}/_classic_era_/${addonFolder}";
          flavour = "forever";
          addons = [
            "github:Peterodox/YUI-Dialogue"
            "github:Total-RP/Total-RP-3"
            "github:DustinChecketts/VendorPricePlus"
          ];
        }
      ];
    };
  };
}
