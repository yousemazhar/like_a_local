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

const PLACES = [
  ["Felfela", "Beloved downtown spot serving Egyptian classics — koshari, ful, ta'meya — under quirky village-style decor since 1959.", "Restaurant", ["Casual","Local","Family"], "$", "Cairo", "Downtown", 30.0489, 31.2374,
    [["Order the mixed mezze plate to try a bit of everything.",0],["Lunch hours are quieter than evenings.",1],["Don't miss the fresh sugarcane juice.",2]],
    ["https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=1200"], true],
  ["Abou Tarek", "The koshari temple. A multi-floor institution that has been perfecting Egypt's national dish for decades.", "Restaurant", ["Local","Iconic","Quick"], "$", "Cairo", "Downtown", 30.0511, 31.2436,
    [["Ask for the spicy chili sauce on the side.",0],["Top floor has the best views and quickest seating.",1]],
    ["https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=1200"], true],
  ["Khan el-Khalili", "14th-century bazaar maze packed with copper, perfume oils, lanterns, and centuries-old coffeehouses.", "Market", ["Cultural","Historic","Lively"], "$", "Cairo", "Old Cairo", 30.0476, 31.2624,
    [["Haggle politely — start at half the asking price.",0],["Slip into El Fishawy cafe for mint tea between shops.",1],["Visit early morning to beat the crowds.",2]],
    ["https://images.unsplash.com/photo-1572252009286-268acec5ca0a?w=1200"], true],
  ["El Fishawy Cafe", "The oldest cafe in Cairo (since 1797). Naguib Mahfouz wrote here. Mirrored walls, brass tables, and mint tea.", "Cafe", ["Historic","Cozy","Romantic"], "$", "Cairo", "Old Cairo", 30.0479, 31.2620,
    [["Order the karkade (hibiscus tea) — it's their specialty.",0],["Late evenings are most atmospheric with locals smoking shisha.",1]],
    ["https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=1200"], false],
  ["Pyramids of Giza", "The last surviving wonder of the ancient world. Visit at sunrise to see the Great Pyramid in golden light without the crowds.", "Landmark", ["Iconic","Historic","Awe"], "$$", "Giza", "Giza Plateau", 29.9792, 31.1342,
    [["Enter via the back gate near Mena House for fewer touts.",0],["Camel rides are overpriced — agree on a flat fee in writing.",1],["Stay for the panoramic viewpoint south of the Sphinx.",2]],
    ["https://images.unsplash.com/photo-1539650116574-75c0c6d73b6e?w=1200"], true],
  ["The Grand Egyptian Museum", "World's largest archaeological museum dedicated to a single civilization, including the full Tutankhamun collection.", "Museum", ["Cultural","Educational","Awe"], "$$", "Giza", "Giza Plateau", 29.9933, 31.1196,
    [["Allow at least four hours — the Tut wing alone is enormous.",0],["Buy tickets online to skip the queue.",1]],
    ["https://images.unsplash.com/photo-1568322445389-f64ac2515020?w=1200"], true],
  ["Al-Azhar Park", "Restored hilltop park with Fatimid-style fountains and the best skyline view of Islamic Cairo at sunset.", "Park", ["Romantic","Relaxing","View"], "$", "Cairo", "Darb al-Ahmar", 30.0405, 31.2630,
    [["Go an hour before sunset for golden hour over the Citadel.",0],["The lakeside restaurant is worth a sit-down dinner.",1]],
    ["https://images.unsplash.com/photo-1580837119756-563d608dd119?w=1200"], false],
  ["Sequoia", "Open-air Nile-side dining with Mediterranean small plates. Best on a breezy night with a view of the Zamalek waterfront.", "Restaurant", ["Romantic","Upscale","View"], "$$$", "Cairo", "Zamalek", 30.0805, 31.2210,
    [["Reserve a riverside table at least a day ahead.",0],["Their seafood mezze platter is the move.",1]],
    ["https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=1200"], false],
  ["Cairo Jazz Club", "Long-running live music venue in Agouza featuring jazz, oriental fusion, and indie Egyptian acts.", "Nightlife", ["Lively","Music","Local"], "$$", "Cairo", "Agouza", 30.0566, 31.2122,
    [["Check the gig calendar — Thursday nights are the strongest.",0],["Dress code is smart-casual at the door.",1]],
    ["https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=1200"], false],
  ["Library of Alexandria", "Striking modern revival of the ancient library, with cascading reading halls and a planetarium next door.", "Landmark", ["Cultural","Architectural","Educational"], "$", "Alexandria", "Corniche", 31.2089, 29.9092,
    [["Combine ticket with the antiquities museum inside.",0],["Go on a weekday morning — calm and almost empty.",1]],
    ["https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=1200"], true],
  ["Mohamed Ahmed", "Alexandria's most famous ful & falafel spot. Tiny, crowded, and unbeatable for breakfast.", "Restaurant", ["Local","Casual","Iconic"], "$", "Alexandria", "Downtown", 31.1987, 29.8987,
    [["Order ful with extra tahini and a side of pickles.",0],["Cash only.",1]],
    ["https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=1200"], false],
  ["Stanley Bridge", "Iconic Mediterranean bridge with whitewashed kiosks, perfect for a sunset corniche walk.", "Landmark", ["Romantic","View","Relaxing"], "$", "Alexandria", "Stanley", 31.2400, 29.9628,
    [["Sunset around 6pm in summer is golden.",0],["Grab a fresh juice from one of the corniche kiosks.",1]],
    ["https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=1200"], false],
  ["Dahab Blue Hole", "World-famous freediving and snorkelling site — dramatic coral wall plunging into deep blue.", "Outdoor", ["Adventure","Nature","Peaceful"], "$$", "Dahab", "Blue Hole", 28.5728, 34.5378,
    [["Snorkel only — leave the deep dives to certified pros.",0],["Beachside Bedouin cafes serve killer fresh seafood.",1]],
    ["https://images.unsplash.com/photo-1519046904884-53103b34b206?w=1200"], true],
  ["Karnak Temple", "Vast open-air temple complex of obelisks, hypostyle halls, and the awe-inspiring Avenue of Sphinxes.", "Landmark", ["Historic","Awe","Cultural"], "$$", "Luxor", "East Bank", 25.7188, 32.6573,
    [["The sound & light show after dark is genuinely magical.",0],["Bring water — there's no shade in the inner courts.",1]],
    ["https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=1200"], false],
  ["Valley of the Kings", "Royal burial ground with painted tombs of pharaohs including Ramesses VI and Tutankhamun.", "Landmark", ["Historic","Awe","Educational"], "$$", "Luxor", "West Bank", 25.7402, 32.6014,
    [["The Tutankhamun tomb is a separate ticket — worth it.",0],["Visit before 10am to avoid the heat.",1],["Photography inside tombs requires an extra permit.",2]],
    ["https://images.unsplash.com/photo-1572252009286-268acec5ca0a?w=1200"], true],
  ["Abu Simbel", "Ramesses II's colossal twin temples carved into a Nubian cliff — relocated stone-by-stone in the 1960s.", "Landmark", ["Iconic","Historic","Awe"], "$$$", "Aswan", "Abu Simbel", 22.3372, 31.6258,
    [["Sunrise convoys leave Aswan around 4am — book a tour.",0],["Twice a year (Feb/Oct) the sun aligns to light the inner sanctum.",1]],
    ["https://images.unsplash.com/photo-1568322445389-f64ac2515020?w=1200"], false],
  ["Nubian Village", "Colorful Aswan riverside village reachable by felucca, with henna artists and Nubian home restaurants.", "Cultural", ["Local","Cultural","Photogenic"], "$", "Aswan", "Gharb Soheil", 24.0758, 32.8843,
    [["Take a felucca across at sunset for the best views.",0],["Lunch at a Nubian home is the highlight — book ahead.",1]],
    ["https://images.unsplash.com/photo-1552733407-5d5c46c3bb3b?w=1200"], false],
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

// Convert a JS value into a Firestore REST API "Value" map.
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
  const [title, description, category, moods, priceLevel, city, neighborhood, lat, lng, tipsRaw, mediaUrls, featured] = p;
  const id = "eg_" + title.toLowerCase().replace(/[^a-z0-9]+/g, "_").replace(/^_|_$/g, "");
  const tips = tipsRaw.map(([text, order]) => ({ text, order }));
  const data = {
    id, title, description, category, moods, priceLevel, city, neighborhood,
    lat, lng,
    location: { lat, lng },
    geohash: geohash7(lat, lng),
    tips, mediaUrls,
    ownerUid: OWNER_UID,
    ownerDisplayName: OWNER_NAME,
    ownerIsSuper: true,
    ratingAvg: 4.6,
    ratingCount: 0,
    saveCount: 0,
    featured,
    hidden: false,
  };
  const fields = {};
  for (const [k, v] of Object.entries(data)) fields[k] = fsValue(v);
  // server timestamps via REST need a different approach (commit endpoint); set ISO strings instead.
  const now = new Date().toISOString();
  fields.createdAt = { timestampValue: now };
  fields.updatedAt = { timestampValue: now };
  return { id, fields };
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
