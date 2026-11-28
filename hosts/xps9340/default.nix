{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
    ./../../modules/core/optional/bluetooth.nix
    ./../../modules/core/optional/printers.nix
    ./../../modules/core/optional/ssh.nix
    ./../../modules/core/optional/keyd
  ];
  _module.args.displayConfig = "1.5";

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    cpupower-gui
    powertop
  ];

  services = {
    power-profiles-daemon.enable = true;

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };

    # NOTE: no tlp.settings here — TLP is not enabled on this host, the dead
    # settings were only shadowing power-profiles-daemon, which owns
    # platform_profile (currently "performance").
  };

  powerManagement.cpuFreqGovernor = "performance";

  # power-profiles-daemon comes back as "balanced" on every boot, which drops
  # energy_performance_preference to balance_performance. Pin it to performance
  # on AC; still switchable at runtime from the shell/quick settings.
  systemd.services.ppd-performance = {
    description = "Default power-profiles-daemon to the performance profile";
    wantedBy = [ "multi-user.target" ];
    after = [ "power-profiles-daemon.service" ];
    wants = [ "power-profiles-daemon.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance";
    };
  };

  # ALSA state persistence restores with `alsactl restore -U`, which skips the
  # UCM BootSequence. On this machine that leaves the RT715 SDCA ADC muxes on
  # MIC1/MIC2 (headset jack) instead of the internal DMIC3/DMIC4, so the
  # onboard microphones capture silence. PipeWire owns audio here, so state
  # persistence is unnecessary; apply the correct routing explicitly instead.
  hardware.alsa.enablePersistence = lib.mkForce false;

  systemd.services.xps9340-internal-mic = {
    description = "Route XPS 9340 onboard microphones to DMIC3/DMIC4";
    wantedBy = [ "multi-user.target" ];
    wants = [ "sound.target" ];
    after = [ "sound.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "xps9340-internal-mic" ''
        set -eu
        amixer="${pkgs.alsa-utils}/bin/amixer"
        seq="${pkgs.coreutils}/bin/seq"
        sleep="${pkgs.coreutils}/bin/sleep"

        # ASoC may bind the SOF card after sound.target is reached.
        for _ in $($seq 1 30); do
          [ -e /proc/asound/sofsoundwire ] && break
          $sleep 1
        done
        if [ ! -e /proc/asound/sofsoundwire ]; then
          echo "sof-soundwire card not ready, skipping mic routing" >&2
          exit 1
        fi

        "$amixer" -c sofsoundwire sset 'rt714 ADC 22 Mux' 'DMIC3'
        "$amixer" -c sofsoundwire sset 'rt714 ADC 23 Mux' 'DMIC4'
      '';
    };
  };

  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages =
      with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
      ]
      ++ [ pkgs.cpupower-gui ];

    # Gaming/host-local tradeoff: drops Spectre/Meltdown-class mitigations.
    kernelParams = [
      "mitigations=off"
      # Meteor Lake iGPU (8086:7d55) is i915 by default; move it to Xe.
      "i915.force_probe=!7d55"
      "xe.force_probe=7d55"
    ];

    # Belt-and-suspenders with the force-probe params above so i915 never
    # claims the iGPU before Xe can bind to it.
    blacklistedKernelModules = [ "i915" ];
  };
}
