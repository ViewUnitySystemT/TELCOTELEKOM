# ICE-Server Konfiguration - Kompletter Guide

## 🎯 **Überblick**

| Dienst | STUN | TURN | Freikontingent* | Primäre URLs | Auth | Geeignet für |
|--------|:---:|:---:|:-------------:|--------------|------|--------------|
| Öffentl. STUN | ✅ | – | unbegrenzt | `stun:stun.l.google.com:19302` | – | Dev/Tests |
| OpenRelay (Metered) | ✅ | ✅ | ~20 GB/Monat | **per API** | API-Token | Prototyping |
| Xirsys (Free Dev) | ✅ | ✅ | ~0.5 GB/Monat | Dashboard | User/Pass | Leichte Last |
| Cloudflare Realtime | ✅ | ✅ | **grosszügig** | Dashboard | Token/Key | Tests → Produktion |
| Eigener coturn | ✅ | ✅ | n/a | `turn:example.com:3478` | statisch | Produktion |

> *Freikontingente sind Richtwerte und können sich ändern.

---

## 🚀 **Schnellstart-Optionen**

### 1. **STUN-only (kostenlos, kein Relay)**

```json
[
  { "urls": [
    "stun:stun.cloudflare.com:3478",
    "stun:stun.l.google.com:19302"
  ]}
]
```

**Verwendung:**
```js
const pc = new RTCPeerConnection({ 
  iceServers: [
    { urls: "stun:stun.cloudflare.com:3478" },
    { urls: "stun:stun.l.google.com:19302" }
  ]
});
```

### 2. **OpenRelay (Metered) - API-basiert**

```js
// API gibt direkt ein komplettes iceServers-Array zurück
async function getIceServers() {
  const res = await fetch(
    "https://<your-subdomain>.metered.live/api/v1/turn/credentials?apiKey=<API_KEY>"
  );
  if (!res.ok) throw new Error("OpenRelay API error");
  return await res.json(); // -> [{ urls: ["stun:…","turn:…"], username, credential }, …]
}

const pc = new RTCPeerConnection({ iceServers: await getIceServers() });
```

### 3. **Xirsys - Statische Konfiguration**

```json
[
  {
    "urls": [
      "stun:<xirsys-host>:3478",
      "turn:<xirsys-host>:3478",
      "turns:<xirsys-host>:5349"
    ],
    "username": "<XIRSYS_USERNAME>",
    "credential": "<XIRSYS_CREDENTIAL>"
  }
]
```

### 4. **Cloudflare Realtime - Token-basiert**

```js
// Hol dir serverseitig ein kurzlebiges Token und TURN-Endpunkte
const iceServers = [
  {
    urls: [
      "stun:<cf-stun-host>:3478",
      "turn:<cf-turn-host>:3478",
      "turns:<cf-turn-host>:5349"
    ],
    username: "<CF_USERNAME_OR_TOKEN>",
    credential: "<CF_CREDENTIAL>"
  }
];
const pc = new RTCPeerConnection({ iceServers });
```

### 5. **Eigener coturn (Produktion)**

```env
# .env
TURN_DOMAIN=turn.example.com
TURN_USERNAME=webrtc
TURN_PASSWORD=super-strong-secret
```

```json
[
  {
    "urls": [
      "stun:${TURN_DOMAIN}:3478",
      "turn:${TURN_DOMAIN}:3478?transport=udp",
      "turn:${TURN_DOMAIN}:3478?transport=tcp",
      "turns:${TURN_DOMAIN}:5349"
    ],
    "username": "${TURN_USERNAME}",
    "credential": "${TURN_PASSWORD}"
  }
]
```

---

## 🧪 **Schnelltest im Browser**

```js
async function testIce(iceServers) {
  const pc = new RTCPeerConnection({ iceServers });
  pc.onicecandidate = e => e.candidate && console.log("ICE:", e.candidate.candidate);
  pc.createDataChannel("t");
  const offer = await pc.createOffer();
  await pc.setLocalDescription(offer);
  // wartet ein paar Sekunden auf Kandidaten
  setTimeout(() => pc.close(), 5000);
}

// Beispiel: testIce([{ urls: ["stun:stun.l.google.com:19302"] }]);
```

