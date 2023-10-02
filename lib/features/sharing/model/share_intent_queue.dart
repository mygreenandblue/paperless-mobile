import 'dart:collection';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:paperless_mobile/core/config/hive/hive_extensions.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:path/path.dart' as p;

class ShareIntentQueue extends ChangeNotifier {
  final Map<String, Queue<File>> _queues = {};

  ShareIntentQueue._();

  static final instance = ShareIntentQueue._();

  Future<void> initialize() async {
    final users = Hive.localUserAccountBox.values;
    for (final user in users) {
      final userId = user.id;
      debugPrint("Locating remaining files to be uploaded for $userId...");
      final consumptionDir =
          await FileService.getConsumptionDirectory(userId: userId);
      final files = await FileService.getAllFiles(consumptionDir);
      debugPrint(
          "Found ${files.length} files to be uploaded for $userId. Adding to queue...");
      getQueue(userId).addAll(files);
    }
  }

  void add(
    File file, {
    required String userId,
  }) =>
      addAll([file], userId: userId);

  Future<void> addAll(
    Iterable<File> files, {
    required String userId,
  }) async {
    if (files.isEmpty) {
      return;
    }
    final consumptionDirectory =
        await FileService.getConsumptionDirectory(userId: userId);
    final copiedFiles = await Future.wait([
      for (var file in files)
        file.copy('${consumptionDirectory.path}/${p.basename(file.path)}')
    ]);

    debugPrint(
      "Adding received files to queue: ${files.map((e) => e.path).join(",")}",
    );
    getQueue(userId).addAll(copiedFiles);
    notifyListeners();
  }

  /// Removes and returns the first item in the requested user's queue if it exists.
  File? pop(String userId) {
    if (hasUnhandledFiles(userId: userId)) {
      final file = getQueue(userId).removeFirst();
      notifyListeners();
      return file;
      // Don't notify listeners, only when new item is added.
    }
    return null;
  }

  Future<void> onConsumed(File file) {
    debugPrint(
        "File ${file.path} successfully consumed. Delelting local copy.");
    return file.delete();
  }

  Future<void> discard(File file) {
    debugPrint("Discarding file ${file.path}.");
    return file.delete();
  }

  /// Returns whether the queue of the requested user contains files waiting for processing.
  bool hasUnhandledFiles({
    required String userId,
  }) =>
      getQueue(userId).isNotEmpty;

  int unhandledFileCount({
    required String userId,
  }) =>
      getQueue(userId).length;

  Queue<File> getQueue(String userId) {
    if (!_queues.containsKey(userId)) {
      _queues[userId] = Queue<File>();
    }
    return _queues[userId]!;
  }
}

class UserAwareShareMediaFile {
  final String userId;
  final SharedMediaFile sharedFile;

  UserAwareShareMediaFile(this.userId, this.sharedFile);
}
