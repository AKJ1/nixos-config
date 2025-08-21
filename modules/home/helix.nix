{
  pkgs,
  ...
}:
{
  home.packages = (
    with pkgs;
    [
      helix
      helix-gpt
    ]
  );
}
