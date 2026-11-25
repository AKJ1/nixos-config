{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    ## Multimedia
    inputs.stablepkgs.legacyPackages.${pkgs.system}.audacity
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
    # stablepkgs.legacyPackages.${pkgs.system}.easyeffects
    ## Utility
    dconf-editor
    gnome-disk-utility
    mission-center # GUI resources monitor
    zenity

    ## Level editor
    ldtk
    tiled
    inputs.photocraft.packages.${pkgs.system}.default
    qbittorrent
  ];

}
