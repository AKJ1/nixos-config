{
  pkgs,
  stablepkgs,
  inputs,
  username,
  host,
  displayConfig,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  environment.systemPackages = with pkgs; [
    sops
    ssh-to-age
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit
        inputs
        username
        host
        displayConfig
        ;
    };
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];
    users.${username} = {
      imports = (
        if (host == "AbsoluteCinema") then
          [ ./../home/default.AbsoluteCinema.nix ]
        else if (host == "PrimeIncarnon") then
          [ ./../home/default.PrimeIncarnon.nix ]
        else if (host == "p1g7") then
          [ ./../home/default.p1g7.nix ]
        else if (host == "z13") then
          [ ./../home/default.z13.nix ]
        else
          [ ./../home ]
      );
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
  nix.settings.allowed-users = [ "${username}" ];
}
