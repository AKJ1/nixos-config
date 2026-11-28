{ pkgs, inputs, ... }:
let
  wowDir = "Program Files (x86)/World of Warcraft";
  addonFolder = "Interface/Addons";
in
{
  imports = [
    inputs.battlenet-umu.homeModules.default
  ];
  programs.battlenet-umu = {
    enable = true;
    # The generated launcher is replaced by the tuned wrapper above; the
    # module is still used for the Wine prefix and the addon sync.
    games = [
      { name = "Battle.net"; }
      { name = "World of Warcraft"; }
    ];
    addons = {
      enable = true;
      versions = [
        {
          name = "era";
          addonDir = "${wowDir}/_forever_/${addonFolder}";
          flavour = "forever_classic";
          addons = [
            "github:Questie/Questie"
            "curse:opie"
            "curse:bartender4"
            "curse:baganator"
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
