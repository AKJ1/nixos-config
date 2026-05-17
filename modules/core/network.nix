{ pkgs, host, ... }:
{
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    extraHosts = "192.168.1.1 routerlogin.net\n";
    nameservers = [
      "192.168.1.1"
      # "1.1.1.1"
      # "8.8.4.4"
      # "8.8.8.8"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        59010
        59011
      ];
      allowedUDPPorts = [
        59010
        59011
      ];
    };
  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
