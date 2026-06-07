{ config, ... }:
{
  services.syncthing = {
    key = "${config.sops.secrets.syncthing_key_absolutecinema.path}";
    cert = "${config.sops.secrets.syncthing_cert_absolutecinema.path}";
  };
}
