# 📄 **helm‑OS Onboarding & VoiceFlow Data Model Specification**  
*(Authoritative System Reference)*

## **Purpose**
This document defines the **exact fields** collected during helm‑OS onboarding and exposed to the VoiceFlow subsystem.  
It serves as the **canonical data model** for:

- onboarding UI  
- onboarding backend  
- voice intent routing  
- system initialization  
- analytics namespace creation  
- hardware configuration  

No additional fields may be added without updating this document.

---

# ## **1. Operator Information**

| Field | Description |
|-------|-------------|
| `operator.alias` | User‑defined alias for voice interaction and personalization |

---

# ## **2. Time Configuration**

| Field | Description |
|-------|-------------|
| `time.region` | Time region derived from system clock (e.g., EST, PST, UTC+1) |
| `time.correct_time` | Confirmation that system time is correct |

---

# ## **3. Hardware Configuration**

### **3.1 HAT Type**
`hardware.hat_type`  
Allowed values:
- Pican‑M  
- MacArthur  

### **3.2 Analog Converter**
`hardware.analog_converter`  
Allowed values:
- CX5106  
- Actisense  
- NoLand  
- CX5001  

---

# ## **4. Vessel Information**

| Field | Description |
|-------|-------------|
| `vessel.manufacturer` | Vessel manufacturer (e.g., Monterey, Bayliner) |
| `vessel.manufacturer_region` | Region of manufacturer: North America, Europe, Asia, Australia, Africa, South America |
| `vessel.boat_manufacturer` | Specific boat model/manufacturer designation |

---

# ## **5. Engine Information**

| Field | Description |
|-------|-------------|
| `engine.make` | Engine manufacturer |
| `engine.model` | Engine model |
| `engine.year` | Year of manufacture |
| `engine.cylinders` | Number of cylinders |
| `engine.stroke` | 2‑stroke or 4‑stroke |
| `engine.gear_ratio` | Gear ratio (ranges vary by engine type) |
| `engine.engine_type` | Alternator w‑terminal, Gasoline ignition coil, Diesel magnetic pickup, ECU digital output |
| `engine.fuel_type` | Gas, Diesel, Hybrid, Electric |

---

# ## **6. Navigation Equipment**

| Field | Description |
|-------|-------------|
| `navigation.chartplotter` | Garmin, Simrad, Lowrance, Humminbird, Raymarine, Furuno |

---

# ## **7. Network Configuration**

| Field | Description |
|-------|-------------|
| `network.type` | NMEA 2000, NMEA 0183, Ethernet, WiFi, Bluetooth |

---

# ## **8. Canonical JSON Structure**

This is the exact structure stored in:

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
  }
}
```

This is the **authoritative schema**.  
All onboarding UI, backend services, and voiceflow must adhere to this structure.

---

# ## **9. VoiceFlow Integration**

VoiceFlow uses the same fields for:

- answering system questions  
- confirming onboarding values  
- routing configuration commands  
- generating system summaries  

Voice intents map directly to the fields in this document.

---

# ## **10. Change Control**

Any modification to:

- field names  
- allowed values  
- structure  
- nesting  
- semantics  



If you want, I can now generate the **updated onboarding.html** and **index.js** that implement this exact schema with zero deviation.
