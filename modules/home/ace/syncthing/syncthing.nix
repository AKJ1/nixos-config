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
          id = "JCZACPW-OQY6IYB-IBTQV7L-KKESAID-RFCQB6F-T7UOD75-66NNXOD-ACA7VA4";
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
          path = "/home/ace/Documents/Shared";
          id = "oymsc-ynvyk";
          devices = [
            "z13"
            "pixel9pro"
            "absolutecinema"
            "primeincarnon"
          ];
        };
        "Photos" = {
          path = "/home/ace/Pictures/Pixel9ProCam";
          id = "pixel_9_pro_xemv-photos";
          # type = "receive"; # Don't allow deletions to interfere with device storage.
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
