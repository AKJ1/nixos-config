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
  };
}
