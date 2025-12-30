#!/usr/bin/env bash

set -e

echo "==> Raspberry Pi Zero 2 W unified dev environment installer"

#######################################
# Parse flags
#######################################

INSTALL_CODE_SERVER=true
INSTALL_AI=true

for arg in "$@"; do
  case $arg in
    --no-code-server)
      INSTALL_CODE_SERVER=false
      ;;
    --no-ai)
      INSTALL_AI=false
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Available options:"
      echo "  --no-docker"
      echo "  --no-code-server"
      echo "  --no-ai"
      exit 1
      ;;
  esac
done

#######################################
# Validation
#######################################

echo "==> Validating system compatibility..."

if ! grep -qiE "debian|ubuntu|raspbian" /etc/os-release; then
  echo "❌ Unsupported OS. Only Debian-based systems are supported."
  exit 1
fi

if ! command -v apt >/dev/null 2>&1; then
  echo "❌ APT package manager not found."
  exit 1
fi

if ! sudo -v >/dev/null 2>&1; then
  echo "❌ Sudo privileges required."
  exit 1
fi

if ! ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
  echo "❌ No internet connection."
  exit 1
fi

FREE_SPACE=$(df / | tail -1 | awk '{print $4}')
if [ "$FREE_SPACE" -lt 2000000 ]; then
  echo "❌ Not enough disk space (need 2GB free)."
  exit 1
fi

echo "✅ System validation passed."

#######################################
# Core tools
#######################################

echo "==> Updating system"
sudo apt update -y
sudo apt upgrade -y

echo "==> Installing core development tools"
sudo apt install -y \
    build-essential clang gdb valgrind make cmake pkg-config \
    git curl wget python3 python3-pip tmux neovim ripgrep fzf \
    htop ncdu netcat-openbsd openssh-client manpages-dev jq \
    ranger exa ca-certificates unzip fd-find lua5.4

echo "==> Installing static analysis tools"
sudo apt install -y cppcheck clang-tidy clang-format

echo "==> Installing networking tools"
sudo apt install -y iproute2 iputils-ping traceroute nmap tcpdump

#######################################
# Languages
#######################################

echo "==> Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

echo "==> Installing Go"
sudo apt install -y golang

echo "==> Installing Node.js LTS"
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

#######################################
# Terminal browser
#######################################

echo "==> Installing w3m"
sudo apt install -y w3m w3m-img

#######################################
# Code-Server (optional)
#######################################

if [ "$INSTALL_CODE_SERVER" = true ]; then
  echo "==> Installing Code-Server"
  curl -fsSL https://code-server.dev/install.sh | sh
else
  echo "⚠️  Skipping Code-Server (--no-code-server)"
fi

#######################################
# Neovim IDE (Treesitter, LSP, Telescope, cmp, lualine, ChatGPT.nvim)
#######################################

echo "==> Installing lazy.nvim"
git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim 2>/dev/null || true

echo "==> Writing Neovim IDE config"
mkdir -p ~/.config/nvim

cat << 'EOF' > ~/.config/nvim/init.lua
-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "lua", "rust", "go", "javascript", "python" },
                highlight = { enable = true },
            })
        end
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({})
        end
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lsp = require("lspconfig")
            lsp.clangd.setup({})
            lsp.rust_analyzer.setup({})
            lsp.gopls.setup({})
            lsp.tsserver.setup({})
            lsp.pyright.setup({})
        end
    },

    -- Autocomplete
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

    -- ChatGPT.nvim (AI plugin)
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

#######################################
# LSP servers
#######################################

echo "==> Installing LSP servers"
sudo apt install -y clangd gopls pyright
rustup component add rust-analyzer || true
sudo npm install -g typescript-language-server typescript

#######################################
# AI CLI (OpenAI)
#######################################

if [ "$INSTALL_AI" = true ]; then
  echo "==> Installing OpenAI CLI support"
  pip install --upgrade openai

  sudo tee /usr/local/bin/ai >/dev/null << 'EOF'
#!/usr/bin/env bash
if [ -z "$OPENAI_API_KEY" ]; then
  echo "❌ OPENAI_API_KEY is not set."
  exit 1
fi

python3 - << PYEOF
from openai import OpenAI
import sys

client = OpenAI()

prompt = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else sys.stdin.read()

resp = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[{"role": "user", "content": prompt}]
)

print(resp.choices[0].message["content"])
PYEOF
EOF

  sudo chmod +x /usr/local/bin/ai
else
  echo "⚠️  Skipping AI (--no-ai)"
fi

#######################################
# Shell Environment (Bash Only)
#######################################

echo "==> Configuring Bash environment"

# Ensure OPENAI_API_KEY persists in bash
if [ "$INSTALL_AI" = true ]; then
  if ! grep -q "OPENAI_API_KEY" ~/.bashrc; then
    echo 'export OPENAI_API_KEY="$OPENAI_API_KEY"' >> ~/.bashrc
  fi
fi

# Set Neovim as default editor
if ! grep -q "EDITOR=nvim" ~/.bashrc; then
  echo 'export EDITOR=nvim' >> ~/.bashrc
  echo 'export VISUAL=nvim' >> ~/.bashrc
fi

#######################################
# Done
#######################################

echo
echo "==> Installation complete!"
echo "Neovim IDE: run 'nvim'"
echo "Neovim AI: :ChatGPT"
echo "Terminal AI: ai \"your question\""
if [ "$INSTALL_CODE_SERVER" = true ]; then
  echo "Code-Server: systemctl --user start code-server"
fi
if [ "$INSTALL_DOCKER" = true ]; then
  echo "Docker installed — log out and back in to activate group changes."
fi
echo
