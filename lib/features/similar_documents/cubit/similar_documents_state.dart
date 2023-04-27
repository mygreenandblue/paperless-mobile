part of 'similar_documents_cubit.dart';

class SimilarDocumentsState extends DocumentPagingState {
  final Map<int, Correspondent> correspondents;
  final Map<int, DocumentType> documentTypes;
  final Map<int, Tag> tags;
  final Map<int, StoragePath> storagePaths;

  const SimilarDocumentsState({
    required super.filter,
    super.hasLoaded,
    super.isLoading,
    super.value,
    this.correspondents = const {},
    this.documentTypes = const {},
    this.tags = const {},
    this.storagePaths = const {},
  });

  @override
  List<Object> get props => [
        filter,
        hasLoaded,
        isLoading,
        value,
        correspondents,
        documentTypes,
        tags,
        storagePaths,
      ];

  @override
  SimilarDocumentsState copyWithPaged({
    bool? hasLoaded,
    bool? isLoading,
    List<PagedSearchResult<DocumentModel>>? value,
    DocumentFilter? filter,
  }) {
    return copyWith(
      hasLoaded: hasLoaded,
      isLoading: isLoading,
      value: value,
      filter: filter,
    );
  }

  SimilarDocumentsState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    List<PagedSearchResult<DocumentModel>>? value,
    DocumentFilter? filter,
    Map<int, Correspondent>? correspondents,
    Map<int, DocumentType>? documentTypes,
    Map<int, Tag>? tags,
    Map<int, StoragePath>? storagePaths,
  }) {
    return SimilarDocumentsState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      value: value ?? this.value,
      filter: filter ?? this.filter,
      correspondents: correspondents ?? this.correspondents,
      documentTypes: documentTypes ?? this.documentTypes,
      tags: tags ?? this.tags,
      storagePaths: storagePaths ?? this.storagePaths,
    );
  }
}
