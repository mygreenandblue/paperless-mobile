// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as int,
      taskId: json['task_id'] as String?,
      taskFileName: json['task_file_name'] as String?,
      dateCreated: const LocalDateTimeJsonConverter()
          .fromJson(json['date_created'] as String),
      dateDone: _$JsonConverterFromJson<String, DateTime>(
          json['date_done'], const LocalDateTimeJsonConverter().fromJson),
      type: json['type'] as String?,
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']),
      acknowledged: json['acknowledged'] as bool? ?? false,
      relatedDocument: tryParseNullable(json['related_document'] as String?),
      result: json['result'] as String?,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'task_id': instance.taskId,
      'task_file_name': instance.taskFileName,
      'date_created':
          const LocalDateTimeJsonConverter().toJson(instance.dateCreated),
      'date_done': _$JsonConverterToJson<String, DateTime>(
          instance.dateDone, const LocalDateTimeJsonConverter().toJson),
      'type': instance.type,
      'status': _$TaskStatusEnumMap[instance.status],
      'result': instance.result,
      'acknowledged': instance.acknowledged,
      'related_document': instance.relatedDocument,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$TaskStatusEnumMap = {
  TaskStatus.started: 'STARTED',
  TaskStatus.pending: 'PENDING',
  TaskStatus.failure: 'FAILURE',
  TaskStatus.success: 'SUCCESS',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
