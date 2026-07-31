/// App identity and store links.
abstract final class AppConfig {
  static const String appDisplayName = 'SH Rec - Screen Recorder';
  static const String appName = 'SH Rec';
  static const String splashName = 'SH Rec';
  static const String splashSubtitle = 'Screen Recorder';
  static const String appTagline = 'Record. Protect. Share safely.';

  static const String appStoreSubtitle = 'Blur & scan before you share';

  static const String packageName = 'com.azrecorder.screenrecording';
  static const String broadcastExtensionBundleId =
      'com.azrecorder.screenrecording.BroadcastExtension';
  static const String broadcastSetupUiBundleId =
      'com.azrecorder.screenrecording.BroadcastUploadExtensionSetupUI';
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

  static const String appVersion = '1.0.0';
}
