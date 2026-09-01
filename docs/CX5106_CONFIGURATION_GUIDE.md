# CX5106 Engine Gateway - Configuration Guide

## Overview

The CX5106 is an analog-to-NMEA2000 engine gateway that converts analog engine signals into NMEA2000 PGNs for display on marine chartplotters and multi-function displays.

**Hardware:**
- Raspberry Pi 4B
- PiCAN-M HAT
- CX5106 Engine Gateway
- NMEA2000 backbone

---

## Part 1: DIP Switch Configuration Logic

The CX5106 has two physically separate switch blocks inside the enclosure. They are **not** eight
switches in one row.

### Physical DIP Switch Layout

**Visual Reference:**

![CX5106 DIP Switches](../../assets/images/cx5106_10125.png)

*Photo showing the actual CX5106 interior: the 7-position Block A (upper) and 2-position Block B (lower).*

```
   BLOCK A — SEVEN positions (numbered 1–7)
   Sets ONE value: the RPM speed ratio

   +-------------------------------+
   | ON                            |
   | [ ] [ ] [ ] [ ] [ ] [ ] [ ]  |
   |  1   2   3   4   5   6   7   |
   +-------------------------------+


   BLOCK B — TWO positions (numbered 1 and 2)
   Sets TWO independent things

   +-------------+
   | ON          |
   | [ ] [ ]     |
   |  1   2      |
   +-------------+
```

### Block A — RPM Speed Ratio (7 positions)

The seven switches in Block A encode a **single binary number**: the RPM speed ratio. They are not
seven independent settings. Each switch has a place value, with switch 1 as the least significant:

| Switch | 1 | 2 | 3 | 4 | 5  | 6  | 7  |
|--------|---|---|---|---|----|----|----|
| Value  | 1 | 2 | 4 | 8 | 16 | 32 | 64 |

**Rule:** `ratio = 1 + (sum of the values of every switch that is ON)`

- All switches OFF → ratio **1**
- Switch 1 and 2 ON → 1 + 2 = 3 → ratio **4**

To set a ratio: take the ratio, subtract 1, then express the remainder as a sum of switch values.

