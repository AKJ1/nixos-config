{
  config,
  pkgs,
  lib,
  host,
  inputs,
  ...
}:
let
  terminal = "${pkgs.ghostty}/bin/ghostty";
  browser = "${inputs.zen-browser.packages.${pkgs.system}.default}/bin/zen-beta";

  kdlTemplate = builtins.readFile ./config/${host}.kdl;

  niriConfig = pkgs.writeText "niri-config.kdl" (
    lib.replaceStrings [ "@terminal@" "@browser@" ] [ terminal browser ] kdlTemplate
  );
in
{

  home.packages = with pkgs; [
    hyprpicker
    wl-clipboard
    imagemagick
    mpvpaper
    zbar
    curl
    translate-shell
    wl-screenrec
    ffmpeg
    gifski
    jq
    python3
    python3Packages.pygobject3
    # python3Packages.pygobject

    xwayland-satellite
    tokyonight-gtk-theme
    swayimg
    rose-pine-cursor
    nemo
    fuzzel
    gpu-screen-recorder
    wl-clipboard
    libsForQt5.qt5ct
    mpvpaper
    grim # screensht
    slurp # region select
    satty
    wl-clip-persist
    cliphist # clipboard history
  ];

  systemd.user.targets.niri-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    font = {
      name = "IBM Plex Sans Condensed";
      size = 12;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "black"; };
    };
    cursorTheme = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
    };

    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = true;
    };

    gtk4.extraConfig = {
      "gtk-application-prefer-dark-theme" = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "Fusion";
  };

  xdg.configFile = {
    "gtk-3.0/settings.ini".force = true;
    "gtk-4.0/settings.ini".force = true;
    "niri/config.kdl" = {
      source = niriConfig;
      onChange = ''notify-send "Niri config reloaded"'';
    };
    # "niri/noctalia.kdl".source = ../noctalia/config/noctalia.kdl;
    # "ghostty/config".source = ../config/ghostty/tokyo-night.ghostty;
  };

  home.pointerCursor = {
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "BreezeX-RosePine-Linux";
    XCURSOR_SIZE = "24";
    NIXOS_OZONE_WL = "1";
    # ICON_THEME = "Papirus";
    # QS_ICON_THEME = "Papirus";
  };
}
