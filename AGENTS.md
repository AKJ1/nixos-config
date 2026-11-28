# NixOS Configuration

Flake-based NixOS configuration for `x86_64-linux`, user `ace`.   

## Hosts

| Host | Path | CPU | GPU |
|------|------|-----|-----|
| `PrimeIncarnon` | `hosts/desktop-PrimeIncarnon/` | AMD 9700X + 6800XT | sff Desktop |
| `AbsoluteCinema` | `hosts/desktop-AbsoluteCinema/` | Intel i3-12100 | AMD 9060XT | sff Desktop | currently out of use.
| `z13` | `hosts/z13/` | AMD 6860Z, (680M, integrated) | AMD | laptop
| `p1g7` | `hosts/p1g7/` | Intel Arrow Lake 165H (with integrated 140T GPU) + RTX 4070 dGPU | laptop
| `xps9340` | `hosts/xps9340/` | Intel 155H (with integrated 140T GPU) | Intel | laptop
| `laptop` | `hosts/laptop/` | Generic, Unused | laptop

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
        ├── niri/config/            # Per-host niri WM settings
        └── <app>/                  # Per-app config (ghostty, zsh, vscodium, etc.)
```

- **Core modules** (`modules/core/`) — system-level config shared by all hosts
- **Home modules** (`modules/home/`) — user-level config via Home Manager, selected per-host
- **`modules/core/user.nix`** — dispatches to the correct host-specific home config
- **`pkgs/`** — custom package derivations
- **`wallpapers/`** — gruvbox-themed wallpaper collection
- No secrets management (handled out-of-band)


## Verification

```bash
# Build a NixOS configuration
nix build ".#nixosConfigurations.<Host>.config.system.build.toplevel"

# Evaluate a foreign-host configuration on your current machine
# Catches eval errors without needing the target host
nix eval ".#nixosConfigurations.<Host>.config.system.build.toplevel" --raw 2>&1 | head -5

# Format
nix fmt
# Or manually:
nix run nixpkgs#nixfmt -- file.nix
```

## Agent Workflow
- sudo is restricted, never try to rebuild the user's system, they will apply the changes permanently.
- atomic - commit semantically per-change. If changes to different components are made during the same turn - commit them separately
- never apply a fix to a battery-powered (laptop, handheld, etc) host that would change it's power behaviour on battery without explicity asking the user for confirmation. If you are asked to make a change pertaining to performance, limit that behaviour to AC-only unless e

## Workflow Gotchas

- **New `.nix` files must be `git add`ed before `nix build`.** The flake reads from the git store; untracked files are invisible.
- **Don't use `nix flake check` as a blanket validation.** It tries to build every output and fails on cross-platform configs from your current host. Use the targeted `nix build` (local platform) + `nix eval` (foreign platform) commands above instead.
- Commit style: semantic with host scope, e.g. `feat(p1g7):`, `fix(absolutecinema):`, `chore:`.
## Flake Inputs

15+ external inputs including `niri`, `ghostty`, `zen-browser`, `noctalia`, `vicinae`, `nvf`, `nix-gaming`, `nix-flatpak`, `nix-colors`, `nix-vscode-extensions`, `nur`, `zig`.

## Key Stack

| Layer | Choice |
|-------|--------|
| Desktop-Shell | Noctalia |
| Compositor | Niri (scrollable-tiling Wayland) |
| Shell | ZSH + Powerlevel10k |
| Terminal | Ghostty / Kitty |
| Bar/Notifications | Noctalia-shell |
| Browser | Zen Browser |
| Editor | VSCodium + Neovim + Zed |
| Audio | PipeWire |
| Theming | Noctalia throughout |


## Notes
The flake is under active development by a single user, there may be orphaned or deprecated hosts or other unmentioned issues!