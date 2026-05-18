{ pkgs, ... }:
{
  systemd.user.services.wl-gammarelay-rs = {
    Unit = {
      Description = "Wayland gamma relay - software brightness and temperature control";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.wl-gammarelay-rs}/bin/wl-gammarelay-rs";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install = {
      WantedBy = [ "niri-session.target" ];
    };
  };
}
