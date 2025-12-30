# 🧰 Universal Dev Environment Installers  
### For Desktop/Server and Raspberry Pi Zero 2 W  
### (Headless‑First, GUI‑Optional, AI‑Ready)

This repository provides two fully‑featured, headless‑friendly development environment installers:

- **install-desktop-universal.sh** — for Ubuntu Server, Debian, and headless desktop PCs  
- **install-pi-zero.sh** — for Raspberry Pi Zero 2 W running Raspberry Pi OS Legacy (64‑bit)

Both installers are:

- 🟦 Bash‑only (no GUI required)  
- 🟩 Headless‑compatible  
- 🖥 Optional lightweight GUI (XFCE or Openbox)  
- 🌐 Browser‑ready (Chromium or Falkon)  
- 🤖 AI‑enabled (optional)  
- ✨ Neovim‑based IDE (minimal or full)  
- 🖥 Code‑Server‑enabled (optional)  
- 🔑 `.env`‑based API key loading  
- 📦 USB import support for `.env`

---

# 🚀 Quick Installation Guide

## 📥 Install Git (if missing)

```bash
sudo apt update -y && sudo apt install -y git
```

## 📥 Clone the repository

```bash
git clone https://github.com/pmetaxas-dev/minimal-dev-env.git
cd minimal-dev-env
```

---

# 🖥 Desktop / Server Installation (Ubuntu or Debian)

```bash
bash install-desktop-universal.sh
```

Minimal install example:

```bash
bash install-desktop-universal.sh --no-docker --no-zsh --no-code-server --no-ai --minimal-nvim --no-chromium
```

---

# 🍓 Raspberry Pi Zero 2 W Installation

```bash
bash install-pi-zero.sh
```

Minimal install example:

```bash
bash install-pi-zero.sh --no-code-server --no-ai --no-falkon
```

---

# 🧭 GUI Support (Optional)

Both installers include **lightweight graphical environments**, but **they do NOT start automatically**.  
Your system will still boot into **pure terminal mode**.

### 🖥 Desktop Installer → XFCE Minimal
- Lightweight, stable, full desktop environment  
- Browser support: **Chromium**  
- Launch manually:

```bash
startx
```

### 🍓 Pi Zero Installer → Openbox Ultra‑Minimal
- Extremely lightweight window manager  
- Browser support: **Falkon**  
- Launch manually:

```bash
startx
```

### Disable GUI autostart (already applied)
Both installers run:

```bash
sudo systemctl set-default multi-user.target
```

This ensures **CLI‑only boot**, even with GUI installed.

---

# 🔑 API Key Management via `.env`

Your OpenAI API key is stored in:

```
~/.env
```

Example:

```
OPENAI_API_KEY="sk-xxxx..."
```

The installers automatically:

- Create `.env` if missing  
- Add `source ~/.env` to `.bashrc`  
- Configure the `ai` CLI to load `.env`  
- Configure Neovim ChatGPT.nvim to read `.env`  

---

# 📦 Importing `.env` from USB

Use the included script:

```bash
bash import-env-from-usb.sh
```

It will:

- Detect the USB device  
- Mount it  
- Copy `.env` to your home directory  
- Set secure permissions  
- Unmount safely  

Perfect for offline systems.

---

# 🔧 Features

## 🧱 Core Tools
- GCC, Make, CMake  
- Git, curl, wget  
- Python3 + pip  
- Go, Rust, Node.js  
- ripgrep, fzf, fd, ranger, eza (via cargo)  
- tmux, jq, ncdu, htop  
- w3m terminal browser  
- Static analysis tools (clang-tidy, cppcheck)  
- Networking tools (nmap, tcpdump, traceroute)

---

## 🌐 Browsers

### Desktop Installer
- **Chromium** (optional)

### Pi Zero Installer
- **Falkon** (optional, lightweight QtWebEngine browser)

---

## ✨ Neovim IDE

### Minimal Mode
- Telescope  
- Git signs  
- Lualine  
- No Treesitter  
- No LSP  
- No autocomplete  

### Full Mode
- Treesitter  
- LSP servers  
- Autocomplete (cmp)  
- Telescope  
- Git signs  
- Lualine  
- ChatGPT.nvim  

Both modes use **Lazy.nvim** as the plugin manager.

---

## 🤖 AI Integration (Optional)

### Terminal AI
```bash
ai "Explain this code"
```

### Neovim AI
Inside Neovim:

```
:ChatGPT
```

### API key is loaded automatically from:
```
~/.env
```

---

## 🖥 Code‑Server (Optional)

Start Code‑Server:

```bash
systemctl --user start code-server
```

Then open in your browser:

```
http://<your-device-ip>:8080
```

---

# ⚙️ Installer Flags

| Flag | Description |
|------|-------------|
| `--no-docker` | Skip Docker installation (desktop only) |
| `--no-zsh` | Skip Zsh installation (desktop only) |
| `--no-code-server` | Skip Code‑Server |
| `--no-ai` | Skip AI integration |
| `--no-chromium` | Skip Chromium browser (desktop only) |
| `--no-falkon` | Skip Falkon browser (Pi only) |
| `--minimal-nvim` | Use minimal Neovim config |

---

# 🔍 System Validation

Before installing, you can validate your system:

```bash
bash validate.sh
```

This checks:

- OS compatibility (Debian/Ubuntu)
- APT availability
- Sudo access
- Internet connection
- Disk space (≥ 2GB)
- Docker group membership
- GUI availability (optional)

---

# 📁 Repository Structure

```
minimal-dev-env/
│
├── install-desktop-universal.sh     # Desktop/server installer
├── install-pi-zero.sh               # Pi Zero installer
├── import-env-from-usb.sh           # USB-based .env importer
├── validate.sh                      # System validation script
├── .env.example                     # Template for API key
├── README.md
├── CHANGELOG.md
└── LICENSE
```

---

# 🧭 Requirements

- Debian or Ubuntu system  
- Raspberry Pi Zero 2 W (for Pi installer)  
- Internet connection  
- OpenAI API key (optional for AI features)

---

# 🤝 Contributing

PRs and suggestions welcome.

---

# 📜 License

This project is licensed under the **Zone01 Restricted License**.
