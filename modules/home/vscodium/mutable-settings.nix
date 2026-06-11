{
  config,
  pkgs,
  lib,
  ...
}:
let
  userDir = "${config.xdg.configHome}/VSCodium/User";
  # noctaliaExt = pkgs.nix-vscode-extensions.vscode-marketplace.noctalia.noctaliatheme;
in
{
  home.activation.vscodiumWritableSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for f in "${userDir}/settings.json" "${userDir}/keybindings.json"; do
      if [ -L "$f" ] && [ -e "$f" ]; then
        tmp="$(mktemp)"
        cp "$(readlink -f "$f")" "$tmp"
        mv "$tmp" "$f"
        chmod u+w "$f"
      fi
    done
  '';

  # home.activation.linkNoctaliaExtension = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   ext_target="$HOME/.vscode-oss/extensions/noctalia.noctaliatheme"

  #   # Only create if the Nix extension exists
  #   if [ -d "${noctaliaExt}" ]; then
  #     mkdir -p "$(dirname "$ext_target")"
  #     # Remove stale symlink or directory
  #     if [ -L "$ext_target" ] || [ -e "$ext_target" ]; then
  #       rm -rf "$ext_target"
  #     fi
  #     ln -sf "${noctaliaExt}" "$ext_target"
  #   fi
  # '';
}
