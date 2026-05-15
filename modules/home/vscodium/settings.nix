{ ... }:
{
  programs.vscodium.profiles.default = {
    userSettings = {
      "update.mode" = "none";
      "extensions.autoUpdate" = false; # This stuff fixes vscode freaking out when theres an update

      "editor.fontFamily" =
        "'BlexMono NerdFont', 'Maple Mono', 'SymbolsNerdFont', 'monospace', monospace";
      "terminal.integrated.fontFamily" = "'BlexMono NerdFont', 'Maple Mono', 'SymbolsNerdFont'";
      "editor.fontSize" = 18;
      "workbench.colorTheme" = "NoctaliaTheme";
      "workbench.iconTheme" = "gruvbox-material-icon-theme";
      "material-icon-theme.folders.theme" = "classic";
      "vsicons.dontShowNewVersionMessage" = true;
      "explorer.confirmDragAndDrop" = false;
      "editor.fontLigatures" = true;
      "editor.minimap.enabled" = false;
      "workbench.startupEditor" = "none";

      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.formatOnPaste" = true;
      "editor.inlayHints.enabled" = "off";

      "workbench.editor.limit.enabled" = true;
      "workbench.editor.limit.value" = 10;
      "workbench.editor.limit.perEditorGroup" = true;
      "workbench.editor.showTabs" = "none";
      "files.autoSave" = "onWindowChange";
      "breadcrumbs.enabled" = false;
      "editor.renderControlCharacters" = false;
      "workbench.statusBar.visible" = false;
      "editor.scrollbar.verticalScrollbarSize" = 2;
      "editor.scrollbar.horizontalScrollbarSize" = 2;
      "editor.scrollbar.vertical" = "hidden";
      "editor.scrollbar.horizontal" = "hidden";

      "editor.mouseWheelZoom" = true;

      # C/C++
      "clangd.arguments" = [
        "--clang-tidy"
        "--inlay-hints=false"
      ];

      "vim.vimrc.enable" = true;
      "vim.vimrc.path" = "~/.vsvimrc";

      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "nixEnvSelector.useFlakes" = true;
      # "nix.serverSettings" = {
      #   "nixd" = {
      #     "formatting" = {
      #       "command" = [ "nixfmt" ];
      #     };
      #   };
      # };
    };
  };
}
