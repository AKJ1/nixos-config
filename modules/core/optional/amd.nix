{pkgs, ...}:
{
    hardware.graphics.extraPackages = with pkgs; [
      mesa
      libva
      libva-utils
    ];
    
    environment.systemPackages = with pkgs; [
      rocmPackages.clr
      clinfo
      lact
      mangohud
    ];
    
    programs.corectrl.enable = true;
}
