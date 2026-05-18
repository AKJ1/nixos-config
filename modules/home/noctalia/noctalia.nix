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
        # suspendTimeout = 1800;
        fadeDuration = 10;
      };

      dock = {
        enabled = false;
      };

      ui = {
        fontDefault = "IBM Plex Sans Cond Text";
      };
      colorSchemes.predefinedScheme = "Catpuccin Lavender";
      templates = {
        activeTemplates = [
          "discord"
          "zen-browser"
          "niri"
          "vicinae"
          "steam"
          "ghostty"
        ];
        enableUserTheming = false;
      };

      # Bar configuration
      bar = {
        position = "top";
        density = "default";
        showCapsule = true;
        widgets = {
          right = [
            {
              id = "Tray";
              drawerEnabled = true;
            }
            {
              id = "NotificationHistory";
              showUnreadBadge = true;
              unreadBadgeColor = "primary";
            }
            {
              id = "Battery";
              hideIfIdle = false;
              hideIfNotDetected = true;
              deviceNativePath = "__default__";
              displayMode = "graphic-clean";
            }
            {
              id = "Volume";
              displayMode = "onhover";
              middleClickCommand = "pwvucontrol || pavucontrol";
            }
            {
              id = "Brightness";
              displayMode = "onhover";
            }
            {
              id = "plugin:network-manager-vpn";
            }
            {
              id = "plugin:screen-toolkit";
            }
            {
              id = "plugin:mini-docker";
            }
            {
              id = "plugin:wallcards";
            }
            {
              id = "ControlCenter";
              icon = "noctalia";
            }
          ];
        };
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
  home.packages = [
    inputs.noctalia.packages.${pkgs.system}.default
  ];

  # Wire noctalia into niri session startup
  systemd.user.targets.niri-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
}
