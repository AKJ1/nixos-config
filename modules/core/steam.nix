{ pkgs, super, ... }:
{
  # Drop this override once the fix PR lands in nixos-unstable.
  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;

      gamescopeSession.enable = true;

      extraCompatPackages = [
        pkgs.proton-ge-bin
        pkgs.icu
      ];
    };

    gamescope = {
      enable = true;
      capSysNice = false;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };

    # gamemoderun is only useful if gamemoded is actually running; the package
    # alone leaves the daemon disabled. GPU optimisations are AMD/NVIDIA-only,
    # so on Intel this buys governor/scheduler/IO priority and screensaver inhibit.
    # pin_cores is set explicitly: gamemode's Intel autodetection was pinning to
    # 0-19 (P+E), which puts game threads on the much slower E-cores.
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general.renice = 0;
        cpu.pin_cores = "0-11";
      };
    };
  };
}
