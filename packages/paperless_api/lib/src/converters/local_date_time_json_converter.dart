import 'package:json_annotation/json_annotation.dart';

class LocalDateTimeJsonConverter extends JsonConverter<DateTime, String> {
  const LocalDateTimeJsonConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json).toLocal();
  }

  @override
  String toJson(DateTime object) {
    return object.toUtc().toIso8601String();
  }
}
