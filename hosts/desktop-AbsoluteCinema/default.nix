{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
    ./../../modules/core/optional/bluetooth.nix
    ./../../modules/core/optional/printers.nix
    ./../../modules/core/optional/amd.nix
    ./../../modules/core/optional/docker.nix
    ./../../modules/core/optional/mouse-actions.nix
  ];
  _module.args.displayConfig = "1.25";

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    cpupower-gui
    powertop
  ];

  services = {

    tlp.settings = {
      # High performance when on AC
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      PLATFORM_PROFILE_ON_AC = "performance";
      INTEL_GPU_MIN_FREQ_ON_AC = 1500; # Higher for performance
      INTEL_GPU_MAX_FREQ_ON_AC = 0; # Use maximum (auto)
      INTEL_GPU_BOOST_FREQ_ON_AC = 0; # Use maximum (auto)
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
