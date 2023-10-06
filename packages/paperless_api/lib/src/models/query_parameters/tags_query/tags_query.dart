import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';
part 'tags_query.freezed.dart';
part 'tags_query.g.dart';

sealed class TagsQuery {
  const TagsQuery();
  Map<String, String> toQueryParameter();
  bool matches(Iterable<int> ids);
}

@HiveType(typeId: PaperlessApiHiveTypeIds.notAssignedTagsQuery)
@Freezed(toJson: false, fromJson: false)
class NotAssignedTagsQuery extends TagsQuery with _$NotAssignedTagsQuery {
  const NotAssignedTagsQuery._();
  const factory NotAssignedTagsQuery() = _NotAssignedTagsQuery;
  @override
  Map<String, String> toQueryParameter() {
    return {'is_tagged': '0'};
  }

  @override
  bool matches(Iterable<int> ids) => ids.isEmpty;
}

@HiveType(typeId: PaperlessApiHiveTypeIds.anyAssignedTagsQuery)
@Freezed(toJson: false, fromJson: false)
class AnyAssignedTagsQuery extends TagsQuery with _$AnyAssignedTagsQuery {
  const AnyAssignedTagsQuery._();
  const factory AnyAssignedTagsQuery({
    @HiveField(0) @Default([]) List<int> tagIds,
  }) = _AnyAssignedTagsQuery;
  @override
  Map<String, String> toQueryParameter() {
    if (tagIds.isEmpty) {
      return {'is_tagged': '1'};
    }
    return {'tags__id__in': tagIds.join(',')};
  }

  @override
  bool matches(Iterable<int> ids) => ids.isNotEmpty;
}

@HiveType(typeId: PaperlessApiHiveTypeIds.idsTagsQuery)
@Freezed(toJson: false, fromJson: false)
class IdsTagsQuery extends TagsQuery with _$IdsTagsQuery {
  const IdsTagsQuery._();
  const factory IdsTagsQuery({
    @HiveField(0) @Default([]) List<int> include,
    @HiveField(1) @Default([]) List<int> exclude,
  }) = _IdsTagsQuery;
  @override
  Map<String, String> toQueryParameter() {
    final Map<String, String> params = {};
    if (include.isNotEmpty) {
      params.putIfAbsent('tags__id__all', () => include.join(','));
    }
    if (exclude.isNotEmpty) {
      params.putIfAbsent('tags__id__none', () => exclude.join(','));
    }
    return params;
  }

  @override
  bool matches(Iterable<int> ids) {
    return include.toSet().difference(ids.toSet()).isEmpty &&
        exclude.toSet().intersection(ids.toSet()).isEmpty;
  }
}
