{ pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;

    settings = {
      listener = [
        {
          timeout = 180; # 3 minutes in seconds
          on-timeout = "${pkgs.hyprutils}/bin/hyprctl dispatch dpms off";
        }
        {
          timeout = 181;
          on-resume = "${pkgs.hyprutils}/bin/hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
