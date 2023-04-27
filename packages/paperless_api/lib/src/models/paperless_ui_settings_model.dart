import 'package:json_annotation/json_annotation.dart';

part 'paperless_ui_settings_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaperlessUiSettingsModel {
  final String displayName;

  PaperlessUiSettingsModel({required this.displayName});
  factory PaperlessUiSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PaperlessUiSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaperlessUiSettingsModelToJson(this);
}
