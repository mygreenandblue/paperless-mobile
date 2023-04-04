part of 'document_edit_cubit.dart';

@freezed
class DocumentEditState with _$DocumentEditState {
  const factory DocumentEditState({
    required DocumentModel document,
    required Map<int, Correspondent> correspondents,
    required Map<int, DocumentType> documentTypes,
    required Map<int, StoragePath> storagePaths,
    required Map<int, Tag> tags,
  }) = _DocumentEditState;
}
