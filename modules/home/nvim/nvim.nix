{ inputs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extras = {
      lang.nix.enable = true;
      lang.python.enable = true;
      # lang.csharp.enable = true;
      # lang.typescript.enable = true;
    };
  };

  imports = [ inputs.nvf.homeModules.nvf ];
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "gruvbox";
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
