import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

class PendingTasksNotifier extends ValueNotifier<Map<String, Task>> {
  final PaperlessTasksApi _api;
  PendingTasksNotifier(this._api) : super({});

  void listenToTaskChanges(String taskId) {
    _api.listenForTaskChanges(taskId).forEach((task) {
      value = {...value, taskId: task};
      notifyListeners();
    }).whenComplete(
      () {
        value = value..remove(taskId);
        notifyListeners();
      },
    );
  }

  Future<void> acknowledgeTasks(Iterable<String> taskIds) async {
    final tasks = value.values.where((task) => taskIds.contains(task.taskId));
    await Future.wait([for (var task in tasks) _api.acknowledgeTask(task)]);
    value = value..removeWhere((key, value) => taskIds.contains(key));
    notifyListeners();
  }
}
