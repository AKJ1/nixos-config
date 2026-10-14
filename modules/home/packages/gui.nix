{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    audacity
    gimp
    obs-studio
    pavucontrol
    soundwireserver
    video-trimmer
    vlc
    ipmiview
    ipmitool
    ipmicfg
    ipmiutil
    alsa-scarlett-gui
    easyeffects
    ## Office
    inputs.stablepkgs.legacyPackages.${pkgs.system}.libreoffice-still
    gnome-calculator
    ## Utility
    dconf-editor
    gnome-disk-utility
    mission-center # GUI resources monitor
    zenity

    ## Level editor
    ldtk
    tiled

    inputs.photocraft.packages.${pkgs.system}.default
  ];
}
