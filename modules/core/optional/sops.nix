{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops.secrets.ace-secrets = {
    format = "yaml";
    sopsFile = ./nixos-config/secrets/ace-secrets.yaml;
    key = "";
  };
  sops.defaultSopsFile = ../../../secrets/ace-secrets.yaml;
  sops.age.sshKeyPaths = [ "~/.ssh/id_absolutecinema" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
}
