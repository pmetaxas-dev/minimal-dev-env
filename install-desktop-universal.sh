#!/usr/bin/env bash
set -euo pipefail

echo "==> Zone01 headless dev environment installer (Debian/Ubuntu)"

#######################################
# Flags (headless defaults)
#######################################
INSTALL_DOCKER=true
INSTALL_ZSH=true
INSTALL_CODE_SERVER=true
INSTALL_AI=true
INSTALL_EZA=true
INSTALL_XFCE=false
INSTALL_CHROMIUM=false
NVIM_MODE="full"  # "full" or "minimal"

for arg in "$@"; do
  case "$arg" in
    --no-docker)      INSTALL_DOCKER=false ;;
    --no-zsh)         INSTALL_ZSH=false ;;
    --no-code-server) INSTALL_CODE_SERVER=false ;;
    --no-ai)          INSTALL_AI=false ;;
    --no-eza)         INSTALL_EZA=false ;;
    --with-xfce)      INSTALL_XFCE=true ;;
    --with-chromium)  INSTALL_CHROMIUM=true ;;
    --minimal-nvim)   NVIM_MODE="minimal" ;;
    *)
      echo "Unknown option: $arg"
      echo "Available options:"
      echo "  --no-docker"
      echo "  --no-zsh"
      echo "  --no-code-server"
      echo "  --no-ai"
      echo "  --no-eza"
      echo "  --with-xfce"
      echo "  --with-chromium"
      echo "  --minimal-nvim"
      exit 1
      ;;
  esac
done

#######################################
# Detect OS + basic validation
#######################################
echo "==> Detecting OS"

if ! [ -f /etc/os-release ]; then
  echo "❌ /etc/os-release not found. Unsupported system."
  exit 1
fi

if grep -qi "ubuntu" /etc/os-release; then
  OS="ubuntu"
elif grep -qi "debian" /etc/os-release; then
  OS="debian"
else
  echo "❌ Unsupported OS. Only Debian/Ubuntu are supported."
  exit 1
fi

echo "Detected OS: $OS"

if ! command -v apt >/dev/null 2>&1; then
  echo "❌ APT package manager not found."
  exit 1
fi

if ! sudo -v >/dev/null 2>&1; then
  echo "❌ Sudo privileges required."
  exit 1
fi

# More reliable than ping (ICMP may be blocked)
if ! curl -fsSL https://deb.debian.org/ >/dev/null 2>&1 && ! curl -fsSL https://archive.ubuntu.com/ >/dev/null 2>&1; then
  echo "❌ No working HTTPS connectivity to distro mirrors."
  exit 1
fi

# Ensure 2GB free on /
FREE_SPACE_KB="$(df -Pk / | awk 'NR==2{print $4}')"
if [ "${FREE_SPACE_KB}" -lt 2000000 ]; then
  echo "❌ Not enough disk space (need ~2GB free on /)."
  exit 1
fi

echo "✅ Validation passed"

#######################################
# Core tools
#######################################
export DEBIAN_FRONTEND=noninteractive

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
  curl \
  wget \
  python3 \
  python3-pip \
  python3-venv \
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
  ca-certificates \
  unzip \
  fd-find \
  w3m \
  w3m-img \
  iproute2 \
  iputils-ping \
  traceroute \
  nmap \
  tcpdump

# Convenience symlink: fd-find installs as "fdfind" on Debian/Ubuntu
mkdir -p "$HOME/.local/bin"
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

#######################################
# Static analysis tools
#######################################
echo "==> Installing static analysis tools"
sudo apt install -y cppcheck clang-tidy clang-format

#######################################
# Docker (optional)
#######################################
if [ "$INSTALL_DOCKER" = true ]; then
  echo "==> Installing Docker"
  sudo apt install -y docker.io docker-compose-plugin
  sudo usermod -aG docker "$USER"
  echo "⚠️ Docker group updated. Log out and back in to use Docker without sudo."
else
  echo "⚠️ Skipping Docker (--no-docker)"
fi

#######################################
# GitHub CLI
#######################################
echo "==> Installing GitHub CLI"
type -p curl >/dev/null || sudo apt install -y curl
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
sudo apt update -y
sudo apt install -y gh

#######################################
# Languages
#######################################
echo "==> Installing Go"
sudo apt install -y golang

