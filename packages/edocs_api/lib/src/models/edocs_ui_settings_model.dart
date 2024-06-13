import 'package:json_annotation/json_annotation.dart';

part 'edocs_ui_settings_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EdocsUiSettingsModel {
  final String displayName;

  EdocsUiSettingsModel({required this.displayName});
  factory EdocsUiSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$EdocsUiSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EdocsUiSettingsModelToJson(this);
}
