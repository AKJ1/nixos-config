{ inputs, pkgs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      # Theme configuration
      colorSchemes.predefinedScheme = "Noctalia (default)";

      # Bar configuration
      bar = {
        position = "top";
        density = "default";
        showCapsule = true;
      };

      # General UI settings
      general = {
        radiusRatio = 1;
        animationSpeed = 1;
        enableBlurBehind = true;
        enableShadows = true;
      };

      # Notifications
      notifications = {
        enabled = true;
        location = "top_right";
      };

      # OSD (On-Screen Display) for brightness/volume
      osd = {
        enabled = true;
        location = "top_right";
      };
    };
  };

  # Ensure noctalia-shell is available in home packages
  home.packages = with pkgs; [
    inputs.noctalia.packages.${pkgs.system}.default
  ];

  # Wire noctalia into niri session startup
  systemd.user.targets.niri-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
    "noctalia-shell.service"
  ];
}
