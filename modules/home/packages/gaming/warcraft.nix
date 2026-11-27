{ pkgs, inputs, ... }:
let
  wow = "Program Files (x86)/World of Warcraft";
  addonFolder = "Interface/Addons";
in
{
  imports = [
    inputs.battlenet-umu.homeModules.default
  ];
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
      versions = [
        {
          name = "era";
          addonDir = "${wow}/_forever_/${addonFolder}";
          flavour = "forever_classic";
          addons = [
            "github:Questie/Questie"
            "curse:opie"
            "curse:bartender4"
            "curse:baganator`"
            "github:DustinChecketts/VendorPricePlus"
          ];
          #   "github:Peterodox/YUI-Dialogue"
          #   "github:Total-RP/Total-RP-3"
          # ];
        }
      ];
    };
  };
}
