# CHANGELOG

## [2.3.0] – 2025‑12‑30
### Added
- Renamed `install-pizero-unified.sh` → **install-pi-zero.sh**
- Added **USB-based .env import script** (`import-env-from-usb.sh`)
- Added `.env.example` template
- Added `.env` to `.gitignore`
- Added `.env` auto-loading in both installers
- Added secure `.env` creation with permissions
- Updated Neovim ChatGPT.nvim to load API key from `.env`
- Updated `ai` CLI to load `.env` directly
- Added full documentation for `.env` usage and USB import
- Added XFCE minimal desktop to desktop installer
- Added Openbox ultra-minimal GUI to Pi Zero installer

### Changed
- Browser support:
  - Desktop → Chromium
  - Pi Zero → Falkon
- GUI is now disabled by default (`multi-user.target`)
- README updated with:
  - GUI section
  - USB import instructions
  - `.env` workflow
  - Updated flags table
  - Updated installation examples
- Improved installer descriptions and feature lists

### Fixed
- eza installation now uses cargo (APT package removed)
- Falkon/Chromium documentation updated to reflect GUI requirements

---

## [2.2.0]
- Added GUI support (XFCE/Openbox)
- Added manual `startx` instructions
- Updated README and flags

---

## [2.1.0]
- Added Chromium browser to desktop installer
- Added Falkon browser to Pi installer
- Added `--no-chromium` and `--no-falkon` flags

---

## [2.0.0]
- Added universal desktop/server installer
- Added Pi Zero unified installer
- Added AI CLI (`ai`)
- Added ChatGPT.nvim integration
- Added minimal/full Neovim IDE modes
- Added Code‑Server support
- Added validation script

---

## [1.0.0]
- Initial release
