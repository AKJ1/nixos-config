{ config, lib, ... }:
let
  userDir = "${config.xdg.configHome}/VSCodium/User";
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
}
