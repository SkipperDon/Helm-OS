#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

log() {
  echo "[install-packages] $*"
}

ROOT="/usr/local/helm-os"

log "=== INSTALLING HELM-OS PACKAGES AND CONFIGURATION ==="

# Ensure base directories exist
mkdir -p "$ROOT"

# Copy repo assets into place
if [ -d /home/pi/helm-os ]; then
  log "Copying helm-os repo into $ROOT..."
  rsync -a --delete /home/pi/helm-os/ "$ROOT/"
else
  log "ERROR: /home/pi/helm-os not found. Aborting."
  exit 1
fi

# -------------------------------
# Install core system packages
# -------------------------------
log "Installing core system packages..."

apt-get update
apt-get install -y \
  hostapd \
  dnsmasq \
  gpsd \
  gpsd-clients \
  can-utils \
  python3-can \
  python3-pip \
  git \
  curl \
  net-tools \
  iproute2 \
  jq \
  nodejs \
  npm

# -------------------------------
# Configure CAN bus
# -------------------------------
log "Configuring CAN bus..."

install -m 644 "$ROOT/configs/can0" /etc/network/interfaces.d/can0

# -------------------------------
# Configure Wi-Fi Access Point
# -------------------------------
log "Configuring Wi-Fi AP..."

install -m 644 "$ROOT/configs/dnsmasq-eth0.conf" /etc/dnsmasq.d/eth0.conf
install -m 644 "$ROOT/configs/hostapd.conf" /etc/hostapd/hostapd.conf

systemctl enable hostapd
systemctl enable dnsmasq

# -------------------------------
# Install and configure Signal K
# -------------------------------
log "Installing Signal K..."

npm install -g --unsafe-perm signalk-server

# Copy Signal K defaults
mkdir -p /home/pi/.signalk
install -m 644 "$ROOT/configs/signalk-defaults.json" /home/pi/.signalk/settings.json
chown -R pi:pi /home/pi/.signalk

# -------------------------------
# Install systemd services
# -------------------------------
log "Installing systemd services..."

for svc in "$ROOT/services/"*.service; do
  install -m 644 "$svc" /etc/systemd/system/
done

systemctl daemon-reload

# Enable helm-os services
systemctl enable helm-web.service || true
systemctl enable helm-can.service || true
systemctl enable helm-gps.service || true

# -------------------------------
# Finalization
# -------------------------------
log "Helm OS installation complete."
