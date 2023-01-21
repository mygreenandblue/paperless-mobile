import 'dart:collection';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntentQueue extends ChangeNotifier {
  final Queue<SharedMediaFile> _queue = Queue();

  ShareIntentQueue._();

  static final instance = ShareIntentQueue._();

  void add(SharedMediaFile file) {
    debugPrint("Adding received file to queue: ${file.path}");
    _queue.add(file);
    notifyListeners();
  }

  void addAll(Iterable<SharedMediaFile> files) {
    debugPrint(
        "Adding received files to queue: ${files.map((e) => e.path).join(",")}");
    _queue.addAll(files);
    notifyListeners();
  }

  SharedMediaFile? pop() {
    if (hasUnhandledFiles) {
      return _queue.removeFirst();
      // Don't notify listeners, only when new item is added.
    } else {
      return null;
    }
  }

  bool get hasUnhandledFiles => _queue.isNotEmpty;
}
