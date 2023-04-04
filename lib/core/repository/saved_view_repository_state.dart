import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/paperless_api.dart';

part 'saved_view_repository_state.freezed.dart';
part 'saved_view_repository_state.g.dart';

@freezed
class SavedViewRepositoryState with _$SavedViewRepositoryState {
  const factory SavedViewRepositoryState({
    @Default({}) Map<int, SavedView> savedViews,
  }) = _SavedViewRepositoryState;

  factory SavedViewRepositoryState.fromJson(Map<String, dynamic> json) =>
      _$SavedViewRepositoryStateFromJson(json);
}
