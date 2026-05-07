import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";

type SeedPlace = {
  title: string;
  description: string;
  category: string;
  moods: string[];
  priceLevel: "$" | "$$" | "$$$";
  city: string;
  neighborhood: string;
  lat: number;
  lng: number;
  tips: { text: string; order: number }[];
  mediaUrls: string[];
  featured?: boolean;
};

const EGYPT_PLACES: SeedPlace[] = [
  {
    title: "Felfela",
    description:
      "Beloved downtown spot serving Egyptian classics — koshari, ful, ta'meya — under quirky village-style decor since 1959.",
    category: "Restaurant",
    moods: ["Casual", "Local", "Family"],
    priceLevel: "$",
    city: "Cairo",
    neighborhood: "Downtown",
    lat: 30.0489,
    lng: 31.2374,
    tips: [
      { text: "Order the mixed mezze plate to try a bit of everything.", order: 0 },
      { text: "Lunch hours are quieter than evenings.", order: 1 },
      { text: "Don't miss the fresh sugarcane juice.", order: 2 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=1200",
    ],
    featured: true,
  },
  {
    title: "Abou Tarek",
    description:
      "The koshari temple. A multi-floor institution that has been perfecting Egypt's national dish for decades.",
    category: "Restaurant",
    moods: ["Local", "Iconic", "Quick"],
    priceLevel: "$",
    city: "Cairo",
    neighborhood: "Downtown",
    lat: 30.0511,
    lng: 31.2436,
    tips: [
      { text: "Ask for the spicy chili sauce on the side.", order: 0 },
      { text: "Top floor has the best views and quickest seating.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=1200",
    ],
    featured: true,
  },
  {
    title: "Khan el-Khalili",
    description:
      "14th-century bazaar maze packed with copper, perfume oils, lanterns, and centuries-old coffeehouses.",
    category: "Market",
    moods: ["Cultural", "Historic", "Lively"],
    priceLevel: "$",
    city: "Cairo",
    neighborhood: "Old Cairo",
    lat: 30.0476,
    lng: 31.2624,
    tips: [
      { text: "Haggle politely — start at half the asking price.", order: 0 },
      { text: "Slip into El Fishawy cafe for mint tea between shops.", order: 1 },
      { text: "Visit early morning to beat the crowds.", order: 2 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1572252009286-268acec5ca0a?w=1200",
    ],
    featured: true,
  },
  {
    title: "El Fishawy Cafe",
    description:
      "The oldest cafe in Cairo (since 1797). Naguib Mahfouz wrote here. Mirrored walls, brass tables, and mint tea.",
    category: "Cafe",
    moods: ["Historic", "Cozy", "Romantic"],
    priceLevel: "$",
    city: "Cairo",
    neighborhood: "Old Cairo",
    lat: 30.0479,
    lng: 31.2620,
    tips: [
      { text: "Order the karkade (hibiscus tea) — it's their specialty.", order: 0 },
      { text: "Late evenings are most atmospheric with locals smoking shisha.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=1200",
    ],
  },
  {
    title: "Pyramids of Giza",
    description:
      "The last surviving wonder of the ancient world. Visit at sunrise to see the Great Pyramid in golden light without the crowds.",
    category: "Landmark",
    moods: ["Iconic", "Historic", "Awe"],
    priceLevel: "$$",
    city: "Giza",
    neighborhood: "Giza Plateau",
    lat: 29.9792,
    lng: 31.1342,
    tips: [
      { text: "Enter via the back gate near Mena House for fewer touts.", order: 0 },
      { text: "Camel rides are overpriced — agree on a flat fee in writing.", order: 1 },
      { text: "Stay for the panoramic viewpoint south of the Sphinx.", order: 2 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1539650116574-75c0c6d73b6e?w=1200",
    ],
    featured: true,
  },
  {
    title: "The Grand Egyptian Museum",
    description:
      "World's largest archaeological museum dedicated to a single civilization, including the full Tutankhamun collection.",
    category: "Museum",
    moods: ["Cultural", "Educational", "Awe"],
    priceLevel: "$$",
    city: "Giza",
    neighborhood: "Giza Plateau",
    lat: 29.9933,
    lng: 31.1196,
    tips: [
      { text: "Allow at least four hours — the Tut wing alone is enormous.", order: 0 },
      { text: "Buy tickets online to skip the queue.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1568322445389-f64ac2515020?w=1200",
    ],
    featured: true,
  },
  {
    title: "Al-Azhar Park",
    description:
      "Restored hilltop park with Fatimid-style fountains and the best skyline view of Islamic Cairo at sunset.",
    category: "Park",
    moods: ["Romantic", "Relaxing", "View"],
    priceLevel: "$",
    city: "Cairo",
    neighborhood: "Darb al-Ahmar",
    lat: 30.0405,
    lng: 31.2630,
    tips: [
      { text: "Go an hour before sunset for golden hour over the Citadel.", order: 0 },
      { text: "The lakeside restaurant is worth a sit-down dinner.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1580837119756-563d608dd119?w=1200",
    ],
  },
  {
    title: "Sequoia",
    description:
      "Open-air Nile-side dining with Mediterranean small plates. Best on a breezy night with a view of the Zamalek waterfront.",
    category: "Restaurant",
    moods: ["Romantic", "Upscale", "View"],
    priceLevel: "$$$",
    city: "Cairo",
    neighborhood: "Zamalek",
    lat: 30.0805,
    lng: 31.2210,
    tips: [
      { text: "Reserve a riverside table at least a day ahead.", order: 0 },
      { text: "Their seafood mezze platter is the move.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=1200",
    ],
  },
  {
    title: "Cairo Jazz Club",
    description:
      "Long-running live music venue in Agouza featuring jazz, oriental fusion, and indie Egyptian acts.",
    category: "Nightlife",
    moods: ["Lively", "Music", "Local"],
    priceLevel: "$$",
    city: "Cairo",
    neighborhood: "Agouza",
    lat: 30.0566,
    lng: 31.2122,
    tips: [
      { text: "Check the gig calendar — Thursday nights are the strongest.", order: 0 },
      { text: "Dress code is smart-casual at the door.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=1200",
    ],
  },
  {
    title: "Library of Alexandria",
    description:
      "Striking modern revival of the ancient library, with cascading reading halls and a planetarium next door.",
    category: "Landmark",
    moods: ["Cultural", "Architectural", "Educational"],
    priceLevel: "$",
    city: "Alexandria",
    neighborhood: "Corniche",
    lat: 31.2089,
    lng: 29.9092,
    tips: [
      { text: "Combine ticket with the antiquities museum inside.", order: 0 },
      { text: "Go on a weekday morning — calm and almost empty.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=1200",
    ],
    featured: true,
  },
  {
    title: "Mohamed Ahmed",
    description:
      "Alexandria's most famous ful & falafel spot. Tiny, crowded, and unbeatable for breakfast.",
    category: "Restaurant",
    moods: ["Local", "Casual", "Iconic"],
    priceLevel: "$",
    city: "Alexandria",
    neighborhood: "Downtown",
    lat: 31.1987,
    lng: 29.8987,
    tips: [
      { text: "Order ful with extra tahini and a side of pickles.", order: 0 },
      { text: "Cash only.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=1200",
    ],
  },
  {
    title: "Stanley Bridge",
    description:
      "Iconic Mediterranean bridge with whitewashed kiosks, perfect for a sunset corniche walk.",
    category: "Landmark",
    moods: ["Romantic", "View", "Relaxing"],
    priceLevel: "$",
    city: "Alexandria",
    neighborhood: "Stanley",
    lat: 31.2400,
    lng: 29.9628,
    tips: [
      { text: "Sunset around 6pm in summer is golden.", order: 0 },
      { text: "Grab a fresh juice from one of the corniche kiosks.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=1200",
    ],
  },
  {
    title: "Dahab Blue Hole",
    description:
      "World-famous freediving and snorkelling site — dramatic coral wall plunging into deep blue.",
    category: "Outdoor",
    moods: ["Adventure", "Nature", "Peaceful"],
    priceLevel: "$$",
    city: "Dahab",
    neighborhood: "Blue Hole",
    lat: 28.5728,
    lng: 34.5378,
    tips: [
      { text: "Snorkel only — leave the deep dives to certified pros.", order: 0 },
      { text: "Beachside Bedouin cafes serve killer fresh seafood.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1519046904884-53103b34b206?w=1200",
    ],
    featured: true,
  },
  {
    title: "Karnak Temple",
    description:
      "Vast open-air temple complex of obelisks, hypostyle halls, and the awe-inspiring Avenue of Sphinxes.",
    category: "Landmark",
    moods: ["Historic", "Awe", "Cultural"],
    priceLevel: "$$",
    city: "Luxor",
    neighborhood: "East Bank",
    lat: 25.7188,
    lng: 32.6573,
    tips: [
      { text: "The sound & light show after dark is genuinely magical.", order: 0 },
      { text: "Bring water — there's no shade in the inner courts.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=1200",
    ],
  },
  {
    title: "Valley of the Kings",
    description:
      "Royal burial ground with painted tombs of pharaohs including Ramesses VI and Tutankhamun.",
    category: "Landmark",
    moods: ["Historic", "Awe", "Educational"],
    priceLevel: "$$",
    city: "Luxor",
    neighborhood: "West Bank",
    lat: 25.7402,
    lng: 32.6014,
    tips: [
      { text: "The Tutankhamun tomb is a separate ticket — worth it.", order: 0 },
      { text: "Visit before 10am to avoid the heat.", order: 1 },
      { text: "Photography inside tombs requires an extra permit.", order: 2 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1572252009286-268acec5ca0a?w=1200",
    ],
    featured: true,
  },
  {
    title: "Abu Simbel",
    description:
      "Ramesses II's colossal twin temples carved into a Nubian cliff — relocated stone-by-stone in the 1960s.",
    category: "Landmark",
    moods: ["Iconic", "Historic", "Awe"],
    priceLevel: "$$$",
    city: "Aswan",
    neighborhood: "Abu Simbel",
    lat: 22.3372,
    lng: 31.6258,
    tips: [
      { text: "Sunrise convoys leave Aswan around 4am — book a tour.", order: 0 },
      { text: "Twice a year (Feb/Oct) the sun aligns to light the inner sanctum.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1568322445389-f64ac2515020?w=1200",
    ],
  },
  {
    title: "Nubian Village",
    description:
      "Colorful Aswan riverside village reachable by felucca, with henna artists and Nubian home restaurants.",
    category: "Cultural",
    moods: ["Local", "Cultural", "Photogenic"],
    priceLevel: "$",
    city: "Aswan",
    neighborhood: "Gharb Soheil",
    lat: 24.0758,
    lng: 32.8843,
    tips: [
      { text: "Take a felucca across at sunset for the best views.", order: 0 },
      { text: "Lunch at a Nubian home is the highlight — book ahead.", order: 1 },
    ],
    mediaUrls: [
      "https://images.unsplash.com/photo-1552733407-5d5c46c3bb3b?w=1200",
    ],
  },
];

function geohashOf(lat: number, lng: number): string {
  // Simple geohash (precision 7) — sufficient for proximity queries.
  const chars = "0123456789bcdefghjkmnpqrstuvwxyz";
  let evenBit = true;
  let bit = 0;
  let ch = 0;
  let geohash = "";
  let latRange = [-90, 90];
  let lngRange = [-180, 180];
  while (geohash.length < 7) {
    if (evenBit) {
      const mid = (lngRange[0] + lngRange[1]) / 2;
      if (lng >= mid) {
        ch = (ch << 1) + 1;
        lngRange = [mid, lngRange[1]];
      } else {
        ch = ch << 1;
        lngRange = [lngRange[0], mid];
      }
    } else {
      const mid = (latRange[0] + latRange[1]) / 2;
      if (lat >= mid) {
        ch = (ch << 1) + 1;
        latRange = [mid, latRange[1]];
      } else {
        ch = ch << 1;
        latRange = [latRange[0], mid];
      }
    }
    evenBit = !evenBit;
    if (++bit === 5) {
      geohash += chars[ch];
      bit = 0;
      ch = 0;
    }
  }
  return geohash;
}

/**
 * One-shot seed: writes ~17 curated Egypt places.
 * Idempotent: skips inserts whose deterministic id already exists.
 * Auth: any signed-in user can call (run once and forget).
 */
export const seedEgyptPlaces = onCall(
  { region: "us-central1", enforceAppCheck: false },
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
      throw new HttpsError("unauthenticated", "Sign in required.");
    }

    const db = getFirestore();
    const ownerName = "LikeALocal Curator";

    let inserted = 0;
    let skipped = 0;
    const batch = db.batch();

    for (const p of EGYPT_PLACES) {
      const id =
        "eg_" +
        p.title
          .toLowerCase()
          .replace(/[^a-z0-9]+/g, "_")
          .replace(/^_|_$/g, "");
      const ref = db.collection("places").doc(id);
      const snap = await ref.get();
      if (snap.exists) {
        skipped++;
        continue;
      }
      batch.set(ref, {
        id,
        title: p.title,
        description: p.description,
        category: p.category,
        moods: p.moods,
        priceLevel: p.priceLevel,
        city: p.city,
        neighborhood: p.neighborhood,
        lat: p.lat,
        lng: p.lng,
        location: { lat: p.lat, lng: p.lng },
        geohash: geohashOf(p.lat, p.lng),
        tips: p.tips,
        mediaUrls: p.mediaUrls,
        ownerUid: uid,
        ownerDisplayName: ownerName,
        ownerIsSuper: true,
        ratingAvg: 4.6,
        ratingCount: 0,
        saveCount: 0,
        featured: p.featured ?? false,
        hidden: false,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
      inserted++;
    }

    if (inserted > 0) await batch.commit();
    logger.info(`seedEgyptPlaces: inserted=${inserted} skipped=${skipped}`);
    return { inserted, skipped, total: EGYPT_PLACES.length };
  }
);
