part of 'saved_view_details_cubit.dart';

@JsonSerializable(ignoreUnannotated: true)
class SavedViewDetailsState extends PagedDocumentsState {
  @JsonKey()
  final ViewType viewType;

  const SavedViewDetailsState({
    this.viewType = ViewType.list,
    super.filter,
    super.hasLoaded,
    super.isLoading,
    super.value,
  });

  @override
  List<Object?> get props => [
        viewType,
        ...super.props,
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
    ViewType? viewType,
  }) {
    return SavedViewDetailsState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      value: value ?? this.value,
      filter: filter ?? this.filter,
      viewType: viewType ?? this.viewType,
    );
  }

  factory SavedViewDetailsState.fromJson(Map<String, dynamic> json) =>
      _$SavedViewDetailsStateFromJson(json);

  Map<String, dynamic> toJson() => _$SavedViewDetailsStateToJson(this);
}
