# Termuxify

A powerful, aesthetic, and automated environment for Termux.

## Features

- **47 Themes across 11 Families**: Thundra, Material Color, Tokyo Night, Everforest, OkColors, Aethel, Catppuccin, Kanagawa, Oxocarbon, Gruvbox, Nord.
- **Material Color Dynamic Extraction**: Automatically reads your Android system palette from `Settings.Secure` and generates a matching terminal theme (requires root, Shizuku, or ADB).
- **Font Installer**: Automated installation of 6 Nerd Fonts (IBM Plex Mono, Google Sans Code, Ioskeley Mono, Intel One Mono, JetBrains Mono, Monaspace Neon).
- **Interactive Alias Manager (`ah`)**: Easily list, add, and remove aliases for Bash and Nushell.
- **Development Stack Selector (`tc`)**: Quick setup for Python (with JIT), Node.js, Go, Rust, and Lua.
- **Deep Integration**: Pre-configured Starship prompt, Atuin shell history, and NerdFetch.
- **Root & Shizuku Diagnostics (`tt`)**: Comprehensive tests for root managers and Shizuku/Nightzuku APIs.

## Themes

| Family | Variants | Source |
|--------|----------|--------|
| **Thundra** | Dark Hard, Dark Normal, Dark Soft, Light Hard, Light Normal, Light Soft | [kerneldroid/Thundra](https://github.com/kerneldroid/Thundra) |
| **Material Color** | System (dynamic), Tonal Spot, Expressive, Vibrant, Spritz, Rainbow, Fruit Salad | AOSP Monet engine via `Settings.Secure` |
| **Tokyo Night** | Night, Storm, Moon, Day | [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim) |
| **Everforest** | Dark Hard, Dark Medium, Dark Soft, Light Hard, Light Medium, Light Soft | [sainnhe/everforest](https://github.com/sainnhe/everforest) |
| **OkColors** | Dark Smooth, Dark Sharp, Light Smooth, Light Sharp | [e-q/okcolors.nvim](https://github.com/e-q/okcolors.nvim) |
| **Aethel** | Dark Hard, Dark Medium, Dark Soft, Light Hard, Light Medium, Light Soft | Custom perceptually optimized palette |
| **Catppuccin** | Mocha, Macchiato, Frappe, Latte | [catppuccin/catppuccin](https://github.com/catppuccin/catppuccin) |
| **Kanagawa** | Wave, Dragon, Lotus | [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) |
| **Oxocarbon** | Dark, Light | [IBM/oxocarbon](https://github.com/IBM/oxocarbon) |
| **Gruvbox** | Gruvbox, Gruvbox Material | [morhetz/gruvbox](https://github.com/morhetz/gruvbox) |
| **Nord** | Nord | [nordtheme/nord](https://github.com/nordtheme/nord) |

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
- `ah`: Alias Manager (Add/Remove shell shortcuts).
- `tc`: Tech Stack Selector (Install development environments).
- `tt`: Termux Toolbox (Diagnostics for Root/Shizuku).
- `dmg`: Damage Control (Uninstaller & Backup restorer).
- `nerdfetch`: A sleek system fetch script.

## Shell Support

Termuxify supports and can configure the following shells:
- **Nushell** (Default/Recommended)
- **Bash**
- **Zsh**
- **Fish**

## License

Standard Distribution License.
