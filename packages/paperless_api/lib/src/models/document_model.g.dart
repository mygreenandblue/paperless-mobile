// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    DocumentModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as int) ??
          const <int>[],
      documentType: json['document_type'] as int?,
      correspondent: json['correspondent'] as int?,
      created: const LocalDateTimeJsonConverter()
          .fromJson(json['created'] as String),
      modified: const LocalDateTimeJsonConverter()
          .fromJson(json['modified'] as String),
      added:
          const LocalDateTimeJsonConverter().fromJson(json['added'] as String),
      archiveSerialNumber: json['archive_serial_number'] as int?,
      originalFileName: json['original_file_name'] as String,
      archivedFileName: json['archived_file_name'] as String?,
      storagePath: json['storage_path'] as int?,
      searchHit: json['__search_hit__'] == null
          ? null
          : SearchHit.fromJson(json['__search_hit__'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DocumentModelToJson(DocumentModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
    'content': instance.content,
    'tags': instance.tags.toList(),
    'document_type': instance.documentType,
    'correspondent': instance.correspondent,
    'storage_path': instance.storagePath,
    'created': const LocalDateTimeJsonConverter().toJson(instance.created),
    'modified': const LocalDateTimeJsonConverter().toJson(instance.modified),
    'added': const LocalDateTimeJsonConverter().toJson(instance.added),
    'archive_serial_number': instance.archiveSerialNumber,
    'original_file_name': instance.originalFileName,
    'archived_file_name': instance.archivedFileName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__search_hit__', instance.searchHit);
  return val;
}
