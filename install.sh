#!/usr/bin/env bash
set -euo pipefail

echo "==> Universal desktop/server dev environment installer (headless-friendly)"

#######################################
# Flags
#######################################

INSTALL_DOCKER=true
INSTALL_ZSH=true
INSTALL_CODE_SERVER=true
INSTALL_AI=true
NVIM_MODE="full"  # "full" or "minimal"

for arg in "$@"; do
  case "$arg" in
    --no-docker) INSTALL_DOCKER=false ;;
    --no-zsh) INSTALL_ZSH=false ;;
    --no-code-server) INSTALL_CODE_SERVER=false ;;
    --no-ai) INSTALL_AI=false ;;
    --minimal-nvim) NVIM_MODE="minimal" ;;
    *)
      echo "Unknown option: $arg"
      echo "Available options:"
      echo "  --no-docker"
      echo "  --no-zsh"
      echo "  --no-code-server"
      echo "  --no-ai"
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

if ! ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
  echo "❌ No internet connection."
  exit 1
fi

FREE_SPACE=$(df / | tail -1 | awk '{print $4}')
if [ "$FREE_SPACE" -lt 2000000 ]; then
  echo "❌ Not enough disk space (need 2GB free)."
  exit 1
fi

echo "✅ Validation passed"

#######################################
# Core tools
#######################################

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
  eza \
  ca-certificates \
  unzip \
  fd-find \
  w3m \
  w3m-img

echo "==> Installing static analysis tools"
sudo apt install -y cppcheck clang-tidy clang-format

echo "==> Installing networking tools"
sudo apt install -y iproute2 iputils-ping traceroute nmap tcpdump

#######################################
# Docker (optional)
#######################################

if [ "$INSTALL_DOCKER" = true ]; then
  echo "==> Installing Docker"
  sudo apt install -y docker.io docker-compose-plugin
  sudo usermod -aG docker "$USER"
  echo "⚠️  Docker group updated. Log out and back in to use Docker without sudo."
else
  echo "⚠️  Skipping Docker (--no-docker)"
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

echo "==> Installing Rust (rustup)"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# shellcheck disable=SC1090
source "$HOME/.cargo/env"

echo "==> Installing Go"
sudo apt install -y golang

echo "==> Installing Node.js (Debian/Ubuntu version) + npm"
sudo apt install -y nodejs npm

#######################################
# Code-Server (optional, headless VS Code)
#######################################

if [ "$INSTALL_CODE_SERVER" = true ]; then
  echo "==> Installing Code-Server"
  curl -fsSL https://code-server.dev/install.sh | sh
else
  echo "⚠️  Skipping Code-Server (--no-code-server)"
fi

#######################################
# Neovim IDE (minimal or full)
#######################################

echo "==> Installing lazy.nvim"
git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim 2>/dev/null || true

echo "==> Writing Neovim config ($NVIM_MODE mode)"
mkdir -p ~/.config/nvim

if [ "$NVIM_MODE" = "minimal" ]; then
  cat << 'EOF' > ~/.config/nvim/init.lua
-- Minimal Neovim config (no Treesitter, no LSP, no cmp)

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

else
  cat << 'EOF' > ~/.config/nvim/init.lua
-- Full Neovim IDE: Treesitter, LSP, cmp, Telescope, Git signs, Lualine, ChatGPT.nvim

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

  -- Treesitter
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
      lsp.pyright.setup({})
      lsp.lua_ls.setup({})
      lsp.rust_analyzer.setup({})
      lsp.gopls.setup({})
      lsp.tsserver.setup({})
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
fi

#######################################
# LSP servers (for full mode)
#######################################

if [ "$NVIM_MODE" = "full" ]; then
  echo "==> Installing LSP servers"
  sudo apt install -y clangd pyright lua-language-server
  rustup component add rust-analyzer || true
  sudo npm install -g typescript-language-server typescript
fi

#######################################
# AI CLI (OpenAI)
#######################################

if [ "$INSTALL_AI" = true ]; then
  echo "==> Installing OpenAI CLI"
  pip install --upgrade "openai>=1.0.0"

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
# Zsh (optional)
#######################################

if [ "$INSTALL_ZSH" = true ]; then
  echo "==> Installing Zsh (no auto shell switch)"
  sudo apt install -y zsh

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

  echo "⚠️  Zsh installed. If you want to use it as your default shell, run:"
  echo "    chsh -s /usr/bin/zsh"
else
  echo "⚠️  Skipping Zsh (--no-zsh)"
fi

#######################################
# Bash environment
#######################################

echo "==> Configuring Bash environment"

if [ "$INSTALL_AI" = true ]; then
  if ! grep -q "OPENAI_API_KEY" ~/.bashrc 2>/dev/null; then
    echo 'export OPENAI_API_KEY="$OPENAI_API_KEY"' >> ~/.bashrc
  fi
fi

if ! grep -q "EDITOR=nvim" ~/.bashrc 2>/dev/null; then
  echo 'export EDITOR=nvim' >> ~/.bashrc
  echo 'export VISUAL=nvim' >> ~/.bashrc
fi

#######################################
# Done
#######################################

echo
echo "==> Installation complete!"
echo "Neovim: nvim"
echo "Neovim AI: :ChatGPT"
if [ "$INSTALL_AI" = true ]; then
  echo "Terminal AI: ai \"your question\""
fi
if [ "$INSTALL_CODE_SERVER" = true ]; then
  echo "Code-Server: systemctl --user start code-server"
  echo "Then open: http://<your-server-ip>:8080"
fi
if [ "$INSTALL_DOCKER" = true ]; then
  echo "Docker: log out and back in to use 'docker' without sudo."
fi
echo
