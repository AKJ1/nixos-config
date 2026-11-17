# Module for fancy fetch. Pointless but cool.

{ pkgs, inputs, ... }:
{
  imports = [ inputs.areofyl-fetch.homeManagerModules.default ];

  programs.fetch = {
    enable = true;
    info = [
      "host"
      "os"
      "cpu"
      "gpu"
      "memory"
      "disk"
      "kernel"
      "uptime"
      "shell"
      "display"
      "wm"
      "font"
      "terminal"
      "ip"
    ];
    speed = 1.0;
    spin = "y";
    extraConfig = "
      box = 1\n
      shading_mode = blocks
    ";
  };
}
