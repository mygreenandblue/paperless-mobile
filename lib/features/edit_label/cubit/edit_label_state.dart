part of 'edit_label_cubit.dart';

@freezed
class EditLabelState with _$EditLabelState {
  const factory EditLabelState({
    @Default({}) Map<int, Correspondent> correspondents,
    @Default({}) Map<int, DocumentType> documentTypes,
    @Default({}) Map<int, Tag> tags,
    @Default({}) Map<int, StoragePath> storagePaths,
  }) = _EditLabelState;
}
