# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # install dependencies
flutter analyze          # static analysis (enforced in CI)
flutter test             # run all unit/widget tests
flutter test test/path/to/test.dart  # run a single test file
flutter run              # run on connected device/emulator
flutter build apk        # build Android release
flutter build ios        # build iOS release
dart run build_runner build --delete-conflicting-outputs  # run code generation (freezed, riverpod_generator, json_serializable)
dart run build_runner watch  # watch mode for code gen during development
```

Cloud Functions (in `functions/`):
```bash
npm install              # install function deps
npm test                 # run function tests
npm run build            # compile TypeScript
firebase deploy --only functions  # deploy functions
firebase deploy --only firestore:rules,storage  # deploy rules
```

## Architecture

This is a **Flutter + Firebase** app with feature-first clean architecture.

### App state: Riverpod 2
All state lives in Riverpod providers. Use `@riverpod` annotations + code generation. Firestore streams are exposed as `StreamProvider`s; mutations are `Notifier`s. Every async provider returns `AsyncValue<T>` — screens must handle all three states (loading/error/data). Never use `setState` for business logic.

### Navigation: go_router with ShellRoute
`lib/router/app_router.dart` defines a `ShellRoute` for the 5-tab bottom nav (Discover / Search / Saved / Inbox / Profile). Each tab is a `StatefulShellBranch` with its own navigation stack. Auth guard in `lib/router/guards.dart` redirects unauthenticated users to `/auth`. Deep link scheme: `likealocal://`.

### Feature structure
Each feature under `lib/features/<name>/` has three layers:
- `data/` — Firebase repositories, DTOs, Firestore queries
- `domain/` — pure Dart entities (via `freezed`) + Riverpod providers
- `presentation/` — screens and feature-specific widgets

Shared/reusable widgets live in `lib/core/widgets/`. Never import a feature's internals from another feature — go through providers.

### Design system (matches design tokens exactly)
All visuals flow through two files: **`lib/theme/tokens.dart`** (raw values — `LALColors`, `LALSpacing`, `LALRadii`) and **`lib/theme/app_theme.dart`** (the `ThemeData` that wires those tokens into Material widgets — AppBar, buttons, inputs, chips, cards, bottom sheets, status-bar overlay).

Rules: never hardcode `Color(0xFF…)` outside `tokens.dart` (the documented exception is third-party brand color, e.g. Google sign-in arcs). Never construct a `TextStyle(...)` from scratch in feature code — use `LALTypography.*` or `Theme.of(context).textTheme.*`. Buttons, chips, inputs, app bars must inherit from the theme — only override via `style:` for one-off contextual tweaks.

Palette: Blue Gray (`c50`–`c900`), background `#F6F7F8`, accent terracotta `#C97B5C`. Fraunces serif for display/titles, Inter/system for body. Radii 12–22px for cards, 999 for pills. Terracotta is reserved for: CTAs, selected map pins, super-local badge, premium moments.

Status bar: handled globally by `AppBarTheme.systemOverlayStyle` plus a `SystemChrome.setSystemUIOverlayStyle` call in `main.dart`. Screens that build a custom header instead of an `AppBar` (e.g. `LALHeader`) wrap the header in `SafeArea(bottom: false)` so it never collides with the status bar.

### Firebase services in use
| Service | Purpose |
|---|---|
| Auth | Email/password (phase 1), Google Sign-In (phase 2) |
| Firestore | All persistent data; offline persistence enabled by default |
| Storage | Place photos/videos at `places/{placeId}/{mediaId}.ext` |
| Cloud Functions (TypeScript) | AI ranking, chat fan-out, super-local scoring, RevenueCat webhook |
| FCM | Push: chat, proximity alerts, badges |
| Remote Config | Feature flags (`free_pin_limit`, `ai_chat_gated`, etc.) |
| App Check | Abuse protection on Firestore + Functions |

### Key Firestore collections
`users/{uid}`, `places/{placeId}` (+ `media/` + `reviews/` subcollections), `saves/{uid}/pins/` + `collections/`, `chats/{threadId}/messages/`, `notifications/{uid}/items/`, `rankings/{uid}`, `reminders/{uid}/items/`.

### AI (Vertex AI Gemini via Cloud Function)
Feed ranking: callable `rankPlacesForUser` → writes `rankings/{uid}` (24h TTL). AI chat: callable `aiChat` streams Gemini response with user prefs + top saves injected as system context. Client falls back to heuristic ranking (proximity + rating + category) if AI fails.

### Payments
RevenueCat (`purchases_flutter`) for mobile IAP — one offering `premium` with monthly/annual packages. Feature gates read from `users/{uid}.entitlements.premium` (written only by the `onRevenueCatWebhook` Cloud Function — never trust client). On iOS, never show Stripe or external payment URLs.

### Localization
ARB files at `lib/l10n/app_en.arb` and `app_de.arb`. All user-facing strings must use `AppLocalizations.of(context)`. Category names and moods stored in Firestore as `{ en, de }` objects so they translate without a release.

