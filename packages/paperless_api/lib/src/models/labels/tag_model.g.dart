// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag._(
      id: json['id'] as int?,
      name: json['name'] as String,
      documentCount: json['document_count'] as int?,
      isInsensitive: json['is_insensitive'] as bool? ?? true,
      match: json['match'] as String?,
      matchingAlgorithm: $enumDecodeNullable(
              _$MatchingAlgorithmEnumMap, json['matching_algorithm']) ??
          MatchingAlgorithm.defaultValue,
      slug: json['slug'] as String?,
      colorv1: const HexColorJsonConverter().fromJson(json['colour']),
      colorv2: const HexColorJsonConverter().fromJson(json['color']),
      textColor: const HexColorJsonConverter().fromJson(json['text_color']),
      isInboxTag: json['is_inbox_tag'] as bool? ?? false,
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'match': instance.match,
      'matching_algorithm':
          _$MatchingAlgorithmEnumMap[instance.matchingAlgorithm]!,
      'is_insensitive': instance.isInsensitive,
      'document_count': instance.documentCount,
      'text_color': const HexColorJsonConverter().toJson(instance.textColor),
      'is_inbox_tag': instance.isInboxTag,
      'color': const HexColorJsonConverter().toJson(instance.colorv2),
      'colour': const HexColorJsonConverter().toJson(instance.colorv1),
    };

const _$MatchingAlgorithmEnumMap = {
  MatchingAlgorithm.anyWord: 1,
  MatchingAlgorithm.allWords: 2,
  MatchingAlgorithm.exactMatch: 3,
  MatchingAlgorithm.regex: 4,
  MatchingAlgorithm.fuzzy: 5,
  MatchingAlgorithm.auto: 6,
};
