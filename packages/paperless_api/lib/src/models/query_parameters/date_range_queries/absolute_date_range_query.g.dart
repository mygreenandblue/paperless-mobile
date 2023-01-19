// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absolute_date_range_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbsoluteDateRangeQuery _$AbsoluteDateRangeQueryFromJson(
        Map<String, dynamic> json) =>
    AbsoluteDateRangeQuery(
      after: _$JsonConverterFromJson<String, DateTime>(
          json['after'], const LocalDateTimeJsonConverter().fromJson),
      before: _$JsonConverterFromJson<String, DateTime>(
          json['before'], const LocalDateTimeJsonConverter().fromJson),
    );

Map<String, dynamic> _$AbsoluteDateRangeQueryToJson(
        AbsoluteDateRangeQuery instance) =>
    <String, dynamic>{
      'after': _$JsonConverterToJson<String, DateTime>(
          instance.after, const LocalDateTimeJsonConverter().toJson),
      'before': _$JsonConverterToJson<String, DateTime>(
          instance.before, const LocalDateTimeJsonConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
