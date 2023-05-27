import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:rxdart/subjects.dart';

typedef DocumentChangedCallback = void Function(DocumentModel document);

class DocumentChangedNotifier {
  final Subject<DocumentModel> _updated = PublishSubject();
  final Subject<DocumentModel> _deleted = PublishSubject();

  final Map<dynamic, List<StreamSubscription>> _subscribers = {};

  void notifyUpdated(DocumentModel updated) {
    debugPrint("Notifying updated document ${updated.id}");
    _updated.add(updated);
  }

  void notifyDeleted(DocumentModel deleted) {
    debugPrint("Notifying deleted document ${deleted.id}");
    _deleted.add(deleted);
  }

  void addListener(
    Object subscriber, {
    DocumentChangedCallback? onUpdated,
    DocumentChangedCallback? onDeleted,
  }) {
    _subscribers.putIfAbsent(
      subscriber,
      () => [
        _updated.listen((value) {
          onUpdated?.call(value);
        }),
        _deleted.listen((value) {
          onDeleted?.call(value);
        }),
      ],
    );
  }

  void removeListener(Object subscriber) {
    _subscribers[subscriber]?.forEach((element) {
      element.cancel();
    });
  }

  void close() {
    _updated.close();
    _deleted.close();
  }
}
