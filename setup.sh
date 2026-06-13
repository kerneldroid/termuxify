#!/usr/bin/env bash

set -e

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/.termuxify_backup_$TIMESTAMP"
BIN_DIR="${PREFIX}/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS="ty tt ah tc dmg"
SHARED_PACKAGES="starship atuin wget curl git unzip tsu ncurses-utils gum"

if [ -z "$PREFIX" ]; then
    echo -e "\e[1;31m[!] Error: This script must be run within Termux.\e[0m"
    exit 1
fi

echo -e "\e[1;34m[*] Termuxify Installer\e[0m"

INSTALL_MODE="install"
if [ -f "$BIN_DIR/ty" ] || [ -f "$BIN_DIR/tt" ]; then
    echo -e "\e[1;34m[*] Existing Termuxify installation detected.\e[0m"
    echo -e "  \e[1;32m1)\e[0m Update (Safely update binaries and dependencies)"
    echo -e "  \e[1;32m2)\e[0m Reinstall (Creates new backup, asks for shell, resets configs)"
    read -p "Selection [1-2, default: 1]: " mode_choice
    
    if [ "$mode_choice" != "2" ]; then
        INSTALL_MODE="update"
    fi
fi

if [ "$INSTALL_MODE" == "update" ]; then
    echo -e "\e[1;33m[*] Updating Termuxify...\e[0m"
    pkg update -y
    pkg install -y $SHARED_PACKAGES
    
    echo -e "\e[1;33m[*] Updating binaries in $BIN_DIR...\e[0m"
    mkdir -p "$BIN_DIR"
    for script in $SCRIPTS; do
        if [ -f "$SCRIPT_DIR/src/$script" ]; then
            cp "$SCRIPT_DIR/src/$script" "$BIN_DIR/$script"
            chmod +x "$BIN_DIR/$script"
        fi
    done
    
    echo -e "\e[1;33m[*] Updating NerdFetch...\e[0m"
    wget -qO "$BIN_DIR/nerdfetch" "https://raw.githubusercontent.com/ThatOneCalculator/NerdFetch/main/nerdfetch" || echo -e "\e[1;31m[!] Failed to download NerdFetch\e[0m"
    [ -f "$BIN_DIR/nerdfetch" ] && chmod +x "$BIN_DIR/nerdfetch"

    echo -e "\e[1;32m[+] Termuxify successfully updated!\e[0m"
    exit 0
fi

echo -e "\n\e[1;34m[*] Select primary shell:\e[0m"
echo -e "  \e[1;32m1)\e[0m Nushell (Recommended)"
echo -e "  \e[1;32m2)\e[0m Bash"
echo -e "  \e[1;32m3)\e[0m Zsh"
echo -e "  \e[1;32m4)\e[0m Fish"
read -p "Selection [1-4, default: 1]: " shell_choice

case "$shell_choice" in
    2) SELECTED_SHELL="bash" ;;
    3) SELECTED_SHELL="zsh" ;;
    4) SELECTED_SHELL="fish" ;;
    *) SELECTED_SHELL="nu" ;;
esac

echo -e "\e[1;33m[*] Updating package repositories...\e[0m"
pkg update -y

echo -e "\e[1;33m[*] Installing dependencies...\e[0m"
pkg install -y $SHARED_PACKAGES

case "$SELECTED_SHELL" in
    "nu") pkg install -y nushell ;;
    "zsh") pkg install -y zsh ;;
    "fish") pkg install -y fish ;;
esac

echo -e "\e[1;33m[*] Creating configuration backup at $BACKUP_DIR...\e[0m"
mkdir -p "$BACKUP_DIR"
for cfg in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.termux" "$HOME/.config/nushell" "$HOME/.config/fish" "$HOME/.config/starship.toml"; do
    if [ -e "$cfg" ]; then
        cp -r "$cfg" "$BACKUP_DIR/" 2>/dev/null || true
    fi
done

