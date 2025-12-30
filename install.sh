#!/usr/bin/env bash

set -e

echo "==> Updating system"
sudo apt update -y
sudo apt upgrade -y

echo "==> Installing core development tools"
sudo apt install -y \
    build-essential \
    clang \
    gdb \
    valgrind \
    make \
    cmake \
    pkg-config \
    git \
    curl wget \
    python3 python3-pip \
    tmux \
    neovim \
    ripgrep \
    fzf \
    htop \
    ncdu \
    netcat-openbsd \
    openssh-client \
    manpages-dev \
    jq \
    ranger \
    exa

echo "==> Installing static analysis tools"
sudo apt install -y cppcheck clang-tidy clang-format

echo "==> Installing networking tools"
sudo apt install -y iproute2 iputils-ping traceroute nmap tcpdump

echo "==> Installing Docker"
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker "$USER"

echo '==> Installing GitHub CLI'
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" | \
    sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update -y
sudo apt install gh -y

echo "==> Installing VS Code"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] \
    https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update -y
sudo apt install code -y
rm microsoft.gpg

echo "==> Installing Rust (rustup)"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

echo "==> Installing Go"
sudo apt install -y golang

echo "==> Installing Node.js (LTS) + npm"
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

echo "==> Installing lightweight browser (qutebrowser)"
sudo apt install -y qutebrowser

echo "==> Creating minimal Neovim config"
mkdir -p ~/.config/nvim
cat << 'EOF' > ~/.config/nvim/init.lua
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
EOF

echo "==> Setting up Zsh"
sudo apt install -y zsh
chsh -s /usr/bin/zsh
cat << 'EOF' > ~/.zshrc
export EDITOR=nvim
export VISUAL=nvim

# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Better history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_all_dups
EOF

echo "==> All done!"
echo "Log out and back in to activate Docker group changes."
