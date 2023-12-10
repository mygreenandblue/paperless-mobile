import 'package:json_annotation/json_annotation.dart';

part 'paperless_server_message_exception.g.dart';

@JsonSerializable(createToJson: false)
class PaperlessServerMessageException implements Exception {
  final String detail;

  PaperlessServerMessageException(this.detail);

  static bool canParse(dynamic json) {
    if (json is Map<String, dynamic>) {
      return json.containsKey('detail') && json.length == 1;
    }
    return false;
  }

  factory PaperlessServerMessageException.fromJson(Map<String, dynamic> json) =>
      _$PaperlessServerMessageExceptionFromJson(json);
}
