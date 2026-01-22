#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

log() {
  echo "[firstboot] $*"
}

log "=== FIRST BOOT: Installing Helm System ==="

# Update package index
apt-get update

# Base packages needed for Helm OS provisioning and diagnostics
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

# Expand filesystem (ignore if already expanded)
if raspi-config nonint do_expand_rootfs; then
  log "Root filesystem expanded."
else
  log "Root filesystem expansion skipped or already done."
fi

# Run the main Helm OS installer if present
if [ -x /usr/local/bin/install-packages.sh ]; then
  log "Running install-packages.sh..."
  bash /usr/local/bin/install-packages.sh
else
  log "WARNING: /usr/local/bin/install-packages.sh not found or not executable."
fi

# Disable firstboot so it only runs once
if systemctl disable firstboot.service; then
  log "firstboot.service disabled."
else
  log "WARNING: could not disable firstboot.service (already disabled?)."
fi

log "=== FIRST BOOT COMPLETE ==="
