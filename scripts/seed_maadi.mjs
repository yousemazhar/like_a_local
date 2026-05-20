// One-shot Maadi (Cairo) places seeder.
// Uses the OAuth tokens cached by `firebase login` to call Firestore REST API directly.
// Usage:  node scripts/seed_maadi.mjs

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

// 5 well-known Maadi spots — coordinates approximated from Google Maps.
// Photos are generic category-matching Unsplash images (free to hotlink).
const PLACES = [
  {
    id: "eg_maadi_lucilles",
    title: "Lucille's",
    description:
      "Cult-favourite American diner on Road 9, famous for the giant Lucille burger, all-day breakfast, and milkshakes. A Maadi institution since 1998.",
    category: "Restaurant",
    moods: ["Casual", "Comfort", "Local"],
    priceLevel: "$$",
    city: "Cairo",
    neighborhood: "Maadi",
    address: "54 Road 9, Maadi, Cairo Governorate",
    lat: 29.9596,
    lng: 31.2569,
    tips: [
      "Order the Lucille burger — it is enormous and worth the wait.",
      "Weekend brunch fills up fast; arrive before noon or expect a queue.",
      "Cash and card both accepted; tipping ~10% is standard.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=1200",
    ],
    featured: true,
  },
  {
    id: "eg_maadi_eish_malh",
    title: "Eish + Malh",
    description:
      "Italian-inspired bakery and pizzeria with wood-fired sourdough pizzas, fresh pastas, and an airy garden setting tucked off Road 7.",
    category: "Restaurant",
    moods: ["Cosy", "Romantic", "Foodie"],
    priceLevel: "$$",
    city: "Cairo",
    neighborhood: "Maadi",
    address: "12 Road 7, Maadi, Cairo Governorate",
    lat: 29.9613,
    lng: 31.2581,
    tips: [
      "The Margherita with buffalo mozzarella is the move — simple but perfectly done.",
      "Garden seating is the spot on a cool evening; book ahead Thursday–Saturday.",
      "Their sourdough loaves sell out by mid-afternoon.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=1200",
    ],
    featured: true,
  },
  {
    id: "eg_maadi_corniche",
    title: "Maadi Corniche",
    description:
      "Leafy Nile-side promenade lined with cafés and felucca docks — Maadi's go-to spot for a sunset walk, a coffee with a river view, or a slow felucca ride.",
    category: "Park",
    moods: ["Relaxing", "Romantic", "View"],
    priceLevel: "$",
    city: "Cairo",
    neighborhood: "Maadi",
    address: "Corniche El Nil, Maadi, Cairo Governorate",
    lat: 29.9618,
    lng: 31.2515,
    tips: [
      "Sunset over the Nile from the riverside benches is the best free view in Maadi.",
      "Negotiate the felucca price up front — expect EGP 300–500/hour.",
      "Friday evenings get busy with families; weekday mornings are the calm version.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1572252009286-268acec5ca0a?w=1200",
    ],
    featured: false,
  },
  {
    id: "eg_maadi_cilantro_road9",
    title: "Cilantro Road 9",
    description:
      "Egyptian specialty coffee chain's flagship Maadi branch — strong Wi-Fi, reliable espresso, and a balcony perched over Road 9's pedestrian buzz.",
    category: "Cafe",
    moods: ["Work-friendly", "Casual", "Local"],
    priceLevel: "$",
    city: "Cairo",
    neighborhood: "Maadi",
    address: "Road 9, Maadi, Cairo Governorate",
    lat: 29.9601,
    lng: 31.2572,
    tips: [
      "Upstairs balcony is the prime laptop seat — power outlets along the railing.",
      "Try the iced Spanish latte; it is sweeter than a regular latte.",
      "Wi-Fi password is on the receipt.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=1200",
    ],
    featured: false,
  },
  {
    id: "eg_maadi_road9",
    title: "Road 9 (Sharia 9)",
    description:
      "Maadi's pedestrian-friendly main strip — a few hundred metres of cafés, gelato spots, bookshops, and weekend foot traffic that captures the neighbourhood's expat-meets-local rhythm.",
    category: "Market",
    moods: ["Lively", "Local", "Walkable"],
    priceLevel: "$",
    city: "Cairo",
    neighborhood: "Maadi",
    address: "Road 9, Maadi, Cairo Governorate",
    lat: 29.9598,
    lng: 31.2575,
    tips: [
      "Walk it end-to-end on a Thursday or Friday evening for the full vibe.",
      "Stop at Mandarine Koueider for the city's best mango sorbet.",
      "Bookspot and Diwan branches nearby are worth a browse for English titles.",
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=1200",
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
