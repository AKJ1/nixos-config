# NixOS Configuration

Flake-based NixOS configuration for `x86_64-linux`, user `ace`.

## Hosts

| Host | Path | CPU | GPU |
|------|------|-----|-----|
| `desktop` | `hosts/desktop/` | Intel (integrated) | Intel |
| `AbsoluteCinema` | `hosts/desktop-AbsoluteCinema/` | Intel | Intel + NVIDIA (optimus) |
| `p1g7` | `hosts/p1g7/` | Intel | Intel + NVIDIA (optimus) |
| `z13` | `hosts/z13/` | AMD (integrated) | AMD |
| `laptop` | `hosts/laptop/` | AMD | AMD (not wired in flake) |

## Architecture

```
flake.nix
  ├── hosts/<host>/default.nix     # Per-machine config
  │     └── modules/core/           # Shared NixOS modules (bootloader, network,
  │                                 #   pipewire, steam, virtualization, etc.)
  │           └── optional/         # Bluetooth, printers
  └── modules/home/                 # Home Manager user config
        ├── default.nix             # Base (all hosts)
        ├── default.<host>.nix      # Host-specific extras
        ├── packages/               # CLI, dev, GUI, custom pkg groupings
        ├── scripts/scripts/        # ~20 custom shell scripts
        ├── niri/config/            # Per-host niri WM layouts
        └── <app>/                  # Per-app config (ghostty, zsh, vscodium, etc.)
```

- **Core modules** (`modules/core/`) — system-level config shared by all hosts
- **Home modules** (`modules/home/`) — user-level config via Home Manager, selected per-host
- **`modules/core/user.nix`** — dispatches to the correct host-specific home config
- **`pkgs/`** — custom package derivations
- **`wallpapers/`** — gruvbox-themed wallpaper collection
- No secrets management (handled out-of-band)

## Flake Inputs

15+ external inputs including `niri`, `ghostty`, `zen-browser`, `noctalia`, `vicinae`, `nvf`, `nix-gaming`, `nix-flatpak`, `nix-colors`, `nix-vscode-extensions`, `nur`, `zig`.

## Key Stack

| Layer | Choice |
|-------|--------|
| Compositor | Niri (scrollable-tiling Wayland) |
| Shell | ZSH + Powerlevel10k |
| Terminal | Ghostty / Kitty |
| Bar/Notifications | Noctalia-shell |
| Browser | Zen Browser |
| Editor | VSCodium + Neovim |
| Audio | PipeWire |
| Theming | Gruvbox throughout |
