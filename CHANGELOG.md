# CHANGELOG

## [2.1.0] – 2025‑12‑30
### Added
- Chromium browser installation to `install-desktop-universal.sh`
- Falkon lightweight browser installation to `install-pizero-unified.sh`
- New flags:
  - `--no-chromium` (desktop)
  - `--no-falkon` (Pi Zero)
- eza installation via cargo (replaces broken apt package)
- Updated README with:
  - Correct git clone command using `pmetaxas-dev`
  - Browser support section
  - Updated flags table
  - Updated installation examples

### Changed
- Desktop installer now installs Chromium instead of relying on system defaults
- Pi installer now installs Falkon for lightweight GUI browsing
- eza removed from apt list and installed via cargo
- README reorganized for clarity and consistency
- Improved installer descriptions and feature lists

### Fixed
- eza “Unable to locate package” error on Debian/Ubuntu/Pi OS
- Missing browser support for Code‑Server UI on Pi Zero

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
