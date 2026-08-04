/// Shared capture instructions (Settings help, Capture tab copy).
abstract final class RecordingHelpContent {
  static const String iosSteps =
      '• Capture opens Apple’s broadcast picker so you can create a clip to protect.\n\n'
      '• Turn Microphone ON in Apple’s broadcast sheet for audio.\n\n'
      '• Stop using the red status bar or Control Center.\n\n'
      '• Reopen SH Shield, then hide sensitive info in Protect before sharing.';

  static const String iosHowToStart =
      'Tap Capture clip to open Apple’s broadcast picker. Turn Microphone ON for audio. '
      'After you stop, reopen SH Shield and use Protect to scan and hide sensitive info.';

  static const String iosHowToStop =
      'While broadcasting, stop using the red status bar or Screen Broadcast in Control Center. '
      'Then reopen SH Shield to import the clip and protect it before sharing.';

  static const String simulatorNote =
      'The iOS Simulator cannot access ReplayKit. Install on a physical iPhone to capture a clip.';
}
