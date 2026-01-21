#!/bin/bash
set -e

echo "=== FIRST BOOT: Installing Helm System ==="

# Expand filesystem
raspi-config nonint do_expand_rootfs

# Install all packages
bash /usr/local/bin/install-packages.sh

# Disable firstboot so it only runs once
systemctl disable firstboot.service

echo "=== FIRST BOOT COMPLETE ==="
