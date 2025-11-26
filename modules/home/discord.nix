{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vesktop
    # discord
    # (discord.override {
    #  withVencord = true;
    # })
    #     webcord-vencord
  ];
}
