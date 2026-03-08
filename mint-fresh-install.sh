#!/bin/bash

# If double-clicked from file manager (not in a terminal), relaunch in one
if ! [ -t 0 ]; then
    x-terminal-emulator -e bash "$0"
    exit
fi

echo "================================"
echo "  Linux Mint Setup Script"
echo "================================"
echo ""

# --- Step 1: Update & Clean ---
echo "[1/5] Updating and upgrading system..."
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt autoclean
echo "Done."

# --- Step 2: Preload ---
echo ""
echo "[2/5] Installing Preload..."
sudo apt install -y preload
echo "Done."

# --- Step 3: AnyDesk ---
echo ""
echo "[3/5] Installing AnyDesk..."
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update
sudo apt install -y anydesk
echo "Done."

# --- Step 4: Google Chrome ---
echo ""
echo "[4/5] Installing Google Chrome..."
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo dpkg -i /tmp/chrome.deb
sudo apt install -f -y
rm /tmp/chrome.deb
echo "Done."

# --- Step 5: RustDesk ---
echo ""
echo "[5/5] Installing RustDesk..."
RUSTDESK_URL=$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest \
    | grep -o "https://.*x86_64\.deb" | head -1)
wget -q "$RUSTDESK_URL" -O /tmp/rustdesk.deb
sudo dpkg -i /tmp/rustdesk.deb
sudo apt install -f -y
rm /tmp/rustdesk.deb
echo "Done."

echo ""
echo "================================"
echo "  All done! Setup complete."
echo "================================"
echo ""
echo "Launching AnyDesk..."
anydesk &
read -p "Press Enter to close..."
