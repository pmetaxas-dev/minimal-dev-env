#!/usr/bin/env bash
set -euo pipefail

echo "==> Importing .env from USB"

############################################
# Detect USB device
############################################

echo "==> Detecting USB device..."

USB_PART=$(lsblk -nrpo NAME,TYPE | awk '$2=="part" && $1 !~ /mmcblk/ && $1 !~ /loop/ {print $1; exit}')

if [ -z "$USB_PART" ] || [ ! -b "$USB_PART" ]; then
  echo "❌ No valid USB partition found."
  exit 1
fi

echo "📦 Detected USB partition: $USB_PART"


############################################
# Mount USB
############################################

MOUNT_DIR="/mnt/usb"

echo "🔧 Mounting USB to $MOUNT_DIR"
sudo mkdir -p "$MOUNT_DIR"
sudo mount "$USB_PART" "$MOUNT_DIR"


############################################
# Import .env
############################################

if [ ! -f "$MOUNT_DIR/.env" ]; then
  echo "❌ No .env file found on USB."
  sudo umount "$MOUNT_DIR"
  exit 1
fi

echo "📥 Copying .env to home directory"
cp "$MOUNT_DIR/.env" "$HOME/.env"
chmod 600 "$HOME/.env"


############################################
# Auto‑load .env on every shell startup
############################################

echo "⚙️  Ensuring ~/.env is sourced automatically"

# Create file if missing (safety)
touch "$HOME/.env"
chmod 600 "$HOME/.env"

# Add sourcing line if not already present
if ! grep -q 'source ~/.env' "$HOME/.bashrc"; then
    echo 'source ~/.env' >> "$HOME/.bashrc"
    echo "🔗 Added 'source ~/.env' to ~/.bashrc"
else
    echo "🔗 ~/.env already sourced in ~/.bashrc"
fi

############################################
# Ensure ~/.profile loads ~/.bashrc
############################################

echo "⚙️  Ensuring ~/.profile loads ~/.bashrc"

if ! grep -q 'source ~/.bashrc' "$HOME/.profile"; then
    echo 'source ~/.bashrc' >> "$HOME/.profile"
    echo "🔗 Added 'source ~/.bashrc' to ~/.profile"
else
    echo "🔗 ~/.bashrc already sourced in ~/.profile"
fi


############################################
# Cleanup
############################################

echo "🔌 Unmounting USB"
sudo umount "$MOUNT_DIR"

echo
echo "🎉 .env imported successfully!"
echo "🔑 Your OpenAI API key is now active and will load automatically in every new shell."
echo
echo "Try it now:"
echo "  ai \"hello\""
echo
