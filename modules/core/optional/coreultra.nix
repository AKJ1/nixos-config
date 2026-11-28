{ pkgs, ... }:
{
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;
  services.lact.enable = true;
  programs.corectrl.enable = true;
}
