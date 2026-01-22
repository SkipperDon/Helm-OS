#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

log() {
  echo "[firstboot] $*"
}

log "=== FIRST BOOT: Installing Helm System ==="

# Update package index
apt-get update

# Install the base packages required for Helm OS provisioning
apt-get -o Dpkg::Options::="--force-confold" \
        -o Dpkg::Options::="--force-confdef" \
        install -y \
        hostapd \
        dnsmasq \
        gpsd \
        gpsd-clients \
        can-utils \
        python3-can \
        net-tools \
        iproute2 \
        curl \
        git

# Expand filesystem (safe to run multiple times)
if raspi-config nonint do_expand_rootfs; then
  log "Root filesystem expanded."
else
  log "Filesystem already expanded or skipped."
fi

# Run the main Helm OS installer if present
if [ -x /usr/local/bin/install-packages.sh ]; then
  log "Running install-packages.sh..."
  bash /usr/local/bin/install-packages.sh
else
  log "WARNING: install-packages.sh not found or not executable."
fi

# Disable firstboot so it only runs once
if systemctl disable firstboot.service; then
  log "firstboot.service disabled."
else
  log "WARNING: could not disable firstboot.service (maybe already disabled)."
fi

log "=== FIRST BOOT COMPLETE ==="
