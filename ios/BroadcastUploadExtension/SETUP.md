# BroadcastUploadExtension setup (SH Rec)

## Apple Developer portal

1. Create App ID: `com.azrecorder.screenrecording` (main app).
2. Create App ID: `com.azrecorder.screenrecording.BroadcastExtension`.
3. Create App ID: `com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI`.
4. Create App Group: `group.com.azrecorder.screenrecorder.sharedPreferences`.
5. Enable **App Groups** on all three App IDs and add the group above.
6. Select your **Team** in Xcode for Runner + both extension targets.

## Project defaults

- Main bundle ID: `com.azrecorder.screenrecording`
- Extension bundle ID: `com.azrecorder.screenrecording.BroadcastExtension`
- Flutter ↔ native channel: `azrecorder/replaykit`

> Apple requires extension bundle IDs to be prefixed with the parent app ID.
