#!/bin/bash
set -e

REPO="https://github.com/SipperDon/helm-os.git"
TARGET="/home/pi/helm-os"

echo "=== Downloading Helm OS repository ==="
rm -rf $TARGET
git clone $REPO $TARGET

echo "=== Running Helm OS builder ==="
cd $TARGET
sudo bash build.sh
