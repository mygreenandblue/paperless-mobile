part of 'linked_documents_cubit.dart';

@JsonSerializable(ignoreUnannotated: true)
class LinkedDocumentsState extends DocumentPagingState {
  @JsonKey()
  final ViewType viewType;

  final Map<int, Correspondent> correspondents;
  final Map<int, DocumentType> documentTypes;
  final Map<int, StoragePath> storagePaths;
  final Map<int, Tag> tags;

  const LinkedDocumentsState({
    this.viewType = ViewType.list,
    super.filter,
    super.isLoading,
    super.hasLoaded,
    super.value,
    this.correspondents = const {},
    this.documentTypes = const {},
    this.storagePaths = const {},
    this.tags = const {},
  });

  LinkedDocumentsState copyWith({
    DocumentFilter? filter,
    bool? isLoading,
    bool? hasLoaded,
    List<PagedSearchResult<DocumentModel>>? value,
    ViewType? viewType,
    Map<int, Correspondent>? correspondents,
    Map<int, DocumentType>? documentTypes,
    Map<int, StoragePath>? storagePaths,
    Map<int, Tag>? tags,
  }) {
    return LinkedDocumentsState(
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      value: value ?? this.value,
      viewType: viewType ?? this.viewType,
      correspondents: correspondents ?? this.correspondents,
      documentTypes: documentTypes ?? this.documentTypes,
      storagePaths: storagePaths ?? this.storagePaths,
      tags: tags ?? this.tags,
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
        viewType,
        correspondents,
        documentTypes,
        tags,
        storagePaths,
        ...super.props,
      ];

  factory LinkedDocumentsState.fromJson(Map<String, dynamic> json) =>
      _$LinkedDocumentsStateFromJson(json);

  Map<String, dynamic> toJson() => _$LinkedDocumentsStateToJson(this);
}
