#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "=== HELM OS BUILDER (Version 3) ==="

# Apply overlays
echo "Copying overlays into system..."
sudo rsync -av "$SCRIPT_DIR/overlays/" /

# Install scripts
echo "Installing firstboot + package installer..."
sudo cp "$SCRIPT_DIR/scripts/firstboot.sh" /usr/local/bin/firstboot.sh
sudo cp "$SCRIPT_DIR/scripts/install-packages.sh" /usr/local/bin/install-packages.sh
sudo chmod +x /usr/local/bin/firstboot.sh
sudo chmod +x /usr/local/bin/install-packages.sh

# Enable firstboot
echo "Configuring first boot service..."
sudo bash -c 'cat >/etc/systemd/system/firstboot.service <<EOF
[Unit]
Description=Helm OS First Boot Provisioning
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/firstboot.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl enable firstboot.service

echo "=== BUILD COMPLETE ==="
echo "Reboot to begin provisioning."
