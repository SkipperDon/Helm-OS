#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

HELM_USER="pi"

sudo apt-get update

sudo apt-get -o Dpkg::Options::="--force-confold" \
             -o Dpkg::Options::="--force-confdef" \
             install -y <packages>

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
