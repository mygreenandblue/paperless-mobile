part of 'documents_cubit.dart';

@JsonSerializable()
class DocumentsState extends PagedDocumentsState {
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<DocumentModel> selection;

  final ViewType viewType;

  const DocumentsState({
    this.selection = const [],
    this.viewType = ViewType.list,
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
    ViewType? viewType,
  }) {
    return DocumentsState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      value: value ?? this.value,
      filter: filter ?? this.filter,
      selection: selection ?? this.selection,
      viewType: viewType ?? this.viewType,
    );
  }

  factory DocumentsState.fromJson(Map<String, dynamic> json) =>
      _$DocumentsStateFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentsStateToJson(this);

  @override
  List<Object?> get props => [
        selection,
        viewType,
        ...super.props,
      ];

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
