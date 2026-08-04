import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../services/video_library_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/context_extensions.dart';
import '../../widgets/photos_permission_view.dart';
import 'privacy_studio_screen.dart';

/// Pick any Photos video to open in Shield Studio for redaction.
class ProtectClipPickerScreen extends StatefulWidget {
  const ProtectClipPickerScreen({super.key});

  @override
  State<ProtectClipPickerScreen> createState() =>
      _ProtectClipPickerScreenState();
}

class _ProtectClipPickerScreenState extends State<ProtectClipPickerScreen> {
  final VideoLibraryService _library = VideoLibraryService();
  bool _loading = true;
  bool _permissionDenied = false;
  List<AssetEntity> _videos = const [];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() => _loading = true);
    try {
      final hasPermission = await _library.hasPermission();
      if (!hasPermission) {
        if (!mounted) return;
        setState(() {
          _permissionDenied = true;
          _videos = const [];
          _loading = false;
        });
        return;
      }
      final entities = await _library.loadVideos();
      if (!mounted) return;
      setState(() {
        _permissionDenied = false;
        _videos = entities;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load clips. Try again.')),
      );
    }
  }

  void _onSelected(AssetEntity video) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => PrivacyStudioScreen(video: video),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    String two(int n) => n.toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${d.inHours}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
    }
    return '${d.inMinutes}:${two(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Protect a clip'),
        backgroundColor: AppColors.privacyNavy,
        foregroundColor: Colors.white,
      ),
      backgroundColor: palette.background,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _permissionDenied
              ? PhotosPermissionView(
                  message:
                      'Allow Photos access to protect clips and hide sensitive info.',
                )
              : _videos.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No videos in Photos yet.\nCapture a clip first, or save one to Photos.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: palette.textSecondary),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadVideos,
                      color: AppColors.primaryOrange,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        itemCount: _videos.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final video = _videos[index];
                          return _ClipTile(
                            video: video,
                            duration: _formatDuration(video.duration),
                            onTap: () => _onSelected(video),
                          );
                        },
                      ),
                    ),
    );
  }
}

class _ClipTile extends StatelessWidget {
  const _ClipTile({
    required this.video,
    required this.duration,
    required this.onTap,
  });

  final AssetEntity video;
  final String duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: FutureBuilder<Uint8List?>(
          future: video.thumbnailDataWithSize(const ThumbnailSize(120, 120)),
          builder: (context, snapshot) {
            final bytes = snapshot.data;
            if (bytes == null) {
              return Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: palette.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.movie_outlined, color: palette.accent),
              );
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(bytes, width: 52, height: 52, fit: BoxFit.cover),
            );
          },
        ),
        title: Text(
          video.title ?? 'Clip',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
          ),
        ),
        subtitle: Text(duration),
        trailing: const Icon(Icons.visibility_off_outlined),
      ),
    );
  }
}
