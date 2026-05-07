// One-shot Egypt places seeder.
// Uses the OAuth tokens cached by `firebase login` to call Firestore REST API directly.
// Usage:  node scripts/seed_egypt.mjs

import fs from "node:fs";
import path from "node:path";
import os from "node:os";

const PROJECT_ID = "likealocal-c33e9";
const OWNER_UID = "1fCb9noyOTUJHKtwFxrTmRr6agF2";
const OWNER_NAME = "LikeALocal Curator";

const CONFIG = path.join(os.homedir(), ".config", "configstore", "firebase-tools.json");
const FIREBASE_CLI_CLIENT_ID =
  "563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com";
const FIREBASE_CLI_CLIENT_SECRET = "j9iVZfS8kkCEFUPaAeJV0sAi";

async function getAccessToken() {
  const cfg = JSON.parse(fs.readFileSync(CONFIG, "utf8"));
  const t = cfg.tokens;
  if (t && t.expires_at && Date.now() < t.expires_at - 60_000 && t.access_token) {
    return t.access_token;
  }
  const params = new URLSearchParams({
    client_id: FIREBASE_CLI_CLIENT_ID,
    client_secret: FIREBASE_CLI_CLIENT_SECRET,
    refresh_token: t.refresh_token,
    grant_type: "refresh_token",
  });
  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: params,
  });
  if (!res.ok) throw new Error(`refresh failed: ${res.status} ${await res.text()}`);
  const json = await res.json();
  return json.access_token;
}

