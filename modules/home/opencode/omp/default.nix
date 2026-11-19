{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  yaml = pkgs.formats.yaml { };

  overlaySettings = {
    modelRoles.default = "opencode-go/deepseek-v4.1-flash";
    symbolPreset = "unicode";
    composer.shape = "band";
    theme = {
      dark = "titanium";
      light = "dark-forest";
    };
    memory.backend = "local";
    autolearn.enabled = false;
    defaultThinkingLevel = "auto";
    extensions = [ "${inputs.omp-superpowers}" ];
  };

  overlayFile = yaml.generate "omp-config.yml" overlaySettings;

  omp = pkgs.writeShellScriptBin "omp" ''
    export PI_CONFIG_FILES=${overlayFile}
    exec ${pkgs.omp}/bin/omp "$@"
  '';
in
{
  home.packages = [ omp ];
}
