# **helm‑OS Tier‑0 — ONBOARDING ARCHITECTURE**

### *Authoritative architecture for onboarding logic, services, data flow, and system orchestration*

---

# **1. Purpose**

This document describes the **architecture** of the helm‑OS Tier‑0 onboarding system.  
It explains:

- Components  
- Data flow  
- Service boundaries  
- Detection logic  
- AI responsibilities  
- Integration with Node‑RED, Signal K, and systemd  

This is the technical blueprint for how onboarding works under the hood.

---

# **2. High‑Level Architecture**

Onboarding is built from **four cooperating subsystems**:

```
Node‑RED UI  →  Onboarding Backend  →  Hardware Detection  →  System Services
```

Each subsystem has a strict responsibility:

| Subsystem | Role |
|----------|------|
| **Node‑RED UI** | Displays onboarding screens, collects user input, sends API calls |
| **Onboarding Backend** | State machine, logic engine, JSON persistence, DIP rules |
| **Hardware Detection Layer** | PGN scanning, chartplotter detection, CAN bus analysis |
| **System Services** | OpenCPN install, benchmarking, health monitoring |

This separation ensures reproducibility, maintainability, and offline operation.

---

# **3. Component Breakdown**

## **3.1 Node‑RED UI**
- Provides the onboarding wizard  
- Uses dashboard nodes for forms and buttons  
- Calls backend APIs via HTTP request nodes  
- Never stores data  
- Never performs logic  

**Key flows:**
- Welcome  
- Operator/Vessel form  
- Engine form  
- Chartplotter detection  
- OpenCPN install progress  
- PGN detection progress  
- DIP switch instructions  
- Review  
- Benchmark prompt  

---

## **3.2 Onboarding Backend (`services/onboarding/`)**

This is the **brain** of onboarding.

### **Core files**
| File | Purpose |
|------|---------|
| `index.js` | API server + state machine |
| `configStore.js` | JSON read/write abstraction |
| `pgnDetector.js` | CAN bus PGN scanning |
| `dipSwitchCalculator.js` | Rule‑based DIP logic |
| `opencpnInstaller.js` | OpenCPN installation orchestration |
| `benchmarkEngine.js` | Benchmark start/stop logic |
| `aiAssistant.js` | Voice + reasoning integration |

### **Responsibilities**
- Maintain onboarding state  
- Validate and normalize user input  
- Detect hardware automatically  
- Compute DIP switches deterministically  
- Install OpenCPN when required  
- Persist all configuration to JSON  
- Provide clean APIs for Node‑RED  

---

## **3.3 Hardware Detection Layer**

This layer interacts with real hardware:

### **CAN Bus (NMEA2000)**
- Uses `candump` to capture frames  
- Extracts PGNs from 29‑bit CAN IDs  
- Identifies:
  - Engine PGNs  
  - Navigation PGNs  
  - AIS/GPS  
  - Chartplotter presence  
  - Gateway presence  

### **Chartplotter Detection**
- PGN signatures for Garmin, Raymarine, Simrad, Furuno  
- Fallback shell script: `detect-chartplotter.sh`

### **GPS/AIS Detection**
- Via Signal K plugins  
- Via USB device enumeration  

---

## **3.4 System Services**

### **helm-onboarding.service**
- Runs onboarding backend  
- Ensures API is always available  

### **helm-opencpn.service**
- Launches OpenCPN  
- Restarts if it crashes  

### **helm-benchmark.service**
- Captures 30 minutes of engine data  
- Stores results in JSON  

### **helm-health.service**
- Monitors Pi temperature, CPU, memory, disk  
- Monitors Signal K health  

---

# **4. Data Flow Architecture**

The onboarding system uses a **unidirectional data flow**:

```
User → Node‑RED → Onboarding API → JSON Files → System Services
```

### **4.1 User Input**
- Operator name  
- Vessel info  
- Engine info  
- Chartplotter presence  

### **4.2 Backend Processing**
- Validates input  
- Fills missing fields  
- Stores to JSON  

### **4.3 Hardware Detection**
- PGN scan  
- Chartplotter detection  
- Engine inference  

### **4.4 DIP Switch Logic**
- Rule evaluation  
- Mode selection  
- Switch positions  

### **4.5 Finalization**
- JSON configs complete  
- OpenCPN installed (if needed)  
- Benchmark optional  

---

# **5. Onboarding State Machine**

The backend maintains a deterministic state machine:

```
welcome
operator_vessel
engine
chartplotter
opencpn_install (conditional)
pgn_detection
dip_switch
review
benchmark_prompt
complete
```

Stored in:

```
state/onboarding.json
```

### **State transitions**
- Triggered by API calls  
- Always move forward  
- Never skip steps  
- Resume after reboot  

---

# **6. Detection Logic Architecture**

## **6.1 PGN Detection**
- Capture CAN frames for ~10 seconds  
- Extract PGNs  
- Count frequency  
- Identify engine type  
- Identify chartplotter  
- Identify gateway mode  

## **6.2 Chartplotter Detection**
- PGN signatures  
- Manufacturer‑specific PGNs  
- Fallback shell script  

## **6.3 Engine Inference**
- Based on PGNs:
  - 127488 (Rapid Update)  
  - 127489 (Dynamic)  
  - 127493 (Transmission)  
  - 127505 (Fluid Level)  

---

# **7. DIP Switch Architecture**

DIP logic is rule‑based:

```
rules = [
  { match: (context) → true/false, switches: [...], mode: "...", notes: "..." }
]
```

### **Inputs**
- Engine count  
- Engine manufacturer  
- PGNs present  
- Chartplotter presence  

### **Outputs**
- Switch positions  
- Gateway mode  
- Human‑readable explanation  

### **Fallback**
If no rule matches → safe passthrough mode.

---

# **8. OpenCPN Installation Architecture**

Triggered only when **no chartplotter** is detected.

### **Process**
1. Backend calls `install-opencpn.sh`  
2. Script installs:
   - OpenCPN  
   - Signal K plugin  
   - AIS/GPS integration  
3. Logs written to `state/opencpn-install.log`  
4. Backend updates onboarding state  

### **Guarantees**
- Fully offline  
- No user interaction  
- Deterministic  

---

# **9. Voice Assistant Architecture**

### **Pipeline**
```
Microphone → Vosk STT → Intent Router → Onboarding API → Piper TTS → Speaker
```

### **Supported onboarding intents**
- “Start onboarding”  
- “Next step”  
- “What’s my engine type”  
- “Do I need OpenCPN”  
- “Explain my DIP switches”  

---

# **10. Completion Architecture**

Onboarding is complete when:

- All JSON configs are populated  
- PGNs detected  
- DIP switches computed  
- OpenCPN installed (if needed)  
- Benchmark prompt shown  

System transitions to:

```
Node‑RED main menu
OpenCPN launcher
Health dashboard
Benchmarking tools
Voice assistant
```

