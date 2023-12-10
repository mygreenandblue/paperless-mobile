import 'package:paperless_api/src/models/custom_field_model.dart';

abstract interface class CustomFieldsApi {
  Future<CustomFieldModel> createCustomField(CustomFieldModel customField);
  Future<CustomFieldModel?> getCustomField(int id);
  Future<List<CustomFieldModel>> getCustomFields();
  Future<int> deleteCustomField(CustomFieldModel customField);
}