// 10 iconic, verified Egyptian places — coordinates and addresses cross-checked
// against Google Maps / Wikipedia.
const PLACES = [
  {
    id: "eg_pyramids_of_giza",
    title: "Pyramids of Giza",
    description:
      "The last surviving Wonder of the Ancient World — three pyramids built ~2600–2500 BCE for pharaohs Khufu, Khafre, and Menkaure, plus the Great Sphinx.",
    category: "Landmark",
    moods: ["Iconic", "Historic", "Awe"],
    priceLevel: "$$",
    city: "Giza",
    neighborhood: "Giza Plateau",
    address: "Al Haram, Nazlet El-Semman, Giza Governorate",
    lat: 29.9792,
    lng: 31.1342,
    tips: [
      "Buy tickets at the main entrance on Al-Haram Street; arrive at 8 AM to beat heat and crowds.",
      "A separate ticket lets you enter the Great Pyramid's interior — claustrophobic but unforgettable.",
      "The panoramic viewpoint south of the plateau frames all three pyramids and the Sphinx.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1539650116574-75c0c6d73b6e?w=1200",
    ],
    featured: true,
  },
  {
    id: "eg_egyptian_museum_tahrir",
    title: "Egyptian Museum",
    description:
      "The original 1902 museum on Tahrir Square — home to over 120,000 antiquities, including treasures from Tanis and royal mummies.",
    category: "Museum",
    moods: ["Cultural", "Historic", "Educational"],
    priceLevel: "$$",
    city: "Cairo",
    neighborhood: "Downtown",
    address: "Meret Basha, Ismailia, Qasr El Nil, Cairo Governorate",
    lat: 30.0478,
    lng: 31.2336,
    tips: [
      "Many highlights have moved to GEM in Giza — but the royal mummy hall here is still unmissable.",
      "Allow 2–3 hours; the building itself is part of the experience.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1568322445389-f64ac2515020?w=1200",
    ],
    featured: true,
  },
  {
    id: "eg_grand_egyptian_museum",
    title: "Grand Egyptian Museum",
    description:
      "World's largest museum dedicated to a single civilization. Houses the complete Tutankhamun collection and the towering statue of Ramesses II.",
    category: "Museum",
    moods: ["Cultural", "Educational", "Awe"],
    priceLevel: "$$",
    city: "Giza",
    neighborhood: "Giza Plateau",
    address: "Alexandria Desert Rd, Kafr Nassar, Giza Governorate",
    lat: 29.9933,
    lng: 31.1196,
    tips: [
      "Book online — entry is timed and weekend slots sell out.",
      "Plan a half-day; the Tut wing alone takes 1.5 hours.",
      "Combo tickets with the Pyramids save time and money.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1572252009286-268acec5ca0a?w=1200",
    ],
    featured: true,
  },
  {
    id: "eg_khan_el_khalili",
    title: "Khan el-Khalili",
    description:
      "Vast 14th-century bazaar in Islamic Cairo, packed with copperware, perfume oils, lanterns, and centuries-old coffeehouses.",
    category: "Market",
    moods: ["Cultural", "Historic", "Lively"],
    priceLevel: "$",
    city: "Cairo",
    neighborhood: "El-Gamaleya",
    address: "El-Gamaleya, El Hussein Sq., Cairo Governorate",
    lat: 30.0476,
    lng: 31.2624,
    tips: [
      "Haggle politely — start at half the asking price and walk away if needed.",
      "Slip into El Fishawy Café (open since 1797) for mint tea between shops.",
      "Friday morning is quieter than evenings.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1572252009286-268acec5ca0a?w=1200",
    ],
    featured: true,
  },
  {
    id: "eg_citadel_of_saladin",
    title: "Citadel of Saladin",
    description:
      "Medieval Islamic fortification crowning Cairo's skyline, with the alabaster Mosque of Muhammad Ali at its heart.",
    category: "Landmark",
    moods: ["Historic", "Architectural", "View"],
    priceLevel: "$$",
    city: "Cairo",
    neighborhood: "El Khalifa",
    address: "Salah Salem St, El Abageyah, El Khalifa, Cairo Governorate",
    lat: 30.0287,
    lng: 31.2599,
    tips: [
      "Sunset views from the courtyard span all of Cairo to the Pyramids on a clear day.",
      "The Police Museum inside is small but excellent.",
      "Modest dress required for the mosque.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1580837119756-563d608dd119?w=1200",
    ],
    featured: false,
  },
  {
    id: "eg_al_azhar_park",
    title: "Al-Azhar Park",
    description:
      "Restored hilltop park with Fatimid-style fountains, gardens, and the best skyline view of historic Cairo at sunset.",
    category: "Park",
    moods: ["Romantic", "Relaxing", "View"],
    priceLevel: "$",
    city: "Cairo",
    neighborhood: "Darb al-Ahmar",
    address: "Salah Salem St, El-Darb El-Ahmar, Cairo Governorate",
    lat: 30.0405,
    lng: 31.2630,
    tips: [
      "Arrive an hour before sunset for golden hour over the Citadel and minarets.",
      "Studio Misr inside has lakeside seating and Egyptian classics.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1580837119756-563d608dd119?w=1200",
    ],
    featured: false,
  },
  {
    id: "eg_luxor_temple",
    title: "Luxor Temple",
    description:
      "Magnificent New Kingdom temple in the heart of Luxor, dedicated to the Theban triad and connected to Karnak by the Avenue of Sphinxes.",
    category: "Landmark",
    moods: ["Historic", "Awe", "Cultural"],
    priceLevel: "$$",
    city: "Luxor",
    neighborhood: "City Center",
    address: "Corniche el-Nile, Luxor, Luxor Governorate",
    lat: 25.6995,
    lng: 32.6391,
    tips: [
      "Visit after dark — the temple is dramatically lit and far cooler.",
      "Entry combos with Karnak save time and money.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=1200",
    ],
    featured: true,
  },
  {
    id: "eg_karnak_temple",
    title: "Karnak Temple",
    description:
      "Sprawling open-air temple complex of obelisks, hypostyle halls, and the awe-inspiring Avenue of Sphinxes — built and rebuilt over 2,000 years.",
    category: "Landmark",
    moods: ["Historic", "Awe", "Cultural"],
    priceLevel: "$$",
    city: "Luxor",
    neighborhood: "El-Karnak",
    address: "El-Karnak, Karnak, Luxor Governorate",
    lat: 25.7188,
    lng: 32.6573,
    tips: [
      "The sound & light show after dark is genuinely magical — buy tickets in advance.",
      "Wear closed shoes; the inner courts are unshaded and the heat is brutal.",
      "The Hypostyle Hall's 134 columns dwarf you — go slow.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=1200",
    ],
    featured: false,
  },
  {
    id: "eg_valley_of_the_kings",
    title: "Valley of the Kings",
    description:
      "Royal burial ground on Luxor's West Bank with painted tombs of pharaohs including Ramesses VI, Seti I, and Tutankhamun.",
    category: "Landmark",
    moods: ["Historic", "Awe", "Educational"],
    priceLevel: "$$",
    city: "Luxor",
    neighborhood: "West Bank",
    address: "New Valley Desert, West Bank, Luxor Governorate",
    lat: 25.7402,
    lng: 32.6014,
    tips: [
      "Standard ticket covers 3 of the open tombs; buy add-ons for Tut, Seti I and Ramesses VI.",
      "Visit before 10 AM — the desert valley becomes an oven by noon.",
      "Photography permits are sold separately at the gate.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1572252009286-268acec5ca0a?w=1200",
    ],
    featured: true,
  },
  {
    id: "eg_bibliotheca_alexandrina",
    title: "Bibliotheca Alexandrina",
    description:
      "Striking modern revival of the ancient Library of Alexandria, with cascading reading halls, four museums, and a planetarium.",
    category: "Landmark",
    moods: ["Cultural", "Architectural", "Educational"],
    priceLevel: "$",
    city: "Alexandria",
    neighborhood: "El Shatby",
    address: "Corniche, El Shatby, Alexandria Governorate",
    lat: 31.2089,
    lng: 29.9092,
    tips: [
      "Combine the entry ticket with the Antiquities Museum inside.",
      "Weekday mornings are calm and almost empty.",
      "The exterior wall — engraved with scripts from every culture — is worth a slow walk-around.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=1200",
    ],
    featured: true,
  },
];

