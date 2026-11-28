{
  config,
  pkgs,
  lib,
  host,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    (pkgs.writeShellApplication {
      name = "sysbrowser";
      text = "${inputs.zen-browser.packages.${pkgs.system}.default}/bin/zen-beta";
    })
    (pkgs.writeShellApplication {
      name = "systerm";
      text = "${pkgs.ghostty}/bin/ghostty";
    })
    nirimod
    adw-gtk3
    nwg-look
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
    # python3
    python313Packages.pygobject3
    # python313Packages.pygobject

    xwayland-satellite
    swayimg
    rose-pine-cursor
    nemo
    fuzzel
    gpu-screen-recorder
    wl-clipboard
    libsForQt5.qt5ct
    libsForQt5.qtgraphicaleffects
    qt6.qt5compat
    # pywal
    # pywalfox-native
    adw-gtk3
    nwg-look

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
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
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
    # platformTheme.name = "qt6ct";
    # style.name = "Fusion";
  };

  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/modules/home/niri/config/${host}.kdl";

  # xdg.configFile = {
  # "niri/config.kdl" = {
  #   source = niriConfig;
  #   # onChange = ''notify-send "Niri config reloaded"'';
  # };
  # "niri/noctalia.kdl".source = ../noctalia/config/noctalia.kdl;
  # "ghostty/config".source = ../config/ghostty/tokyo-night.ghostty;
  # };

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
    QS_ICON_THEME = "Papirus-Dark";
  };
}
