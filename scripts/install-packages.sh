#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
HELM_USER="pi"
echo "=== FIRST BOOT: Installing Helm System ==="

# Expand filesystem
raspi-config nonint do_expand_rootfs

# Install all packages
bash /usr/local/bin/install-packages.sh

# Disable firstboot so it only runs once
systemctl disable firstboot.service

echo "=== FIRST BOOT COMPLETE ==="
sudo apt-get update


echo "=== Updating system ==="
sudo apt update
sudo apt full-upgrade -y

echo "=== Installing core packages ==="
sudo apt install -y \
  git curl build-essential python3 python3-pip \
  can-utils pkg-config \
  gpsd gpsd-clients \
  vlc \
  chromium-browser \
  x11vnc \
  hostapd dnsmasq \
  xinput xserver-xorg-input-libinput \
  lxterminal lxappearance fonts-dejavu \
  net-tools

echo "=== Installing Node.js LTS ==="
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

echo "=== Installing Signal K ==="
sudo npm install -g --unsafe-perm signalk-server

echo "=== Enabling services ==="
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
sudo systemctl enable gpsd

echo "=== Bringing up CAN0 ==="
sudo ip link set can0 type can bitrate 250000 || true
sudo ifconfig can0 up || true

echo "=== Installing complete ==="
