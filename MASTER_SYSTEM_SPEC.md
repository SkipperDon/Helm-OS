# **helm‑OS Tier‑0 — MASTER SYSTEM SPECIFICATION**  
### *Authoritative architecture, flows, services, AI logic, integrations, assumptions, and file-level detail*

---

# **0. Purpose of This Document**

This document defines the **complete technical specification** for helm‑OS Tier‑0 — a self‑contained marine intelligence platform built on Raspberry Pi hardware, NMEA2000 data, AI‑assisted onboarding, OpenCPN integration, and real‑time vessel diagnostics.

This file is the **single source of truth** for:

- Architecture  
- Directory structure  
- Onboarding logic  
- AI responsibilities  
- OpenCPN integration  
- Signal K integration  
- Benchmarking  
- Voice assistant  
- Systemd services  
- Dependencies  
- Assumptions  

All development must follow this specification.

---

# **1. Hardware Architecture**

## **1.1 CoreBox Tier‑0 Components**
- **Raspberry Pi 4 (4–8GB RAM)**  
- **PiCAN‑M HAT**  
  - NMEA2000 interface  
  - SMPS power conditioning  
- **CX5106 Engine Gateway**  
  - Connected to NMEA2000 backbone  
  - DIP‑switch configurable  
- **NMEA2000 Backbone**  
  - Engine  
  - Sensors  
  - CX5106  
  - PiCAN‑M  
- **USB GPS Receiver**  
- **USB AIS Receiver**  
- **Anker PowerConf S330**  
  - Microphone + speaker  
  - Used for voice assistant  
- **10.1" USB/Mini‑HDMI Touchscreen**  
- **PoE Switch**  
  - Reolink RLC‑810A IP67 camera  
- **Wi‑Fi AP**  
  - SSID: `Helm-OS`  
  - DHCP enabled  

---

# **2. Software Stack**

## **2.1 Operating System**
- Raspberry Pi OS 64‑bit (Debian Bookworm)

## **2.2 Core Runtime**
- Node.js **v20 LTS**
- npm **10.x**
- Python **3.11+**

## **2.3 Node‑RED**
- Node‑RED **3.1.x**
- node-red-dashboard **3.6.x**
- node-red-contrib-signalk
- node-red-contrib-opencpn (optional)
- node-red-contrib-speech (optional)

## **2.4 Signal K**
- Signal K Server **2.6.x**
- signalk-server-plugin-nmea2000
- signalk-server-plugin-gpsd
- signalk-server-plugin-ais
- signalk-server-plugin-health
- signalk-server-plugin-opencpn

## **2.5 OpenCPN (Auto‑Installed if No Chartplotter)**
- OpenCPN **5.8.x**
- OpenCPN Signal K plugin
- OpenCPN chart directories

## **2.6 AI / Voice**
- **Vosk STT**  
  - vosk-model-small-en-us-0.15  
- **Piper TTS**  
  - en_US-amy-medium voice model  

## **2.7 NMEA2000 / CAN**
- can-utils  
- python-can  
- libsocketcan  

## **2.8 Networking**
- dnsmasq  
- hostapd  
- gpsd  
- ffmpeg  
- nginx (optional)  

---

# **3. Repository Structure**

```
helm-os/
│
├── docs/
│   ├── MASTER_SYSTEM_SPEC.md
│   ├── ARCHITECTURE.md
│   ├── ONBOARDING_FLOW.md
│   ├── AI_DESIGN.md
│   ├── SIGNALK_INTEGRATION.md
│   ├── OPENCPN_INTEGRATION.md
│   ├── BENCHMARKING.md
│   └── ROADMAP.md
│
├── services/
│   ├── onboarding/
│   │   ├── index.js
│   │   ├── onboarding.html
│   │   ├── settings_system.html
│   │   ├── configStore.js
│   │   ├── licenseResolver.js
│   │   ├── reasoningEngine.js
│   │   ├── opencpnInstaller.js
│   │   ├── opencpnUninstaller.js
│   │   ├── pgnDetector.js
│   │   ├── dipSwitchCalculator.js
│   │   ├── benchmarkEngine.js
│   │   ├── aiAssistant.js
│   │   ├── package.json
│   │   └── node_modules/
│   │
│   ├── .node-red/
│   │   ├── flows.json
│   │   ├── settings.js
│   │   └── node_modules/
│   │
│   ├── signalk/
│   │   ├── settings.json
│   │   ├── plugins/
│   │   ├── data/
│   │   └── sk-health-monitor.js
│   │
│   └── opencpn/
│       ├── config/
│       ├── install-scripts/
│       ├── uninstall-scripts/
│       └── opencpn-launcher.sh
│
├── config/
│   ├── operator.json
│   ├── boat-identity.json
│   ├── boats/
│   ├── boat-active.json
│   ├── opencpn.json
│   └── benchmark-results.json
│
├── state/
│   ├── onboarding.json
│   ├── baseline.json
│   ├── baseline-trigger.json
│   ├── opencpn-install.log
│   └── health-status.json
│
├── system/
│   ├── helm-onboarding.service
│   ├── helm-opencpn.service
│   ├── helm-health.service
│   └── helm-benchmark.service
│
└── scripts/
    ├── install-opencpn.sh
    ├── uninstall-opencpn.sh
    ├── configure-signalk-opencpn.sh
    ├── detect-chartplotter.sh
    └── generate-dip-switches.sh
```

