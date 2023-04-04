part of 'document_bulk_action_cubit.dart';

@freezed
class DocumentBulkActionState with _$DocumentBulkActionState {
  const DocumentBulkActionState._();
  const factory DocumentBulkActionState({
    required List<DocumentModel> selection,
    required Map<int, Correspondent> correspondents,
    required Map<int, DocumentType> documentTypes,
    required Map<int, Tag> tags,
    required Map<int, StoragePath> storagePaths,
  }) = _DocumentBulkActionState;

  Iterable<int> get selectedIds => selection.map((d) => d.id);
}
