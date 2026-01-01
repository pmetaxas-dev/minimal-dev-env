#!/usr/bin/env bash
set -euo pipefail

echo "==============================================="
echo "  Extra Capabilities + Full Neovim Plugins"
echo "  For Raspberry Pi Zero 2 W (Legacy 64-bit)"
echo "==============================================="
echo

############################################
# Safety checks
############################################

if ! sudo -v >/dev/null 2>&1; then
  echo "❌ Sudo privileges required."
  exit 1
fi

if ! command -v nvim >/dev/null 2>&1; then
  echo "❌ Neovim is not installed. Run install-pi-zero.sh first."
  exit 1
fi

############################################
# Install extra CLI tools
############################################

echo "==> Installing extra CLI tools"

sudo apt install -y \
  bat \
  silversearcher-ag \
  tree \
  shellcheck \
  entr \
  httpie \
  neofetch \
  figlet \
  lolcat \
  pv \
  jq \
  ripgrep \
  fd-find \
  fzf \
  tmux \
  ranger \
  ncdu \
  htop \
  w3m w3m-img

echo "✔ Extra CLI tools installed"
echo

############################################
# Install Neovim plugin dependencies
############################################

echo "==> Installing Neovim plugin dependencies"

sudo apt install -y \
  luarocks \
  python3-venv \
  python3-dev \
  libfuse2 \
  libssl-dev \
  libffi-dev \
  build-essential

echo "✔ Neovim dependencies installed"
echo

############################################
# Install Mason (LSP manager) dependencies
############################################

echo "==> Installing LSP servers (via Mason)"

# These will be installed by Mason automatically inside Neovim:
# - pyright
# - bash-language-server
# - lua-language-server
# - json-lsp
# - yaml-language-server

echo "✔ Mason will handle LSP servers on first Neovim launch"
echo

############################################
# Install full Neovim plugin suite
############################################

echo "==> Installing full Neovim plugin suite"

mkdir -p ~/.config/nvim

cat << 'EOF' > ~/.config/nvim/init.lua
-----------------------------------------------------------
--  FULL NEOVIM CONFIG FOR PI ZERO 2 W (HEADLESS)
-----------------------------------------------------------

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.wrap = false

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    -----------------------------------------------------------
    -- UI / THEMES
    -----------------------------------------------------------
    { "folke/tokyonight.nvim" },
    { "catppuccin/nvim", name = "catppuccin" },
    { "nvim-lualine/lualine.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "akinsho/bufferline.nvim" },

    -----------------------------------------------------------
    -- FILE EXPLORER
    -----------------------------------------------------------
    { "nvim-tree/nvim-tree.lua" },

    -----------------------------------------------------------
    -- SEARCH / NAVIGATION
    -----------------------------------------------------------
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -----------------------------------------------------------
    -- GIT
    -----------------------------------------------------------
    { "lewis6991/gitsigns.nvim" },
    { "tpope/vim-fugitive" },

    -----------------------------------------------------------
    -- LSP / COMPLETION
    -----------------------------------------------------------
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },

    -----------------------------------------------------------
    -- TREESITTER (light config)
    -----------------------------------------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    -----------------------------------------------------------
    -- AI
    -----------------------------------------------------------
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
    },

    -----------------------------------------------------------
    -- PRODUCTIVITY
    -----------------------------------------------------------
    { "windwp/nvim-autopairs" },
    { "numToStr/Comment.nvim" },
    { "lukas-reineke/indent-blankline.nvim" },
    { "folke/which-key.nvim" },
    { "folke/todo-comments.nvim" },
    { "folke/trouble.nvim" },
    { "mbbill/undotree" },
    { "tpope/vim-surround" },
    { "tpope/vim-repeat" },

    -----------------------------------------------------------
    -- TERMINAL
    -----------------------------------------------------------
    { "akinsho/toggleterm.nvim" },

    -----------------------------------------------------------
    -- FILE MANAGER ALTERNATIVE
    -----------------------------------------------------------
    { "stevearc/oil.nvim" },
})
EOF

echo "✔ Full Neovim plugin suite installed"
echo

############################################
# Final message
############################################

echo "==============================================="
echo "  Extra capabilities + full Neovim plugins"
echo "  installation complete!"
echo "==============================================="
echo
echo "Launch Neovim with: nvim"
echo "Run :Lazy to install plugins"
echo "Run :Mason to install LSP servers"
echo
echo "AI inside Neovim: :ChatGPT"
echo
