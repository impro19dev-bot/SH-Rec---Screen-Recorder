import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../controllers/theme_controller.dart';
import '../../services/theme_preference_service.dart';
import '../../config/app_config.dart';
import '../../services/photos_permission_service.dart';
import '../../models/privacy_video_state.dart';
import '../../services/privacy_storage_service.dart';
import '../../services/video_library_service.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_design.dart';
import '../../theme/context_extensions.dart';
import '../../widgets/privacy_status_badge.dart';
import '../../widgets/vault_screen_header.dart';
import '../privacy/privacy_studio_screen.dart';
import '../privacy/protect_clip_picker_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onGoToCapture,
    required this.onGoToLibrary,
    required this.onGoToProtect,
  });

  final VoidCallback onGoToCapture;
  final VoidCallback onGoToLibrary;
  final VoidCallback onGoToProtect;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _storage = PrivacyStorageService.instance;
  final _library = VideoLibraryService();
  int _clipCount = 0;
  int _needsReview = 0;
  int _protected = 0;
  List<AssetEntity> _needsReviewClips = const [];
  Map<String, PrivacyVideoState> _states = {};
  bool _loading = false;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    setState(() => _loading = true);
    try {
      final granted = await PhotosPermissionService.requestAccess();
      if (!granted) {
        if (mounted) {
          setState(() {
            _permissionDenied = true;
            _clipCount = 0;
            _needsReview = 0;
            _protected = 0;
            _needsReviewClips = const [];
            _states = {};
            _loading = false;
          });
        }
        return;
      }

      final assets = await _library.loadVideos(size: 40);
      final states = await _storage.loadMany(assets.map((a) => a.id));
      if (!mounted) return;

      final reviewClips = <AssetEntity>[];
      var needsReview = 0;
      var protected = 0;
      for (final asset in assets) {
        final state = states[asset.id] ?? PrivacyVideoState.unreviewed(asset.id);
        if (state.needsReview) {
          needsReview++;
          if (reviewClips.length < 8) reviewClips.add(asset);
        }
        if (state.status == PrivacyClipStatus.protected ||
            state.status == PrivacyClipStatus.safeToShare) {
          protected++;
        }
      }

      setState(() {
        _permissionDenied = false;
        _clipCount = assets.length;
        _states = states;
        _needsReviewClips = reviewClips;
        _needsReview = needsReview;
        _protected = protected;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openStudio(AssetEntity video) {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => PrivacyStudioScreen(video: video),
          ),
        )
        .then((_) => reload());
  }

  void _openProtectPicker() {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => const ProtectClipPickerScreen(),
          ),
        )
        .then((_) => reload());
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final themeController = ThemeScope.of(context);

    return RefreshIndicator(
      onRefresh: reload,
      color: palette.accent,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: VaultScreenHeader(
              title: AppConfig.appName,
              subtitle: AppConfig.appTagline,
              trailing: [
                ListenableBuilder(
                  listenable: themeController,
                  builder: (context, _) {
                    final dark =
                        Theme.of(context).brightness == Brightness.dark;
                    return VaultIconAction(
                      icon: dark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      tooltip: dark ? 'Light mode' : 'Dark mode',
                      onPressed: () => themeController.setPreference(
                        dark
                            ? AppThemePreference.light
                            : AppThemePreference.dark,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            sliver: SliverToBoxAdapter(
              child: _HeroProtectCard(
                needsReview: _needsReview,
                loading: _loading,
                onProtect: widget.onGoToProtect,
                onImport: _openProtectPicker,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: _ModeCard(
                      title: 'Hide info',
                      subtitle: 'Scan & blur clips',
                      icon: Icons.visibility_off_outlined,
                      gradient: const [
                        AppColors.primaryOrange,
                        AppColors.splashOrange,
                      ],
                      onTap: widget.onGoToProtect,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ModeCard(
                      title: 'Capture',
                      subtitle: 'Optional — for new clips',
                      icon: Icons.videocam_outlined,
                      gradient: const [
                        Color(0xFFFF8A65),
                        AppColors.primaryOrangeLight,
                      ],
                      onTap: widget.onGoToCapture,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverToBoxAdapter(
              child: _StatsStrip(
                loading: _loading,
                clips: _clipCount,
                review: _needsReview,
                protected: _protected,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Text(
                    'NEEDS REVIEW',
                    style: AppDesign.sectionLabel(palette.textSecondary),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: widget.onGoToLibrary,
                    child: const Text('Library'),
                  ),
                ],
              ),
            ),
          ),
          if (_loading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_permissionDenied)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Text(
                      'Photos access is needed to review and protect your clips.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: palette.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: PhotoManager.openSetting,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
              ),
            )
          else if (_needsReviewClips.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 40,
                      color: palette.accent,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _clipCount == 0
                          ? 'Nothing to protect yet.\nImport a clip from Photos or capture a new one.'
                          : 'All recent clips look reviewed.\nImport another clip anytime.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: palette.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _openProtectPicker,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Protect a clip from Photos'),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final clip = _needsReviewClips[index];
                    final state = _states[clip.id] ??
                        PrivacyVideoState.unreviewed(clip.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _RecentRow(
                        title: clip.title ?? 'Clip',
                        duration: _formatDuration(clip.duration),
                        state: state,
                        onProtect: () => _openStudio(clip),
                      ),
                    );
                  },
                  childCount: _needsReviewClips.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _HeroProtectCard extends StatelessWidget {
  const _HeroProtectCard({
    required this.needsReview,
    required this.loading,
    required this.onProtect,
    required this.onImport,
  });

  final int needsReview;
  final bool loading;
  final VoidCallback onProtect;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final headline = loading
        ? 'Checking your clips…'
        : needsReview > 0
            ? '$needsReview clip${needsReview == 1 ? '' : 's'} need review'
            : 'Hide sensitive info before you share';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.privacyNavy, AppColors.privacySurface],
        ),
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.visibility_off_outlined, color: AppColors.privacyTeal),
              SizedBox(width: 10),
              Text(
                'Privacy first',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            headline,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scan for emails and phone numbers, blur what matters, then share a safer copy — on your device.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onProtect,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Review & hide'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onImport,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                  child: const Text('Import clip'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        child: Ink(
          decoration: AppDesign.heroCardDecoration(gradient: gradient),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({
    required this.loading,
    required this.clips,
    required this.review,
    required this.protected,
  });

  final bool loading;
  final int clips;
  final int review;
  final int protected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: palette.divider),
      ),
      child: Row(
        children: [
          _Stat(
            value: loading ? '—' : '$review',
            label: 'To hide',
            palette: palette,
          ),
          _divider(palette),
          _Stat(
            value: loading ? '—' : '$protected',
            label: 'Protected',
            palette: palette,
          ),
          _divider(palette),
          _Stat(
            value: loading ? '—' : '$clips',
            label: 'Clips',
            palette: palette,
          ),
        ],
      ),
    );
  }

  Widget _divider(AppPalette palette) => Container(
        width: 1,
        height: 32,
        color: palette.divider,
      );
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.label,
    required this.palette,
  });

  final String value;
  final String label;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({
    required this.title,
    required this.duration,
    required this.state,
    required this.onProtect,
  });

  final String title;
  final String duration;
  final PrivacyVideoState state;
  final VoidCallback onProtect;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(AppDesign.radiusMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onProtect,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: palette.accentSoft,
                  borderRadius: BorderRadius.circular(AppDesign.radiusSm),
                ),
                child: Icon(Icons.visibility_off_outlined, color: palette.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          duration,
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        PrivacyStatusBadge(state: state, compact: true),
                        const SizedBox(width: 4),
                        Text(
                          state.statusLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onProtect,
                child: const Text('Hide'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
