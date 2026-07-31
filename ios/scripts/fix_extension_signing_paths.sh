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
        "com.azrecorder.screenrecording.com.azrecorder.screenrecording.BroadcastPlugun",
        "com.azrecorder.screenrecording.BroadcastPlugun",
    ),
    (
        "com.azrecorder.screenrecording.com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI",
        "com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI",
    ),
    (
        "com.azrecorder.screenrecording.com.azrecorder.screenrecording.BroadcastPlugunSetupUI",
        "com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI",
    ),
    (
        "PRODUCT_BUNDLE_IDENTIFIER = com.azrecorder.screenrecording.BroadcastPlugunSetupUI;",
        "PRODUCT_BUNDLE_IDENTIFIER = com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI;",
    ),
    (
        "com.azrecorder.screenrecording.BroadcastPlugun/com.azrecorder.screenrecording.BroadcastPlugunDebug.entitlements",
        "BroadcastUploadExtension/BroadcastUploadExtensionDebug.entitlements",
    ),
    (
        "com.azrecorder.screenrecording.BroadcastPlugun/com.azrecorder.screenrecording.BroadcastPlugun.entitlements",
        "BroadcastUploadExtension/BroadcastUploadExtension.entitlements",
    ),
    (
        "com.azrecorder.screenrecording.BroadcastPlugunSetupUI/com.azrecorder.screenrecording.BroadcastPlugunSetupUI.entitlements",
        "BroadcastUploadExtensionSetupUI/BroadcastUploadExtensionSetupUI.entitlements",
    ),
    (
        "com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI/com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI.entitlements",
        "BroadcastUploadExtensionSetupUI/BroadcastUploadExtensionSetupUI.entitlements",
    ),
    (
        "INFOPLIST_FILE = com.azrecorder.screenrecording.BroadcastPlugun/Info.plist",
        "INFOPLIST_FILE = BroadcastUploadExtension/Info.plist",
    ),
    (
        "INFOPLIST_FILE = com.azrecorder.screenrecording.BroadcastPlugunSetupUI/Info.plist",
        "INFOPLIST_FILE = BroadcastUploadExtensionSetupUI/Info.plist",
    ),
    (
        "INFOPLIST_FILE = com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI/Info.plist",
        "INFOPLIST_FILE = BroadcastUploadExtensionSetupUI/Info.plist",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastPlugun;",
        "path = BroadcastUploadExtension;",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastPlugunSetupUI;",
        "path = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "path = com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI;",
        "path = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastPlugun.appex",
        "path = BroadcastUploadExtension.appex",
    ),
    (
        "path = com.azrecorder.screenrecording.BroadcastPlugunSetupUI.appex",
        "path = BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "path = com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI.appex",
        "path = BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "name = com.azrecorder.screenrecording.BroadcastPlugun;",
        "name = BroadcastUploadExtension;",
    ),
    (
        "productName = com.azrecorder.screenrecording.BroadcastPlugun;",
        "productName = BroadcastUploadExtension;",
    ),
    (
        "remoteInfo = com.azrecorder.screenrecording.BroadcastPlugun;",
        "remoteInfo = BroadcastUploadExtension;",
    ),
    (
        "name = com.azrecorder.screenrecording.BroadcastPlugunSetupUI;",
        "name = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "name = com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI;",
        "name = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "productName = com.azrecorder.screenrecording.BroadcastPlugunSetupUI;",
        "productName = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "productName = com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI;",
        "productName = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "remoteInfo = com.azrecorder.screenrecording.BroadcastPlugunSetupUI;",
        "remoteInfo = BroadcastUploadExtensionSetupUI;",
    ),
    (
        "remoteInfo = com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI;",
        "remoteInfo = BroadcastUploadExtensionSetupUI;",
    ),
    (
        'PBXNativeTarget "com.azrecorder.screenrecording.BroadcastPlugun"',
        'PBXNativeTarget "BroadcastUploadExtension"',
    ),
    (
        'PBXNativeTarget "com.azrecorder.screenrecording.BroadcastPlugunSetupUI"',
        'PBXNativeTarget "BroadcastUploadExtensionSetupUI"',
    ),
    (
        'PBXNativeTarget "com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI"',
        'PBXNativeTarget "BroadcastUploadExtensionSetupUI"',
    ),
    (
        "/* com.azrecorder.screenrecording.BroadcastPlugun.appex",
        "/* BroadcastUploadExtension.appex",
    ),
    (
        "/* com.azrecorder.screenrecording.BroadcastPlugunSetupUI.appex",
        "/* BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "/* com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI.appex",
        "/* BroadcastUploadExtensionSetupUI.appex",
    ),
    (
        "/* com.azrecorder.screenrecording.BroadcastPlugun */",
        "/* BroadcastUploadExtension */",
    ),
    (
        "/* com.azrecorder.screenrecording.BroadcastPlugunSetupUI */",
        "/* BroadcastUploadExtensionSetupUI */",
    ),
    (
        "/* com.azrecorder.screenrecordingg.BroadcastUploadExtensionSetupUI */",
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
  /usr/libexec/PlistBuddy -c "Set :ReplayKitBroadcastExtensionBundleId com.azrecorder.screenrecording.BroadcastPlugun" "$INFO_PLIST" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Add :ReplayKitBroadcastExtensionBundleId string com.azrecorder.screenrecording.BroadcastPlugun" "$INFO_PLIST"
  echo "Set ReplayKitBroadcastExtensionBundleId in $INFO_PLIST"
fi
