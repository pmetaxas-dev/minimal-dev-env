# Minimal Dev Environment Installer (Pi Zero 2 W – Minimal Edition)

A lightweight, Pi‑optimized development environment installer designed for **Raspberry Pi Zero 2 W** running **Raspberry Pi OS (Legacy, 64‑bit) Lite**.

This version is **ultra‑minimal**:

- ❌ No Treesitter  
- ❌ No LSP servers  
- ❌ No autocomplete  
- ❌ No Docker  
- ❌ No Zsh  
- ✔ Bash‑only  
- ✔ Neovim minimal IDE  
- ✔ Optional AI integration  
- ✔ Optional Code‑Server  
- ✔ Extremely low RAM usage  

---

## 🚀 Features

### 🧱 Core Development Tools
- GCC, Make, CMake  
- Git  
- Python3 + pip  
- Go  
- Rust (rustup)  
- Node.js (Debian version for ARMv7 stability)  
- ripgrep, fzf, fd, ranger, eza  
- tmux  
- jq  
- w3m terminal browser  

### 🧑‍💻 Minimal Neovim IDE
- Telescope (fuzzy finder)  
- Git signs  
- Lualine statusline  
- **No Treesitter**  
- **No LSP**  
- **No autocomplete**  
- Fast startup, low memory footprint  

### 🤖 AI Integration (Optional)
- Global `ai` command (OpenAI API)  
- ChatGPT.nvim inside Neovim  
- Uses GPT‑4o‑mini by default  
- Bash‑only environment  

### 🖥 Code‑Server (Optional)
Run VS Code in your browser:

```
http://<pi-ip>:8080
```

---

## 📦 Installation

Clone the repo:

```bash
git clone https://github.com/<your-username>/minimal-dev-env.git
cd minimal-dev-env
```

Run the installer:

```bash
bash install-pizero-minimal.sh
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
bash install-pizero-minimal.sh --no-code-server
```

Skip AI:

```bash
bash install-pizero-minimal.sh --no-ai
```

Skip everything optional:

```bash
bash install-pizero-minimal.sh --no-code-server --no-ai
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
├── install-pizero-minimal.sh     # Minimal Pi Zero installer
├── install-pizero-unified.sh     # Full Pi Zero installer (optional)
├── README.md
├── CHANGELOG.md
└── LICENSE
```

---

## 🧭 Requirements

- Raspberry Pi Zero 2 W  
- Raspberry Pi OS (Legacy, 64‑bit) Lite  
- Internet connection  
- OpenAI API key (optional)  

---

## 🧠 Notes on Performance

This minimal edition is optimized for:

- 512MB RAM  
- ARMv7 CPU  
- Low I/O  
- Fast boot  
- Fast Neovim startup  

It is the recommended version for Pi Zero 2 W.

---

## 🤝 Contributing

PRs and suggestions are welcome.

---

## 📜 License

This project is licensed under the **Zone01 Restricted License**.
