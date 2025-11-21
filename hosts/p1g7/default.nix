{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

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
      percentageCritical = 8;
      percentageAction = 5;
      criticalPowerAction = "PowerOff";
    };

    tlp.settings = {
        # High performance when on AC
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        PLATFORM_PROFILE_ON_AC = "performance";
        INTEL_GPU_MIN_FREQ_ON_AC = 1500; # Higher for performance
        INTEL_GPU_MAX_FREQ_ON_AC = 0; # Use maximum (auto)
        INTEL_GPU_BOOST_FREQ_ON_AC = 0; # Use maximum (auto)

        # Power saving on battery, except when dGPU is used
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_BOOST_ON_BAT = 0; # Disable boost to save power
        CPU_HWP_DYN_BOOST_ON_BAT = 0; # Disable dynamic boost
        PLATFORM_PROFILE_ON_BAT = "balanced"; # Balanced for battery

        # GPU: Keep Intel GPU at low minimum for battery, but allow higher if dGPU active
        INTEL_GPU_MIN_FREQ_ON_BAT = 350; # Lower for battery
        INTEL_GPU_MAX_FREQ_ON_BAT = 0; # Use maximum (auto)
        INTEL_GPU_BOOST_FREQ_ON_BAT = 0; # Use maximum (auto)

        # PCIe ASPM: Powersave on battery, default on AC
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersave";

        # dGPU power management: Enable runtime PM for NVIDIA GPU to save power when idle
        RUNTIME_PM_ENABLE = "01:00.0"; # Replace with your GPU's PCI ID (use `lspci | grep NVIDIA`)

        # Battery charging thresholds (optional, to prolong battery life)
        START_CHARGE_THRESH_BAT0 = 70;
        STOP_CHARGE_THRESH_BAT0 = 90;
    };
  };

  powerManagement.cpuFreqGovernor = "schedutil";

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
