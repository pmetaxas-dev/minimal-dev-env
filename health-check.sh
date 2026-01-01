#!/usr/bin/env bash
set -euo pipefail

echo "========================================"
echo "     Pi Zero Health Check"
echo "========================================"
echo

############################################
# Check .env loading
############################################

echo "==> Checking .env loading"

if [ -f "$HOME/.env" ]; then
    echo "✔ ~/.env exists"
else
    echo "❌ ~/.env is missing"
fi

if grep -q 'source "$HOME/.env"' /etc/bash.bashrc; then
    echo "✔ /etc/bash.bashrc sources ~/.env"
else
    echo "❌ /etc/bash.bashrc does NOT source ~/.env"
fi

if [ -n "${OPENAI_API_KEY:-}" ]; then
    echo "✔ OPENAI_API_KEY is loaded into environment"
else
    echo "❌ OPENAI_API_KEY is NOT loaded"
fi

echo

############################################
# Check AI CLI
############################################

echo "==> Checking AI CLI"

if command -v ai >/dev/null 2>&1; then
    echo "✔ ai command exists"
else
    echo "❌ ai command missing"
fi

echo

############################################
# Check Neovim
############################################

echo "==> Checking Neovim"

if command -v nvim >/dev/null 2>&1; then
    echo "✔ Neovim installed"
else
    echo "❌ Neovim missing"
fi

if [ -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
    echo "✔ lazy.nvim installed"
else
    echo "❌ lazy.nvim missing"
fi

echo

############################################
# Check languages
############################################

echo "==> Checking languages"

command -v python3 >/dev/null && echo "✔ Python3 OK" || echo "❌ Python3 missing"
command -v pip >/dev/null && echo "✔ pip OK" || echo "❌ pip missing"
command -v node >/dev/null && echo "✔ Node.js OK" || echo "❌ Node.js missing"
command -v npm >/dev/null && echo "✔ npm OK" || echo "❌ npm missing"
command -v go >/dev/null && echo "✔ Go OK" || echo "❌ Go missing"

echo

############################################
# Check OpenAI Python library
############################################

echo "==> Checking OpenAI Python library"

if python3 -c "import openai" 2>/dev/null; then
    echo "✔ openai Python package installed"
else
    echo "❌ openai Python package missing"
fi

echo

############################################
# Check PATH consistency
############################################

echo "==> Checking PATH"

echo "$PATH" | grep -q "$HOME/.cargo/bin" \
    && echo "✔ cargo PATH present (if Rust installed)" \
    || echo "ℹ cargo PATH not present (OK if Rust not installed)"

echo

############################################
# Check leftover GUI packages
############################################

echo "==> Checking for leftover GUI packages"

GUI_PKGS=(
    openbox obconf tint2
    xorg xserver-xorg-core xinit
    x11-utils x11-xserver-utils
    xfonts-base xkb-data
    falkon
)

LEFTOVERS=0

for pkg in "${GUI_PKGS[@]}"; do
    if dpkg -l | grep -q "^ii  $pkg"; then
        echo "❌ GUI leftover: $pkg"
        LEFTOVERS=1
    fi
done

if [ "$LEFTOVERS" -eq 0 ]; then
    echo "✔ No GUI leftovers"
fi

echo

############################################
# Check Code-Server
############################################

echo "==> Checking Code-Server"

if command -v code-server >/dev/null 2>&1; then
    echo "✔ Code-Server installed"
    systemctl --user is-active code-server >/dev/null 2>&1 \
        && echo "✔ Code-Server running" \
        || echo "ℹ Code-Server installed but not running"
else
    echo "ℹ Code-Server not installed"
fi

echo

############################################
# System resources
############################################

echo "==> System resources"

echo "RAM:"
free -h

echo
echo "Disk:"
df -h /

echo
echo "CPU:"
uname -m

echo
echo "========================================"
echo "     Health Check Complete"
echo "========================================"
