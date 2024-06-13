import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_api/src/extensions/dio_exception_extension.dart';
import 'package:edocs_api/src/models/edocs_api_exception.dart';

class EdocsTasksApiImpl implements EdocsTasksApi {
  final Dio _client;

  EdocsTasksApiImpl(this._client);

  @override
  Future<Task?> find({int? id, String? taskId}) async {
    assert((id != null) != (taskId != null));
    if (id != null) {
      return _findById(id);
    } else if (taskId != null) {
      return _findByTaskId(taskId);
    }
    return null;
  }

  /// API response returns List with single item
  Future<Task?> _findById(int id) async {
    final response = await _client.get("/api/tasks/$id/");
    if (response.statusCode == 200) {
      return Task.fromJson(response.data);
    }
    return null;
  }

  /// API response returns List with single item
  Future<Task?> _findByTaskId(String taskId) async {
    final response = await _client.get("/api/tasks/?task_id=$taskId");
    if (response.statusCode == 200) {
      if ((response.data as List).isNotEmpty) {
        return Task.fromJson((response.data as List).first);
      }
    }
    return null;
  }

  @override
  Future<Iterable<Task>> findAll([Iterable<int>? ids]) async {
    try {
      final response = await _client.get(
        "/api/tasks/",
        options: Options(validateStatus: (status) => status == 200),
      );
      return (response.data as List).map((e) => Task.fromJson(e));
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const EdocsApiException(ErrorCode.loadTasksError),
      );
    }
  }

  @override
  Stream<Task> listenForTaskChanges(String taskId) async* {
    bool isCompleted = false;
    while (!isCompleted) {
      final task = await find(taskId: taskId);
      if (task == null) {
        throw Exception("Task with taskId $taskId does not exist.");
      }
      log("Found new task: ${task.taskId}, ${task.id}, ${task.status}");
      yield task;
      if (task.status == TaskStatus.success ||
          task.status == TaskStatus.failure) {
        isCompleted = true;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Future<Task> acknowledgeTask(Task task) async {
    final acknowledgedTasks = await acknowledgeTasks([task]);
    return acknowledgedTasks.first.copyWith(acknowledged: true);
  }

  @override
  Future<Iterable<Task>> acknowledgeTasks(Iterable<Task> tasks) async {
    try {
      final response = await _client.post(
        "/api/acknowledge_tasks/",
        data: {
          'tasks': tasks.map((e) => e.id).toList(),
        },
        options: Options(validateStatus: (status) => status == 200),
      );
      if (response.data['result'] != tasks.length) {
        throw const EdocsApiException(ErrorCode.acknowledgeTasksError);
      }
      return tasks.map((e) => e.copyWith(acknowledged: true)).toList();
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const EdocsApiException(ErrorCode.acknowledgeTasksError),
      );
    }
  }
}
