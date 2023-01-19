// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_suggestions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldSuggestions _$FieldSuggestionsFromJson(Map<String, dynamic> json) =>
    FieldSuggestions(
      documentId: json['document_id'] as int?,
      correspondents:
          (json['correspondents'] as List<dynamic>?)?.map((e) => e as int) ??
              const [],
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as int) ?? const [],
      documentTypes:
          (json['document_types'] as List<dynamic>?)?.map((e) => e as int) ??
              const [],
      dates: (json['dates'] as List<dynamic>?)?.map((e) =>
              const LocalDateTimeJsonConverter().fromJson(e as String)) ??
          const [],
    );

Map<String, dynamic> _$FieldSuggestionsToJson(FieldSuggestions instance) =>
    <String, dynamic>{
      'document_id': instance.documentId,
      'correspondents': instance.correspondents.toList(),
      'tags': instance.tags.toList(),
      'document_types': instance.documentTypes.toList(),
      'dates': instance.dates
          .map(const LocalDateTimeJsonConverter().toJson)
          .toList(),
    };
