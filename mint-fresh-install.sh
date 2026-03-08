#!/bin/bash
#
# Linux Mint Fresh Install Setup
# Run once after a new install: update system, then install Chrome, AnyDesk,
# Preload, and RustDesk. Execute from terminal: ./mint-fresh-install.sh
# Or make executable and double-click (may need "Run in terminal").
#

set -e
export DEBIAN_FRONTEND=noninteractive

echo "=============================================="
echo "  Linux Mint Fresh Install – Full Setup"
echo "=============================================="

# --- 1. Update & upgrade system (approve all, then clean) ---
echo ""
echo "[1/5] Updating package lists..."
sudo apt update -y

echo "[1/5] Upgrading all packages (this may take a while)..."
sudo apt upgrade -y

echo "[1/5] Removing unused packages and cleaning..."
sudo apt autoremove -y
sudo apt autoclean

echo "[1/5] System update and cleanup done."
echo ""

# --- 2. Install Preload (preloads frequently used apps in memory) ---
echo "[2/5] Installing Preload..."
sudo apt install -y preload
echo ""

# --- 3. Install Google Chrome ---
echo "[3/5] Installing Google Chrome..."
if ! command -v google-chrome-stable &>/dev/null; then
  sudo apt install -y wget gnupg
  wget -qO- https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome-stable.list >/dev/null
  sudo apt update -y
  sudo apt install -y google-chrome-stable
else
  echo "Chrome already installed, skipping."
fi
echo ""

# --- 4. Install AnyDesk ---
echo "[4/5] Installing AnyDesk..."
if ! command -v anydesk &>/dev/null; then
  sudo apt install -y wget gnupg ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY -o /etc/apt/keyrings/keys.anydesk.com.asc
  sudo chmod a+r /etc/apt/keyrings/keys.anydesk.com.asc
  echo "deb [signed-by=/etc/apt/keyrings/keys.anydesk.com.asc] https://deb.anydesk.com all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list >/dev/null
  sudo apt update -y
  sudo apt install -y anydesk
else
  echo "AnyDesk already installed, skipping."
fi
echo ""

# --- 5. Install RustDesk ---
echo "[5/5] Installing RustDesk..."
if ! command -v rustdesk &>/dev/null; then
  RUSTDESK_VER="1.4.6"
  ARCH=$(uname -m)
  if [ "$ARCH" = "x86_64" ]; then
    DEB="rustdesk-${RUSTDESK_VER}-x86_64.deb"
  elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    DEB="rustdesk-${RUSTDESK_VER}-aarch64.deb"
  else
    echo "Unsupported architecture: $ARCH. Skipping RustDesk."
  fi
  if [ -n "$DEB" ]; then
    URL="https://github.com/rustdesk/rustdesk/releases/download/${RUSTDESK_VER}/${DEB}"
    TMP_DEB=$(mktemp --suffix=.deb)
    wget -q -O "$TMP_DEB" "$URL" && sudo apt install -y -f "$TMP_DEB" && rm -f "$TMP_DEB"
  fi
else
  echo "RustDesk already installed, skipping."
fi
echo ""

echo "=============================================="
echo "  All done. Installed/updated:"
echo "  - System (updated, upgraded, cleaned)"
echo "  - Preload"
echo "  - Google Chrome"
echo "  - AnyDesk"
echo "  - RustDesk"
echo "=============================================="
echo ""
echo "You can log out and back in (or reboot) so Preload starts. Then enjoy."
