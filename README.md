# Like A Local

Flutter + Firebase app for discovering places the way locals actually live them.

## Live Distribution (Android)

- **Landing page**: https://likealocal-c33e9.web.app
- **Direct APK**: https://likealocal-c33e9.web.app/app-release.apk
- **QR code**: shown on the landing page (encodes the APK URL — scan with any Android camera)

The APK is a release build signed with the debug keystore — sideload only, not Play Store.

## Getting Started (Dev)

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

See [CLAUDE.md](CLAUDE.md) for architecture, design tokens, Firebase services, and the full quality-gate checklist.

## Updating the Public Build

Whenever you want to ship a new build to https://likealocal-c33e9.web.app:

```powershell
# 1. Rebuild
flutter pub get
flutter analyze                                # must exit clean (per CLAUDE.md gates)
flutter build apk --release                    # debug-keystore signed; R8 disabled

# 2. Copy artifact into the hosting payload
Copy-Item build\app\outputs\flutter-apk\app-release.apk public\app-release.apk -Force

# 3. Deploy hosting only (functions/firestore/storage untouched)
firebase deploy --only hosting --project likealocal-c33e9
```

If the APK download URL changes, regenerate the QR with:

```powershell
npx qrcode -o public/qr.png -t png -w 600 -e H "https://likealocal-c33e9.web.app/app-release.apk"
```

### One-time setup notes (already done, documented for the next environment)

- `firebase.json` has a `hosting` block pointing at `public/` with APK `Content-Type` + `Content-Disposition` headers.
- `android/app/build.gradle.kts` release block sets `isMinifyEnabled = false` / `isShrinkResources = false`. Required because R8 fails on Stripe `pushProvisioning` missing classes. Re-enable only after adding the proper ProGuard keep rules.
- App Check is enabled — sideloaded APKs need their debug-keystore SHA-256 registered in Firebase Console → App Check → Android → Manage debug tokens. Get the fingerprint with:
  ```powershell
  keytool -list -v -keystore $env:USERPROFILE\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
  ```

## Project Structure

See [CLAUDE.md](CLAUDE.md).