---

# **4. Systemd Services**

## **4.1 helm-onboarding.service**
Runs onboarding backend API.

## **4.2 helm-opencpn.service**
Launches OpenCPN and ensures it stays running.

## **4.3 helm-health.service**
Monitors Pi temperature, CPU, memory, disk, and Signal K health.

## **4.4 helm-benchmark.service**
Handles 30‑minute engine capture and stores results.

---

# **5. Onboarding Flow**

## **5.1 Steps**
1. Welcome  
2. Operator + vessel info  
3. Engine info  
4. Chartplotter detection  
5. If **NO chartplotter** → auto‑install OpenCPN  
6. PGN detection  
7. DIP switch calculation  
8. Landing page (review + DIP instructions)  
9. Benchmark prompt  
10. Main menu  

## **5.2 Auto‑Detection Logic**
- Detect chartplotter via NMEA2000 PGNs  
- Detect engine type via PGNs  
- Detect gateway presence  
- Detect AIS/GPS devices  
- Detect CX5106 DIP requirements  

## **5.3 DIP Switch Logic**
- Based on:
  - Engine type  
  - PGNs present  
  - Chartplotter requirements  
  - Manufacturer rules  

---

# **6. Benchmarking Flow**

1. User starts benchmark  
2. helm‑OS captures 30 minutes of engine data  
3. AI analyzes:
   - RPM stability  
   - Temperature curves  
   - Fuel rate  
   - Voltage  
   - Pressure  
4. AI generates performance report  
5. User accepts  
6. Stored in `benchmark-results.json`

---

# **7. AI Responsibilities**

## **7.1 Onboarding**
- Fill missing fields  
- Validate user answers  
- Detect chartplotter model  
- Detect engine PGNs  
- Compute DIP switch settings  
- Voice‑guided onboarding  

## **7.2 Health Monitoring**
- Every 5 minutes:
  - Compare engine data to baseline  
  - Detect anomalies  
  - Log deviations  
  - Provide reports on request  

## **7.3 PGN Translation**
- Understand CX5106 output  
- Understand chartplotter requirements  
- Convert PGNs accordingly  

## **7.4 Voice Assistant**
- STT → intent → TTS  
- Commands:
  - “What’s engine status”  
  - “Any anomalies”  
  - “Open OpenCPN”  
  - “Start benchmarking”  
  - “Start onboarding”  

## **7.5 Pi Health**
- Temperature  
- Voltage  
- CPU load  
- Memory  
- Disk  
- Signal K health  

---

# **8. OpenCPN Integration**

## **8.1 Auto‑Install**
Triggered when user selects **“No chartplotter”**.

Installs:
- OpenCPN  
- Signal K plugin  
- AIS/GPS integration  
- Configures data feeds  

## **8.2 Auto‑Configure**
- Signal K → OpenCPN  
- GPS → OpenCPN  
- AIS → OpenCPN  
- NMEA2000 PGNs → OpenCPN  

## **8.3 UI Integration**
- “Open OpenCPN” button  
- “Uninstall OpenCPN” button  
- Status indicator  

---

# **9. Node‑RED Flows**

## **9.1 Required Flows**
- Onboarding launcher  
- Menu system  
- OpenCPN launcher  
- OpenCPN uninstall  
- Voice intent routing  
- Health dashboard  
- Benchmarking UI  

---

# **10. API Specification**

## **10.1 Onboarding**
- `POST /onboarding/operator-alias`  
- `POST /onboarding/boat`  
- `POST /onboarding/engine`  
- `POST /onboarding/chartplotter`  
- `POST /onboarding/gateway`  
- `POST /onboarding/finalize`  
- `POST /onboarding/reset`  

## **10.2 OpenCPN**
- `POST /onboarding/install-opencpn`  
- `POST /onboarding/uninstall-opencpn`  
- `GET /onboarding/opencpn-status`  

## **10.3 Benchmarking**
- `POST /benchmark/start`  
- `POST /benchmark/stop`  
- `GET /benchmark/status`  
- `GET /benchmark/report`  
- `POST /benchmark/accept`  

## **10.4 AI**
- `POST /ai/query`  
- `GET /health/summary`  
- `GET /health/anomalies`  

---

# **11. Assumptions**

1. User has no technical background.  
2. helm‑OS must operate fully offline.  
3. Voice assistant must work offline.  
4. OpenCPN must install without user interaction.  
5. All NMEA2000 data is available via PiCAN‑M.  
6. CX5106 DIP logic is deterministic based on PGNs.  
7. Benchmarking requires 30 minutes of stable engine operation.  
8. helm‑OS must survive power loss without corruption.  
9. All configuration must be stored in JSON.  
10. Node‑RED is the primary UI server.  

---

Don — this is the **full, detailed, production‑grade MASTER SYSTEM SPEC** you asked for.  
It’s ready to drop into GitHub as‑is.

If you want, I can now generate:

- **ARCHITECTURE.md**  
- **ROADMAP.md**  
- **README.md**  
- **CONTRIBUTING.md**  
- **First code scaffolding**  

Just tell me where you want to go next.
