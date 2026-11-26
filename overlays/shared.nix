(self: super: {
  # gh: disable telemetry (https://cli.github.com/telemetry). Nixpkgs does not
  # disable it by default; wrap the binary so every invocation has the env var.
  gh = super.gh.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ super.makeWrapper ];
    postInstall = (old.postInstall or "") + ''
      wrapProgram $out/bin/gh --set GH_TELEMETRY false
    '';
  });

  pipewire-control-center = super.pipewire-control-center.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace pwctl/backend/chains.py \
        --replace-fail "/usr/bin/pipewire" "${super.pipewire}/bin/pipewire"
    '';
  });

  # openldap-2.6.13: the old `doCheck = false` override was here because the
  # syncreplication tests (test017/test019) failed on slow / sandboxed
  # builders. It is dropped now: nixos-26.11's openldap-2.6.13 is built by
  # Hydra with checks enabled and substitutes from cache. Keeping the override
  # would make openldap (and every dependent, e.g. libreoffice) cache-cold and
  # force multi-hour local builds. Re-add only if checks actually fail again.

  # xdg-desktop-portal-1.20.4: two integration tests fail in the Nix build
  # sandbox because the validator helpers (xdg-desktop-portal-validate-sound
  # and -validate-icon) shell out to bwrap, which tries to create a nested
  # user namespace and trips on:
  #     bwrap: Can't mount proc on /newroot/proc: Operation not permitted
  # The failures:
  #   - integration/dynamiclauncher (exit status 1)
  #   - integration/notification    (pytest test_sound_fd: "invalid sound:
  #                                  The sound data is invalid (36)" because
  #                                  the validator subprocess died)
  # Same family as openldap/fwupd above — environment-driven, not a real
  # package bug. Affects the gaming Linux hosts (CauldronLake / BrightFalls)
  # that pull xdg-desktop-portal in via their desktop closure.
  #
  # Skipping the check phase until upstream nixpkgs ships a fix. The closest
  # tracking issue is open with no comments and was filed for a different
  # trigger (a custom enableGeoLocation override), but the failing test is
  # the same one:
  #   Issue: https://github.com/NixOS/nixpkgs/issues/511228 (OPEN)
  # Drop this override once nixos-unstable ships an xdg-desktop-portal whose
  # checkPhase passes inside the build sandbox.
  xdg-desktop-portal = super.xdg-desktop-portal.overrideAttrs (_: {
    doCheck = false;
  });

  # kernel 7.3 + nixpkgs' deterministic module signing (`kmodigest`, see
  # pkgs/os-specific/linux/kernel/common-flags.nix): every module now ships a
  # `<module>.ko.cer` certificate sidecar, which `system.modulesTree` merges
  # into the kernel's `modules.cer`. Out-of-tree `acpi-call` still copies a
  # bare, unsigned `acpi_call.ko` out of its build tree, so the modules tree
  # build dies with:
  #     cat: misc/acpi_call.ko.cer: No such file or directory
  # Install through the kernel's `modules_install` target instead, which runs
  # the `cmd_sign` hook and installs the certificate alongside the module.
  # `modules/core/bootloader.nix` pins every host to `linuxPackages_latest`,
  # and most hosts load `acpi_call` via `boot.kernelModules`.
  linuxPackages_latest = super.linuxPackages_latest.extend (
    _lpFinal: lpPrev: {
      acpi_call = lpPrev.acpi_call.overrideAttrs (_: {
        # Drop upstream's installPhase (a bare `install acpi_call.ko`) so the
        # generic builder runs `make modules_install` instead.
        installPhase = null;
        installFlags = [
          "-C"
          "${lpPrev.kernel.dev}/lib/modules/${lpPrev.kernel.modDirVersion}/build"
          "M=$(sourceRoot)"
          "INSTALL_MOD_PATH=${placeholder "out"}"
          "INSTALL_MOD_DIR=misc"
        ];
        installTargets = [ "modules_install" ];
        # make resolves `$(sourceRoot)` after `-C`-ing into the kernel build
        # directory, so it has to be exported as an absolute path.
        preInstall = ''export sourceRoot="$PWD"'';
        postInstall = ''
          install -D -m755 examples/turn_off_gpu.sh $out/bin/test_discrete_video_off.sh
        '';
      });
    }
  );
})
