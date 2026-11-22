{ pkgs, ... }:
{
  programs.vscodium = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "codium-wrapped";
      paths = [ pkgs.vscodium ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/codium \
          --prefix LD_LIBRARY_PATH : ${pkgs.stdenv.cc.cc.lib}/lib
      '';
    };
  };
}
