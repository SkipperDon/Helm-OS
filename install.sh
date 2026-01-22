#!/bin/bash
set -e

# Prevent running via curl | bash
if [ ! -t 0 ]; then
    echo "ERROR: Do not run this script with curl | bash."
    echo "Download it first, then run: bash install.sh"
    exit 1
fi

REPO="https://github.com/SkipperDon/Helm-OS.git"
TARGET="/home/pi/helm-os"

echo "=== Downloading Helm OS repository ==="
echo "[INFO] Repo: $REPO"
echo "[INFO] Target: $TARGET"

if [ -d "$TARGET" ]; then
    echo "[INFO] Removing existing directory $TARGET"
    rm -rf "$TARGET"
fi

git clone "$REPO" "$TARGET"

if [ ! -d "$TARGET" ]; then
    echo "[ERROR] git clone failed. Exiting."
    exit 1
fi

chmod +x "$TARGET/build.sh"

echo "=== Running Helm OS builder ==="
sudo bash "$TARGET/build.sh"
