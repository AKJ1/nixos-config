{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    keyd
  ];

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [
          "25a7:fa7b:f1066c13"
          "m:25a7:fa7c"
          "*"
        ];
        settings = {
          main = {
            # Mouse4: tap = M4, hold >200ms = SUPER (meta layer)
            mouse2 = "overload(meta, mouse2)";
          };
        };
      };
    };
  };

  # libinput quirk for palm rejection with keyd virtual keyboard
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
