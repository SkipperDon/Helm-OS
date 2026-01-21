A turnkey Raspberry Pi marine navigation system with Signal K, NMEA2000, CAN bus, GPS/AIS, and full helm automation.  
Includes Wi‑Fi AP, Ethernet DHCP, touchscreen UI, PoE camera support, and a one‑command installer for rapid deployment.
# Helm OS (Raspberry Pi Marine Navigation System)

Helm OS is a turnkey marine navigation environment for Raspberry Pi 4/5.
It installs:

- Signal K Server
- PiCAN-M CAN bus support (NMEA2000)
- USB GPS + AIS (gpsd)
- Ethernet DHCP server (for PoE cameras)
- Wi-Fi Access Point
- Chromium browser
- VLC (RTSP camera support)
- Touchscreen scaling
- Terminal utilities
- VNC server
- Automatic CAN0 + NMEA2000 configuration

## Requirements

- Raspberry Pi 4 or 5
- Raspberry Pi OS 64-bit (Full Desktop)
- PiCAN-M HAT (or MCP2515 CAN board)
- USB GPS + USB AIS (optional)
- PoE switch + IP camera (optional)

## One-Command Install

Run this on a fresh Raspberry Pi OS:

curl -sL https://raw.githubusercontent.com/SkipperDon/helm-os/main/install.sh | bash

After installation, reboot: sudo reboot

Your Pi will now be a complete helm system.

## Disclaimer

Helm OS is provided “as is” without any warranties or guarantees. 
Use of this software on a vessel is entirely at your own risk. 
The authors and contributors are not responsible for any damage, 
data loss, navigation errors, or safety issues resulting from its use.
