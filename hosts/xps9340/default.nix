{ pkgs, config, lib, ... }:
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

    tlp.settings = {
      CPU_ENERGY_PERF_POLICY_ON_AC = "power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "performance";

      # PCIE_ASPM_ON_AC = "default";
      # PCIE_ASPM_ON_BAT = "powersupersave";
    };
  };

  powerManagement.cpuFreqGovernor = "performance";

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
        "$amixer" -c sofsoundwire sset 'rt714 FU02 Capture Switch' '1'
        "$amixer" -c sofsoundwire sset 'rt714 FU02 Capture Volume' '47'
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
  };
}
