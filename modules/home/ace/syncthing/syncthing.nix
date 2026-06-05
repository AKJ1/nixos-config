{ pkgs, host, ... }:
{
  environment.systemPackages = with pkgs; [
    syncthing
    syncthingtray
  ];

  imports = [
    ./syncthing.
    "host".nix
  ];

  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        "pixel9pro" = {
          id = "DEVICE-ID-GOES-HERE";
        };
        "PrimeIncarnon" = {
          id = "DEVICE-ID-GOES-HERE";
        };
        "z13" = {
          id = "DEVICE-ID-GOES-HERE";
        };
        "absolutecinema" = {
          id = "DEVICE-ID-GOES-HERE";
        };
        "homeserver" = {
          id = "DEVICE-ID-GOES-HERE";
        };
      };
      folders = {
        "Documents" = {
          path = "/home/ace/Documents";
          devices = [
            "device1"
            "device2"
          ];
        };
        "Photos" = {
          path = "/home/myusername/Example";
          devices = [ "device1" ];
          # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          ignorePerms = false;
        };
        "Addons" = {
          path = "/home/ace/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_/WTF";
          devices = [
            "PrimeIncarnon"
          ];
        };
        "Sensitive" = {
          path = "/home/myusername/Sensitive";
          devices = [
            # We trust this device to have access
            # to the decrypted contents of this folder.
            "device1"
            # We do not trust this device, but we want to have another
            # (encrypted) copy of the data for redundancy/backup/sync purposes.
            {
              name = "device2";
              # encryptionPasswordFile is a path to a file containing the encryption password.
              # See below for information about managing secrets on NixOS.
              encryptionPasswordFile = "/run/secrets/st-sensitive-password";
            }
          ];
        };
      };
    };
  };
}
