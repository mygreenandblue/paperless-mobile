import 'dart:async';

import 'package:paperless_api/paperless_api.dart';
import 'package:rxdart/subjects.dart';

typedef WarehouseChangedCallback = void Function(WarehouseModel document);

class WarehouseChangedNotifier {
  final Subject<WarehouseModel> _updated = PublishSubject();
  final Subject<WarehouseModel> _deleted = PublishSubject();

  final Map<dynamic, List<StreamSubscription>> _subscribers = {};

  Stream<WarehouseModel> get $updated => _updated.asBroadcastStream();

  Stream<WarehouseModel> get $deleted => _deleted.asBroadcastStream();

  void notifyUpdated(WarehouseModel updated) {
    _updated.add(updated);
  }

  void notifyDeleted(WarehouseModel deleted) {
    _deleted.add(deleted);
  }

  void addListener(
    Object subscriber, {
    WarehouseChangedCallback? onUpdated,
    WarehouseChangedCallback? onDeleted,
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
