{
  inputs,
  host,
  pkgs,
  ...
}:
{
  sops.defaultSopsFile = ./../../../secrets/ace-secrets.yaml;
  sops.age.keyFile = "/home/ace/.sops-nix/key.txt";
  sops.age.sshKeyPaths = [ ];
  sops.age.generateKey = true;
  sops.secrets.syncthing_cert_absolutecinema = { };
  sops.secrets.syncthing_key_absolutecinema = { };
  sops.secrets.syncthing_cert_z13 = { };
  sops.secrets.syncthing_key_z13 = { };
  sops.secrets.syncthing_cert_primeincarnon = { };
  sops.secrets.syncthing_key_primeincarnon = { };
}
