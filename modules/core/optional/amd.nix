{ pkgs, ... }:
{

  # hardware.graphics.extraPackages = with pkgs; [
  #   rocmPackages.clr.icd
  # ];

  # nixpkgs.overlays = [
  #   (self: super: {
  #     rocmPackages = super.rocmPackages.overrideScope (
  #       fs: ps: {
  #         clr = ps.clr.override {
  #           localGPUTargets = [ "gfx1200" ]; # on hardware change, add more targets.h
  #         };
  #       }
  #     );
  #   })
  # ];
}
