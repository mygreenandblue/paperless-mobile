part of 'document_search_cubit.dart';

enum SearchView {
  suggestions,
  results;
}

@JsonSerializable(ignoreUnannotated: true)
class DocumentSearchState extends DocumentPagingState {
  @JsonKey()
  final List<String> searchHistory;
  final SearchView view;
  final List<String> suggestions;
  @JsonKey()
  final ViewType viewType;

  final Map<int, Correspondent> correspondents;
  final Map<int, DocumentType> documentTypes;
  final Map<int, Tag> tags;
  final Map<int, StoragePath> storagePaths;

  const DocumentSearchState({
    this.view = SearchView.suggestions,
    this.searchHistory = const [],
    this.suggestions = const [],
    this.viewType = ViewType.detailed,
    super.filter,
    super.hasLoaded,
    super.isLoading,
    super.value,
    this.correspondents = const {},
    this.documentTypes = const {},
    this.tags = const {},
    this.storagePaths = const {},
  });

  @override
  List<Object?> get props => [
        ...super.props,
        searchHistory,
        suggestions,
        view,
        viewType,
        correspondents,
        documentTypes,
        tags,
        storagePaths,
      ];

  @override
  DocumentSearchState copyWithPaged({
    bool? hasLoaded,
    bool? isLoading,
    List<PagedSearchResult<DocumentModel>>? value,
    DocumentFilter? filter,
  }) {
    return copyWith(
      hasLoaded: hasLoaded,
      isLoading: isLoading,
      filter: filter,
      value: value,
    );
  }

  DocumentSearchState copyWith({
    List<String>? searchHistory,
    bool? hasLoaded,
    bool? isLoading,
    List<PagedSearchResult<DocumentModel>>? value,
    DocumentFilter? filter,
    List<String>? suggestions,
    SearchView? view,
    ViewType? viewType,
    Map<int, Correspondent>? correspondents,
    Map<int, DocumentType>? documentTypes,
    Map<int, Tag>? tags,
    Map<int, StoragePath>? storagePaths,
  }) {
    return DocumentSearchState(
      value: value ?? this.value,
      filter: filter ?? this.filter,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      searchHistory: searchHistory ?? this.searchHistory,
      view: view ?? this.view,
      suggestions: suggestions ?? this.suggestions,
      viewType: viewType ?? this.viewType,
      correspondents: correspondents ?? this.correspondents,
      documentTypes: documentTypes ?? this.documentTypes,
      tags: tags ?? this.tags,
      storagePaths: storagePaths ?? this.storagePaths,
    );
  }

  factory DocumentSearchState.fromJson(Map<String, dynamic> json) =>
      _$DocumentSearchStateFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSearchStateToJson(this);
}
