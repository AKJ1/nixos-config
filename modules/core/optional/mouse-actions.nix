{
  pkgs,
  inputs,
  username,
  ...
}:
{
  # programs.mouse-actions.enable = true;
  # programs.mouse-actions.autorun = true;
  environment.systemPackages = [
    inputs.inputactions.packages.${pkgs.system}.default
    inputs.inputactions.packages.${pkgs.system}.ctl
  ];

  users.users.${username}.extraGroups = [
    "input"
    "plugdev"
  ];
  users.groups.plugdev = { };

  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"
  '';

  # environment.systemPackages = [
  #   pkgs.mouse-actions-gui
  # ];
  # nixpkgs.config = {
  #   problems.handlers = {
  #     mouse-actions-gui.broken = "warn"; # or "ignore"

  #   };
  # };
}
