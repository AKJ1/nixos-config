{ config, pkgs, ... }:
{
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    ipp-usb.enable = true;

    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };

  };

  # Allow proprietary/unfree drivers
  nixpkgs.config.allowUnfree = true;

  # Enable the SANE framework and the brscan5 backend
  hardware.sane = {
    enable = true;
    brscan5 = {
      enable = true;
      netDevices = {
        CinemaMFD = {
          model = "DCP-L2622DW";
          ip = "192.168.1.2";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    simple-scan
    brscan5
  ];

  # Give your user scanner privileges
  users.users.ace.extraGroups = [
    "scanner"
    "lp"
  ];
}
