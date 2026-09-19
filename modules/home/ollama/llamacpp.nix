{ pkgs, ... }:
{
  home.packages = with pkgs; [
    llama-cpp
    llama-cpp-rocm
  ];
}
