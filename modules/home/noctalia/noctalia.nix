{ inputs, pkgs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      idle = {
        enabled = true;
        screenOffTimeout = 180;
        lockTimeout = 180;
        suspendTimeout = 1800;
        fadeDuration = 10;
      };

      dock = {
        enabled = false;
      };

      ui = {
        fontDefault = "IBM Plex Sans Cond Text";
      };

      templates = {
        activeTemplates = ["discord" "zen-browser" "niri" "vscode" "vicinae" "steam" "ghostty"];
        enableUserTheming = false;
      };

      # Bar configuration
      bar = {
        position = "top";
        density = "default";
        showCapsule = true;
      };

      # General UI settings
      general = {
        allowPasswordWithFprintd = false;
        radiusRatio = 1;
        scaleRatio = 1.3;
        animationSpeed = 1.5;
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
