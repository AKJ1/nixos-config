{ pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;

    listeners = [
      {
        timeout = 180; # 3 minutes in seconds
        onTimeout = "${pkgs.hyprutils}/bin/hyprctl dispatch dpms off";
      }
      {
        timeout = 181;
        onResume = "${pkgs.hyprutils}/bin/hyprctl dispatch dpms on";
      }
    ];
  };
}
