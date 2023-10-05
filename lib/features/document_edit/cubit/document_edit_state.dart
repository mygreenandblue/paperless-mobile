part of 'document_edit_cubit.dart';

@freezed
class DocumentEditState with _$DocumentEditState {
  const factory DocumentEditState({
    required DocumentModel document,
    FieldSuggestions? suggestions,
    @Default({}) Map<int, Correspondent> correspondents,
    @Default({}) Map<int, DocumentType> documentTypes,
    @Default({}) Map<int, StoragePath> storagePaths,
    @Default({}) Map<int, Tag> tags,
  }) = _DocumentEditState;
}
