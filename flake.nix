{
  description = "Ace's modified nixos configuration (based on FrostPhoenix)";

  inputs = {
    # release-26.11 pinned to a rev Hydra has finished building (the branch tip
    # is binary-cache-cold for days, incl. libreoffice/texlive → hours of local
    # compiles). fzf here is 0.75.0, which home-manager's fzf module asserts
    # (>=0.73) when nushell integration is on — 26.05's 0.72.0 fails that.

    nixpkgs.url = "github:NixOS/nixpkgs/390a25727ab14d1a6bfc9a392556cecd84d97b2b";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Pinned for orca-slicer 2.4.1 (last revision before the 2.4.2 bump, which is broken)
    orca-pkgs.url = "github:NixOS/nixpkgs/138998ca74d541ca9410f5823c07d25dc44b9267";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri/main";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    luciole.url = "github:noctalia-dev/luciole/cachix";
    # Pinned community plugin source: avoids the runtime git fetch that races
    # with network availability at login and leaves plugin bar widgets missing.
    noctalia-plugins = {
      url = "github:noctalia-dev/community-plugins";
      flake = false;
    };

    herdr.url = "github:AKJ1/herdr-app/nix-flake";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    matcha.url = "github:floatpane/matcha";
    handy.url = "github:cjpais/Handy";
    battlenet-umu.url = "github:jacobjdowning/battlenet-umu";

    waybar.url = "github:Alexays/Waybar";
    nur.url = "github:nix-community/NUR";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-colors.url = "github:misterio77/nix-colors";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    #omp
    oh-my-pi.url = "github:can1357/oh-my-pi";

    # omp-adapted fork of obra/superpowers; matches the installed 7.0.2-omp.3
    omp-superpowers = {
      url = "github:LoneExile/omp-superpowers/v7.0.2-omp.3";
      flake = false;
    };

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
    areofyl-fetch.url = "github:areofyl/fetch";
    nvf.url = "github:notashelf/nvf";
  };

  outputs =
    {
      nixpkgs,
      unstable,
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
        # `inputs.unstable.legacyPackages.<system>` instantiates nixpkgs with the
        # *default* config (allowUnfree = false, no overlays), so anything taken
        # from it bypasses `nixpkgs.config` — e.g. lutris pulling in steam dies
        # with "Refusing to evaluate package 'steam-...' unfreeRedistributable"
        # even though system.nix sets allowUnfree. Re-instantiate unstable with
        # the config of the evaluated package set and use `pkgs.unstable.<pkg>`.
        (final: _prev: {
          unstable = import inputs.unstable {
            system = final.stdenv.hostPlatform.system;
            config = final.config;
          };
        })
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
              unstable
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
              unstable
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
