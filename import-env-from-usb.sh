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
