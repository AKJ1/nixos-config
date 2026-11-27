{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    # shellWrappperName = "y";
    enableZshIntegration = true;
    package = pkgs.yazi.override {
      _7zz = pkgs._7zz-rar;
    };
    settings = {
      opener.edit = [
        {
          run = "nvim %s";
          desc = "Edit with Neovim";
          block = true;
        }
      ];
    };
  };
}
