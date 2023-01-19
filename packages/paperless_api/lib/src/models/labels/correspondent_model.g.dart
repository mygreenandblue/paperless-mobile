// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'correspondent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Correspondent _$CorrespondentFromJson(Map<String, dynamic> json) =>
    Correspondent(
      id: json['id'] as int?,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      match: json['match'] as String?,
      matchingAlgorithm:
          $enumDecode(_$MatchingAlgorithmEnumMap, json['matching_algorithm']),
      isInsensitive: json['is_insensitive'] as bool?,
      documentCount: json['document_count'] as int?,
      lastCorrespondence: _$JsonConverterFromJson<String, DateTime>(
          json['last_correspondence'],
          const LocalDateTimeJsonConverter().fromJson),
    );

Map<String, dynamic> _$CorrespondentToJson(Correspondent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  writeNotNull('slug', instance.slug);
  writeNotNull('match', instance.match);
  val['matching_algorithm'] =
      _$MatchingAlgorithmEnumMap[instance.matchingAlgorithm]!;
  writeNotNull('is_insensitive', instance.isInsensitive);
  writeNotNull('document_count', instance.documentCount);
  writeNotNull(
      'last_correspondence',
      _$JsonConverterToJson<String, DateTime>(instance.lastCorrespondence,
          const LocalDateTimeJsonConverter().toJson));
  return val;
}

const _$MatchingAlgorithmEnumMap = {
  MatchingAlgorithm.anyWord: 1,
  MatchingAlgorithm.allWords: 2,
  MatchingAlgorithm.exactMatch: 3,
  MatchingAlgorithm.regex: 4,
  MatchingAlgorithm.fuzzy: 5,
  MatchingAlgorithm.auto: 6,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
