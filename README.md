# 🧰 Universal Dev Environment Installers  
### For Desktop/Server and Raspberry Pi Zero 2 W (Headless, Bash‑Only)

This repository provides two fully‑featured, headless‑friendly development environment installers:

- **install-desktop-universal.sh** — for Ubuntu Server, Debian, and headless desktop PCs  
- **install-pizero-unified.sh** — for Raspberry Pi Zero 2 W running Raspberry Pi OS Legacy (64‑bit)

Both installers are:

- 🟦 Bash‑only (no Zsh or GUI dependencies)  
- 🟩 Headless‑compatible  
- 🤖 AI‑enabled (optional)  
- 🖥 Code‑Server‑enabled (optional)  
- ✨ Neovim‑based IDE (minimal or full)

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
bash install-desktop-universal.sh --no-docker --no-zsh --no-code-server --no-ai --minimal-nvim
```

---

# 🍓 Raspberry Pi Zero 2 W Installation (Raspberry Pi OS Legacy 64‑bit)

```bash
bash install-pizero-unified.sh
```

Minimal install example:

```bash
bash install-pizero-unified.sh --no-code-server --no-ai
```

---

# 📦 Installers Overview

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

# 🔧 Features

## 🧱 Core Tools
- GCC, Make, CMake  
- Git, curl, wget  
- Python3 + pip  
- Go, Rust, Node.js (Debian version)  
- ripgrep, fzf, fd, ranger, eza  
- tmux, jq, ncdu, htop  
- w3m terminal browser  
- Static analysis tools (clang-tidy, cppcheck)  
- Networking tools (nmap, tcpdump, traceroute)

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

### Set your API key
```bash
export OPENAI_API_KEY="your_api_key_here"
echo 'export OPENAI_API_KEY="your_api_key_here"' >> ~/.bashrc
source ~/.bashrc
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
| `--minimal-nvim` | Use minimal Neovim config (no Treesitter/LSP/cmp) |

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
├── install-pizero-unified.sh        # Pi Zero unified installer
├── validate.sh                      # System validation script
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
