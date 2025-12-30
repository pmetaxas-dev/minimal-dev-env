# CHANGELOG

# CHANGELOG

## [2.0.0] – 2025‑12‑30
### Added
- `install-desktop-universal.sh` — universal desktop/server installer
  - Optional Docker, Zsh, Code‑Server, AI
  - Minimal or full Neovim IDE
- `install-pizero-unified.sh` — Pi Zero unified installer
  - Minimal Neovim IDE
  - Optional Code‑Server and AI
- `validate.sh` — system validation script
  - OS, APT, sudo, internet, disk space, Docker group, GUI checks
- AI CLI (`ai`) using OpenAI Python SDK v1+
- ChatGPT.nvim integration
- Lazy.nvim plugin manager
- Flags for all installers:
  - `--no-docker`, `--no-zsh`, `--no-code-server`, `--no-ai`, `--minimal-nvim`

### Changed
- Node.js installation uses Debian/Ubuntu repo version for ARMv7 stability
- Replaced `exa` with `eza` for compatibility
- Removed GUI apps (VS Code, qutebrowser)
- Improved Bash environment setup
- Unified Neovim config structure

### Removed
- Zsh auto shell switching
- Treesitter/LSP/autocomplete from Pi installer
- GUI dependencies

---

## [1.0.0]
- Initial Pi Zero installer with minimal Neovim IDE


## [1.6.0] – 2025‑12‑30
### Added
- **Universal Installer (`install-universal.sh`)**
  - Auto‑detects OS (Ubuntu, Debian, Raspberry Pi OS)
  - Auto‑detects architecture (ARMv7, ARM64, x86_64)
  - Automatically adjusts package choices for each platform
- Optional AI integration (ChatGPT.nvim + `ai` CLI)
- Optional Code‑Server installation
- Minimal Neovim configuration:
  - Telescope
  - Git signs
  - Lualine
  - No Treesitter
  - No LSP
  - No autocomplete

### Changed
- Replaced `exa` with `eza` for compatibility across all distros
- Switched Node.js installation to Debian repo version for ARMv7 stability
- Bash‑only environment (no Zsh)
- Updated README to reflect universal installer
- Updated Pi Zero installers to match new structure

### Removed
- Docker support (fully removed)
- Zsh installation and shell switching
- Treesitter (removed for performance reasons)
- All LSP servers (clangd, pyright, lua_ls, rust-analyzer)
- Autocomplete (nvim-cmp, LuaSnip)

---

## [1.5.0]
- Added minimal Pi Zero installer
- Added AI integration
- Added Code‑Server support

## [1.4.0]
- Added full Pi Zero unified installer

## [1.3.0]
- Added Pi Zero optimized installer

## [1.2.0]
- Added validation script

## [1.1.0]
- Added core development tools

## [1.0.0]
- Initial release
