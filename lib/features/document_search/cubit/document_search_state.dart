import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/paged_document_view/model/paged_documents_state.dart';

part 'document_search_state.g.dart';

enum SearchView {
  suggestions,
  results;
}

@JsonSerializable(ignoreUnannotated: true)
class DocumentSearchState extends PagedDocumentsState {
  @JsonKey()
  final List<String> searchHistory;
  final SearchView view;
  final List<String> suggestions;
  const DocumentSearchState({
    this.view = SearchView.suggestions,
    this.searchHistory = const [],
    this.suggestions = const [],
    super.filter,
    super.hasLoaded,
    super.isLoading,
    super.value,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        searchHistory,
        suggestions,
        view,
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
  }) {
    return DocumentSearchState(
      value: value ?? this.value,
      filter: filter ?? this.filter,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      searchHistory: searchHistory ?? this.searchHistory,
      view: view ?? this.view,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  factory DocumentSearchState.fromJson(Map<String, dynamic> json) =>
      _$DocumentSearchStateFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSearchStateToJson(this);
}
