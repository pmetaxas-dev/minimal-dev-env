#!/usr/bin/env bash
set -euo pipefail

echo "==> Universal Minimal Dev Environment Installer (Pi-friendly, headless)"

############################################
# Detect OS + Architecture
############################################

OS=""
ARCH=""

if grep -qi "ubuntu" /etc/os-release; then
  OS="ubuntu"
elif grep -qi "raspbian" /etc/os-release; then
  OS="raspbian"
elif grep -qi "debian" /etc/os-release; then
  OS="debian"
else
  echo "❌ Unsupported OS. Only Ubuntu, Debian, and Raspberry Pi OS are supported."
  exit 1
fi

ARCH="$(uname -m)"

echo "Detected OS: $OS"
echo "Detected Architecture: $ARCH"

############################################
# Parse flags
############################################

INSTALL_CODE_SERVER=true
INSTALL_AI=true

for arg in "$@"; do
  case "$arg" in
    --no-code-server)
      INSTALL_CODE_SERVER=false
      ;;
    --no-ai)
      INSTALL_AI=false
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Available options:"
      echo "  --no-code-server"
      echo "  --no-ai"
      exit 1
      ;;
  esac
done

############################################
# Validation
############################################

echo "==> Validating system..."

if ! sudo -v >/dev/null 2>&1; then
  echo "❌ Sudo privileges required."
  exit 1
fi

if ! ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
  echo "❌ No internet connection."
  exit 1
fi

FREE_SPACE="$(df / | tail -1 | awk '{print $4}')"
if [ "$FREE_SPACE" -lt 2000000 ]; then
  echo "❌ Not enough disk space (need 2GB free)."
  exit 1
fi

echo "✅ Validation passed"

############################################
# Update system
############################################

echo "==> Updating system"
sudo apt update -y
sudo apt upgrade -y

############################################
# Install core tools
############################################

echo "==> Installing core tools"
sudo apt install -y \
  build-essential git curl wget python3 python3-pip \
  tmux neovim ripgrep fzf htop ncdu jq ranger \
  ca-certificates unzip fd-find lua5.4 w3m w3m-img

############################################
# eza (modern ls) via apt if available
############################################

echo "==> Installing eza (if available in repos)"
if sudo apt install -y eza 2>/dev/null; then
  echo "✅ eza installed from apt"
else
  echo "⚠️ eza package not available in repos, skipping"
fi

############################################
# Install languages
############################################

echo "==> Installing Go"
sudo apt install -y golang

echo "==> Installing Node.js (Debian version)"
sudo apt install -y nodejs npm

############################################
# Code-Server (optional)
############################################

if [ "$INSTALL_CODE_SERVER" = true ]; then
  # Pi Zero friendly warning
  if [ "$ARCH" = "armv6l" ] || [ "$ARCH" = "armv7l" ]; then
    echo "⚠️ Code-Server can be heavy on low-RAM devices like Pi Zero."
    echo "   If it fails or is too slow, reinstall with --no-code-server."
  fi

  echo "==> Installing Code-Server"
  curl -fsSL https://code-server.dev/install.sh | sh
else
  echo "⚠️ Skipping Code-Server (--no-code-server)"
fi

############################################
# Minimal Neovim config (no Treesitter, no LSP)
############################################

echo "==> Installing lazy.nvim"
git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim 2>/dev/null || true

echo "==> Writing minimal Neovim config"
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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({})
        end
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = { theme = "auto" }
            })
        end
    },

    -- ChatGPT.nvim (AI)
    {
        "jackMort/ChatGPT.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim"
        },
        config = function()
            require("chatgpt").setup({
                api_key_cmd = "echo $OPENAI_API_KEY"
            })
        end
    }
})
EOF

############################################
# AI CLI (OpenAI)
############################################

if [ "$INSTALL_AI" = true ]; then
  echo "==> Installing OpenAI CLI"
  pip install --break-system-packages --upgrade "openai>=1.0.0"

  sudo tee /usr/local/bin/ai >/dev/null << 'EOF'
#!/usr/bin/env bash
if [ -z "${OPENAI_API_KEY:-}" ]; then
  echo "❌ OPENAI_API_KEY is not set."
  echo "   Make sure your .env is imported and sourced (e.g. via your USB import script)."
  exit 1
fi

python3 - "$@" << 'PYEOF'
from openai import OpenAI
import sys

client = OpenAI()

if len(sys.argv) > 1:
    prompt = " ".join(sys.argv[1:])
else:
    prompt = sys.stdin.read().strip()

if not prompt:
    print("❌ No prompt provided.")
    sys.exit(1)

resp = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[{"role": "user", "content": prompt}]
)

print(resp.choices[0].message.content)
PYEOF
EOF

  sudo chmod +x /usr/local/bin/ai
else
  echo "⚠️ Skipping AI (--no-ai)"
fi

############################################
# Bash environment (minimal, no .env touching)
############################################

echo "==> Configuring Bash (EDITOR only, no API key logic)"

if ! grep -q "EDITOR=nvim" "${HOME}/.bashrc" 2>/dev/null; then
  {
    echo 'export EDITOR=nvim'
    echo 'export VISUAL=nvim'
  } >> "${HOME}/.bashrc"
fi

############################################
# Done
############################################

echo
echo "==> Universal installation complete!"
echo "Neovim: nvim"
echo "Neovim AI: :ChatGPT (requires OPENAI_API_KEY in environment)"
echo "Terminal AI: ai \"your question\""
if [ "$INSTALL_CODE_SERVER" = true ]; then
  echo "Code-Server: systemctl --user start code-server"
fi
echo
echo "Reminder: Use your USB import script to populate ~/.env and ensure it is sourced via /etc/bash.bashrc."
echo "This way, your AI API Key will be installed and persistent!"
echo "**********************  Ready for Action!!  **************************"
