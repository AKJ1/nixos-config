{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  zenPref = "user_pref(\"browser.link.open_newwindow.override.external\", 3);";
in
{
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
    firefox
    google-chrome
    jellyfin-desktop
  ];

  home.activation.zenBrowserExternalLinks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PROFILES_INI="$HOME/.zen/browser/profiles.ini"
    if [ -f "$PROFILES_INI" ]; then
      PROFILE_PATH=$("${pkgs.gawk}/bin/awk" -F= '
        /^\[Profile[0-9]+\]/ { profile_num = $0; gsub(/^\[|\]$/, "", profile_num) }
        /^Default=1$/ { default_num = profile_num }
        /^Path=/ && profile_num == default_num { path = substr($0, 6) }
        END { if (path) print path }
      ' "$PROFILES_INI")

      if [ -n "$PROFILE_PATH" ]; then
        ZEN_PROFILE="$HOME/.zen/browser/$PROFILE_PATH"
        mkdir -p "$ZEN_PROFILE"
        printf '%s\n' '${zenPref}' > "$ZEN_PROFILE/user.js"
      fi
    fi
  '';
}

# let
#   zen-beta = pkgs.runCommand "zen-browser-offloaded" { buildInputs = [ pkgs.makeWrapper ]; } ''
#     mkdir -p $out/bin
#     # Copy everything from the original package
#     cp -r ${inputs.zen-browser.packages.${pkgs.system}.default}/bin $out/
#     cp -r ${inputs.zen-browser.packages.${pkgs.system}.default}/lib $out/ || true
#     cp -r ${inputs.zen-browser.packages.${pkgs.system}.default}/share $out/ || true

#     # Now wrap the binary
#     chmod +rwx $out/bin/zen-beta
#     makeWrapper $out/bin/zen-beta $out/bin/zen-beta \
#       --set __NV_PRIME_RENDER_OFFLOAD 1 \
#       --set __GLX_VENDOR_LIBRARY_NAME nvidia \
#       --set __VK_LAYER_NV_optimus NVIDIA_only

#   '';
# in
# {
#   home.packages = (
#     with pkgs;
#     [
#       zen-beta
#     ]
#   );
# }
