{ inputs, pkgs, ... }:
{
  sops.defaultSopsFile = ./../../../secrets/ace-secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.sshKeyPaths = [ "/etc/ssh/id_absolutecinema" ];
  sops.age.generateKey = true;
  sops.secrets.syncthing_id_z13 = { };
  sops.secrets.syncthing_cert_absolutecinema = { };
  sops.secrets.syncthing_key_absolutecinema = { };
  sops.secrets.syncthing_cert_z13 = { };
  sops.secrets.syncthing_key_z13 = { };
  sops.secrets.syncthing_cert_primeincarnon = { };
  sops.secrets.syncthing_key_primeincarnon = { };
}
