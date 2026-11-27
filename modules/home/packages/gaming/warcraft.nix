{ pkgs, inputs, ... }:
let
  wowDir = "Program Files (x86)/World of Warcraft";
  addonFolder = "Interface/Addons";
  prefix = "$HOME/.local/share/battlenet-umu/prefix";

  # The battlenet-umu module only generates `umu-run <exe>` wrappers, which
  # leaves nowhere to hang gamemode/mangohud/Proton env tuning. Keep the module
  # for the Battle.net prefix and addon sync, launch the game through this.
  wowLauncher = pkgs.writeShellApplication {
    name = "wow-classic";
    runtimeInputs = with pkgs; [
      gamemode
      umu-launcher
      util-linux
    ];
    text = ''
      export WINEPREFIX="${prefix}"
      export GAMEID="umu-default"
      export PROTONPATH="${pkgs.proton-ge-bin.steamcompattool}"

      # Do not re-check the umu runtime on every single launch.
      export UMU_RUNTIME_UPDATE=0

      # Use Wine's native Wayland driver instead of going through
      # xwayland-satellite.
      export PROTON_ENABLE_WAYLAND=1

      export MANGOHUD=1

      # Pin ANV so the Vulkan loader cannot fall back to a software ICD.
      export VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json

      exe="$WINEPREFIX/drive_c/${wowDir}/_forever_/Wow.exe"
      if [ ! -f "$exe" ]; then
        echo "WoW Classic is not installed at $exe" >&2
        exit 1
      fi

      # P-cores only: on the Ultra 7 155H the 1.4 GHz P-core cluster is CPUs
      # 0-11, the E-cores (0.9 GHz) and LP-E cores (0.7 GHz) are far slower.
      exec gamemoderun taskset -c 0-11 umu-run "$exe" "$@"
    '';
  };

  wowDesktop = pkgs.makeDesktopItem {
    name = "wow-classic";
    desktopName = "World of Warcraft";
    exec = "${wowLauncher}/bin/wow-classic";
    terminal = false;
    categories = [ "Game" ];
  };
in
{
  imports = [
    inputs.battlenet-umu.homeModules.default
  ];
  home.packages = [
    wowLauncher
    wowDesktop
  ];
  programs.battlenet-umu = {
    enable = true;
    games = [
      { name = "Battle.net"; }
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
