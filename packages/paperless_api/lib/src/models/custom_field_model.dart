import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/src/models/custom_field_data_type.dart';

part 'custom_field_model.g.dart';

@JsonSerializable()
class CustomFieldModel with EquatableMixin {
  final int? id;
  final String? name;
  final CustomFieldDataType dataType;

  CustomFieldModel({
    this.id,
    required this.name,
    required this.dataType,
  });

  @override
  List<Object?> get props => [id, name, dataType];

  factory CustomFieldModel.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomFieldModelToJson(this);
}

/// An instance of the [CustomFieldModel].
@JsonSerializable()
class CustomFieldInstance {
  final int? id;
  final dynamic value;

  const CustomFieldInstance({
    this.id,
    this.value,
  });

  factory CustomFieldInstance.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldInstanceFromJson(json);
}
