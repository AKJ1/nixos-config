{ pkgs, host, ... }:
{
  home.packages = with pkgs; [
    syncthingtray
  ];

  imports = [
    ./syncthing.${host}.nix
  ];

  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        "pixel9pro" = {
          id = "U2EDJHT-HENOUG2-RW52NBD-DY3OLG7-KHK2RKN-3RC5JLR-76GOAGD-XFP5XQF";
        };
        "primeincarnon" = {
          id = "DXFAEPV-Q6S7EK5-6CC6PDC-MVLA3IG-RCPZPR6-LN3O2WG-H4QKNCW-PDI7XQG";
        };
        "z13" = {
          id = "7GZC2ZZ-XQFNPJV-7R4HGDR-AKN3LI2-BOTNUIM-VLTXK5B-IGBGOKL-TTOK3QL";
        };
        "absolutecinema" = {
          id = "WQSV2AV-AZXI5RB-TZ72H2G-MSVMNSX-M6ZPFMU-QMMQWMB-35MUTUV-TTV6AAB";
        };
        "homeserver" = {
          id = "DEVICE-ID-GOES-HERE";
        };
      };
      folders = {
        "Documents" = {
          path = "/home/ace/Documents";
          devices = [
            "pixel9pro"
            "absolutecinema"
            "primeincarnon"
          ];
        };
        "Photos" = {
          path = "/home/myusername/Example";
          devices = [
            "pixel9pro"
            "absolutecinema"
            "primeincarnon"
          ];
          # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          ignorePerms = false;
        };
        "Addons" = {
          path = "/home/ace/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_/WTF";
          devices = [
            "primeincarnon"
            "absolutecinema"
          ];
        };
      };
    };
  };
}
