// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'similar_document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimilarDocumentModel _$SimilarDocumentModelFromJson(
        Map<String, dynamic> json) =>
    SimilarDocumentModel(
      id: json['id'] as int,
      title: json['title'] as String,
      documentType: json['documentType'] as int?,
      correspondent: json['correspondent'] as int?,
      created: const LocalDateTimeJsonConverter()
          .fromJson(json['created'] as String),
      modified: const LocalDateTimeJsonConverter()
          .fromJson(json['modified'] as String),
      added:
          const LocalDateTimeJsonConverter().fromJson(json['added'] as String),
      originalFileName: json['originalFileName'] as String,
      searchHit:
          SearchHit.fromJson(json['__search_hit__'] as Map<String, dynamic>),
      archiveSerialNumber: json['archiveSerialNumber'] as int?,
      archivedFileName: json['archivedFileName'] as String?,
      content: json['content'] as String?,
      storagePath: json['storagePath'] as int?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as int) ??
          const <int>[],
    );

Map<String, dynamic> _$SimilarDocumentModelToJson(
        SimilarDocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags.toList(),
      'documentType': instance.documentType,
      'correspondent': instance.correspondent,
      'storagePath': instance.storagePath,
      'created': const LocalDateTimeJsonConverter().toJson(instance.created),
      'modified': const LocalDateTimeJsonConverter().toJson(instance.modified),
      'added': const LocalDateTimeJsonConverter().toJson(instance.added),
      'archiveSerialNumber': instance.archiveSerialNumber,
      'originalFileName': instance.originalFileName,
      'archivedFileName': instance.archivedFileName,
      '__search_hit__': instance.searchHit,
    };
