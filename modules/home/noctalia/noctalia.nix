{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    settings = {
      # ── Shell / appearance ────────────────────────────────────────────────
      shell = {
        font_family = "IBM Plex Sans Condensed";
        corner_radius_scale = 1.0;
        animation.speed = 1.5;
        panel = {
          transparency_mode = "soft";
          shadow = true;
        };
      };

      # ── Theme ─────────────────────────────────────────────────────────────
      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-tonal-spot";
        builtin = "Rosé Pine";

        templates = {
          enable_builtin_templates = true;
          builtin_ids = [
            "ghostty"
            "gtk3"
            "gtk4"
            "niri"
            "kcolorscheme"
            "mango"
            "qt"
          ];
          enable_community_templates = true;
          community_ids = [
            "zen-browser"
            "pywalfox"
            "steam"
            "vicinae"
            "yazi"
            "telegram"
            "discord"
          ];
        };
      };

      # ── Bar ───────────────────────────────────────────────────────────────
      bar.main = {
        position = "top";
        capsule = true;
        background_opacity = 0.93;
        # v4's default density was a 31px bar with ~9.9pt labels.
        thickness = 31;
        font_scale = 0.85;

        # v4 defaults that the old config inherited for the left/center lanes.
        start = [
          "launcher"
          "clock"
          "sysmon-cpu"
          "sysmon-temp"
          "sysmon-ram"
          "active_window"
          "media"
        ];
        center = [ "workspaces" ];
        end = [
          "tray"
          "notifications"
          "battery"
          "volume"
          "brightness"
          "vpn"
          "screen-toolkit"
          "docker"
          "wallpaper"
          "control-center"
        ];
      };

      widget = {
        launcher.glyph = "rocket";

        clock = {
          format = "{:%H:%M %a, %b %d}";
          tooltip_format = "{:%H:%M %a, %b %d}";
        };

        # v4's single SystemMonitor showed CPU usage, CPU temp and RAM.
        "sysmon-cpu" = {
          type = "sysmon";
          stat = "cpu_usage";
          font_family = "IBM Plex Mono";
        };
        "sysmon-temp" = {
          type = "sysmon";
          stat = "cpu_temp";
          font_family = "IBM Plex Mono";
        };
        "sysmon-ram" = {
          type = "sysmon";
          stat = "ram_used";
          font_family = "IBM Plex Mono";
        };

        media = {
          artist_first = true;
          max_length = 145;
        };

        workspaces = {
          label_source = "id";
          max_label_chars = 2;
          labels_only_when_occupied = true;
          show_icons = false;
        };

        tray.drawer = true;

        battery = {
          display_mode = "graphic";
          show_label = false;
          device = "auto";
        };

        volume = {
          peek = true;
          actions.middle = "exec pwvucontrol || pavucontrol";
        };

        brightness.peek = true;

        # v5 community ports of the v4 plugin widgets
        vpn.type = "andrewdems/vpn-manager:bar";
        "screen-toolkit".type = "alexander/screen-toolkit:widget";
        docker.type = "8bury/mini-docker:mini-docker";

        control-center.glyph = "noctalia";
      };

      # ── Idle ──────────────────────────────────────────────────────────────
      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "suspend"
        ];
        pre_action_fade_seconds = 10;

        behavior = {
          lock = {
            timeout = 180;
            action = "lock";
            enabled = true;
          };
          "screen-off" = {
            timeout = 180;
            action = "screen_off";
            enabled = true;
          };
          suspend = {
            timeout = 1800;
            action = "lock_and_suspend";
            enabled = true;
          };
        };
      };

      # ── Services ──────────────────────────────────────────────────────────
      dock.enabled = false;

      lockscreen.fingerprint = false;

      notification = {
        enable_daemon = true;
        position = "top_right";
      };

      osd.position = "top_right";

      plugins = {
        enabled = [
          "andrewdems/vpn-manager"
          "alexander/screen-toolkit"
          "8bury/mini-docker"
        ];
        # Read plugins from the pinned flake input instead of fetching the
        # community git source at every login.
        source = [
          {
            name = "community";
            kind = "path";
            location = "${inputs.noctalia-plugins}";
            enabled = true;
          }
        ];
      };
    };
  };
}
