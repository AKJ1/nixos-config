{ inputs, pkgs, ... }:
{
  sops.defaultSopsFile = ./../../secrets/ace-secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.sshKeyPaths = [ "/etc/ssh/id_absolutecinema" ];
  sops.age.generateKey = true;
  sops.secrets.syncthing_id_z13 = { };
}
