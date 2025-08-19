{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  unstable = import (fetchTarball {
    url = "https://github.com/nixos/nixpkgs/tarball/fbcf476f790d8a217c3eab4e12033dc4a0f6d23c";
    sha256 = "sha256-wNO3+Ks2jZJ4nTHMuks+cxAiVBGNuEBXsT29Bz6HASo=";
  }) { };

  cfg = {
    enable = true;
    package = vicinae;
    autoStart = true;
  };

  vicinae = pkgs.stdenv.mkDerivation rec {
    pname = "vicinae";
    version = "0.2.1";

    src = pkgs.fetchurl {
      url = "https://github.com/vicinaehq/vicinae/releases/download/v${version}/vicinae-linux-x86_64-v${version}.tar.gz";
      sha256 = "sha256-736602fe2db2ba5dc829ab147b12ab5b4a3cec713c5fad1a073912f88ee79d02";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      qt6.wrapQtAppsHook
    ];
    buildInputs = with pkgs; [
      qt6.qtbase
      qt6.qtsvg
      qt6.qttools
      qt6.qtwayland
      qt6.qtdeclarative
      qt6.qt5compat
      kdePackages.qtkeychain
      kdePackages.layer-shell-qt
      openssl
      cmark-gfm
      libqalculate
      minizip
      stdenv.cc.cc.lib
      unstable.abseil-cpp
      protobuf
    ];

    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share/applications
      cp bin/vicinae $out/bin/
      cp share/applications/vicinae.desktop $out/share/applications/
      chmod +x $out/bin/vicinae
    '';

    meta = {
      description = "A focused launcher for your desktop — native, fast, extensible";
      homepage = "https://github.com/vicinaehq/vicinae";
      license = pkgs.lib.licenses.gpl3;
      maintainers = [ ];
      platforms = pkgs.lib.platforms.linux;
    };
  };
in
{
  options.services.vicinae = {
    enable = mkEnableOption "vicinae launcher daemon" // {
      default = true;
    };

    package = mkOption {
      type = types.package;
      default = vicinae;
      defaultText = literalExpression "vicinae";
      description = "The vicinae package to use.";
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start the vicinae daemon automatically on login.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.vicinae = {
      Unit = {
        Description = "Vicinae launcher daemon";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/vicinae server";
        Restart = "on-failure";
        RestartSec = 3;
        Environment = [
          "PATH=${pkgs.lib.makeBinPath [ cfg.package ]}"
        ];
      };

      Install = mkIf cfg.autoStart {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
