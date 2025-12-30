#!/usr/bin/env bash
set -euo pipefail

echo "==> Importing .env from USB"

############################################
# Detect USB device
############################################

echo "==> Detecting USB device..."

# Find the most recently added /dev/sdX1 device
USB_DEV=$(lsblk -o NAME,TYPE | grep "disk" | awk '{print $1}' | tail -n 1)

if [ -z "$USB_DEV" ]; then
  echo "❌ No USB device detected."
  exit 1
fi

USB_PART="/dev/${USB_DEV}1"

if [ ! -b "$USB_PART" ]; then
  echo "❌ USB partition not found: $USB_PART"
  exit 1
fi

echo "Detected USB partition: $USB_PART"

############################################
# Mount USB
############################################

MOUNT_DIR="/mnt/usb"

echo "==> Mounting USB to $MOUNT_DIR"
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

echo "==> Copying .env to home directory"
cp "$MOUNT_DIR/.env" "$HOME/.env"
chmod 600 "$HOME/.env"

############################################
# Cleanup
############################################

echo "==> Unmounting USB"
sudo umount "$MOUNT_DIR"

echo "==> .env imported successfully!"
echo "Your OpenAI API key is now available to the system."
echo
echo "If your shell does not load it automatically, run:"
echo "  source ~/.env"
echo
