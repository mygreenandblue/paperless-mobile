import 'package:json_annotation/json_annotation.dart';

part 'create_document_success_payload.g.dart';

@JsonSerializable()
class CreateDocumentSuccessPayload {
  final int documentId;

  CreateDocumentSuccessPayload(this.documentId);

  factory CreateDocumentSuccessPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateDocumentSuccessPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDocumentSuccessPayloadToJson(this);
}
