import 'package:flutter/material.dart';

enum RecordingPreset {
  support,
  tutorial,
  personal,
  standard,
}

extension RecordingPresetDetails on RecordingPreset {
  String get label => switch (this) {
        RecordingPreset.support => 'Support',
        RecordingPreset.tutorial => 'Tutorial',
        RecordingPreset.personal => 'Chats',
        RecordingPreset.standard => 'General',
      };

  String get hint => switch (this) {
        RecordingPreset.support =>
          'Bug reports — hide emails and account info before sharing',
        RecordingPreset.tutorial =>
          'Guides — scan for notifications after capture',
        RecordingPreset.personal =>
          'Messages — blur names and numbers in Shield Studio',
        RecordingPreset.standard =>
          'Capture a clip, then hide sensitive info before sharing',
      };

  IconData get icon => switch (this) {
        RecordingPreset.support => Icons.support_agent_outlined,
        RecordingPreset.tutorial => Icons.school_outlined,
        RecordingPreset.personal => Icons.lock_person_outlined,
        RecordingPreset.standard => Icons.visibility_off_outlined,
      };
}
