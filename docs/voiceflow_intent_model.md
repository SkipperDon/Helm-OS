## 1. Purpose

This document defines the **canonical VoiceFlow model** for helm‑OS.

It describes:

- Intents  
- Variables  
- API calls  
- System summary behavior  
- Onboarding reset behavior  

All of it is aligned 1:1 with:

`/opt/helm-os/state/onboarding.json`

and the onboarding flow.

---

## 2. Canonical data source

All voice behavior reads from this file:

```text
/opt/helm-os/state/onboarding.json
```

Example structure:

```json
{
  "operator": { "alias": "Skipper Don" },
  "time": { "region": "EST", "correct_time": "12:48:03 PM" },
  "hardware": { "hat_type": "Pican-M", "analog_converter": "CX5106" },
  "vessel": { "manufacturer_region": "North America", "boat_manufacturer": "Monterey" },
  "engine": {
    "make": "Mercruiser",
    "model": "7.4 Litre",
    "year": "1994",
    "cylinders": "8",
    "stroke": "4",
    "gear_ratio": "4:1",
    "engine_type": "Gasoline ignition coil",
    "fuel_type": "Gas"
  },
  "navigation": { "chartplotter": "Garmin" },
  "network": { "type": "NMEA 2000" },
  "complete": true
}
```

---

## 3. VoiceFlow variables

Create these VoiceFlow variables (all lowercase, snake_case):

**Operator**

- `operator_alias`

**Time**

- `time_region`
- `correct_time`

**Hardware**

- `hat_type`
- `analog_converter`

**Vessel**

- `manufacturer_region`
- `boat_manufacturer`

**Engine**

- `engine_make`
- `engine_model`
- `engine_year`
- `engine_cylinders`
- `engine_stroke`
- `gear_ratio`
- `engine_type`
- `fuel_type`

**Navigation**

- `chartplotter`

**Network**

- `network_type`

**Meta**

- `onboarding_complete` (boolean)
- `system_summary_text` (string)

---

## 4. API: Load onboarding state

### 4.1 API block configuration

**Method:** `GET`  
**URL:** `http://<pi-ip>:8081/onboarding/status`  
**Headers:** none required  
**Body:** none  

### 4.2 Response mapping

Map JSON → VoiceFlow variables:

- `operator.alias` → `operator_alias`
- `time.region` → `time_region`
- `time.correct_time` → `correct_time`
- `hardware.hat_type` → `hat_type`
- `hardware.analog_converter` → `analog_converter`
- `vessel.manufacturer_region` → `manufacturer_region`
- `vessel.boat_manufacturer` → `boat_manufacturer`
- `engine.make` → `engine_make`
- `engine.model` → `engine_model`
- `engine.year` → `engine_year`
- `engine.cylinders` → `engine_cylinders`
- `engine.stroke` → `engine_stroke`
- `engine.gear_ratio` → `gear_ratio`
- `engine.engine_type` → `engine_type`
- `engine.fuel_type` → `fuel_type`
- `navigation.chartplotter` → `chartplotter`
- `network.type` → `network_type`
- `complete` → `onboarding_complete`

---

## 5. Core intents

### 5.1 Intent: System summary

**Name:** `system_summary`  
**Example utterances:**

- “Give me a system summary”  
- “Summarize my setup”  
- “What does helm‑OS know about my boat?”  
- “Read back my configuration”  

**Flow:**

1. **API Block** → GET `/onboarding/status` → map variables  
2. **Set system_summary_text** (using a Speak or Set block):

   Example template:

   > “Operator: {operator_alias}. Time region: {time_region}, time: {correct_time}.  
   > Hardware: HAT {hat_type}, converter {analog_converter}.  
   > Vessel: {boat_manufacturer} in {manufacturer_region}.  
   > Engine: {engine_make} {engine_model}, {engine_year}, {engine_cylinders} cylinders, {engine_stroke} stroke, gear ratio {gear_ratio}, type {engine_type}, fuel {fuel_type}.  
   > Navigation: {chartplotter}. Network: {network_type}.”

3. **Speak Block** → say `system_summary_text`.

---

### 5.2 Intent: What engine do I have?

**Name:** `engine_info`  
**Example utterances:**

- “What engine do I have?”  
- “Tell me about my engine”  
- “What’s my engine model?”  

**Flow:**

1. API Block → GET `/onboarding/status`  
2. Speak:

   > “You have a {engine_year} {engine_make} {engine_model} with {engine_cylinders} cylinders, {engine_stroke} stroke, gear ratio {gear_ratio}, engine type {engine_type}, running on {fuel_type}.”

---

### 5.3 Intent: What chartplotter do I have?

**Name:** `chartplotter_info`  
**Example utterances:**

- “What chartplotter do I have?”  
- “What brand is my chartplotter?”  
- “What navigation system am I using?”  

**Flow:**

1. API Block → GET `/onboarding/status`  
2. Speak:

   > “Your chartplotter is {chartplotter}.”

---

### 5.4 Intent: Network type

**Name:** `network_info`  
**Example utterances:**

- “What network am I using?”  
- “Is this NMEA 2000?”  
- “What’s my network type?”  

**Flow:**

1. API Block → GET `/onboarding/status`  
2. Speak:

   > “Your network type is {network_type}.”

---

### 5.5 Intent: Vessel info

**Name:** `vessel_info`  
**Example utterances:**

- “What boat do I have?”  
- “Who makes my boat?”  
- “What’s my boat manufacturer?”  

**Flow:**

1. API Block → GET `/onboarding/status`  
2. Speak:

   > “Your vessel is built by {boat_manufacturer} in {manufacturer_region}.”

---

### 5.6 Intent: Time info

**Name:** `time_info`  
**Example utterances:**

- “What time do you have?”  
- “What time zone are you using?”  
- “What’s my time region?”  

**Flow:**

1. API Block → GET `/onboarding/status`  
2. Speak:

   > “Your time region is {time_region}, and the current time I have stored is {correct_time}.”

---

### 5.7 Intent: Start onboarding again

**Name:** `onboarding_reset`  
**Example utterances:**

- “Start onboarding again”  
- “Reset my setup”  
- “Clear my configuration”  

**Flow:**

1. **API Block** → POST `/onboarding/reset`  
   - Method: `POST`  
   - URL: `http://<pi-ip>:8081/onboarding/reset`  
   - No body required  

2. Speak:

   > “Onboarding has been reset. You can now restart the setup on the helm‑OS screen.”

---

## 6. Error handling

### 6.1 If onboarding is incomplete

If `onboarding_complete` is `false`, and the user asks for a summary or engine info:

- Speak:

  > “Your onboarding is not complete yet. Please finish the setup on the helm‑OS screen, then ask me again.”

You can implement this with a Condition block after the API call:

- If `onboarding_complete == false` → speak the above  
- Else → continue with normal response

---

## 7. Integration with voice bridge

The **voice bridge** (on the Pi) will:

- Capture microphone audio  
- Convert to text (STT)  
- Send text to VoiceFlow runtime  
- Receive text response  
- Send to TTS  
- Play audio  

The VoiceFlow side doesn’t need to know about audio—only text in and text out.

---

## 8. Change control

Any change to:

- onboarding.json structure  
- field names  
- allowed values  

must be reflected here **and** in:

- `onboarding_voice_datamodel.md`  
- `voice_bridge.js`  

before deployment.

This keeps helm‑OS voice, onboarding, and backend perfectly aligned.

