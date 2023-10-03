import 'dart:async';

import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

class PendingTasksNotifier extends ValueNotifier<Map<String, Task>> {
  final PaperlessTasksApi _api;

  final Map<String, StreamSubscription> _subscriptions = {};

  PendingTasksNotifier(this._api) : super({});

  @override
  void dispose() {
    stopListeningToTaskChanges();
    super.dispose();
  }

  void listenToTaskChanges(String taskId) {
    final sub = _api.listenForTaskChanges(taskId).listen(
      (task) {
        if (value.containsKey(taskId)) {
          final oldTask = value[taskId]!;
          if (oldTask.status != task.status) {
            // Only notify of changes if task status has changed...
            value = {...value, taskId: task};
            notifyListeners();
          }
        } else {
          value = {...value, taskId: task};
          notifyListeners();
        }
      },
    );
    sub
      ..onDone(() {
        sub.cancel();
        value = value..remove(taskId);
        notifyListeners();
      })
      ..onError((_) {
        sub.cancel();
        value = value..remove(taskId);
        notifyListeners();
      });

    _subscriptions.putIfAbsent(taskId, () => sub);
  }

  void stopListeningToTaskChanges([String? taskId]) {
    if (taskId != null) {
      _subscriptions[taskId]?.cancel();
      _subscriptions.remove(taskId);
    } else {
      _subscriptions.forEach((key, value) {
        value.cancel();
        _subscriptions.remove(key);
      });
    }
  }

  Future<void> acknowledgeTasks(Iterable<String> taskIds) async {
    final tasks = value.values.where((task) => taskIds.contains(task.taskId));
    await Future.wait([for (var task in tasks) _api.acknowledgeTask(task)]);
    value = value..removeWhere((key, value) => taskIds.contains(key));
    notifyListeners();
  }
}