**Common ratios by engine type** (from the manufacturer's leaflet):

| Engine | Ratio | Block A switches ON |
|---|---|---|
| 4-cylinder, 4-cycle inboard gasoline | 2 | **1** |
| 6-cylinder, 4-cycle inboard gasoline | 3 | **2** |
| **8-cylinder, 4-cycle inboard gasoline** | **4** | **1, 2** |
| 10-cylinder, 4-cycle inboard gasoline | 5 | **3** |
| 12-cylinder, 4-cycle inboard gasoline | 6 | **1, 3** |
| Outboard — 4 poles | 2 | **1** |
| Outboard — 6 poles | 3 | **2** |
| Outboard — 8 poles | 4 | **1, 2** |
| Diesel — gear number N | N | per ratio rule |

For diesel engines, the manufacturer states: **Speed Ratio = Gear Number**. If the gear number is
not in the engine documentation, determine the ratio empirically (see the companion guide
`CX5106_DIP_SWITCH.md`).

---

### Block B — Independent Settings (2 positions)

| Switch | OFF | ON |
|--------|-----|----|
| **1** — tank level sender standard | `0–190 Ω` (European) | `240–33 Ω` (American) |
| **2** — engine position | `PORT` | `STBD` |

Block B switch 1 applies to **all** tank inputs simultaneously (fuel, fresh water, black water,
livewell). There is no per-tank setting.

---

## Part 2: Wizard Questions

To automatically determine the correct switch positions, the helm-OS wizard asks the following
questions.

### **Question 1: Engine Type**
**Question**: "What type of engine does your vessel have?"

**Options**:
- Inboard gasoline (petrol)
- Outboard
- Diesel inboard

**Maps to**: Block A (determines the lookup table for the RPM ratio)

---

### **Question 2: Engine Specification**

For **inboard gasoline**:
- "How many cylinders does your engine have?" (4, 6, 8, 10, 12)
- "Is it 4-cycle or 2-cycle?" (almost always 4-cycle for inboard)

For **outboard**:
- "How many poles does your outboard alternator/stator have?" (4, 6, 8, 10, 12)
- Help text: "This is usually in the engine service manual. If unknown, select 'I don't know'."

For **diesel**:
- "What is your engine's gear number?" (numeric entry)
- Help text: "Found in the engine specification sheet, sometimes labeled 'Gear No.'"

**Maps to**: Block A — determines the RPM speed ratio from the manufacturer's table

**If unknown**: Display ratio lookup table from `CX5106_DIP_SWITCH.md` Appendix A; offer
empirical method (measure at known RPM on the analogue tachometer).

---

### **Question 3: Tank Sender Standard**
**Question**: "What type of tank level senders does your boat use?"

**Options**:
- American / North American (240–33 Ω, falling resistance)
- European / International (0–190 Ω, rising resistance)
- I don't know

**Maps to**: Block B switch 1

**Help text**:
- **American senders**: Resistance is high (~240 Ω) when tank is empty; falls toward ~33 Ω when
  full. Common on North American-built boats.
- **European senders**: Resistance is low (~0 Ω) when empty; rises toward ~190 Ω when full.
- **Telling them apart**: A mismatched sender will invert the gauge — full tank reads empty. If
  you are not sure, note which way the gauge moved the last time you filled a tank.
- This one switch applies to every tank at once (fuel, water, waste, livewell).

**If "I don't know"**: Suggest American for North American boats as a starting assumption; advise
operator that a mismatch will show as an inverted tank gauge.

---

### **Question 4: Engine Position**
**Question**: "What position is this CX5106 monitoring?"

**Options**:
- Single engine (or port / primary)
- Starboard engine

**Maps to**: Block B switch 2

**Logic**:
```
Single engine      → Block B switch 2: OFF (PORT)
Port engine        → Block B switch 2: OFF
Starboard engine   → Block B switch 2: ON
```

**Help text**: On twin-engine vessels, both CX5106 units must be set differently. Two units with
the same Block B switch 2 setting will collide on the NMEA 2000 network.

---

## Part 3: Wizard Flow Integration

### Step-by-Step Configuration

**Step 1: Determine the RPM ratio**
```
Question: "Engine type?"           → Inboard gasoline
Question: "Cylinders?"             → 8
Question: "Stroke?"                → 4-cycle
System: ratio = 4  (from table)
System: Block A → switches 1 and 2 ON, switches 3–7 OFF
```

**Step 2: Set Block B**
```
Question: "Tank senders?"          → North America (240–33 Ω)
System: Block B switch 1 → ON

Question: "Engine position?"       → Single / Port
System: Block B switch 2 → OFF
```

**Step 3: Generate the diagram**
```
System output:

   BLOCK A — set these seven switches:
   +-------------------------------+
   | ON                            |
   | [X] [X] [ ] [ ] [ ] [ ] [ ]  |
   |  1   2   3   4   5   6   7   |
   +-------------------------------+
   X = push toward ON label

   BLOCK B — set these two switches:
   +-------------+
   | ON          |
   | [X] [ ]     |
   |  1   2      |
   +-------------+
```

**Step 4: Verification prompt**
```
"Please set the DIP switches as shown, then press Next.

Important: Power cycle the CX5106 after changing any switch.
Turn the ignition off, wait 10 seconds, turn back on.
Then watch the network for at least 2.5 minutes before
concluding the unit is not present — it announces itself
periodically, not continuously."
```

---

## Part 4: AI-Assisted Configuration

### When user selects "I don't know" for ratio

**Step 1**: Display the ratio lookup table (see `CX5106_DIP_SWITCH.md` Appendix A).

**Step 2**: Offer the empirical method:
- Start with ratio 2 (switch 1 ON, all others OFF)
- Compare displayed RPM against analogue tachometer at a steady throttle
- If display reads too high by factor N, multiply the ratio by N; if too low, divide
- Repeat until displayed and analogue agree across the rev range

**Step 3**: AI inference based on engine make/model/year as a last resort. Always label this
as an estimate and recommend the operator verify on the tachometer.

```
Engine: Yanmar 3YM30, 2015, Diesel
Diesel rule: Speed Ratio = Gear Number
AI: "Check your engine specification sheet for the Gear Number.
     If unavailable, start with ratio 2 and compare to your tachometer."
```

---

## Part 5: JSON Configuration Storage

### config/boat-active.json

```json
{
  "engine": {
    "manufacturer": "MerCruiser",
    "model": "7.4L MPI",
    "type": "inboard_gasoline",
    "cylinders": 8,
    "stroke": "4-cycle"
  },
  "gateway": {
    "model": "CX5106",
    "rpm_speed_ratio": 4,
    "block_a_switches_on": [1, 2],
    "tank_sender_standard": "american_240_33",
    "engine_position": "port",
    "block_b": {
      "sw1": "ON",
      "sw2": "OFF"
    },
    "notes": "8-cyl 4-cycle V8 → ratio 4 → sw1+sw2 ON. North American boat. Single / port."
  }
}
```

---

## Part 6: Common Configurations

#### **Single MerCruiser 7.4L V8 Gasoline (8-cyl, 4-cycle)**
```
Block A: sw1 ON, sw2 ON, sw3–7 OFF    (ratio 4)
Block B: sw1 ON (American), sw2 OFF (port/single)
```

#### **Single Yanmar 3YM30 Diesel (Gear Number 2)**
```
Block A: sw1 ON, sw2–7 OFF            (ratio 2)
Block B: sw1 ON (American), sw2 OFF (port/single)
```

#### **Single Volvo Penta D4 Diesel (Gear Number 3)**
```
Block A: sw2 ON, sw1 sw3–7 OFF        (ratio 3)
Block B: sw1 ON (American), sw2 OFF (port/single)
```

#### **Twin MerCruiser V8 — Port unit**
```
Block A: sw1 ON, sw2 ON, sw3–7 OFF    (ratio 4)
Block B: sw1 ON (American), sw2 OFF (PORT)
```

#### **Twin MerCruiser V8 — Starboard unit**
```
Block A: sw1 ON, sw2 ON, sw3–7 OFF    (ratio 4)
Block B: sw1 ON (American), sw2 ON (STBD)
```

---

## Part 7: Troubleshooting

### RPM Reading is a Constant Multiple of True Value
**Cause**: Wrong speed ratio — a ratio error is a constant factor, not one that changes with RPM.
**Fix**: Determine the observed factor (displayed ÷ actual). Adjust the ratio by that factor using
the empirical method in `CX5106_DIP_SWITCH.md` §10.

### RPM Error Changes With Engine Speed
**Cause**: Not the ratio (a ratio error is a fixed proportion). Investigate the tachometer
signal source and its wiring.

### Tank Gauge is Inverted (full reads empty or vice versa)
**Cause**: Block B switch 1 is set to the wrong sender standard.
**Fix**: Flip Block B switch 1. Measure sender resistance at empty and full if uncertain.

### Unit Does Not Appear on the Network
1. Confirm ignition supply (10–30 V DC) is present at the gateway.
2. Confirm NMEA 2000 backbone is powered and terminated at both ends.
3. **Watch for at least 2.5 minutes** — the unit announces periodically, not continuously.

### Unit Present But RPM Not Displayed
**Cause**: Wiring or sender issue, not the ratio (the ratio scales a value, not whether it is sent).
**Fix**: Check sender wiring against the terminal reference in `CX5106_DIP_SWITCH.md` Appendix B.

### Twin-Engine Data Collides or One Engine Missing
**Cause**: Both gateways have Block B switch 2 set the same.
**Fix**: One unit switch 2 OFF (PORT), the other switch 2 ON (STBD).

---

## Summary

### The Three Questions for Complete CX5106 Configuration

1. **RPM speed ratio** → Block A (7 switches, binary, ratio = 1 + sum of ON values)
2. **Tank sender standard** → Block B switch 1 (OFF = 0–190 Ω European; ON = 240–33 Ω American)
3. **Engine position** → Block B switch 2 (OFF = PORT; ON = STBD)

### Output
- Block A diagram (7 switches)
- Block B diagram (2 switches)
- JSON configuration
- Power-cycle reminder
- Network verification instructions

### Full detail
See `CX5106_DIP_SWITCH.md` for the complete derivation guide including the full ratio table
(1–127), the empirical calibration method, and the manufacturer's terminal and sender
specifications.
