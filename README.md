# SH Rec - Screen Recorder

Screen recorder with on-device privacy tools for iOS and Android.

Record locally, then use Shield Studio to scan for sensitive text, blur regions, and export a safe copy before sharing.

## Features

- Full-device recording (ReplayKit) with optional mic
- Clips library with search and sort
- Shield Studio — OCR scan, Privacy Score, blur, safe export
- Safe Share confirmation
- No ads · No account · No cloud upload of videos

## Identifiers

- Bundle ID: `com.azrecorder.screenrecorderr`
- App Group: `group.com.azrecorder.screenrecorder.shared`

See [docs/app_store_submission.md](docs/app_store_submission.md) for App Store copy and checklist.

## Develop

```bash
flutter pub get
flutter run
```

Full-device recording needs a physical iPhone.
