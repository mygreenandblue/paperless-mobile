import 'package:json_annotation/json_annotation.dart';

part 'edocs_server_message_exception.g.dart';

@JsonSerializable(createToJson: false)
class EdocsServerMessageException implements Exception {
  final String detail;

  EdocsServerMessageException(this.detail);

  static bool canParse(dynamic json) {
    if (json is Map<String, dynamic>) {
      return json.containsKey('detail') && json.length == 1;
    }
    return false;
  }

  factory EdocsServerMessageException.fromJson(Map<String, dynamic> json) =>
      _$EdocsServerMessageExceptionFromJson(json);
}
