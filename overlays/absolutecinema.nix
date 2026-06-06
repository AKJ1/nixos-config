(
  final: super:
  let
    bubblewrap_legacy = super.bubblewrap.overrideAttrs (old: {
      name = "bubblewrap-0.10.0";
      src = super.fetchzip {
        url = "https://github.com/containers/bubblewrap/archive/refs/tags/v0.10.0.tar.gz";
        hash = "sha256-HYJoX7DnAwHCgxCzTYGJlc4RodbVP6hutK065AmGSl0=";
      };
      version = "0.10.0";
      NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or [ ]) ++ [ "-std=gnu17" ];
    });
    fhsenv_legacy = super.buildFHSEnv.override { bubblewrap = bubblewrap_legacy; };
  in
  {
    rocmPackages = super.rocmPackages // rec {
      clr =
        (super.rocmPackages.clr.override {
          localGpuTargets = [ "gfx1200" ]; # 9060XT = gfx1200, 6800xt = gfx1030
        }).overrideAttrs
          (oldAttrs: {
            passthru = oldAttrs.passthru // {
              gpuTargets = oldAttrs.passthru.gpuTargets ++ [ "gfx1200" ]; # 9060XT = gfx1200, 6800xt = gfx1030
            };
          });

      rocminfo = (
        super.rocmPackages.rocminfo.override {
          clr = clr;
        }
      );

      rocblas = (
        super.rocmPackages.rocblas.override {
          clr = clr;
        }
      );

      rocsparse = (
        super.rocmPackages.rocsparse.override {
          clr = clr;
        }
      );

      rocsolver = (
        super.rocmPackages.rocsolver.override {
          clr = clr;
        }
      );
    };
    steam = super.steam.override {
      buildFHSEnv = fhsenv_legacy;
    };
  }
)
