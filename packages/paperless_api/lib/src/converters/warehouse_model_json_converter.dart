import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/paperless_api.dart';

class WarehouseModelJsonConverter
    extends JsonConverter<WarehouseModel, Map<String, dynamic>> {
  @override
  WarehouseModel fromJson(Map<String, dynamic> json) {
    return WarehouseModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(WarehouseModel object) {
    return object.toJson();
  }
}
