#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
echo "=== FIRST BOOT: Installing Helm System ==="
sudo apt-get -o Dpkg::Options::="--force-confold" \
             -o Dpkg::Options::="--force-confdef" \
             install -y <packages>
# Expand filesystem
raspi-config nonint do_expand_rootfs

# Install all packages
bash /usr/local/bin/install-packages.sh

# Disable firstboot so it only runs once
systemctl disable firstboot.service

echo "=== FIRST BOOT COMPLETE ==="
