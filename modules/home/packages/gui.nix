{
  pkgs,
  inputs,
  unstable,
  ...
}:
{
  home.packages = with pkgs; [
    ## Multimedia
    audacity
    # gimp
    obs-studio
    pavucontrol
    video-trimmer
    vlc
    ipmiview
    ipmitool
    ipmicfg
    ipmiutil
    alsa-scarlett-gui
    ## Utility
    dconf-editor
    gnome-disk-utility
    mission-center # GUI resources monitor
    zenity

    ## Level editor
    # ldtk
    # tiled
    inputs.photocraft.packages.${pkgs.system}.default
    qbittorrent
    inputs.luciole.packages.${pkgs.system}.default
  ];

}
