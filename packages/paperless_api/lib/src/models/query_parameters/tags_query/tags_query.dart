import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';
part 'tags_query.freezed.dart';
part 'tags_query.g.dart';

@freezed
class TagsQuery with _$TagsQuery {
  const TagsQuery._();
  @HiveType(typeId: PaperlessApiHiveTypeIds.notAssignedTagsQuery)
  const factory TagsQuery.notAssigned() = NotAssignedTagsQuery;

  @HiveType(typeId: PaperlessApiHiveTypeIds.anyAssignedTagsQuery)
  const factory TagsQuery.anyAssigned({
    @Default([]) List<int> tagIds,
  }) = AnyAssignedTagsQuery;

  @HiveType(typeId: PaperlessApiHiveTypeIds.idsTagsQuery)
  const factory TagsQuery.ids({
    @Default([]) List<int> include,
    @Default([]) List<int> exclude,
  }) = IdsTagsQuery;

  Map<String, String> toQueryParameter() {
    return when(
      anyAssigned: (tagIds) {
        if (tagIds.isEmpty) {
          return {'is_tagged': '1'};
        }
        return {'tags__id__in': tagIds.join(',')};
      },
      ids: (include, exclude) {
        final Map<String, String> params = {};
        if (include.isNotEmpty) {
          params.putIfAbsent('tags__id__all', () => include.join(','));
        }
        if (exclude.isNotEmpty) {
          params.putIfAbsent('tags__id__none', () => exclude.join(','));
        }
        return params;
      },
      notAssigned: () {
        return {'is_tagged': '0'};
      },
    );
  }

  bool matches(Iterable<int> ids) {
    return when(
      anyAssigned: (_) => ids.isNotEmpty,
      ids: (include, exclude) =>
          include.toSet().difference(ids.toSet()).isEmpty &&
          exclude.toSet().intersection(ids.toSet()).isEmpty,
      notAssigned: () => ids.isEmpty,
    );
  }

  factory TagsQuery.fromJson(Map<String, dynamic> json) => _$TagsQueryFromJson(json);
}