### Offline
Firestore offline persistence is on by default. `cached_network_image` for photos. Hive CE (`lib/features/offline/`) for drafts, recent searches, and cached rankings. `connectivity_plus` drives the `OfflineBanner` widget shown app-wide.

### Code generation
Models use `freezed` + `json_serializable`. Providers use `riverpod_generator`. Always re-run `build_runner` after adding or modifying annotated classes. Generated output goes to `lib/gen/` — do not edit manually.

## Delivery phases

The implementation follows a phased plan:
- **Phase 0** (foundation): pubspec, theme tokens, go_router shell, l10n scaffold, empty feature modules
- **Phase 1** (MVP): Auth → Places model → Feed → Place Details → Add Place → Search → Map → Saved → Error states → Offline → i18n
- **Phase 2** (social): Reviews → Chat → Push notifications → Reminders → AI feed ranking
- **Phase 3** (monetization): Paywall → AI chat assistant → Super-local scoring → Premium offline

## Quality Gates

**Never declare a feature done until all of the following pass:**
1. `flutter analyze` exits with zero errors and zero warnings
2. `flutter test` passes (or new tests are added for the feature)
3. All user-facing strings have EN + DE ARB keys
4. No synchronous I/O or CPU work on the UI isolate
5. `dart run build_runner build --delete-conflicting-outputs` is up to date if annotated classes changed

## Firebase Deployment Rules

- After modifying **Cloud Functions** → run `firebase deploy --only functions` before testing
- After modifying **Firestore rules** → run `firebase deploy --only firestore:rules` and verify with a test read
- Adding **Google Sign-In** on a new device → remind user to register the SHA-1 debug/release fingerprint in Firebase console
- **App Check** is enabled — new dev environments need a debug token registered; missing tokens cause silent 403s
- **Cloud Run** endpoints require correct IAM permissions; verify before debugging client-side 4xx/5xx errors

## Public Android Distribution (Firebase Hosting)

The Android APK is distributed publicly via Firebase Hosting on the same project (`likealocal-c33e9`). No GitHub Releases, no Play Store.

| URL | What |
|---|---|
| `https://likealocal-c33e9.web.app` | Landing page + QR code + Download button |
| `https://likealocal-c33e9.web.app/app-release.apk` | The APK itself (forced download via `Content-Disposition`) |

**Hosting payload** lives in `public/`:
- `index.html` — hand-written single-file landing page using the design tokens (terracotta CTA, Fraunces headline). Do not replace with Flutter web output.
- `qr.png` — QR encoding the APK URL. Regenerate if the URL changes.
- `app-release.apk` — built artifact, copied in by hand before each deploy.

**Hosting config** is in `firebase.json` under the `hosting` block — sets `application/vnd.android.package-archive` content type and `attachment; filename="like-a-local.apk"` disposition so browsers download instead of preview.

### Updating the public build

```powershell
flutter pub get
flutter analyze                                  # must exit clean
flutter build apk --release
Copy-Item build\app\outputs\flutter-apk\app-release.apk public\app-release.apk -Force
firebase deploy --only hosting --project likealocal-c33e9
```

Never deploy other targets in the same command — `firebase deploy` without `--only hosting` also pushes functions/firestore/storage.

### Build-config caveats (don't break these without thinking)

- **R8/minification is disabled** for `release` in `android/app/build.gradle.kts` (`isMinifyEnabled = false`, `isShrinkResources = false`). Stripe's React Native push-provisioning classes are referenced but not present, so R8 fails with `Missing class com.stripe.android.pushProvisioning.*`. To re-enable shrinking, add ProGuard `-dontwarn com.stripe.android.pushProvisioning.**` plus keep rules for any other reflective consumers (Firebase, Riverpod-gen, freezed) and verify in a clean build before merging.
- **Signing**: release uses the debug keystore by design (`signingConfig = signingConfigs.getByName("debug")`). Anyone rebuilding with the standard Android debug key can produce a bit-for-bit-compatible signature — this is *not* a security boundary. Replace with a real keystore before any Play Store work.
- **applicationId is still `com.example.like_a_local`** — fine for sideload, blocks Play Store publication.
- **App Check** on sideloaded APK: if Firestore reads silently fail on a new device after install, register the debug-keystore SHA-256 in Firebase Console → App Check → Android → Manage debug tokens. Get the fingerprint with `keytool -list -v -keystore $env:USERPROFILE\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android`.

### Updating the landing page or QR

- Edit `public/index.html` directly. Keep it a single self-contained file using inline CSS and the design tokens (background `#F6F7F8`, terracotta `#C97B5C`, Fraunces serif via Google Fonts CDN).
- If the APK URL ever changes, regenerate the QR: `npx qrcode -o public/qr.png -t png -w 600 -e H "<new-url>"`.

## Common Pitfalls (Do Not Repeat)

- UI freeze from sync I/O → always use `async`/`await` or isolates for file/hash/image work
- `DEVELOPER_ERROR` on Google Sign-In → SHA-1 not registered in Firebase console
- Firestore permission denied → rules not redeployed after change
- Chat button stays in broken state across sessions → check Firestore rule + document existence + UI state all together
- Push notifications not received → FCM token not refreshed / Cloud Function not redeployed
