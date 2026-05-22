# Termuxify

The ultimate automated setup, customization, and shell management suite for Termux.

Termuxify transforms a fresh Termux installation into a fully featured, optimized, and professional terminal environment in seconds.

## Installation

Run the following command in your Termux:

```bash
pkg install git -y && git clone https://github.com/kerneldroid/termuxify && cd termuxify && bash setup.sh
```

## Key Features

- **Selective Shell Setup**: Choose your primary shell at startup: Nushell (Recommended), Bash, Zsh, or Fish.
- **Dynamic Shell Switcher**: Switch default shells anytime via the `ty` menu. It handles `pkg` installation, config generation, and hooks default entry redirectors seamlessly.
- **Safe Configuration**: Uses marker blocks (`# --- TERMUXIFY START ---`) in `.bashrc` to ensure your personal settings are never overwritten.
- **Python JIT Support**: Instantly activate the official experimental JIT in Python 3.13+ through environment variables.
- **Optimized Font Mirroring**: Cuts network traffic by downloading only single, patched `.ttf` files instead of massive ZIP archives.
- **Robust Uninstaller**: A reliable `dmg` tool that restores original configurations from backups with pre-flight safety checks.

## Built-in Tools

- `ty` : Theme, font, and shell management TUI.
- `ah` : Interactive Alias Manager (Bash & Nushell support).
- `tc` : Dev stack installer (Python 3.13 JIT, Numba, LuaJIT).
- `tt` : Deep diagnostic check (Shizuku/Nightzuku & ADB module validation).
- `dmg`: Safe system restoration and Termuxify removal.

## Requirements

- A fresh or existing Termux installation.
- Internet connection for dependencies and fonts.

---
*Created by Kerneldroid*
