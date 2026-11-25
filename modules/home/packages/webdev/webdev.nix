{ pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.webstorm # // 3gb
    jetbrains.datagrip # // 3gb
  ];
}
