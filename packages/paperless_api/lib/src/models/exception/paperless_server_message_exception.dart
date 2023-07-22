import 'package:json_annotation/json_annotation.dart';

part 'paperless_server_exception.g.dart';

@JsonSerializable(createToJson: false)
class PaperlessServerMessageException implements Exception {
  final String detail;

  PaperlessServerMessageException(this.detail);

  static bool canParse(Map<String, dynamic> json) {
    return json.containsKey('detail') && json.length == 1;
  }

  factory PaperlessServerMessageException.fromJson(Map<String, dynamic> json) =>
      _$PaperlessServerExceptionFromJson(json);
}
