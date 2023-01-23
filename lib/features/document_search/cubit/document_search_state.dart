import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/paged_document_view/model/documents_paged_state.dart';

part 'document_search_state.g.dart';



@JsonSerializable(ignoreUnannotated: true)
class DocumentSearchState extends DocumentsPagedState {
  @JsonKey()
  final List<String> searchHistory;

  final List<String> suggestions;

  const DocumentSearchState({
    this.searchHistory = const [],
    this.suggestions = const [],
    super.filter,
    super.hasLoaded,
    super.isLoading,
    super.value,
  });

  @override
  List<Object> get props => [
        hasLoaded,
        isLoading,
        filter,
        value,
        searchHistory,
        suggestions,
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
  }) {
    return DocumentSearchState(
      value: value ?? this.value,
      filter: filter ?? this.filter,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      searchHistory: searchHistory ?? this.searchHistory,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  factory DocumentSearchState.fromJson(Map<String, dynamic> json) =>
      _$DocumentSearchStateFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSearchStateToJson(this);
}

class 
