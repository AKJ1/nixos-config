{ inputs, pkgs, ... }:
let
  # Upstream only focuses the notification's sender window when the
  # notification has no default action. Nearly every application sets one, and
  # niri does not switch to the window's workspace when that action is invoked,
  # so clicking a notification appears to do nothing.
  noctalia-shell = inputs.noctalia.packages.${pkgs.system}.default.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./focus-sender-on-notification-click.patch ];
  });
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    package = noctalia-shell;
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
        fontDefault = "IBM Plex Sans Condensed";
        fontFixed = "IBM Plex Mono";
      };
      colorSchemes = {
        useWallpaperColors = true;
        predefinedScheme = "Rosepine";
        darkMode = true;
        generationMethod = "tonal-spot";
      };
      templates = {
        activeTemplates = [
          {
            "enabled" = true;
            "id" = "ghostty";
          }
          {
            "enabled" = true;
            "id" = "gtk";
          }
          {
            "enabled" = true;
            "id" = "zenBrowser";
          }
          {
            "enabled" = true;
            "id" = "pywalfox";
          }
          {
            "enabled" = true;
            "id" = "niri";
          }
          {
            "enabled" = true;
            "id" = "steam";
          }
          {
            "enabled" = true;
            "id" = "vicinae";
          }
          # {
          #   "enabled" = true;
          #   "id" = "code";
          # }
          {
            "enabled" = true;
            "id" = "yazi";
          }
          {
            "enabled" = true;
            "id" = "kcolorscheme";
          }
          {
            "enabled" = true;
            "id" = "telegram";
          }
          {
            "enabled" = true;
            "id" = "mango";
          }
          {
            "enabled" = true;
            "id" = "qt";
          }
          {
            "enabled" = true;
            "id" = "discord";
          }
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

  # Wire noctalia into niri session startup
  systemd.user.targets.niri-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
}