---

## 🔧 **PeerLink Integration**

### Server-seitig (server.js)

```js
// ICE-Server-Konfiguration wird automatisch an Client gesendet
const configMessage = {
  type: 'config',
  iceServers: JSON.parse(config.ICE_SERVERS_JSON),
  publicUrl: config.PUBLIC_URL
};
ws.send(JSON.stringify(configMessage));
```

### Client-seitig (peerlink.html)

```js
// Client empfängt und verwendet ICE-Server-Konfiguration
if (message.type === 'config') {
  config.iceServers = message.iceServers;
  config.publicUrl = message.publicUrl;
}

// Verwendung in createPeerConnection()
const pc = new RTCPeerConnection({
  iceServers: config.iceServers || fallbackServers,
  iceTransportPolicy: 'all'
});
```

---

## 🚨 **Troubleshooting**

### Häufige Probleme

1. **Keine ICE-Kandidaten**
   - Prüfe Firewall-Einstellungen
   - Teste mit STUN-Servern zuerst
   - Verwende TURN-Server für NAT-Traversal

2. **Symmetric NAT**
   - STUN reicht nicht aus
   - TURN-Server erforderlich
   - Ports 80/443 (TCP/TLS) bevorzugen

3. **Firmen-Netzwerke**
   - Nur Ports 80/443 erlaubt
   - TURNS (TLS) verwenden
   - Kurzlebige Credentials bevorzugen

### Diagnose-Tools

```js
// ICE Connection State überwachen
pc.oniceconnectionstatechange = () => {
  console.log('ICE Connection State:', pc.iceConnectionState);
};

// ICE Gathering State überwachen
pc.onicegatheringstatechange = () => {
  console.log('ICE Gathering State:', pc.iceGatheringState);
};
```

---

## 📊 **Performance-Optimierung**

### ICE-Server-Reihenfolge

```js
// Optimale Reihenfolge: STUN → TURN UDP → TURN TCP → TURNS
const iceServers = [
  { urls: "stun:stun.l.google.com:19302" },           // Schnellster Weg
  { urls: "turn:turn.example.com:3478?transport=udp" }, // UDP TURN
  { urls: "turn:turn.example.com:3478?transport=tcp" }, // TCP TURN
  { urls: "turns:turn.example.com:5349" }              // TLS TURN
];
```

### Transport-Prioritäten

```js
const rtcConfiguration = {
  iceServers: iceServers,
  iceTransportPolicy: 'all',        // Erlaube STUN und TURN
  iceCandidatePoolSize: 10,         // Mehr Kandidaten sammeln
  bundlePolicy: 'balanced',         // Optimale Bundle-Strategie
  rtcpMuxPolicy: 'require'          // RTCP-Muxing aktivieren
};
```

---

## 🔒 **Sicherheit**

### Kurzlebige Credentials

```js
// Server generiert kurzlebige TURN-Credentials
const generateTurnCredentials = () => {
  const username = `user_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  const password = crypto.randomBytes(16).toString('base64');
  return { username, password };
};
```

### Credential-Rotation

```js
// Credentials alle 24 Stunden erneuern
setInterval(() => {
  const newCredentials = generateTurnCredentials();
  // An alle verbundenen Clients senden
  broadcastToAllClients({
    type: 'ice-config-update',
    iceServers: updatedIceServers
  });
}, 24 * 60 * 60 * 1000);
```

---

## 🎯 **Empfehlungen**

### Für Entwicklung
- **STUN-only** für lokale Tests
- **OpenRelay** für erste Demos

### Für Produktion
- **Eigener coturn** für volle Kontrolle
- **IPv6-Unterstützung** aktivieren
- **TLS-Termination** für Firmen-Netzwerke

### Für Skalierung
- **Load Balancer** vor TURN-Servern
- **Geografische Verteilung** der TURN-Server
- **Monitoring** der ICE-Verbindungsqualität

---

**🎉 Mit dieser Konfiguration ist PeerLink optimal für alle Netzwerk-Umgebungen gerüstet!**
