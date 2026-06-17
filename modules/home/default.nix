{ ... }:
{
  imports = [
    ./dotfiles.nix
    ./aseprite/aseprite.nix # pixel art editor
    ./audacious/audacious.nix # music player
    ./bat.nix # better cat command
    ./browser.nix # firefox based browser
    ./btop.nix # resouces monitor
    ./cava.nix # audio visualizer
    ./discord.nix # discord
    ./fastfetch.nix # fetch tool
    ./flow.nix # terminal text editor
    ./fzf.nix # fuzzy finder
    ./gaming.nix # packages related to gaming
    ./ghostty.nix # terminal
    ./git.nix # version control
    ./gnome.nix # gnome apps
    ./gtk.nix # gtk theme
    ./kitty.nix # terminal
    ./lazygit.nix
    ./micro.nix # nano replacement
    ./nemo.nix # file manager
    ./nix-search/nix-search.nix # TUI to search nixpkgs
    ./noctalia # shell / panel / notifications
    ./nvim.nix # neovim editor
    ./obsidian.nix
    ./opencode
    ./p10k/p10k.nix
    ./packages # other packages
    ./retroarch.nix
    ./rofi.nix # launcher
    ./scripts/scripts.nix # personal scripts
    ./ssh.nix # ssh config
    ./superfile/superfile.nix # terminal file manager
    ./viewnior.nix # image viewer
    ./vscodium # vscode fork
    ./waypaper.nix # GUI wallpaper picker
    ./wl-gammarelay-rs.nix # software brightness control
    ./xdg-mimes.nix # xdg config
    ./zsh # shell
    ./niri # window manager
    ./ace # ace-specific modules
    ./keyd # keyd service
  ];
}
