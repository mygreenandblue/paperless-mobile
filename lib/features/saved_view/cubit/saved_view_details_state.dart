part of 'saved_view_details_cubit.dart';

class SavedViewDetailsState extends PagedDocumentsState {
  const SavedViewDetailsState({
    super.filter,
    super.hasLoaded,
    super.isLoading,
    super.value,
  });

  @override
  List<Object?> get props => [
        filter,
        hasLoaded,
        isLoading,
        value,
      ];

  @override
  SavedViewDetailsState copyWithPaged({
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

  SavedViewDetailsState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    List<PagedSearchResult<DocumentModel>>? value,
    DocumentFilter? filter,
  }) {
    return SavedViewDetailsState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      value: value ?? this.value,
      filter: filter ?? this.filter,
    );
  }
}