echo -e "\e[1;33m[*] Deploying binaries to $BIN_DIR...\e[0m"
mkdir -p "$BIN_DIR"
for script in $SCRIPTS; do
    if [ -f "$SCRIPT_DIR/src/$script" ]; then
        cp "$SCRIPT_DIR/src/$script" "$BIN_DIR/$script"
        chmod +x "$BIN_DIR/$script"
    fi
done

echo -e "\e[1;33m[*] Installing NerdFetch...\e[0m"
wget -qO "$BIN_DIR/nerdfetch" "https://raw.githubusercontent.com/ThatOneCalculator/NerdFetch/main/nerdfetch" || echo -e "\e[1;31m[!] Failed to download NerdFetch\e[0m"
[ -f "$BIN_DIR/nerdfetch" ] && chmod +x "$BIN_DIR/nerdfetch"

echo -e "\e[1;33m[*] Configuring $SELECTED_SHELL environment...\e[0m"

update_config() {
    local file="$1"
    local content="$2"
    local start_marker="# --- TERMUXIFY START ---"
    local end_marker="# --- TERMUXIFY END ---"
    
    touch "$file"
    if grep -q "$start_marker" "$file"; then
        sed -i "/$start_marker/,/$end_marker/d" "$file"
    fi
    echo -e "\n$start_marker\n$content\n$end_marker" >> "$file"
}

case "$SELECTED_SHELL" in
    "nu")
        mkdir -p "$HOME/.config/nushell"
        cat << 'EOF' > "$HOME/.config/nushell/termuxify_env.nu"
$env.STARSHIP_SHELL = "nu"
$env.STARSHIP_SESSION_KEY = (random chars -l 16)
$env.ATUIN_SESSION = (atuin uuid)
EOF
        cat << 'EOF' > "$HOME/.config/nushell/termuxify_config.nu"
$env.config = { show_banner: false }
source ~/.config/nushell/starship.nu
nerdfetch
EOF
        starship init nu | sed 's/--right//g' > "$HOME/.config/nushell/starship.nu"
        
        if ! grep -q "termuxify_env.nu" "$HOME/.config/nushell/env.nu" 2>/dev/null; then
            echo "source ~/.config/nushell/termuxify_env.nu" >> "$HOME/.config/nushell/env.nu"
        fi
        if ! grep -q "termuxify_config.nu" "$HOME/.config/nushell/config.nu" 2>/dev/null; then
            echo "source ~/.config/nushell/termuxify_config.nu" >> "$HOME/.config/nushell/config.nu"
        fi

        update_config "$HOME/.bashrc" "if [[ $- == *i* ]] && [ -z \"$NU_VERSION\" ]; then exec nu; fi"
        ;;
    "bash")
        update_config "$HOME/.bashrc" "eval \"\$(starship init bash)\"\neval \"\$(atuin init bash)\"\nnerdfetch"
        ;;
    "zsh")
        update_config "$HOME/.zshrc" "eval \"\$(starship init zsh)\"\neval \"\$(atuin init zsh)\"\nnerdfetch"
        update_config "$HOME/.bashrc" "if [[ $- == *i* ]] && [ -z \"$ZSH_VERSION\" ]; then exec zsh; fi"
        ;;
    "fish")
        mkdir -p "$HOME/.config/fish"
        update_config "$HOME/.config/fish/config.fish" "starship init fish | source\natuin init fish | source\nnerdfetch"
        update_config "$HOME/.bashrc" "if [[ $- == *i* ]] && [ -z \"$FISH_VERSION\" ]; then exec fish; fi"
        ;;
esac

echo -e "\e[1;32m[+] Termuxify installation complete!\e[0m"

echo -e "\e[1;32m[+] Starting the TUI (ty) for initial setup...\e[0m"
if [ -f "$BIN_DIR/ty" ]; then
    "$BIN_DIR/ty"
else
    env bash "$SCRIPT_DIR/src/ty"
fi

echo -e "\n\e[1;32m[SUCCESS] Termuxify is installed.\e[0m"
echo -e "\e[1;33m[!] Restart Termux to enter $SELECTED_SHELL properly.\e[0m"

