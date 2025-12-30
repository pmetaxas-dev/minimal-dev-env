# Minimal Dev Environment Installer

![License](https://img.shields.io/badge/license-Zone01%20Restricted-blue)
![Platform](https://img.shields.io/badge/platform-Debian%20%2F%20Ubuntu-green)
![Shell](https://img.shields.io/badge/shell-bash-orange)
![Status](https://img.shields.io/badge/status-active-success)
![Contributions](https://img.shields.io/badge/contributions-welcome-brightgreen)
![Maintained](https://img.shields.io/badge/maintained-yes-blueviolet)

A lightweight, fast, and powerful development environment setup script designed for **Zone01 / 01Edu / 42‑style** workflows.  
This installer prepares a clean Debian‑based system for a full 2‑year cohort journey, including C programming, system development, networking, DevOps, Rust, Go, Node.js, and more.

---

## 🚀 Features

### 🧱 Core Development Tools
- GCC, Clang, Make, CMake  
- GDB, Valgrind  
- pkg-config  
- Git + GitHub CLI  
- Python3 + pip  

### 🧑‍💻 Editors & Workflow Tools
- Neovim (minimal config)  
- tmux  
- ripgrep  
- fzf  
- ranger  
- exa  

### 🧪 Static Analysis & Formatting
- cppcheck  
- clang-tidy  
- clang-format  

### 🌐 Networking Tools
- iproute2  
- iputils-ping  
- traceroute  
- nmap  
- tcpdump  

### 🐳 DevOps & Containers
- Docker  
- docker-compose  

### 🦀 Modern Languages
- Rust (rustup)  
- Go  
- Node.js (LTS) + npm  

### 🌍 Lightweight Browser
- qutebrowser  

### 🐚 Shell Environment
- Zsh with clean defaults  

---

## 📦 Installation

Run the installer using:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/<YOUR_USERNAME>/minimal-dev-env/main/install.sh)
```

Replace `<YOUR_USERNAME>` with your GitHub username.

---

## 📁 Repository Structure

```
minimal-dev-env/
│
├── install.sh      # Main installer script
├── README.md       # Documentation
├── CHANGELOG.md    # Version history
└── LICENSE         # Zone01-restricted license
```

---

## 🧭 Requirements

- Debian or Debian-based distribution (Ubuntu, Mint, Pop!\_OS, Kali, etc.)
- sudo privileges
- Internet connection

---

## 🛠️ Ideal For

- Zone01 / 01Edu / 42 school projects  
- C programming (libft, get_next_line, minishell, etc.)  
- Algorithms & data structures  
- System programming  
- Networking projects  
- Docker & DevOps  
- Rust, Go, Node.js development  
- Terminal-first workflows  
- Lightweight servers or VMs  

---

## 🤝 Contributing

Contributions are welcome.  
If you want to add optional modules (e.g., full Neovim IDE, .NET, Java, Kubernetes), feel free to open an issue.

---

## 📜 License

This project is licensed under the **Zone01 Restricted License**.  
Only Zone01 students and mentors may use, modify, or distribute this software.

See the [LICENSE](LICENSE) file for details.
