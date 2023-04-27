part of 'label_cubit.dart';

@freezed
class LabelState with _$LabelState {
  const factory LabelState({
    @Default({}) Map<int, Correspondent> correspondents,
    @Default({}) Map<int, DocumentType> documentTypes,
    @Default({}) Map<int, Tag> tags,
    @Default({}) Map<int, StoragePath> storagePaths,
  }) = _LabelState;
}
