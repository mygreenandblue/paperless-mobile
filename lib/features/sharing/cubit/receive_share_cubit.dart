import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:path/path.dart' as p;

part 'receive_share_state.dart';

class ConsumptionChangeNotifier extends ChangeNotifier {
  List<File> pendingFiles = [];

  final Completer _restored = Completer();

  Future<void> get isInitialized => _restored.future;

  Future<void> loadFromConsumptionDirectory({required String userId}) async {
    pendingFiles = await _getCurrentFiles(userId);
    if (!_restored.isCompleted) {
      _restored.complete();
    }
    notifyListeners();
  }

  /// Creates a local copy of all shared files and reloads all files
  /// from the user's consumption directory.
  Future<void> addFiles({
    required List<File> files,
    required String userId,
  }) async {
    if (files.isEmpty) {
      return;
    }
    final consumptionDirectory =
        await FileService.getConsumptionDirectory(userId: userId);
    for (final file in files) {
      File localFile;
      if (file.path.startsWith(consumptionDirectory.path)) {
        localFile = file;
      } else {
        final fileName = p.basename(file.path);
        localFile = File(p.join(consumptionDirectory.path, fileName));
        await file.copy(localFile.path);
      }
    }
    return loadFromConsumptionDirectory(userId: userId);
  }

  /// Marks a file as processed by removing it from the queue and deleting the local copy of the file.
  Future<void> discardFile(
    File file, {
    required String userId,
  }) async {
    final consumptionDirectory =
        await FileService.getConsumptionDirectory(userId: userId);
    if (file.path.startsWith(consumptionDirectory.path)) {
      await file.delete();
    }
    return loadFromConsumptionDirectory(userId: userId);
  }

  /// Returns the next file to process of null if no file exists.
  Future<File?> getNextFile({required String userId}) async {
    final files = await _getCurrentFiles(userId);
    if (files.isEmpty) {
      return null;
    }
    return files.first;
  }

  Future<List<File>> _getCurrentFiles(String userId) async {
    final directory = await FileService.getConsumptionDirectory(userId: userId);
    final files = await FileService.getAllFiles(directory);
    return files;
  }
}
