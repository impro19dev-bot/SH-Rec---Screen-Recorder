#!/usr/bin/env bash
# Codemagic `xcode-project use-profiles` rewrites extension paths to bundle-id
# folder names that do not exist. Restore real source/entitlements paths only.
set -euo pipefail

PBXPROJ="${1:-ios/Runner.xcodeproj/project.pbxproj}"

if [[ ! -f "$PBXPROJ" ]]; then
  echo "Missing $PBXPROJ" >&2
  exit 1
fi

python3 - "$PBXPROJ" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()

replacements = [
    (
        "com.azrecorder.screenrecording.com.azrecorder.screenrec.BroadcastExtension",
        "com.azrecorder.screenrec.BroadcastExtension",
    ),
    (
        "com.azrecorder.screenrecording.com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI",
        "com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI",
    ),
    (
        "com.azrecorder.screenrecording.com.azrecorder.screenrec.BroadcastExtensionSetupUI",
        "com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI",
    ),
    (
        "PRODUCT_BUNDLE_IDENTIFIER = com.azrecorder.screenrec.BroadcastExtensionSetupUI;",
        "PRODUCT_BUNDLE_IDENTIFIER = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI;",
    ),
    (
        "com.azrecorder.screenrec.BroadcastExtension/com.azrecorder.screenrec.BroadcastExtensionDebug.entitlements",
        "BroadcastUploadExtension/BroadcastUploadExtensionDebug.entitlements",
    ),
    (
        "com.azrecorder.screenrec.BroadcastExtension/com.azrecorder.screenrec.BroadcastExtension.entitlements",
        "BroadcastUploadExtension/BroadcastUploadExtension.entitlements",
    ),
    (
        "com.azrecorder.screenrec.BroadcastExtensionSetupUI/com.azrecorder.screenrec.BroadcastExtensionSetupUI.entitlements",
        "BroadcastUploadExtensionSetupUI/BroadcastUploadExtensionSetupUI.entitlements",
    ),
    (
        "com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI/com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI.entitlements",
        "BroadcastUploadExtensionSetupUI/BroadcastUploadExtensionSetupUI.entitlements",
    ),
    (
        "INFOPLIST_FILE = com.azrecorder.screenrec.BroadcastExtension/Info.plist",
        "INFOPLIST_FILE = BroadcastUploadExtension/Info.plist",
    ),
    (
        "INFOPLIST_FILE = com.azrecorder.screenrec.BroadcastExtensionSetupUI/Info.plist",
        "INFOPLIST_FILE = BroadcastUploadExtensionSetupUI/Info.plist",
    ),
    (
        "INFOPLIST_FILE = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI/Info.plist",
        "INFOPLIST_FILE = BroadcastUploadExtensionSetupUI/Info.plist",
    ),
    (
        "path = com.azrecorder.screenrec.BroadcastExtension;",
        "path = BroadcastUploadExtension;",
    ),
    (
        "path = com.azrecorder.screenrec.BroadcastExtensionSetupUI;",
        "path = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI;",
        "path = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "path = com.azrecorder.screenrec.BroadcastExtension.appex",
        "path = BroadcastUploadExtension.appex",
    ),
    (
        "path = com.azrecorder.screenrec.BroadcastExtensionSetupUI.appex",
        "path = BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI.appex",
        "path = BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "name = com.azrecorder.screenrec.BroadcastExtension;",
        "name = BroadcastUploadExtension;",
    ),
    (
        "productName = com.azrecorder.screenrec.BroadcastExtension;",
        "productName = BroadcastUploadExtension;",
    ),
    (
        "remoteInfo = com.azrecorder.screenrec.BroadcastExtension;",
        "remoteInfo = BroadcastUploadExtension;",
    ),
    (
        "name = com.azrecorder.screenrec.BroadcastExtensionSetupUI;",
        "name = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "name = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI;",
        "name = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "productName = com.azrecorder.screenrec.BroadcastExtensionSetupUI;",
        "productName = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "productName = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI;",
        "productName = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "remoteInfo = com.azrecorder.screenrec.BroadcastExtensionSetupUI;",
        "remoteInfo = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "remoteInfo = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI;",
        "remoteInfo = BroadcastUploadExtensionSetupUI;",
    ),
    (
        'PBXNativeTarget "com.azrecorder.screenrec.BroadcastExtension"',
        'PBXNativeTarget "BroadcastUploadExtension"',
    ),
    (
        'PBXNativeTarget "com.azrecorder.screenrec.BroadcastExtensionSetupUI"',
        'PBXNativeTarget "BroadcastUploadExtensionSetupUI"',
    ),
    (
        'PBXNativeTarget "com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI"',
        'PBXNativeTarget "BroadcastUploadExtensionSetupUI"',
    ),
    (
        "/* com.azrecorder.screenrec.BroadcastExtension.appex",
        "/* BroadcastUploadExtension.appex",
    ),
    (
        "/* com.azrecorder.screenrec.BroadcastExtensionSetupUI.appex",
        "/* BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "/* com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI.appex",
        "/* BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "/* com.azrecorder.screenrec.BroadcastExtension */",
        "/* BroadcastUploadExtension */",
    ),
    (
        "/* com.azrecorder.screenrec.BroadcastExtensionSetupUI */",
        "/* BroadcastUploadExtensionSetupUI */",
    ),
    (
        "/* com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI */",
        "/* BroadcastUploadExtensionSetupUI */",
    ),
]

for old, new in replacements:
    text = text.replace(old, new)

path.write_text(text)
print(f"Patched extension paths in {path}")
PY

INFO_PLIST="ios/Runner/Info.plist"
if [[ -f "$INFO_PLIST" ]]; then
  /usr/libexec/PlistBuddy -c "Set :ReplayKitBroadcastExtensionBundleId com.azrecorder.screenrec.BroadcastExtension" "$INFO_PLIST" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Add :ReplayKitBroadcastExtensionBundleId string com.azrecorder.screenrec.BroadcastExtension" "$INFO_PLIST"
  echo "Set ReplayKitBroadcastExtensionBundleId in $INFO_PLIST"
fi
