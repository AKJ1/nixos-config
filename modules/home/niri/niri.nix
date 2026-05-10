{
  config,
  pkgs,
  lib,
  hostName,
  ...
}:
let
  niriConfig = ./config/z13.kdl;
in
{

  home.packages = with pkgs; [
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
    "gtk-4.0/gtk.css".force = true;
    "niri/config.kdl".source = niriConfig;
    "niri/noctalia.kdl".source = ../noctalia/config/noctalia.kdl;
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
