import 'dart:async';

import 'package:paperless_api/paperless_api.dart';
import 'package:rxdart/subjects.dart';

typedef DocumentChangedCallback = void Function(DocumentModel document);

class DocumentChangedNotifier {
  final Subject<DocumentModel> _updated = PublishSubject();
  final Subject<DocumentModel> _deleted = PublishSubject();

  void notifyUpdated(DocumentModel updated) {
    _updated.add(updated);
  }

  void notifyDeleted(DocumentModel deleted) {
    _deleted.add(deleted);
  }

  List<StreamSubscription> listen({
    DocumentChangedCallback? onUpdated,
    DocumentChangedCallback? onDeleted,
  }) {
    return [
      _updated.listen((value) {
        onUpdated?.call(value);
      }),
      _updated.listen((value) {
        onDeleted?.call(value);
      }),
    ];
  }

  void close() {
    _updated.close();
    _deleted.close();
  }
}
