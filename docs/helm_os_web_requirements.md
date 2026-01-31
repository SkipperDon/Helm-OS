# 📄 **helm_os_web_requirements.md**  
### *helm‑OS Web Architecture & Accessibility Requirements*  
*(GitHub‑ready)*

---

## **1. Purpose**

This document defines the official requirements for all helm‑OS web interfaces, including:

- Onboarding  
- Dashboard  
- Future helm‑OS UI modules  

It ensures consistency, accessibility, and maintainability across the entire system.

---

## **2. Directory Structure**

All helm‑OS web assets must follow this structure:

```
/opt/helm-os/
   ├── onboarding/
   │     └── onboarding.html
   ├── dashboard/
   │     └── helm-osdashboard.html
   ├── ui/
   │     └── (static assets, shared CSS, images, JS)
   └── state/
         └── onboarding.json
```

### **2.1 Static Serving Requirements**

The backend must expose:

```
/ui         → /opt/helm-os/ui
/onboarding → /opt/helm-os/onboarding
/dashboard  → /opt/helm-os/dashboard
```

This ensures consistent routing and predictable URLs.

---

## **3. AODA / WCAG 2.1 AA Compliance**

All helm‑OS web pages **must** be fully AODA‑compliant.

### **3.1 Required Accessibility Features**

Every page must include:

- **ARIA labels** for all inputs and interactive elements  
- **ARIA live regions** for dynamic updates  
- **Focus management** when navigating between steps or views  
- **Keyboard operability** for all controls  
- **Semantic HTML structure** (headings, regions, landmarks)  
- **High‑contrast color scheme** (helm‑OS black/green meets AAA)  
- **Accessible completion screens**  
- **Screen reader announcements** for:  
  - Step changes  
  - Errors  
  - AI‑filled fields  
  - Completion messages  

### **3.2 Required Landmarks**

Each page must include:

- `<main role="main">`  
- `<header role="banner">` (if applicable)  
- `<nav role="navigation">` (dashboard only)  
- `<footer role="contentinfo">` (optional)

---

## **4. Onboarding Requirements**

### **4.1 Onboarding Completion Behavior**

When onboarding is complete:

- The backend sets `"complete": true` in `onboarding.json`
- The UI must redirect to:

```
/dashboard/helm-osdashboard.html
```

### **4.2 AODA‑Compliant Completion Screen**

The completion screen must:

- Use `<main role="main">`  
- Announce completion via ARIA live region  
- Include a large, accessible button:  
  **“Go to helm‑OS Dashboard”**  
- Redirect to the dashboard path above  

---

## **5. Dashboard Requirements**

### **5.1 Dashboard Location**

The official dashboard file must be located at:

```
/opt/helm-os/dashboard/helm-osdashboard.html
```

### **5.2 Dashboard Structure**

The dashboard must include:

- A left navigation rail  
- A main content region  
- Status widgets (engine, navigation, network, system)  
- AODA‑compliant layout and controls  
- High‑contrast helm‑OS theme  

### **5.3 Future Modules**

All future helm‑OS modules must:

- Live under `/dashboard` or `/ui`  
- Follow the same accessibility and structural rules  
- Use consistent styling and spacing  

---

## **6. Backend Requirements**

### **6.1 Static Serving**

index.js must include:

```js
app.use('/dashboard', express.static('/opt/helm-os/dashboard'));
```

### **6.2 Onboarding Redirect**

The onboarding “Complete” action must:

- Save onboarding.json  
- Set `"complete": true`  
- Replace the page with the AODA‑compliant completion screen  
- Redirect to `/dashboard/helm-osdashboard.html` when the user presses the button  

---

## **7. Change Control**

Any change to:

- Web structure  
- Accessibility requirements  
- Dashboard layout  
- Onboarding flow  
- File locations  

must be reflected in this document **before** implementation.
