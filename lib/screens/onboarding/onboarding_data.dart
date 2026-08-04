import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.features,
    required this.icon,
    required this.colors,
    required this.accentColor,
  });

  final String title;
  final String description;
  final List<String> features;
  final IconData icon;
  final List<Color> colors;
  final Color accentColor;
}

const onboardingPages = [
  OnboardingPageData(
    title: 'Hide info before you share',
    description:
        'SH Shield helps you find and cover sensitive details in screen clips — '
        'emails, phone numbers, and personal UI — before anyone else sees them.',
    features: [
      'On-device privacy scan',
      'Blur sensitive spots',
      'No account · No cloud upload',
    ],
    icon: Icons.visibility_off_outlined,
    colors: [Color(0xFFFF8A65), Color(0xFFFF5722)],
    accentColor: AppColors.primaryOrange,
  ),
  OnboardingPageData(
    title: 'Protect with Shield Studio',
    description:
        'Scan clips for emails and phone numbers, check your Privacy Score, '
        'add blur regions, and export a safer copy — all on your device.',
    features: [
      'Privacy Score',
      'Tap findings to place blur',
      'Safe export before sharing',
    ],
    icon: Icons.verified_user_outlined,
    colors: [Color(0xFFFFAB91), Color(0xFFFF7043)],
    accentColor: AppColors.primaryOrangeLight,
  ),
  OnboardingPageData(
    title: 'Capture only when you need a clip',
    description:
        'Recording is optional. Import any video from Photos to protect, '
        'or capture a new clip and hide sensitive info before you share.',
    features: [
      'Protect clips from Photos',
      'Optional screen capture',
      'Share only when ready',
    ],
    icon: Icons.shield_outlined,
    colors: [Color(0xFFFFB74D), Color(0xFFF57C00)],
    accentColor: AppColors.splashOrange,
  ),
];
