// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_search_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentSearchState _$DocumentSearchStateFromJson(Map<String, dynamic> json) =>
    DocumentSearchState(
      searchHistory: (json['searchHistory'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DocumentSearchStateToJson(
        DocumentSearchState instance) =>
    <String, dynamic>{
      'searchHistory': instance.searchHistory,
    };
