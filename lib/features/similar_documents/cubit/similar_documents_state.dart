part of 'similar_documents_cubit.dart';

class SimilarDocumentsState extends DocumentPagingState {
  const SimilarDocumentsState({
    super.filter,
    super.hasLoaded,
    super.isLoading,
    super.value,
  });

  @override
  List<Object> get props => [
        filter,
        hasLoaded,
        isLoading,
        value,
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
  }) {
    return SimilarDocumentsState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      value: value ?? this.value,
      filter: filter ?? this.filter,
    );
  }
}
