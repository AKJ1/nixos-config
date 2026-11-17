{ inputs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  imports = [ inputs.nvf.homeModules.nvf ];
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
        style = "dark";
      };
      lsp.enable = true;
      languages = {
        nix.enable = true;
        python.enable = true;
      };
      visuals.nvim-web-devicons.enable = true;
      statusline.lualine.enable = true;
    };
  };

}
