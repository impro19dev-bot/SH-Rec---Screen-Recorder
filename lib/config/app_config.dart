/// App identity and store links.
abstract final class AppConfig {
  static const String appDisplayName = 'SH Shield';
  static const String appName = 'SH Shield';
  static const String splashName = 'SH Shield';
  static const String splashSubtitle = 'Hide info before you share';
  static const String appTagline = 'Scan. Hide. Share safely.';

  static const String appStoreSubtitle = 'Hide emails & info before sharing';

  static const String packageName = 'com.azrecorder.screenrecording';
  static const String broadcastExtensionBundleId =
      'com.azrecorder.screenrecording.BroadcastPlugun';
  static const String broadcastSetupUiBundleId =
      'com.azrecorder.screenrecording.BroadcastUploadExSetupUI';
  static const String appGroupId =
      'group.com.azrecorder.screenrecorder.sharedPreferences';

  /// Must be publicly readable (no login wall) before App Review.
  static const String privacyPolicyUrl =
      'https://sites.google.com/view/sh-rec---screen-recorder/home';

  static const String supportUrl =
      'https://sites.google.com/view/sh-rec---screen-recorder1/home';

  static const String supportEmail = 'impro19dev@gmail.com';

  static String get supportEmailUrl => 'mailto:$supportEmail';

  static const String? appStoreId = null;

  static bool get showRateApp => appStoreId != null && appStoreId!.isNotEmpty;

  static String? get appStoreReviewUrl => showRateApp
      ? 'https://apps.apple.com/app/id$appStoreId?action=write-review'
      : null;

  static const String appVersion = '1.1.0';
}
