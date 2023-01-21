// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedView _$SavedViewFromJson(Map<String, dynamic> json) => SavedView(
      id: json['id'] as int?,
      name: json['name'] as String,
      showOnDashboard: json['show_on_dashboard'] as bool,
      showInSidebar: json['show_in_sidebar'] as bool,
      sortField: $enumDecodeNullable(_$SortFieldEnumMap, json['sort_field']),
      sortReverse: json['sort_reverse'] as bool,
      filterRules: (json['filter_rules'] as List<dynamic>)
          .map((e) => FilterRule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SavedViewToJson(SavedView instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'show_on_dashboard': instance.showOnDashboard,
      'show_in_sidebar': instance.showInSidebar,
      'sort_field': _$SortFieldEnumMap[instance.sortField],
      'sort_reverse': instance.sortReverse,
      'filter_rules': instance.filterRules,
    };

const _$SortFieldEnumMap = {
  SortField.archiveSerialNumber: 'archive_serial_number',
  SortField.correspondentName: 'correspondent__name',
  SortField.title: 'title',
  SortField.documentType: 'document_type__name',
  SortField.created: 'created',
  SortField.added: 'added',
  SortField.modified: 'modified',
};
