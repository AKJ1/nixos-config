{
  inputs,
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    grim # screenshot
    slurp # region select
    wl-clip-persist
    cliphist # clipboard history
  ];

  systemd.user.targets.niri-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
}
