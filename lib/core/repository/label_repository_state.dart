import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/paperless_api.dart';

part 'label_repository_state.freezed.dart';
part 'label_repository_state.g.dart';

@freezed
class LabelRepositoryState with _$LabelRepositoryState {
  const factory LabelRepositoryState({
    @Default({}) Map<int, Correspondent> correspondents,
    @Default({}) Map<int, DocumentType> documentTypes,
    @Default({}) Map<int, Tag> tags,
    @Default({}) Map<int, StoragePath> storagePaths,
  }) = _LabelRepositoryState;

  factory LabelRepositoryState.fromJson(Map<String, dynamic> json) =>
      _$LabelRepositoryStateFromJson(json);
}
