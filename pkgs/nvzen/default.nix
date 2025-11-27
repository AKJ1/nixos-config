{
  config,
  inputs,
  pkgs,
  ...
}:

let
  zen-offloaded = pkgs.runCommand "zen-browser-offloaded" { buildInputs = [ pkgs.makeWrapper ]; } ''
    mkdir -p $out/bin
    # Copy everything from the original package
    cp -r ${inputs.zen-browser.packages.${pkgs.system}.default}/bin $out/
    cp -r ${inputs.zen-browser.packages.${pkgs.system}.default}/lib $out/ || true
    cp -r ${inputs.zen-browser.packages.${pkgs.system}.default}/share $out/ || true

    # Now wrap the binary
    makeWrapper $out/bin/zen-beta $out/bin/zen-beta \
      --set __NV_PRIME_RENDER_OFFLOAD 1 \
      --set __GLX_VENDOR_LIBRARY_NAME nvidia \
      --set __VK_LAYER_NV_optimus NVIDIA_only
  '';
in
{
  home.packages = [
    zen-offloaded
  ];
}
