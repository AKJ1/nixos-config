{ ... }:
{
  # ~/.vimrc ported to Zed's vim mode (see dotfiles/home/.vimrc).
  # mutableUserSettings/mutableUserKeymaps stay at their default `true`, so these
  # keys are merged into the live settings.json/keymap.json on activation;
  # everything else in those files stays untouched and editable in-app.
  programs.zed-editor = {
    enable = true;

    userSettings = {
      vim_mode = true;
      vertical_scroll_margin = 5; # :set scrolloff=5 (Zed default: 3)
    };

    userKeymaps = [
      {
        # :unmap <C-n> <C-v> <C-c> <C-x> <C-w>
        # VimControl == normal|visual|operator, the same scope as :unmap.
        context = "VimControl";
        bindings = {
          "ctrl-n" = null;
          "ctrl-v" = null;
          "ctrl-c" = null;
          "ctrl-x" = null;
          "ctrl-w" = null;
        };
      }
      {
        # :nmap <space> <Leader>  -> space stops moving right, becomes leader
        # :nnoremap s <Nop>       -> kills vim::Substitute
        # :nnoremap S <Nop>       -> kills vim::SubstituteLine
        # :nnoremap \e :e ~/.vimrc -> space e opens the keymap file
        #   (:source maps to nothing: Zed reloads config on save)
        context = "vim_mode == normal";
        bindings = {
          "space" = null;
          "s" = null;
          "shift-s" = null;
          "space e" = "zed::OpenKeymapFile";
        };
      }
      {
        # :imap jk <Esc>
        context = "vim_mode == insert";
        bindings = {
          "j k" = "vim::NormalBefore";
        };
      }
    ];
  };
}
