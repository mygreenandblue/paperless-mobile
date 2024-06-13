import 'dart:async';

import 'package:edocs_api/edocs_api.dart';
import 'package:rxdart/subjects.dart';

typedef LabelChangedCallback = void Function(Label label);

class LabelChangedNotifier {
  final Subject<Label> _updated = PublishSubject();
  final Subject<Label> _deleted = PublishSubject();

  final Map<dynamic, List<StreamSubscription>> _subscribers = {};

  Stream<Label> get $updated => _updated.asBroadcastStream();

  Stream<Label> get $deleted => _deleted.asBroadcastStream();

  void notifyUpdated(Label updated) {
    _updated.add(updated);
  }

  void notifyDeleted(Label deleted) {
    _deleted.add(deleted);
  }

  void addListener(
    Object subscriber, {
    LabelChangedCallback? onUpdated,
    LabelChangedCallback? onDeleted,
    Iterable<int>? ids,
  }) {
    _subscribers.putIfAbsent(
      subscriber,
      () => [
        _updated.where((doc) => ids?.contains(doc.id) ?? true).listen((value) {
          onUpdated?.call(value);
        }),
        _deleted.where((doc) => ids?.contains(doc.id) ?? true).listen((value) {
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
