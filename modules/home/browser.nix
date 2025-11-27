{ inputs, pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      inputs.zen-browser.packages."${system}".default
      {
        extraEnv = {
          __NV_PRIME_RENDER_OFFLOAD = 1;
          __GLX_VENDOR_LIBRARY_NAME = nvidia;
          __VK_LAYER_NV_optimus = NVIDIA_only;
        };
      }
    ]
  );
}
