// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_hit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchHit _$SearchHitFromJson(Map<String, dynamic> json) => SearchHit(
      score: (json['score'] as num?)?.toDouble(),
      highlights: json['highlights'] as String?,
      rank: json['rank'] as int?,
    );

Map<String, dynamic> _$SearchHitToJson(SearchHit instance) => <String, dynamic>{
      'score': instance.score,
      'highlights': instance.highlights,
      'rank': instance.rank,
    };
