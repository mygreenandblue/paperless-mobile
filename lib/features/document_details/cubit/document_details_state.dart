part of 'document_details_cubit.dart';

@freezed
class DocumentDetailsState with _$DocumentDetailsState {
  const factory DocumentDetailsState({
    required DocumentModel document,
    DocumentMetaData? metaData,
    @Default(false) bool isFullContentLoaded,
    String? fullContent,
    FieldSuggestions? suggestions,
    @Default({}) Map<int, Correspondent> correspondents,
    @Default({}) Map<int, DocumentType> documentTypes,
    @Default({}) Map<int, Tag> tags,
    @Default({}) Map<int, StoragePath> storagePaths,
  }) = _DocumentDetailsState;
}
