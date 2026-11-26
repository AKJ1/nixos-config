{ pkgs, host, ... }:
let
  # keyd only ever reads /etc/keyd (CONFIG_DIR is compiled in; there is no
  # --config-dir flag and no XDG lookup), so this must be a system config.
  conf = if host == "xps9340" then ./xps9340.conf else ./base.conf;
in
{
  environment.systemPackages = with pkgs; [
    keyd
  ];

  services.keyd.enable = true;

  environment.etc."keyd/default.conf".source = conf;

  # services.keyd only auto-restarts on keyboards.<name> changes, which we
  # bypass by installing the conf file directly.
  systemd.services.keyd.restartTriggers = [ conf ];

  # libinput quirk for palm rejection with keyd virtual keyboard
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
