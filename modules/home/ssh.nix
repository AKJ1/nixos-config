{ ... }:
{
  programs.ssh = {
    enable = true;
    settings."*" = {
      AddKeysToAgent = "8h";
      ControlMaster = "auto";
      ControlPath = "~/.ssh/control-%r@%h:%p";
      ControlPersist = "10m";
    };

    matchBlocks = {
      github = {
        host = "github.com";
        hostname = "ssh.github.com";
        user = "git";
        port = 443;
        identityFile = "~/.ssh/id_github";
        identitiesOnly = true;
      };
      dockerhost = {
        host = "dockerhost";
        hostname = "192.168.1.151";
        user = "ace";
        port = 22;
      };
      mintyfresh = {
        host = "mintyfresh";
        hostname = "192.168.1.149";
        user = "ace";
        port = 22;
      };
    };
  };

  services.ssh-agent.enable = true;
}
