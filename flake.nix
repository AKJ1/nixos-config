{
  description = "Ace's modified nixos configuration (based on FrostPhoenix)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri/main";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar.url = "github:Alexays/Waybar";
    nur.url = "github:nix-community/NUR";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions/00e11463876a04a77fb97ba50c015ab9e5bee90d";

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
      nixpkgs-stable,
      self,
      nix-vscode-extensions,
      ...
    }@inputs:
    let
      username = "ace";
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "electron-36.9.5"
            "qtwebkit-5.212.0-alpha4"
            "libsForQt5"
          ];
        };
      };
      stablepkgs = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/desktop ];
          specialArgs = {
            host = "desktop";
            inherit self inputs username;
          };
        };
        p1g7 = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/p1g7 ];
          specialArgs = {
            host = "p1g7";
            inherit self inputs username;
          };
        };
        z13 = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/z13 ];
          specialArgs = {
            host = "z13";
            inherit self inputs username;
          };
        };
      };
    };
}
