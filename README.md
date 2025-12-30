# Universal Minimal Dev Environment Installer  
### (Ubuntu Server • Debian • Raspberry Pi OS • Pi Zero 2 W Optimized)

This project provides a **universal**, **auto‑detecting**, **minimal** development environment installer that works across:

- **Ubuntu Server (headless)**
- **Debian**
- **Raspberry Pi OS (Legacy, 64‑bit)**
- **Raspberry Pi Zero 2 W**
- **ARMv7 / ARM64 / x86_64**

The installer automatically detects your OS and architecture and configures a **lightweight, stable, bash‑only development environment**.

---

## 🚀 Features

### 🧱 Core Development Tools
- GCC, Make, CMake  
- Git  
- Python3 + pip  
- Go  
- Rust (rustup)  
- Node.js (Debian version for ARM stability)  
- ripgrep, fzf, fd, ranger, eza  
- tmux  
- jq  
- w3m terminal browser  

### 🧑‍💻 Minimal Neovim IDE
- Telescope (fuzzy finder)  
- Git signs  
- Lualine  
- **No Treesitter**  
- **No LSP**  
- **No autocomplete**  
- Fast startup, low memory usage  
- Perfect for Pi Zero 2 W  

### 🤖 AI Integration (Optional)
- Global `ai` command (OpenAI API)  
- ChatGPT.nvim inside Neovim  
- Uses GPT‑4o‑mini by default  
- Bash‑only environment  

### 🖥 Code‑Server (Optional)
Run VS Code in your browser:

```
http://<device-ip>:8080
```

---

## 📦 Installation

Clone the repo:

```bash
git clone https://github.com/<your-username>/minimal-dev-env.git
cd minimal-dev-env
```

Run the universal installer:

```bash
bash install-universal.sh
```

---

## ⚙️ Installer Options

| Flag | Description |
|------|-------------|
| `--no-code-server` | Skip Code‑Server installation |
| `--no-ai` | Skip AI integration |

Examples:

Skip Code‑Server:

```bash
bash install-universal.sh --no-code-server
```

Skip AI:

```bash
bash install-universal.sh --no-ai
```

Skip everything optional:

```bash
bash install-universal.sh --no-code-server --no-ai
```

---

## 🤖 AI Usage

### Set your OpenAI API key

```bash
export OPENAI_API_KEY="your_api_key_here"
echo 'export OPENAI_API_KEY="your_api_key_here"' >> ~/.bashrc
source ~/.bashrc
```

### Terminal AI

```bash
ai "Explain this code"
```

Pipe input:

```bash
cat main.c | ai "summarize this"
```

### Neovim AI

Inside Neovim:

```
:ChatGPT
```

---

## 📁 Repository Structure

```
minimal-dev-env/
│
├── install-universal.sh          # Universal auto-detecting installer
├── install-pizero-minimal.sh     # Pi Zero minimal installer
├── install-pizero-unified.sh     # Full Pi Zero installer (optional)
├── README.md
├── CHANGELOG.md
└── LICENSE
```

---

## 🧭 Requirements

- Ubuntu Server, Debian, or Raspberry Pi OS  
- ARMv7, ARM64, or x86_64  
- Internet connection  
- OpenAI API key (optional)  

---

## 🧠 Notes on Performance

This universal installer is optimized for:

- Low‑RAM devices (Pi Zero 2 W)  
- Headless servers  
- ARMv7 compatibility  
- Fast Neovim startup  
- Minimal background services  

---

## 🤝 Contributing

PRs and suggestions are welcome.

---

## 📜 License

This project is licensed under the **Zone01 Restricted License**.
