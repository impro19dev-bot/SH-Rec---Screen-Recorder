import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';

/// Resolves Photos library assets and opens the system share sheet reliably.
class VideoShareService {
  VideoShareService._();
  static final VideoShareService instance = VideoShareService._();

  /// Opens the share sheet for [video]. Returns `true` when the sheet was shown.
  Future<bool> shareAsset(BuildContext context, AssetEntity video) async {
    final file = await resolveShareableFile(video);
    if (file == null) return false;
    if (!context.mounted) return false;
    return shareFile(context, file);
  }

  /// Opens the share sheet for an on-disk [file].
  Future<bool> shareFile(BuildContext context, File file) async {
    if (!file.existsSync()) return false;
    if (!context.mounted) return false;

    // Capture share origin before awaits so we never use a stale context layout.
    final origin = _shareOrigin(context);
    final mime = _mimeForPath(file.path);

    // Let any closing dialog/route finish before presenting the sheet.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (!context.mounted) return false;

    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: mime)],
          sharePositionOrigin: origin,
        ),
      );
      return true;
    } catch (_) {
      // Retry once with a temp copy — Photos paths are sometimes unshareable.
      final copy = await _copyToTemp(file);
      if (copy == null || !context.mounted) return false;
      try {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(copy.path, mimeType: mime)],
            sharePositionOrigin: origin,
          ),
        );
        return true;
      } catch (_) {
        return false;
      }
    }
  }

  Future<File?> resolveShareableFile(AssetEntity video) async {
    final origin = await video.originFile;
    if (origin != null && origin.existsSync()) return origin;
    final file = await video.file;
    if (file != null && file.existsSync()) return file;
    return null;
  }

  Future<File?> _copyToTemp(File source) async {
    try {
      final dir = await getTemporaryDirectory();
      final ext = source.path.contains('.')
          ? source.path.split('.').last
          : 'mp4';
      final dest = File(
        '${dir.path}/share_${DateTime.now().millisecondsSinceEpoch}.$ext',
      );
      return source.copy(dest.path);
    } catch (_) {
      return null;
    }
  }

  Rect _shareOrigin(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      final size = MediaQuery.sizeOf(context);
      return Rect.fromLTWH(0, 0, size.width, size.height / 2);
    }
    return box.localToGlobal(Offset.zero) & box.size;
  }

  String _mimeForPath(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.mov')) return 'video/quicktime';
    if (lower.endsWith('.m4v')) return 'video/x-m4v';
    return 'video/mp4';
  }
}
