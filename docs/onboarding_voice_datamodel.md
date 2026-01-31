# 📄 **onboarding_voice_datamodel.md**  
### *helm‑OS Onboarding & VoiceFlow Data Model Specification*  
*(Authoritative System Reference — Updated)*

---

## **1. Purpose**

This document defines the **canonical data model** for helm‑OS onboarding and voiceflow integration.  
It ensures:

- UI  
- backend  
- voice interaction  
- analytics  
- hardware configuration  

all operate from the same source of truth.

This specification must be updated **before** any implementation changes are made.

---

## **2. Onboarding Flow Overview**

The onboarding process is a **multi‑step wizard** optimized for touchscreen use.  
The bottom 1/3 of the screen is reserved for the on‑screen keypad.

The steps are:

1. Operator  
2. Time  
3. Hardware  
4. Vessel  
5. Engine  
6. Navigation  
7. Network  
8. **Summary (AI‑assisted completion)**  
9. **Start Again / Complete**

The UI theme is:

- **Black background**
- **Green highlights**
- **Terminal‑style contrast**

---

## **3. Data Model**

The onboarding system collects the following fields.  
These fields are also exposed to the VoiceFlow subsystem.

---

### **3.1 Operator Information**

| Field | Description |
|-------|-------------|
| `operator.alias` | User‑defined alias for voice interaction |

---

### **3.2 Time Configuration**

| Field | Description |
|-------|-------------|
| `time.region` | Time region derived from system clock |
| `time.correct_time` | Confirmation that system time is correct |

---

### **3.3 Hardware Configuration**

#### HAT Type  
`hardware.hat_type`  
Allowed values:
- Pican‑M  
- MacArthur  

#### Analog Converter  
`hardware.analog_converter`  
Allowed values:
- CX5106  
- Actisense  
- NoLand  
- CX5001  

---

### **3.4 Vessel Information**

| Field | Description |
|-------|-------------|
| `vessel.manufacturer` | Vessel manufacturer |
| `vessel.manufacturer_region` | Region of manufacturer (North America, Europe, Asia, Australia, Africa, South America) |
| `vessel.boat_manufacturer_region` | **Corrected field name** (formerly “Boat Manufacturer”) |

---

### **3.5 Engine Information**

| Field | Description |
|-------|-------------|
| `engine.make` | Engine manufacturer |
| `engine.model` | Engine model |
| `engine.year` | Year of manufacture |
| `engine.cylinders` | Number of cylinders |
| `engine.stroke` | 2‑stroke or 4‑stroke |
| `engine.gear_ratio` | Gear ratio (varies by engine type) |
| `engine.engine_type` | Alternator w‑terminal, Gasoline ignition coil, Diesel magnetic pickup, ECU digital output |
| `engine.fuel_type` | Gas, Diesel, Hybrid, Electric |

---

### **3.6 Navigation Equipment**

| Field | Description |
|-------|-------------|
| `navigation.chartplotter` | Garmin, Simrad, Lowrance, Humminbird, Raymarine, Furuno |

---

### **3.7 Network Configuration**

| Field | Description |
|-------|-------------|
| `network.type` | NMEA 2000, NMEA 0183, Ethernet, WiFi, Bluetooth |

---

## **4. Summary Step (AI‑Assisted Completion)**

After all fields are collected, helm‑OS generates a **Summary Screen**.

The summary includes:

```
summary:
  operator
  time
  hardware
  vessel
  engine
  navigation
  network
  ai_filled_fields
```

The user is presented with:

- **Start Again**  
  - Clears onboarding.json  
  - Returns to Step 1  

- **Complete**  
  - Writes final onboarding.json  
  - Sets `"complete": true`  
  - Signals Tier‑1 services to initialize  

---

## **5. Canonical JSON Structure**

This is the exact structure stored at:

```
/opt/helm-os/state/onboarding.json
```

```json
{
  "operator": {
    "alias": ""
  },
  "time": {
    "region": "",
    "correct_time": ""
  },
  "hardware": {
    "hat_type": "",
    "analog_converter": ""
  },
  "vessel": {
    "manufacturer": "",
    "manufacturer_region": "",
    "boat_manufacturer_region": ""
  },
  "engine": {
    "make": "",
    "model": "",
    "year": "",
    "cylinders": "",
    "stroke": "",
    "gear_ratio": "",
    "engine_type": "",
    "fuel_type": ""
  },
  "navigation": {
    "chartplotter": ""
  },
  "network": {
    "type": ""
  },
  "complete": false
}
```

This is the **authoritative schema**.  
All onboarding UI, backend services, and voiceflow must adhere to this structure.

---

## **6. VoiceFlow Integration**

VoiceFlow uses the same fields to:

- answer system questions  
- confirm onboarding values  
- generate system summaries  
- route configuration commands  
- support hands‑free diagnostics  

Voice intents map directly to the fields in this document.

---

## **7. Change Control**

Any modification to:

- field names  
- allowed values  
- structure  
- nesting  
- semantics  

must be updated in this document **before** implementation.

This prevents drift between:

- onboarding UI  
- onboarding backend  
- voiceflow  
- analytics  
- system services  
