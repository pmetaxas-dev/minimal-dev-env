# Minimal Dev Environment Installer (Pi Zero 2 W Optimized)

A lightweight, fully automated development environment installer designed for **Raspberry Pi Zero 2 W** and other Debian-based systems.  
Includes a complete Neovim IDE, optional Code‑Server, optional Docker, and integrated AI support using the OpenAI API.

---

## 🚀 Features

### 🧱 Core Development Tools
- GCC, Clang, Make, CMake  
- GDB, Valgrind  
- pkg-config  
- Git + GitHub CLI  
- Python3 + pip  
- Node.js (LTS)  
- Go  
- Rust (rustup)

### 🧑‍💻 Editors & Workflow Tools
- **Neovim IDE** (Treesitter, LSP, Telescope, Autocomplete, Git signs, Lualine)  
- tmux  
- ripgrep  
- fzf  
- ranger  
- exa  

### 🤖 AI Integration (OpenAI)
- Global `ai` command for terminal AI queries  
- Neovim AI plugin: **ChatGPT.nvim**  
- Uses OpenAI API (GPT‑4o‑mini by default)  
- Optional via `--no-ai` flag  

### 🐳 Optional Components
- Docker (`--no-docker` to skip)  
- Code‑Server (VS Code in browser) (`--no-code-server` to skip)

### 🌐 Networking Tools
- iproute2  
- iputils-ping  
- traceroute  
- nmap  
- tcpdump  

### 🐚 Shell Environment
- Zsh with clean defaults  

---

## 📦 Installation

Run the unified installer:

```bash
chmod +x install-pizero-unified.sh
./install-pizero-unified.sh
```

---

## ⚙️ Installer Options

The installer supports optional flags:

| Flag | Description |
|------|-------------|
| `--no-docker` | Skip Docker installation |
| `--no-code-server` | Skip Code‑Server installation |
| `--no-ai` | Skip AI integration (OpenAI, ChatGPT.nvim, `ai` command) |

### Examples

Skip Docker:

```bash
./install-pizero-unified.sh --no-docker
```

Skip Code‑Server:

```bash
./install-pizero-unified.sh --no-code-server
```

Skip AI:

```bash
./install-pizero-unified.sh --no-ai
```

Skip everything optional:

```bash
./install-pizero-unified.sh --no-docker --no-code-server --no-ai
```

---

## 🤖 AI Usage

### 1. Set your OpenAI API key

```bash
export OPENAI_API_KEY="your_api_key_here"
echo 'export OPENAI_API_KEY="your_api_key_here"' >> ~/.zshrc
```

### 2. Use the global `ai` command

Ask a question:

```bash
ai "Explain pointers in C"
```

Pipe input:

```bash
cat main.c | ai "Find bugs"
```

### 3. Use AI inside Neovim

Open Neovim:

```bash
nvim
```

Then run:

```
:ChatGPT
```

---

## 📁 Repository Structure

```
minimal-dev-env/
│
├── install.sh                   # Main desktop installer
├── install-pizero-unified.sh    # Pi Zero 2 W unified installer (with AI, flags, Neovim IDE)
├── validate.sh                  # System compatibility checker
├── README.md                    # Documentation
├── CHANGELOG.md                 # Version history
└── LICENSE                      # Zone01-restricted license
```

---

## 🧭 Requirements

- Raspberry Pi Zero 2 W (or any Debian-based system)
- sudo privileges
- Internet connection
- OpenAI API key (optional, for AI features)

---

## 🧠 Notes on Performance

The Pi Zero 2 W is a low-power device.  
This installer is optimized for:

- terminal-first workflows  
- lightweight tools  
- cloud-based AI  
- Neovim instead of VS Code GUI  

---

## 🤝 Contributing

Contributions are welcome.  
Feel free to open issues or PRs for:

- additional AI providers  
- new Neovim modules  
- performance improvements  
- Pi 4 / Pi 5 optimized versions  

---

## 📜 License

This project is licensed under the **Zone01 Restricted License**.  
Only Zone01 students and mentors may use, modify, or distribute this software.

See the [LICENSE](LICENSE) file for details.
