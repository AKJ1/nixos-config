{pkgs, ...}:
{
    hardware.graphics.extraPackages = with pkgs; [
      mesa
      libva
      libva-utils
      vappiVdpau
    ];
    
    environment.systemPackages = with pkgs; [
      rocminfo
      clinfo
      lact
      mangohud
    ];
    
    programs.corectl.enable = true;
}
