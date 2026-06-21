# Termuxify

A powerful, aesthetic, and automated environment for Termux.

## Features

- **59 Themes across 13 Families**: Thundra, Material Color, Tokyo Night, Everforest, OkColors, Aethel, Catppuccin, Kanagawa, Oxocarbon, Gruvbox, Gruvbox Material, Nord.
- **Material Color Dynamic Extraction**: Automatically reads your Android system palette from `Settings.Secure` and generates a matching terminal theme (requires root, Shizuku, or ADB).
- **Font Installer**: Automated installation of 6 Nerd Fonts (IBM Plex Mono, Google Sans Code, Ioskeley Mono, Intel One Mono, JetBrains Mono, Monaspace Neon).
- **Interactive Alias Manager (`ah`)**: Easily list, add, and remove aliases for Bash and Nushell.
- **Development Stack Selector (`tc`)**: Quick setup for Python (with JIT), Node.js, Go, Rust, and Lua.
- **Deep Integration**: Pre-configured Starship prompt, Atuin shell history, and NerdFetch.
- **Root & Shizuku Diagnostics (`tt`)**: Comprehensive tests for root managers and Shizuku/Nightzuku APIs.

## Requirements

- **Termux** (from F-Droid or GitHub recommended)
- **Android 7.0+**
- Active internet connection

## Installation

Run the following command in your Termux terminal:

```bash
pkg install git -y
git clone https://github.com/kerneldroid/termuxify
cd termuxify
bash setup.sh
```

## Tools

Once installed, you can access the following tools from anywhere:

- `ty`: The main TUI for Theme & Font Selection.
- `mc`: Material Color Manager — apply .mc color schemes to Android system UI (requires root or Shizuku).
- `ah`: Alias Manager (Add/Remove shell shortcuts).
- `tc`: Tech Stack Selector (Install development environments).
- `tt`: Termux Toolbox (Diagnostics for Root/Shizuku).
- `dmg`: Damage Control (Uninstaller & Backup restorer).
- `nerdfetch`: A sleek system fetch script.

## Material Color Manager

The `mc` command lets you apply Material You color schemes to your Android system UI, matching your Termux theme.

### .mc File Format

```ini
name=Everforest Dark
seed=#A7C080
style=TONAL_SPOT
source=home_wallpaper
```

| Key | Description | Values |
|-----|-------------|--------|
| `name` | Display name | Any text |
| `seed` | Hex color for palette generation | `#RRGGBB` |
| `style` | Material You style | `TONAL_SPOT`, `VIBRANT`, `EXPRESSIVE`, `SPRITZ`, `RAINBOW`, `FRUIT_SALAD` |
| `source` | Color source | `home_wallpaper`, `lock_wallpaper`, `preset` |

### Built-in Templates

54 templates included — one for every Termux theme variant. Run `mc` → "List Templates" to see all.

### Usage

```bash
mc    # Interactive menu: Apply .mc file or List Templates
```

## Shell Support

Termuxify supports and can configure the following shells:
- **Nushell** (Default/Recommended)
- **Bash**
- **Zsh**
- **Fish**

## Credits

- [ColorBlendr](https://github.com/Mahmud0808/ColorBlendr) — Material You color customization app. The `mc` command and `.mc` format are inspired by ColorBlendr's architecture. Material You palette generation concepts based on AOSP's Monet engine.
- [Thundra](https://github.com/kerneldroid/Thundra) — Arctic-inspired color scheme family.
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) — Dark theme based on Tokyo's night sky.
- [Everforest](https://github.com/sainnhe/everforest) — Green-based comfortable theme.
- [OkColors](https://github.com/e-q/okcolors.nvim) — OKLab-based accessible color scheme.
- [Nord](https://github.com/nordtheme/nord) — Arctic, north-bluish color palette.
- [Catppuccin](https://github.com/catppuccin/catppuccin) — Soothing pastel theme.
- [Kanagawa](https://github.com/rebelot/kanagawa.nvim) — Dark theme inspired by Kanagawa wave.
- [Gruvbox](https://github.com/morhetz/gruvbox) — Retro groove color scheme (6 variants: dark hard/medium/soft, light hard/medium/soft).
- [Gruvbox Material](https://github.com/sainnhe/gruvbox-material) — Gruvbox with Material Design palette by sainnhe (6 variants: dark hard/medium/soft, light hard/medium/soft).
- [Oxocarbon](https://github.com/nyoom-engineering/oxocarbon.nvim) — Carbon-inspired color palette.

## License

Standard Distribution License.
