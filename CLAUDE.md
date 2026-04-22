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
Colors from `lib/theme/tokens.dart` — Blue Gray palette (`c50`–`c900`), background `#F6F7F8`, accent terracotta `#C97B5C`. Fraunces serif for display/titles, Inter/system for body. Radii 12–22px for cards, 999 for pills. Terracotta is reserved for: CTAs, selected map pins, super-local badge, premium moments.

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