echo "==> Installing Node.js (distro) + npm"
sudo apt install -y nodejs npm

echo "==> Installing Rust (rustup)"
if ! command -v cargo >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

#######################################
# eza (optional)
#######################################
if [ "$INSTALL_EZA" = true ]; then
  echo "==> Installing eza"
  if sudo apt install -y eza >/dev/null 2>&1; then
    :
  else
    # Fallback: install via cargo if apt doesn't have it
    # shellcheck disable=SC1090
    source "$HOME/.cargo/env"
    cargo install eza
  fi
else
  echo "⚠️ Skipping eza (--no-eza)"
fi

#######################################
# Headless defaults: XFCE/Chromium disabled unless requested
#######################################
if [ "$INSTALL_XFCE" = true ]; then
  echo "==> Installing minimal XFCE environment (requested)"
  sudo apt install -y \
    xfce4 \
    xfce4-terminal \
    xorg \
    lightdm-gtk-greeter \
    --no-install-recommends

  # Prevent GUI from starting automatically
  sudo systemctl set-default multi-user.target
  echo "XFCE installed. Launch manually with: startx"
else
  echo "==> Skipping XFCE (headless default). Use --with-xfce to install."
fi

if [ "$INSTALL_CHROMIUM" = true ]; then
  echo "==> Installing Chromium (requested)"
  # On Ubuntu, chromium-browser is often a snap; keep best-effort for both distros.
  sudo apt install -y chromium || sudo apt install -y chromium-browser
else
  echo "==> Skipping Chromium (headless default). Use --with-chromium to install."
fi

#######################################
# Code-Server (optional)
#######################################
if [ "$INSTALL_CODE_SERVER" = true ]; then
  echo "==> Installing code-server"
  curl -fsSL https://code-server.dev/install.sh | sh

  # Enable as a system service (recommended in code-server docs)
  # Service name is typically code-server@<user>
  if systemctl list-unit-files | grep -q "^code-server@"; then
    sudo systemctl enable --now "code-server@${USER}"
  else
    echo "⚠️ code-server systemd unit not found. You can run it manually: code-server"
  fi
else
  echo "⚠️ Skipping code-server (--no-code-server)"
fi

#######################################
# Neovim IDE (minimal or full)
#######################################
echo "==> Installing lazy.nvim"
git clone https://github.com/folke/lazy.nvim "$HOME/.local/share/nvim/lazy/lazy.nvim" 2>/dev/null || true

echo "==> Writing Neovim config ($NVIM_MODE mode)"
mkdir -p "$HOME/.config/nvim"

if [ "$NVIM_MODE" = "minimal" ]; then
  cat << 'EOF' > "$HOME/.config/nvim/init.lua"
-- Minimal Neovim config (Telescope, Git signs, Lualine)

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({ options = { theme = "auto" } })
    end
  },
})
EOF
else
  cat << 'EOF' > "$HOME/.config/nvim/init.lua"
-- Full Neovim IDE: Treesitter, LSP, cmp, Telescope, Git signs, Lualine

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

local function exe(cmd)
  return vim.fn.executable(cmd) == 1
end

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "python", "rust", "go", "javascript" },
        highlight = { enable = true },
      })
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lsp = require("lspconfig")
      if exe("clangd") then lsp.clangd.setup({}) end
      if exe("pyright-langserver") then lsp.pyright.setup({}) end
      if exe("lua-language-server") then lsp.lua_ls.setup({}) end
      if exe("rust-analyzer") then lsp.rust_analyzer.setup({}) end
      if exe("gopls") then lsp.gopls.setup({}) end
      if exe("typescript-language-server") then lsp.tsserver.setup({}) end
    end
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip"
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        })
      })
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({ options = { theme = "auto" } })
    end
  },
})
EOF
fi

#######################################
# LSP servers (for full mode)
#######################################
if [ "$NVIM_MODE" = "full" ]; then
  echo "==> Installing LSP servers (best-effort)"
  sudo apt install -y clangd || true

  # Python LSP: pyright via npm (more reliable than apt on Debian/Ubuntu)
  sudo npm install -g pyright || true

  # Rust analyzer via rustup
  # shellcheck disable=SC1090
  source "$HOME/.cargo/env"
  rustup component add rust-analyzer || true

  # TypeScript LSP
  sudo npm install -g typescript typescript-language-server || true

  # Go LSP (gopls) via 'go install' (works with distro Go)
  if command -v go >/dev/null 2>&1; then
    GOBIN="$HOME/.local/bin" go install golang.org/x/tools/gopls@latest || true
  fi

  # lua-language-server is optional and not consistently packaged; skip by default.