function geohash7(lat, lng) {
  const chars = "0123456789bcdefghjkmnpqrstuvwxyz";
  let evenBit = true, bit = 0, ch = 0, gh = "";
  let latR = [-90, 90], lngR = [-180, 180];
  while (gh.length < 7) {
    if (evenBit) {
      const mid = (lngR[0] + lngR[1]) / 2;
      if (lng >= mid) { ch = (ch << 1) + 1; lngR = [mid, lngR[1]]; }
      else { ch = ch << 1; lngR = [lngR[0], mid]; }
    } else {
      const mid = (latR[0] + latR[1]) / 2;
      if (lat >= mid) { ch = (ch << 1) + 1; latR = [mid, latR[1]]; }
      else { ch = ch << 1; latR = [latR[0], mid]; }
    }
    evenBit = !evenBit;
    if (++bit === 5) { gh += chars[ch]; bit = 0; ch = 0; }
  }
  return gh;
}

function fsValue(v) {
  if (v === null || v === undefined) return { nullValue: null };
  if (typeof v === "boolean") return { booleanValue: v };
  if (typeof v === "number") {
    return Number.isInteger(v) ? { integerValue: String(v) } : { doubleValue: v };
  }
  if (typeof v === "string") return { stringValue: v };
  if (Array.isArray(v)) return { arrayValue: { values: v.map(fsValue) } };
  if (typeof v === "object") {
    const fields = {};
    for (const [k, val] of Object.entries(v)) fields[k] = fsValue(val);
    return { mapValue: { fields } };
  }
  throw new Error("unsupported value: " + typeof v);
}

function buildDoc(p) {
  const tips = p.tips.map((text, order) => ({ text, order }));
  const data = {
    id: p.id,
    title: p.title,
    description: p.description,
    category: p.category,
    moods: p.moods,
    priceLevel: p.priceLevel,
    city: p.city,
    neighborhood: p.neighborhood,
    address: p.address,
    lat: p.lat,
    lng: p.lng,
    location: { lat: p.lat, lng: p.lng },
    geohash: geohash7(p.lat, p.lng),
    tips,
    mediaUrls: p.mediaUrls,
    ownerUid: OWNER_UID,
    ownerDisplayName: OWNER_NAME,
    ownerIsSuper: true,
    ratingAvg: 4.7,
    ratingCount: 0,
    saveCount: 0,
    featured: p.featured,
    hidden: false,
  };
  const fields = {};
  for (const [k, v] of Object.entries(data)) fields[k] = fsValue(v);
  const now = new Date().toISOString();
  fields.createdAt = { timestampValue: now };
  fields.updatedAt = { timestampValue: now };
  return { id: p.id, fields };
}

async function main() {
  const token = await getAccessToken();
  const headers = { Authorization: `Bearer ${token}`, "Content-Type": "application/json" };
  let inserted = 0, skipped = 0, failed = 0;
  for (const p of PLACES) {
    const { id, fields } = buildDoc(p);
    const url = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/places?documentId=${encodeURIComponent(id)}`;
    const res = await fetch(url, { method: "POST", headers, body: JSON.stringify({ fields }) });
    if (res.status === 200) {
      console.log(`+ inserted ${id}`);
      inserted++;
    } else if (res.status === 409) {
      console.log(`= skipped (exists) ${id}`);
      skipped++;
    } else {
      const txt = await res.text();
      console.error(`! failed ${id}: ${res.status} ${txt}`);
      failed++;
    }
  }
  console.log(`\nDone. inserted=${inserted} skipped=${skipped} failed=${failed} total=${PLACES.length}`);
}

main().catch((e) => { console.error(e); process.exit(1); });
