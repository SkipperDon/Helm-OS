# 📄 **UPDATED onboarding_voice_datamodel.md**  
### *helm‑OS Onboarding & VoiceFlow Data Model Specification*  
*(Finalized for GitHub — aligned with current implementation)*

---

## **1. Purpose**

This document defines the **canonical data model** and **onboarding flow** for helm‑OS.  
It ensures that:

- onboarding UI  
- backend services  
- voiceflow integration  
- analytics  
- system initialization  

all operate from a single, authoritative source of truth.

Any changes to this document must be made **before** modifying code.

---

## **2. Onboarding Flow Overview**

helm‑OS uses a **multi‑step touchscreen wizard** optimized for a helm environment.  
The bottom 1/3 of the screen is reserved for the on‑screen keypad.

### **Steps**
1. Operator  
2. Time  
3. Hardware  
4. Vessel  
5. Engine  
6. Navigation  
7. Network  
8. Summary (AI‑assisted completion)  
9. Start Again / Complete  

### **Theme**
- Black background  
- Green highlights  
- Large touchscreen‑friendly fonts  

---

## **3. Data Model**

The onboarding system collects the following fields and stores them in a structured JSON file.  
These fields are also exposed to VoiceFlow for natural‑language interaction.

---

### **3.1 Operator**

| Field | Description |
|-------|-------------|
| `operator.alias` | User‑defined alias for voice interaction |

---

### **3.2 Time**

| Field | Description |
|-------|-------------|
| `time.region` | Time region (user‑entered) |
| `time.correct_time` | Confirmed or AI‑filled current time |

**AI Behavior:**  
If `correct_time` is blank, helm‑OS fills it using the system clock.

---

### **3.3 Hardware**

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

### **3.4 Vessel**

| Field | Description |
|-------|-------------|
| `vessel.manufacturer_region` | Region of vessel manufacturer |
| `vessel.boat_manufacturer` | Name of the boat manufacturer |

**Removed:**  
- `manufacturer` (redundant)

---

### **3.5 Engine**

| Field | Description |
|-------|-------------|
| `engine.make` | Engine manufacturer |
| `engine.model` | Engine model |
| `engine.year` | Year of manufacture |
| `engine.cylinders` | Number of cylinders |
| `engine.stroke` | 2‑stroke or 4‑stroke |
| `engine.gear_ratio` | Gear ratio |
| `engine.engine_type` | Alternator w‑terminal, Gasoline ignition coil, Diesel magnetic pickup, ECU digital output |
| `engine.fuel_type` | Gas, Diesel, Hybrid, Electric |

---

### **3.6 Navigation**

| Field | Description |
|-------|-------------|
| `navigation.chartplotter` | Garmin, Simrad, Lowrance, Humminbird, Raymarine, Furuno |

---

### **3.7 Network**

| Field | Description |
|-------|-------------|
| `network.type` | NMEA 2000, NMEA 0183, Ethernet, WiFi, Bluetooth |

---

## **4. Summary Step (AI‑Assisted Completion)**

After all fields are entered, helm‑OS generates a **Summary Screen**.

### **AI Behavior**
- Any empty field eligible for inference is filled automatically  
- AI‑filled fields are tagged visually  
- Missing fields are highlighted in yellow  

### **User Options**
- **Start Again**  
  - Clears onboarding.json  
  - Returns to Step 1  
- **Complete**  
  - Saves final onboarding.json  
  - Sets `"complete": true`  
  - Displays a “Setup Complete” confirmation screen  

No redirect occurs unless a future UI page is defined.

---

## **5. Canonical JSON Structure**

Stored at:

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
    "manufacturer_region": "",
    "boat_manufacturer": ""
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
All onboarding UI, backend logic, and voiceflow intents must adhere to it.

---

## **6. VoiceFlow Integration**

VoiceFlow uses this data model to:

- answer system questions  
- confirm onboarding values  
- generate system summaries  
- support hands‑free diagnostics  
- route configuration commands  

Voice intents map directly to the fields in this document.

---

## **7. Change Control**

Any modification to:

- field names  
- allowed values  
- structure  
- semantics  

must be reflected in this document **before** implementation.

