# Termuxify

A powerful, aesthetic, and automated environment for Termux.

## Features

- **Hierarchical Theme Selection**: Choose from popular themes like Catppuccin, Kanagawa, Oxocarbon, Nord, Tokyo Night, and the perceptually optimized **Aethel**.
- **Font Installer**: Automated installation of Nerd Fonts (IBM Plex Mono, Google Sans Code, Ioskeley Mono).
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
