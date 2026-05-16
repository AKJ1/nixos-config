{ pkgs, ... }:
{
  programs.mouse-actions.enable = true;
  environment.systemPackages = with pkgs; [
    mouse-actions-gui
  ];
}
