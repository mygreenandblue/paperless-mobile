import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/paged_document_view/model/paged_documents_state.dart';

class DocumentsState extends PagedDocumentsState {
  final int? selectedSavedViewId;

  @JsonKey(ignore: true)
  final List<DocumentModel> selection;

  const DocumentsState({
    this.selection = const [],
    this.selectedSavedViewId,
    super.value = const [],
    super.filter = const DocumentFilter(),
    super.hasLoaded = false,
    super.isLoading = false,
  });

  List<int> get selectedIds => selection.map((e) => e.id).toList();

  DocumentsState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    List<PagedSearchResult<DocumentModel>>? value,
    DocumentFilter? filter,
    List<DocumentModel>? selection,
    int? Function()? selectedSavedViewId,
  }) {
    return DocumentsState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      value: value ?? this.value,
      filter: filter ?? this.filter,
      selection: selection ?? this.selection,
      selectedSavedViewId: selectedSavedViewId != null
          ? selectedSavedViewId.call()
          : this.selectedSavedViewId,
    );
  }

  @override
  List<Object?> get props => [
        hasLoaded,
        filter,
        value,
        selection,
        isLoading,
        selectedSavedViewId,
      ];

  Map<String, dynamic> toJson() {
    final json = {
      'hasLoaded': hasLoaded,
      'isLoading': isLoading,
      'filter': filter.toJson(),
      'selectedSavedViewId': selectedSavedViewId,
      'value':
          value.map((e) => e.toJson(DocumentModelJsonConverter())).toList(),
    };
    return json;
  }

  factory DocumentsState.fromJson(Map<String, dynamic> json) {
    return DocumentsState(
      hasLoaded: json['hasLoaded'],
      isLoading: json['isLoading'],
      selectedSavedViewId: json['selectedSavedViewId'],
      value: (json['value'] as List<dynamic>)
          .map((e) =>
              PagedSearchResult.fromJsonT(e, DocumentModelJsonConverter()))
          .toList(),
      filter: DocumentFilter.fromJson(json['filter']),
    );
  }

  @override
  DocumentsState copyWithPaged({
    bool? hasLoaded,
    bool? isLoading,
    List<PagedSearchResult<DocumentModel>>? value,
    DocumentFilter? filter,
  }) {
    return copyWith(
      filter: filter,
      hasLoaded: hasLoaded,
      isLoading: isLoading,
      value: value,
    );
  }
}
