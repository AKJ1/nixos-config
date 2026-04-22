{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    swww
    grimblast
    hyprpicker
    grim
    slurp
    wl-clip-persist
    cliphist
    wf-recorder
    glib
    wayland
    direnv
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    # package = inputs.self.packages.${pkgs.system}.hyprland-with-plugins;
    portalPackage = null;

    xwayland = {
      enable = true;
      #hidpi = true;
    };
    systemd.enable = true;
  };
}
