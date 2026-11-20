{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
    ./../../modules/core/optional/bluetooth.nix
    ./../../modules/core/optional/docker.nix
    ./../../modules/core/optional/printers.nix
    ./../../modules/core/optional/ssh.nix
  ];
  _module.args.displayConfig = "1.5";

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    cpupower-gui
    powertop
  ];

  services = {
    # LightDM's Wayland autologin is unreliable on this host: it fails with
    # "session_run: assertion 'priv->display_server != NULL'" and leaves a
    # blank console. Use greetd, which handles Wayland sessions natively.
    xserver.displayManager.lightdm.enable = false;
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${pkgs.niri}/bin/niri-session";
          user = "ace";
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd ${pkgs.niri}/bin/niri-session";
          user = "greeter";
        };
      };
    };

    power-profiles-daemon.enable = true;
    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };

    # Lid switch is handled here; idle suspend is handled by noctalia
    # (see modules/home/noctalia/noctalia.nix) so it can lock before sleeping.
    #
    # The hall sensor behind the lid switch is dead on this host (confirmed by
    # Lenovo's UEFI checker; /proc/acpi/button/lid/LID/state is stuck "open"
    # and a magnet over either half never flips it), so HandleLidSwitch never
    # fires. Suspend is entered with the power key instead; the lid action is
    # left in place for the case the sensor ever gets repaired.
    logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandleSuspendKey = "hibernate";
      HandleHibernateKey = "hibernate";
      HandleLidSwitch = "suspend";
    };

    # Wake from suspend must come from the power button only: while carried in
    # a bag the keyboard and TrackPoint produce ghost input that otherwise
    # resumes the machine. Both are i8042 serio devices, which is where their
    # wakeup flag lives; the touchpad and pen are i2c-hid and cannot wake it at
    # all. Power Button (PNP0C0C:00) is deliberately left enabled.
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="serio", KERNEL=="serio0", ATTR{power/wakeup}="disabled"
      ACTION=="add", SUBSYSTEM=="serio", KERNEL=="serio1", ATTR{power/wakeup}="disabled"
      ACTION=="add", SUBSYSTEM=="platform", KERNEL=="PNP0C0D:00", ATTR{power/wakeup}="disabled"
      ACTION=="add", SUBSYSTEM=="platform", KERNEL=="PNP0C0E:00", ATTR{power/wakeup}="disabled"
    '';

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

  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
      cpupower
    ];

    # Resume from hibernate. Swap (33G) is larger than RAM (30G), so this is
    # just the missing piece; without it hibernate can't come back.
    resumeDevice = "/dev/disk/by-uuid/449dba86-86d8-41fc-a678-857c7c2007ba";
  };
}
