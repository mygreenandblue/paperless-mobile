import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/src/converters/local_date_time_json_converter.dart';
import 'package:paperless_api/src/models/document_model.dart';
import 'package:paperless_api/src/models/search_hit.dart';

part 'similar_document_model.g.dart';

@LocalDateTimeJsonConverter()
@JsonSerializable()
class SimilarDocumentModel extends DocumentModel {
  @JsonKey(name: '__search_hit__')
  final SearchHit searchHit;

  const SimilarDocumentModel({
    required super.id,
    required super.title,
    required super.documentType,
    required super.correspondent,
    required super.created,
    required super.modified,
    required super.added,
    required super.originalFileName,
    required this.searchHit,
    super.archiveSerialNumber,
    super.archivedFileName,
    super.content,
    super.storagePath,
    super.tags,
  });

  factory SimilarDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$SimilarDocumentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SimilarDocumentModelToJson(this);
}
