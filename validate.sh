#!/usr/bin/env bash

set -e

echo "🔍 Validating system compatibility..."

# Check OS type
if ! grep -qi "debian" /etc/os-release && ! grep -qi "ubuntu" /etc/os-release; then
  echo "❌ Unsupported OS. This script supports Debian-based systems only."
  exit 1
fi

# Check package manager
if ! command -v apt >/dev/null 2>&1; then
  echo "❌ 'apt' not found. This script requires APT package manager."
  exit 1
fi

# Check sudo access
if ! sudo -v >/dev/null 2>&1; then
  echo "❌ Sudo access required. Please run with a user that has sudo privileges."
  exit 1
fi

# Check internet connection
if ! ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
  echo "❌ No internet connection. Please check your network."
  exit 1
fi

# Check disk space (at least 2GB free)
FREE_SPACE=$(df / | tail -1 | awk '{print $4}')
if [ "$FREE_SPACE" -lt 2000000 ]; then
  echo "❌ Not enough disk space. At least 2GB required."
  exit 1
fi

# Check Docker group membership
if groups "$USER" | grep -q docker; then
  echo "✅ Docker group: OK"
else
  echo "⚠️  Docker group: missing. You may need to run: sudo usermod -aG docker $USER"
fi

# Optional: check if GUI is available for VS Code
if command -v code >/dev/null 2>&1; then
  if ! command -v xhost >/dev/null 2>&1; then
    echo "⚠️  VS Code installed, but no GUI detected. You may be in a headless environment."
  else
    echo "✅ VS Code GUI support: OK"
  fi
fi

echo "✅ System validation complete. You may now run: ./install.sh"
