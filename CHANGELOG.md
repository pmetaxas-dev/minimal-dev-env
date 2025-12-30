# CHANGELOG

## [2.2.0] – 2025‑12‑30
### Added
- **XFCE minimal desktop** to `install-desktop-universal.sh`
- **Openbox ultra‑minimal GUI** to `install-pizero-unified.sh`
- GUI is **disabled by default** using `systemctl set-default multi-user.target`
- Manual GUI launch instructions (`startx`)
- Updated README with:
  - GUI section
  - Browser compatibility notes
  - Updated flags table
  - Updated installation examples

### Changed
- Browser support:
  - Desktop → Chromium
  - Pi Zero → Falkon
- README reorganized for clarity and GUI integration
- Improved installer descriptions and feature lists

### Fixed
- eza installation now uses cargo (APT package removed)
- Falkon/Chromium documentation updated to reflect GUI requirements

---

## [2.1.0]
- Added Chromium browser to desktop installer
- Added Falkon browser to Pi installer
- Added `--no-chromium` and `--no-falkon` flags
- Updated README and flags table

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
