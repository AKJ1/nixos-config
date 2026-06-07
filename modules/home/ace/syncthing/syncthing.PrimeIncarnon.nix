{ config, ... }:
{
  services.syncthing = {
    key = "${config.sops.secrets.syncthing_key_primeincarnon.path}";
    cert = "${config.sops.secrets.syncthing_cert_primeincarnon.path}";
  };
}
