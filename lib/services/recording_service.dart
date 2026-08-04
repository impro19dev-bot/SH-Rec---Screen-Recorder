import 'dart:io';

import 'package:flutter/services.dart';

import 'photos_permission_service.dart';
import 'replaykit_service.dart';

class RecordingResult {
  const RecordingResult({
    required this.success,
    this.filePath,
    this.error,
  });

  final bool success;
  final String? filePath;
  final String? error;
}

/// iOS-only capture via ReplayKit (broadcast + optional in-app).
class RecordingService {
  final ReplayKitService _replayKitService = ReplayKitService();
  bool _appOnlyRecording = false;

  bool get isRecording => _appOnlyRecording;

  Future<bool> requestMediaPermissions() async {
    PhotosPermissionService.unlockLibraryBrowse();
    return PhotosPermissionService.requestAccess();
  }

  /// Opens Apple's broadcast picker for full-device capture.
  Future<RecordingResult> startFullDeviceRecording() async {
    if (!Platform.isIOS) {
      return const RecordingResult(
        success: false,
        error: 'Capture is only available on iOS.',
      );
    }

    try {
      final isSimulator = await _replayKitService.isSimulator();
      if (isSimulator) {
        return const RecordingResult(
          success: false,
          error:
              'Full-device capture does not work on the iOS Simulator. Use a physical iPhone.',
        );
      }

      if (_appOnlyRecording) {
        return const RecordingResult(
          success: false,
          error: 'Stop in-app capture before starting a broadcast.',
        );
      }

      final hasAccess = await requestMediaPermissions();
      if (!hasAccess) {
        return const RecordingResult(
          success: false,
          error: 'Photos permission is required to save clips.',
        );
      }

      await _replayKitService.setBroadcastStatus('requested');
      await _replayKitService.showBroadcastPicker();
      return const RecordingResult(success: true);
    } on PlatformException catch (e) {
      return RecordingResult(
        success: false,
        error: e.message ?? e.toString(),
      );
    } catch (e) {
      return RecordingResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// In-app only capture via RPScreenRecorder (optional fallback).
  Future<RecordingResult> startAppOnlyRecording() async {
    if (!Platform.isIOS) {
      return const RecordingResult(
        success: false,
        error: 'Capture is only available on iOS.',
      );
    }

    try {
      final isSimulator = await _replayKitService.isSimulator();
      if (isSimulator) {
        return const RecordingResult(
          success: false,
          error:
              'In-app capture does not work on the iOS Simulator. Use a physical iPhone.',
        );
      }

      if (await _replayKitService.isBroadcastRecordingActive()) {
        return const RecordingResult(
          success: false,
          error: 'Stop the broadcast before starting in-app capture.',
        );
      }

      final hasAccess = await requestMediaPermissions();
      if (!hasAccess) {
        return const RecordingResult(
          success: false,
          error: 'Photos permission is required to save clips.',
        );
      }

      await _replayKitService.startAppOnlyRecording();
      _appOnlyRecording = true;
      return const RecordingResult(success: true);
    } on PlatformException catch (e) {
      _appOnlyRecording = false;
      return RecordingResult(
        success: false,
        error: e.message ?? e.toString(),
      );
    } catch (e) {
      _appOnlyRecording = false;
      return RecordingResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<RecordingResult> start() => startFullDeviceRecording();

  Future<RecordingResult> stopAppOnlyRecording() async {
    if (!Platform.isIOS) {
      return const RecordingResult(
        success: false,
        error: 'Capture is only available on iOS.',
      );
    }

    try {
      if (!_appOnlyRecording) {
        return const RecordingResult(
          success: false,
          error: 'No in-app capture session is active.',
        );
      }

      final path = await _replayKitService.stopAppOnlyRecording();
      _appOnlyRecording = false;
      return RecordingResult(
        success: true,
        filePath: path,
      );
    } on PlatformException catch (e) {
      _appOnlyRecording = false;
      return RecordingResult(
        success: false,
        error: e.message ?? e.toString(),
      );
    } catch (e) {
      _appOnlyRecording = false;
      return RecordingResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<RecordingResult> stop() => stopAppOnlyRecording();
}
