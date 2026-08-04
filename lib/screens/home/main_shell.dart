import 'package:flutter/material.dart';

import '../../widgets/vault_bottom_nav.dart';
import '../privacy/privacy_screen.dart';
import '../record/record_screen.dart';
import '../settings/settings_screen.dart';
import '../videos/videos_screen.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  AppTab _currentTab = AppTab.home;
  final GlobalKey<VideosScreenState> _videosKey = GlobalKey<VideosScreenState>();
  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();
  final GlobalKey<PrivacyScreenState> _protectKey =
      GlobalKey<PrivacyScreenState>();

  void _refreshVideos() {
    _videosKey.currentState?.reloadVideos();
    _homeKey.currentState?.reload();
    _protectKey.currentState?.reload();
  }

  void _selectTab(AppTab tab) {
    if (tab == _currentTab) return;
    setState(() => _currentTab = tab);
    if (tab == AppTab.library) {
      _videosKey.currentState?.reloadVideos(requestPermission: true);
    }
    if (tab == AppTab.protect) {
      _protectKey.currentState?.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab.index,
        children: [
          HomeScreen(
            key: _homeKey,
            onGoToCapture: () => _selectTab(AppTab.capture),
            onGoToLibrary: () => _selectTab(AppTab.library),
            onGoToProtect: () => _selectTab(AppTab.protect),
          ),
          VideosScreen(key: _videosKey),
          PrivacyScreen(key: _protectKey),
          RecordScreen(
            onRecordingSaved: _refreshVideos,
            isTabActive: _currentTab == AppTab.capture,
          ),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: VaultBottomNav(
        currentTab: _currentTab,
        onTabSelected: _selectTab,
      ),
    );
  }
}
