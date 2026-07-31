# SH Rec — App Store submission

## Bundle IDs

| Target | Bundle ID |
|--------|-----------|
| App | `com.azrecorder.screenrecording` |
| Broadcast | `com.azrecorder.screenrec.BroadcastExtension` |
| Setup UI | `com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI` |

App Group (all three): `group.com.azrecorder.screenrecorder.sharedPreferences`

Set your Development Team in Xcode before archiving.

---

## Listing

**Name:** SH Rec - Screen Recorder  
**Subtitle:** Blur & scan before you share  

**Promotional text:**
```
Record your screen, scan for emails and phones, blur sensitive spots, and export a safe copy on your iPhone. No account. No cloud. No ads.
```

**Description:**
```
SH Rec is a screen recorder with a built-in privacy workflow. Capture your screen, then use Shield Studio to review and redact sensitive information before you share — all on your device.

FEATURES
• Full-device recording with Apple’s broadcast picker
• Optional microphone audio
• Shield Studio — on-device OCR for emails and phone numbers
• Privacy Score before you share
• Manual blur regions and safe export to Photos
• Safe Share confirmation
• Clips library with search and sort

PRIVATE BY DESIGN
• No account
• No cloud upload of your videos
• No ads
• Processing stays on your iPhone

Note: Screen recording requires a physical iPhone.
```

**Keywords:**
```
screen record,privacy,redact,OCR,tutorial,video,capture,export,blur,mic
```

---

## Review notes

```
SH Rec includes Shield Studio for on-device privacy review before sharing.

Test path:
1. Complete onboarding.
2. Allow Photos on Home if asked.
3. Capture → Start Recording → Apple broadcast picker (device required).
4. Clips → open a recording → Shield Studio → Scan → blur → Safe Export → Safe Share.

No tracking. App Privacy: Data Not Collected. No ATT prompt.
```

---

## Checklist

- [ ] Public privacy + support pages (no login wall)
  - Privacy: `https://sites.google.com/view/sh-rec---screen-recorder/home`
  - Support: `https://sites.google.com/view/sh-rec---screen-recorder1/home`
  - Email: `impro19dev@gmail.com`
- [ ] App Privacy in ASC: Data Not Collected / Tracking = No
- [ ] App IDs + App Group registered
- [ ] Xcode Team selected for Runner + extensions
- [ ] Physical iPhone test of record → Shield → export
- [ ] Screenshots lead with Shield Studio, not only the record button
- [ ] Build: `1.0.0+1` (bump `pubspec.yaml` for each upload)
