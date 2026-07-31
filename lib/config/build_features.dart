/// Compile-time flags for developer-only UI.
class BuildFeatures {
  BuildFeatures._();

  /// Broadcast audio debug panel — kept off for store builds and normal use.
  static bool get showBroadcastAudioDebugTools => false;
}
