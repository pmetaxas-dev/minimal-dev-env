# 🧰 Universal Dev Environment Installers  
### For Desktop/Server and Raspberry Pi Zero 2 W (Headless, Bash‑Only)

This repository provides two fully‑featured, headless‑friendly development environment installers:

- **install-desktop-universal.sh** — for Ubuntu Server, Debian, and headless desktop PCs  
- **install-pizero-unified.sh** — for Raspberry Pi Zero 2 W running Raspberry Pi OS Legacy (64‑bit)

Both installers are:

- Bash‑only (no Zsh or GUI dependencies)
- Headless‑compatible
- AI‑enabled (optional)
- Code‑Server‑enabled (optional)
- Neovim‑based IDE (minimal or full)

---

## 📦 Installers Overview

### 🖥 Desktop/Server Installer  
**File:** `install-desktop-universal.sh`  
**Best for:**  
- Ubuntu Server  
- Debian  
- Headless desktops  
- Cloud VMs  

### 🍓 Pi Zero Installer  
**File:** `install-pizero-unified.sh`  
**Best for:**  
- Raspberry Pi Zero 2 W  
- Raspberry Pi OS Legacy (64‑bit)  
- ARMv7 systems  

---

## 🚀 Features

### Core Tools
- GCC, Make, CMake  
- Git, curl, wget  
- Python3 + pip  
- Go, Rust, Node.js (Debian version)  
- ripgrep, fzf, fd, ranger, eza  
- tmux, jq, ncdu, htop  
- w3m terminal browser  
- Static analysis tools (clang-tidy, cppcheck)  
- Networking tools (nmap, tcpdump, traceroute)

### Neovim IDE
- Minimal mode: Telescope, Git signs, Lualine  
- Full mode: Treesitter, LSP servers, Autocomplete (cmp), ChatGPT.nvim  
- Lazy.nvim plugin manager  
- Bash‑based config

### AI Integration (Optional)
- `ai` CLI using OpenAI API  
- ChatGPT.nvim inside Neovim  
- GPT‑4o‑mini by default  
- Bash‑only, no GUI required

### Code‑Server (Optional)
- Browser‑based VS Code  
- Runs on port `8080`  
- Systemd user service

---

## ⚙️ Installer Flags

| Flag | Description |
|------|-------------|
| `--no-docker` | Skip Docker installation (desktop only) |
| `--no-zsh` | Skip Zsh installation (desktop only) |
| `--no-code-server` | Skip Code‑Server |
| `--no-ai` | Skip AI integration |
| `--minimal-nvim` | Use minimal Neovim config (no Treesitter/LSP/cmp) |

### Example

```bash
bash install-desktop-universal.sh --no-docker --no-zsh --no-code-server --no-ai --minimal-nvim
```

```bash
bash install-pizero-unified.sh --no-code-server --no-ai
```

---

## 🤖 AI Usage

Set your OpenAI API key:

```bash
export OPENAI_API_KEY="your_api_key_here"
echo 'export OPENAI_API_KEY="your_api_key_here"' >> ~/.bashrc
source ~/.bashrc
```

Use in terminal:

```bash
ai "Explain this code"
```

Use in Neovim:

```
:ChatGPT
```

---

## 🖥 Code‑Server Usage

Start Code‑Server:

```bash
systemctl --user start code-server
```

Then open:

```
http://<your-device-ip>:8080
```

---

## 🔍 System Validation

Run:

```bash
bash validate.sh
```

Checks:

- OS compatibility (Debian/Ubuntu)
- APT availability
- Sudo access
- Internet connection
- Disk space (≥ 2GB)
- Docker group membership
- GUI availability (optional)

---

## 📁 Repository Structure

```
dev-env/
│
├── install-desktop-universal.sh     # Desktop/server installer
├── install-pizero-unified.sh        # Pi Zero unified installer
├── validate.sh                      # System validation script
├── README.md
├── CHANGELOG.md
└── LICENSE
```

---

## 🧭 Requirements

- Debian or Ubuntu system  
- Raspberry Pi Zero 2 W (for Pi installer)  
- Internet connection  
- OpenAI API key (optional for AI features)

---

## 🤝 Contributing

PRs and suggestions welcome.

---

## 📜 License

This project is licensed under the **Zone01 Restricted License**.
