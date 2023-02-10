part of 'linked_documents_cubit.dart';


class LinkedDocumentsState extends PagedDocumentsState {
  const LinkedDocumentsState({
    super.filter,
    super.isLoading,
    super.hasLoaded,
    super.value,
  });

  LinkedDocumentsState copyWith({
    DocumentFilter? filter,
    bool? isLoading,
    bool? hasLoaded,
    List<PagedSearchResult<DocumentModel>>? value,
  }) {
    return LinkedDocumentsState(
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      value: value ?? this.value,
    );
  }

  @override
  LinkedDocumentsState copyWithPaged({
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

  @override
  List<Object?> get props => [
        filter,
        isLoading,
        hasLoaded,
        value,
      ];
}
