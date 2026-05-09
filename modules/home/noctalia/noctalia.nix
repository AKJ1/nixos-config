{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    inputs.noctalia.packages.${pkgs.system}.default
  ];

  # Noctalia provides:
  # - Desktop shell integration
  # - Panel/status bar
  # - Notification daemon
  # - Lock screen integration
  # - OSD for brightness/volume control
  #
  # Note: Noctalia home-manager integration may not be available yet.
  # If there's a home-manager module, it should be imported here.
  # For now, we're just ensuring the Noctalia package is available
  # and can be launched as part of the session.
}
