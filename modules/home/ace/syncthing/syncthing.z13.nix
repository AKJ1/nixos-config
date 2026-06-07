{ config, ... }:
{
  services.syncthing = {
    key = "${config.sops.secrets.syncthing_key_z13.path}";
    cert = "${config.sops.secrets.syncthing_cert_z13.path}";
  };
}
