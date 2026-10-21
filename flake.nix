{
  description = "Ace's modified nixos configuration (based on FrostPhoenix)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hermes-agent.url = "github:NousResearch/hermes-agent";
    stablepkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # Pinned for orca-slicer 2.4.1 (last revision before the 2.4.2 bump, which is broken)
    orca-pkgs.url = "github:NixOS/nixpkgs/138998ca74d541ca9410f5823c07d25dc44b9267";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri/main";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    matcha.url = "github:floatpane/matcha";
    handy.url = "github:cjpais/Handy";

    waybar.url = "github:Alexays/Waybar";
    nur.url = "github:nix-community/NUR";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-colors.url = "github:misterio77/nix-colors";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    #omp
    oh-my-pi.url = "github:can1357/oh-my-pi";

    #craftapps
    photocraft.url = "github:makemake-kbo/photocraft";

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    zig.url = "github:mitchellh/zig-overlay";
    vicinae.url = "github:vicinaehq/vicinae";

    nvf.url = "github:notashelf/nvf";
  };

  outputs =
    {
      nixpkgs,
      stablepkgs,
      self,
      sops-nix,
      nix-vscode-extensions,
      ...
    }@inputs:
    let
      username = "ace";
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      baseOverlays = [
        inputs.nur.overlays.default
        inputs.nix-vscode-extensions.overlays.default
        (import ./overlays/shared.nix)
      ];
    in
    {
      nixosConfigurations = {
        AbsoluteCinema = lib.nixosSystem {
          inherit system;
          modules = [
            { nixpkgs.overlays = baseOverlays ++ [ (import ./overlays/absolutecinema.nix) ]; }
            ./hosts/desktop-AbsoluteCinema
          ];
          specialArgs = {
            host = "AbsoluteCinema";
            inherit
              self
              inputs
              username
              stablepkgs
              ;
          };
        };

        PrimeIncarnon = lib.nixosSystem {
          inherit system;
          modules = [
            { nixpkgs.overlays = baseOverlays ++ [ (import ./overlays/primeincarnon.nix) ]; }
            ./hosts/desktop-PrimeIncarnon
          ];
          specialArgs = {
            host = "PrimeIncarnon";
            inherit
              self
              inputs
              username
              stablepkgs
              ;
          };
        };
        p1g7 = lib.nixosSystem {
          inherit system;
          modules = [
            { nixpkgs.overlays = baseOverlays ++ [ (import ./overlays/p1g7.nix) ]; }
            ./hosts/p1g7
          ];
          specialArgs = {
            host = "p1g7";
            inherit self inputs username;
          };
        };
        z13 = lib.nixosSystem {
          inherit system;
          modules = [
            { nixpkgs.overlays = baseOverlays ++ [ (import ./overlays/z13.nix) ]; }
            ./hosts/z13
          ];
          specialArgs = {
            host = "z13";
            inherit self inputs username;
          };
        };
        xps9340 = lib.nixosSystem {
          inherit system;
          modules = [
            { nixpkgs.overlays = baseOverlays ++ [ (import ./overlays/xps9340.nix) ]; }
            ./hosts/xps9340
          ];
          specialArgs = {
            host = "xps9340";
            inherit self inputs username;
          };
        };
      };
    };
}