fi

############################################
# AI CLI (OpenAI) (optional) - venv-based
############################################
if [ "$INSTALL_AI" = true ]; then
  echo "==> Installing OpenAI Python SDK in a venv"
  AI_VENV="$HOME/.local/share/zone01-ai-venv"
  python3 -m venv "$AI_VENV"
  "$AI_VENV/bin/pip" install --upgrade pip
  "$AI_VENV/bin/pip" install --upgrade openai

  echo "==> Installing /usr/local/bin/ai helper"
  sudo tee /usr/local/bin/ai >/dev/null << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [ -z "${OPENAI_API_KEY:-}" ]; then
  echo "❌ OPENAI_API_KEY is not set."
  echo "Set it for your shell session, for example:"
  echo '  export OPENAI_API_KEY="your_key_here"'
  exit 1
fi

AI_VENV="$HOME/.local/share/zone01-ai-venv"
PY="$AI_VENV/bin/python3"

if [ ! -x "$PY" ]; then
  echo "❌ AI venv not found at: $AI_VENV"
  echo "Re-run the installer with AI enabled."
  exit 1
fi

# Allow: ai "prompt..."  OR: echo "prompt" | ai
"$PY" - "$@" << 'PYEOF'
import os
import sys
from openai import OpenAI

client = OpenAI()

model = os.environ.get("OPENAI_MODEL", "gpt-5.2")

if len(sys.argv) > 1:
    prompt = " ".join(sys.argv[1:])
else:
    prompt = sys.stdin.read().strip()

if not prompt:
    print("❌ No prompt provided.", file=sys.stderr)
    sys.exit(1)

resp = client.responses.create(
    model=model,
    input=prompt,
)

print(resp.output_text)
PYEOF
EOF

  sudo chmod +x /usr/local/bin/ai

  echo "==> Note: OPENAI_API_KEY is not persisted automatically (recommended)."
else
  echo "⚠️ Skipping AI (--no-ai)"
fi

#######################################
# Zsh (optional)
#######################################
if [ "$INSTALL_ZSH" = true ]; then
  echo "==> Installing Zsh (no auto shell switch)"
  sudo apt install -y zsh

  cat << 'EOF' > "$HOME/.zshrc"
export EDITOR=nvim
export VISUAL=nvim

# Better history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_all_dups

# User-local bin
export PATH="$HOME/.local/bin:$PATH"
EOF

  echo "⚠️ Zsh installed. If you want it as default shell:"
  echo "    chsh -s /usr/bin/zsh"
else
  echo "⚠️ Skipping Zsh (--no-zsh)"
fi

#######################################
# Bash environment (non-interactive safe)
#######################################
echo "==> Configuring Bash environment"
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

if ! grep -q "EDITOR=nvim" "$HOME/.bashrc" 2>/dev/null; then
  echo 'export EDITOR=nvim' >> "$HOME/.bashrc"
  echo 'export VISUAL=nvim' >> "$HOME/.bashrc"
fi

#######################################
# Done
#######################################
echo
echo "==> Installation complete!"
echo "Neovim: nvim"

if [ "$INSTALL_AI" = true ]; then
  echo "Terminal AI:"
  echo '  export OPENAI_API_KEY="your_key_here"'
  echo '  ai "your question"'
  echo "Optional model override:"
  echo '  export OPENAI_MODEL="gpt-5.2"'
fi

if [ "$INSTALL_CODE_SERVER" = true ]; then
  echo "code-server:"
  echo "  systemctl status code-server@${USER} --no-pager  (if enabled)"
  echo "  open: http://<server-ip>:8080"
  echo "  password: ~/.config/code-server/config.yaml"
fi

if [ "$INSTALL_DOCKER" = true ]; then
  echo "Docker: log out and back in to use 'docker' without sudo."
fi

echo "PATH changes apply to new shells. Reconnect SSH or start a new session."
echo
