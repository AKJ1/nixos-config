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
    ./../../modules/core/optional/coreultra.nix
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

    # NOTE: no tlp.settings here — TLP is not enabled on this host; PPD owns
    # platform_profile and is set to "balanced" at boot (see below).
  };

  # intel_pstate only exposes "performance" and "powersave" as governors.
  # "balance_power" is an energy_performance_preference value, so setting it as
  # a governor made cpupower.service fail on CPU 0 every boot. The EPP is set
  # explicitly by the oneshot below instead.
  powerManagement.cpuFreqGovernor = "powersave";

  systemd.services.ppd-balanced = {
    description = "Default power-profiles-daemon to the balanced profile";
    wantedBy = [ "multi-user.target" ];
    after = [ "power-profiles-daemon.service" ];
    wants = [ "power-profiles-daemon.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced";
    };
  };

  # What actually fixed WoW's framerate on this host. PPD "balanced" maps to
  # balance_performance, which still overspends the shared CPU+GPU power budget;
  # balance_power gives the Xe iGPU enough headroom to hold a steady framerate.
  # Must run after PPD and cpufreq, both of which write EPP/governor on boot.
  systemd.services.xps9340-epp = {
    description = "Set Intel EPP to balance_power on xps9340";
    wantedBy = [ "multi-user.target" ];
    wants = [
      "power-profiles-daemon.service"
      "ppd-balanced.service"
    ];
    after = [
      "power-profiles-daemon.service"
      "ppd-balanced.service"
      "cpufreq.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for epp in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
        [ -w "$epp" ] || continue
        echo balance_power > "$epp"
      done
    '';
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
