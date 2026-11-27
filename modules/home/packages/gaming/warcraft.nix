{ pkgs, inputs, ... }:
let
  wowDir = "Program Files (x86)/World of Warcraft";
  addonFolder = "Interface/Addons";
  prefix = "$HOME/.local/share/battlenet-umu/prefix";

  # WoW must be started from Battle.net so Blizzard gets the login cookie.
  # Apply the tuning to the launcher instead of a dedicated Wow.exe shortcut:
  # env and affinity are inherited by every game the launcher spawns.
  bnetLauncher = pkgs.writeShellApplication {
    name = "battle-net-umu";
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

      # Use Wine's native Wayland driver instead of xwayland-satellite.
      export PROTON_ENABLE_WAYLAND=1

      export MANGOHUD=1

      # Pin ANV so the Vulkan loader cannot fall back to a software ICD.
      export VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json

      exe="$WINEPREFIX/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"
      if [ ! -f "$exe" ]; then
        echo "Battle.net is not installed at $exe" >&2
        echo "Install it once with the battlenet-umu installer, then relaunch." >&2
        exit 1
      fi

      # P-cores only: on the Ultra 7 155H the 1.4 GHz P-core cluster is CPUs
      # 0-11, the E-cores (0.9 GHz) and LP-E cores (0.7 GHz) are far slower.
      exec gamemoderun taskset -c 0-11 umu-run "$exe" "$@"
    '';
  };

  bnetDesktop = pkgs.makeDesktopItem {
    name = "battle-net-umu";
    desktopName = "Battle.net";
    exec = "${bnetLauncher}/bin/battle-net-umu";
    terminal = false;
    categories = [ "Game" ];
  };
in
{
  imports = [
    inputs.battlenet-umu.homeModules.default
  ];
  home.packages = [
    bnetLauncher
    bnetDesktop
  ];
  programs.battlenet-umu = {
    enable = true;
    # The generated launcher is replaced by the tuned wrapper above; the
    # module is still used for the Wine prefix and the addon sync.
    games = [ ];
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
