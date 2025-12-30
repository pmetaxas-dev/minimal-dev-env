# CHANGELOG

## [1.4.0] – 2025-12-30
### Added
- Full AI integration using the OpenAI API
- Global `ai` command for terminal-based AI queries
- Neovim AI plugin: ChatGPT.nvim
- New installer flags:
  - `--no-ai`
  - `--no-docker`
  - `--no-code-server`
- Unified Pi Zero 2 W installer with:
  - Neovim IDE (Treesitter, LSP, Telescope, cmp, Git signs, Lualine)
  - Optional Code‑Server
  - Optional Docker
  - Rust, Go, Node.js, Python3
  - Zsh environment
- Updated README to document AI usage and installer flags

### Changed
- Consolidated all Pi Zero setup steps into a single unified installer
- Improved validation logic and error messages
- Simplified Neovim configuration structure
- Removed Zsh entirely from the installer
- Bash is now the default and only supported shell
- AI environment variables now persist in ~/.bashrc
- Removed shell switching (no more chsh)

### Fixed
- fd/fdfind aliasing on Debian-based systems
- Missing dependencies for ChatGPT.nvim (plenary, nui)

### Removed
- Docker support removed entirely from the Pi Zero unified installer
- `--no-docker` flag removed
- All Docker-related messages and group modifications removed


---

## [1.3.0] – Previous Release
- Added Pi Zero optimized installer
- Added minimal Neovim config
- Added Code‑Server support
- Added Docker support

## [1.2.0]
- Added validation script
- Added static analysis tools

## [1.1.0]
- Added core development tools
- Added networking tools

## [1.0.0]
- Initial release
