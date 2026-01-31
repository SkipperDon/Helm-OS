# 📄 **voice_subsystem_prerequisites.md**  
### *helm‑OS Voice Subsystem — Prerequisites & Installation Guide*  
*(GitHub‑ready, clean, and aligned with helm‑OS architecture)*

---

## **1. Purpose**

This document defines the prerequisites and installation steps required for helm‑OS to:

- **Capture voice** (Speech‑to‑Text / STT)  
- **Generate digital speech** (Text‑to‑Speech / TTS)  
- **Integrate with VoiceFlow** for conversational control  
- **Operate offline or online depending on configuration**

This is the authoritative reference for preparing the helm‑OS voice subsystem.

---

## **2. Voice Subsystem Overview**

helm‑OS uses a modular voice pipeline:

```
[ Microphone ] → [ STT Engine ] → [ VoiceFlow ] → [ TTS Engine ] → [ Speaker ]
```

### **Components**
| Component | Purpose |
|----------|---------|
| **Microphone** | Captures raw audio |
| **Speech‑to‑Text (STT)** | Converts voice → text |
| **VoiceFlow Runtime** | Interprets text, runs intents, returns responses |
| **Text‑to‑Speech (TTS)** | Converts text → digital voice |
| **Speaker** | Plays audio output |

helm‑OS supports both **online** and **offline** voice engines.

---

## **3. Required Software**

### **3.1 Speech‑to‑Text (STT)**  
You need one of the following:

### **Option A — Online (Recommended for VoiceFlow)**  
**Whisper.cpp (local)** or **OpenAI Whisper API (cloud)**

- High accuracy  
- Works well with marine background noise  
- Easy integration with Node.js  

Install Whisper.cpp:

```
sudo apt install build-essential ffmpeg
git clone https://github.com/ggerganov/whisper.cpp
cd whisper.cpp
make
```

### **Option B — Offline (No internet required)**  
**Vosk STT**

```
sudo apt install python3-pip
pip3 install vosk
```

---

## **3.2 Text‑to‑Speech (TTS)**  
You need one of the following:

### **Option A — Online (Best quality)**  
**Microsoft Azure Neural TTS**

- Natural voice  
- Fast  
- Easy to integrate with VoiceFlow  

### **Option B — Offline (No internet required)**  
**Piper TTS**

```
sudo apt install pipx
pipx install piper-tts
```

---

## **4. Node.js Voice Bridge**

helm‑OS requires a small Node.js service that:

- Listens to microphone input  
- Sends audio to STT  
- Sends recognized text to VoiceFlow  
- Receives VoiceFlow’s response  
- Sends text to TTS  
- Plays the audio output  

This service will live here:

```
/opt/helm-os/voice/voice_bridge.js
```

(You will generate this after the VoiceFlow model is built.)

---

## **5. Hardware Requirements**

### **Microphone**
- USB microphone  
- Or I2S microphone (Adafruit SPH0645 recommended)

### **Speaker**
- USB speaker  
- Or 3.5mm audio output  
- Or I2S amplifier (MAX98357A)

### **Test audio devices**
```
arecord -l
aplay -l
```

---

## **6. VoiceFlow Integration Requirements**

Before connecting helm‑OS to VoiceFlow, ensure:

### ✔ VoiceFlow project exists  
Use a **General Assistant** project.

### ✔ API endpoint reachable  
VoiceFlow must access:

```
http://<pi-ip>:8081/onboarding/status
```

### ✔ Variables created  
VoiceFlow must have variables matching onboarding.json:

- operator_alias  
- time_region  
- correct_time  
- hat_type  
- analog_converter  
- manufacturer_region  
- boat_manufacturer  
- engine_make  
- engine_model  
- engine_year  
- engine_cylinders  
- engine_stroke  
- gear_ratio  
- engine_type  
- fuel_type  
- chartplotter  
- network_type  

### ✔ VoiceFlow runtime key  
You will need your **VoiceFlow API key** for the voice bridge.

---

## **7. Directory Structure**

After installation, helm‑OS voice subsystem will look like:

```
/opt/helm-os/
   ├── onboarding/
   ├── state/
   ├── voice/
   │     ├── voice_bridge.js
   │     ├── stt/
   │     ├── tts/
   │     └── config.json
   └── logs/
```

---

## **8. Next Steps**

Once prerequisites are installed:

1. Build the **VoiceFlow intent model**  
2. Generate the **voice_bridge.js** service  
3. Add systemd service:  
   ```
   voice.service
   ```
4. Test end‑to‑end voice interaction  
5. Integrate with helm‑OS dashboard  
 

Just tell me what you want next.
