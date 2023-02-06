import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/state/indexed_repository_state.dart';

part 'tag_repository_state.g.dart';

@JsonSerializable()
class TagRepositoryState extends IndexedRepositoryState<Tag> {
  const TagRepositoryState({
    super.values = const {},
    super.hasLoaded = false,
  });

  @override
  TagRepositoryState copyWith({
    Map<int, Tag>? values,
    bool? hasLoaded,
  }) {
    return TagRepositoryState(
      values: values ?? this.values,
      hasLoaded: hasLoaded ?? this.hasLoaded,
    );
  }

  factory TagRepositoryState.fromJson(Map<String, dynamic> json) =>
      _$TagRepositoryStateFromJson(json);

  Map<String, dynamic> toJson() => _$TagRepositoryStateToJson(this);
}
