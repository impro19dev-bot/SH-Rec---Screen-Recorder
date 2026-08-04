# SH Shield — App Store submission

## Bundle IDs

| Target | Bundle ID |
|--------|-----------|
| App | `com.azrecorder.screenrecording` |
| Broadcast | `com.azrecorder.screenrecording.BroadcastPlugun` |
| Setup UI | `com.azrecorder.screenrecording.BroadcastUploadExSetupUI` |

App Group (all three): `group.com.azrecorder.screenrecorder.sharedPreferences`

Set your Development Team in Xcode before archiving.

---

## Listing (privacy-first positioning)

**Name:** SH Shield  
**Subtitle:** Hide emails & info before sharing  

**Promotional text:**
```
Scan screen clips for emails and phone numbers, blur sensitive spots, and share a safer copy — on your iPhone. Capture is optional. No account. No cloud. No ads.
```

**Description:**
```
SH Shield helps you hide sensitive information in screen clips before you share — emails, phone numbers, and personal UI. Capture is optional; the core product is on-device review and redaction.

WHAT MAKES SH SHIELD DIFFERENT
• Protect / Hide Info workspace for any Photos video
• On-device OCR scan for emails and phone numbers
• Privacy Score before you share
• Tap a finding to place blur and jump to that moment
• Manual blur regions and safe export to Photos
• Share-protected confirmation flow
• Needs-review queue so unprotected clips are obvious

OPTIONAL CAPTURE
• Create a new clip with Apple’s broadcast picker when you need one
• Then hide sensitive info before sharing

PRIVATE BY DESIGN
• No account
• No cloud upload of your videos
• No ads
• Processing stays on your iPhone

Note: Full-device capture requires a physical iPhone.
```

**Keywords:**
```
redact,privacy,blur,hide info,OCR,safe share,screen clip,protect,email,phone
```

---

## Review notes (4.3 differentiation)

```
PRIMARY PURPOSE: On-device privacy / redact-before-share utility.
Screen capture is an optional way to create a clip to protect — not the main product.

Unique flow for App Review:
1. Open SH Shield → Home shows Needs Review / Hide info (not a giant record button).
2. Protect → “Protect a clip from Photos” (or capture optionally).
3. Hide Info → Scan → tap a finding to place blur → Safe export → Share protected.
4. Library shows privacy status (Needs review / Info hidden / Safe to share).

No login. No tracking. App Privacy: Data Not Collected.
```

---

## Checklist

- [ ] Public privacy + support pages (no login wall)
  - Privacy: `https://sites.google.com/view/sh-rec---screen-recorder/home`
  - Support: `https://sites.google.com/view/sh-rec---screen-recorder1/home`
  - Email: `impro19dev@gmail.com`
- [ ] App Privacy in ASC: Data Not Collected / Tracking = No
- [ ] Screenshots lead with Hide Info / Privacy Score / blur — not Capture
- [ ] Name = SH Shield; subtitle emphasizes hide/redact, not “Screen Recorder”
- [ ] Physical iPhone test: import clip → scan → blur → export → share
- [ ] Bump `pubspec.yaml` version for each upload
