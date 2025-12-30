# CHANGELOG

## [1.5.0] – 2025‑12‑30
### Added
- New **Minimal Pi Zero Installer** (`install-pizero-minimal.sh`)
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
- Replaced `exa` with `eza` for compatibility with Raspberry Pi OS
- Switched Node.js installation to Debian repo version for ARMv7 stability
- Bash‑only environment (no Zsh)
- Updated README to reflect minimal edition
- Updated unified installer references

### Removed
- Treesitter (removed for performance reasons)
- All LSP servers (clangd, pyright, lua_ls, rust-analyzer)
- Autocomplete (nvim-cmp, LuaSnip)
- Docker support (fully removed)
- Zsh installation and shell switching

---

## [1.4.0]
- Added full Pi Zero unified installer
- Added AI integration
- Added ChatGPT.nvim
- Added Code‑Server support

## [1.3.0]
- Added Pi Zero optimized installer
- Added Neovim IDE

## [1.2.0]
- Added validation script
- Added static analysis tools

## [1.1.0]
- Added core development tools
- Added networking tools

## [1.0.0]
- Initial release
