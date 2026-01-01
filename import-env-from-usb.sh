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
# Ensure .env loads on every shell startup
# (Pi Zero autologin loads ONLY /etc/bash.bashrc)
############################################

echo "⚙️ Ensuring /etc/bash.bashrc loads ~/.env"

if ! grep -q 'source "$HOME/.env"' /etc/bash.bashrc; then
  sudo tee -a /etc/bash.bashrc >/dev/null << 'EOF'

# Load user environment variables
if [ -f "$HOME/.env" ]; then
    source "$HOME/.env"
fi
EOF
  echo "🔗 Added .env sourcing to /etc/bash.bashrc"
else
  echo "🔗 /etc/bash.bashrc already sources ~/.env"
fi

############################################
# Cleanup
############################################

echo "🔌 Unmounting USB"
sudo umount "$MOUNT_DIR"

echo
echo "🎉 .env imported successfully!"
echo "🔑 Your OpenAI API key will now load automatically in every new shell."
echo
echo "Try it now:"
echo "  ai \"hello\""
echo
