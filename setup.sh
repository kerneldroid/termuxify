#!/usr/bin/env bash

set -e

# Configuration
REPO_BASE="https://raw.githubusercontent.com/kerneldroid/termuxify/main"
BACKUP_DIR="$HOME/.termuxify_backup"
BIN_DIR="${PREFIX}/bin"

echo -e "\e[1;34m[*] Termuxify Installer\e[0m"

# Shell selection
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

SHARED_PACKAGES="starship atuin wget curl git unzip tsu ncurses-utils gum"
echo -e "\e[1;33m[*] Installing dependencies...\e[0m"
pkg install -y $SHARED_PACKAGES

case "$SELECTED_SHELL" in
    "nu") pkg install -y nushell ;;
    "zsh") pkg install -y zsh ;;
    "fish") pkg install -y fish ;;
esac

# Backup logic
echo -e "\e[1;33m[*] Creating configuration backup at $BACKUP_DIR...\e[0m"
mkdir -p "$BACKUP_DIR"
for cfg in "$HOME/.bashrc" "$HOME/.termux" "$HOME/.config/nushell" "$HOME/.config/fish" "$HOME/.config/starship.toml"; do
    if [ -e "$cfg" ]; then
        cp -r "$cfg" "$BACKUP_DIR/" 2>/dev/null || true
    fi
done

# Install scripts
echo -e "\e[1;33m[*] Deploying binaries to $BIN_DIR...\e[0m"
mkdir -p "$BIN_DIR"
for script in ty tt ah tc dmg; do
    if [ -f "src/$script" ]; then
        cp "src/$script" "$BIN_DIR/$script"
        chmod +x "$BIN_DIR/$script"
    fi
done

# NerdFetch
echo -e "\e[1;33m[*] Installing NerdFetch...\e[0m"
wget -qO "$BIN_DIR/nerdfetch" "https://raw.githubusercontent.com/ThatOneCalculator/NerdFetch/main/nerdfetch"
chmod +x "$BIN_DIR/nerdfetch"

# Shell configuration
echo -e "\e[1;33m[*] Configuring $SELECTED_SHELL environment...\e[0m"

# Safe .bashrc modification function
update_bashrc() {
    local content="$1"
    local start_marker="# --- TERMUXIFY START ---"
    local end_marker="# --- TERMUXIFY END ---"
    
    if grep -q "$start_marker" "$HOME/.bashrc"; then
        # Replace existing block
        sed -i "/$start_marker/,/$end_marker/d" "$HOME/.bashrc"
    fi
    echo -e "\n$start_marker\n$content\n$end_marker" >> "$HOME/.bashrc"
}

case "$SELECTED_SHELL" in
    "nu")
        mkdir -p "$HOME/.config/nushell"
        cat << 'EOF' > "$HOME/.config/nushell/env.nu"
$env.STARSHIP_SHELL = "nu"
$env.STARSHIP_SESSION_KEY = (random chars -l 16)
$env.ATUIN_SESSION = (atuin uuid)
EOF
        cat << 'EOF' > "$HOME/.config/nushell/config.nu"
$env.config = { show_banner: false }
source ~/.config/nushell/starship.nu
nerdfetch
EOF
        starship init nu | sed 's/--right//g' > "$HOME/.config/nushell/starship.nu"
        
        update_bashrc "if [[ \$- == *i* ]] && [ -z \"\$NU_VERSION\" ]; then exec nu; fi"
        ;;
    "bash")
        update_bashrc "eval \"\$(starship init bash)\"\neval \"\$(atuin init bash)\"\nnerdfetch"
        ;;
    "zsh")
        cat << 'EOF' > "$HOME/.zshrc"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
nerdfetch
EOF
        update_bashrc "if [[ \$- == *i* ]] && [ -z \"\$ZSH_VERSION\" ]; then exec zsh; fi"
        ;;
    "fish")
        mkdir -p "$HOME/.config/fish"
        cat << 'EOF' > "$HOME/.config/fish/config.fish"
starship init fish | source
atuin init fish | source
nerdfetch
EOF
        update_bashrc "if [[ \$- == *i* ]] && [ -z \"\$FISH_VERSION\" ]; then exec fish; fi"
        ;;
esac

echo -e "\e[1;32m[+] Termuxify installation complete!\e[0m"

echo -e "\e[1;32m[+] Starting the TUI (ty) for initial setup...\e[0m"
env bash ./src/ty

echo -e "\n\e[1;32m[SUCCESS] Termuxify is installed.\e[0m"
echo -e "\e[1;33m[!] Restart Termux to enter $SELECTED_SHELL properly.\e[0m"

