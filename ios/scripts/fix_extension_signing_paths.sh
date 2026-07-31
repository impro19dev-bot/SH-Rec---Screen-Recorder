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
        "com.azrecorder.screenrecording.com.azrecorder.screenrecording.BroadcastExtension",
        "com.azrecorder.screenrecording.BroadcastExtension",
    ),
    (
        "com.azrecorder.screenrecording.com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI",
        "com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI",
    ),
    (
        "com.azrecorder.screenrecording.com.azrecorder.screenrecording.BroadcastExtensionSetupUI",
        "com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI",
    ),
    (
        "PRODUCT_BUNDLE_IDENTIFIER = com.azrecorder.screenrecording.BroadcastExtensionSetupUI;",
        "PRODUCT_BUNDLE_IDENTIFIER = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI;",
    ),
    (
        "com.azrecorder.screenrecording.BroadcastExtension/com.azrecorder.screenrecording.BroadcastExtensionDebug.entitlements",
        "BroadcastUploadExtension/BroadcastUploadExtensionDebug.entitlements",
    ),
    (
        "com.azrecorder.screenrecording.BroadcastExtension/com.azrecorder.screenrecording.BroadcastExtension.entitlements",
        "BroadcastUploadExtension/BroadcastUploadExtension.entitlements",
    ),
    (
        "com.azrecorder.screenrecording.BroadcastExtensionSetupUI/com.azrecorder.screenrecording.BroadcastExtensionSetupUI.entitlements",
        "BroadcastUploadExtensionSetupUI/BroadcastUploadExtensionSetupUI.entitlements",
    ),
    (
        "com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI/com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI.entitlements",
        "BroadcastUploadExtensionSetupUI/BroadcastUploadExtensionSetupUI.entitlements",
    ),
    (
        "INFOPLIST_FILE = com.azrecorder.screenrecording.BroadcastExtension/Info.plist",
        "INFOPLIST_FILE = BroadcastUploadExtension/Info.plist",
    ),
    (
        "INFOPLIST_FILE = com.azrecorder.screenrecording.BroadcastExtensionSetupUI/Info.plist",
        "INFOPLIST_FILE = BroadcastUploadExtensionSetupUI/Info.plist",
    ),
    (
        "INFOPLIST_FILE = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI/Info.plist",
        "INFOPLIST_FILE = BroadcastUploadExtensionSetupUI/Info.plist",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastExtension;",
        "path = BroadcastUploadExtension;",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastExtensionSetupUI;",
        "path = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI;",
        "path = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastExtension.appex",
        "path = BroadcastUploadExtension.appex",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastExtensionSetupUI.appex",
        "path = BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI.appex",
        "path = BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "name = com.azrecorder.screenrecording.BroadcastExtension;",
        "name = BroadcastUploadExtension;",
    ),
    (
        "productName = com.azrecorder.screenrecording.BroadcastExtension;",
        "productName = BroadcastUploadExtension;",
    ),
    (
        "remoteInfo = com.azrecorder.screenrecording.BroadcastExtension;",
        "remoteInfo = BroadcastUploadExtension;",
    ),
    (
        "name = com.azrecorder.screenrecording.BroadcastExtensionSetupUI;",
        "name = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "name = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI;",
        "name = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "productName = com.azrecorder.screenrecording.BroadcastExtensionSetupUI;",
        "productName = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "productName = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI;",
        "productName = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "remoteInfo = com.azrecorder.screenrecording.BroadcastExtensionSetupUI;",
        "remoteInfo = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "remoteInfo = com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI;",
        "remoteInfo = BroadcastUploadExtensionSetupUI;",
    ),
    (
        'PBXNativeTarget "com.azrecorder.screenrecording.BroadcastExtension"',
        'PBXNativeTarget "BroadcastUploadExtension"',
    ),
    (
        'PBXNativeTarget "com.azrecorder.screenrecording.BroadcastExtensionSetupUI"',
        'PBXNativeTarget "BroadcastUploadExtensionSetupUI"',
    ),
    (
        'PBXNativeTarget "com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI"',
        'PBXNativeTarget "BroadcastUploadExtensionSetupUI"',
    ),
    (
        "/* com.azrecorder.screenrecording.BroadcastExtension.appex",
        "/* BroadcastUploadExtension.appex",
    ),
    (
        "/* com.azrecorder.screenrecording.BroadcastExtensionSetupUI.appex",
        "/* BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "/* com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI.appex",
        "/* BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "/* com.azrecorder.screenrecording.BroadcastExtension */",
        "/* BroadcastUploadExtension */",
    ),
    (
        "/* com.azrecorder.screenrecording.BroadcastExtensionSetupUI */",
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
  /usr/libexec/PlistBuddy -c "Set :ReplayKitBroadcastExtensionBundleId com.azrecorder.screenrecording.BroadcastExtension" "$INFO_PLIST" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Add :ReplayKitBroadcastExtensionBundleId string com.azrecorder.screenrecording.BroadcastExtension" "$INFO_PLIST"
  echo "Set ReplayKitBroadcastExtensionBundleId in $INFO_PLIST"
fi
