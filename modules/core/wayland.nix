{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  programs.niri.enable = true;

  # Handy's handy-keys backend reads keyboards via evdev for real press/release
  # (push-to-talk) and grabs them to block the hotkey.
  #
  # The uaccess tag must be set before 73-seat-late.rules, which queues the ACL
  # builtin; services.udev.extraRules lands in 99-local.rules and is too late.
  # keyd and uinput virtual keyboards have no ID_SEAT, so the per-seat ACL is
  # never applied to them; pin seatless keyboards to seat0 first.
  hardware.uinput.enable = true;
  services.udev.packages = [
    (pkgs.writeTextDir "etc/udev/rules.d/72-handy-input.rules" ''
      SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_KEYBOARD}=="1", TAG+="uaccess"
      SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_KEYBOARD}=="1", ENV{ID_SEAT}=="", ENV{ID_SEAT}="seat0"
    '')
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
    };

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
