part of 'saved_view_cubit.dart';

@freezed
class SavedViewState with _$SavedViewState {
  const factory SavedViewState.initial({
    required Map<int, Correspondent> correspondents,
    required Map<int, DocumentType> documentTypes,
    required Map<int, Tag> tags,
    required Map<int, StoragePath> storagePaths,
  }) = _SavedViewIntialState;

  const factory SavedViewState.loading({
    required Map<int, Correspondent> correspondents,
    required Map<int, DocumentType> documentTypes,
    required Map<int, Tag> tags,
    required Map<int, StoragePath> storagePaths,
  }) = _SavedViewLoadingState;

  const factory SavedViewState.loaded({
    required Map<int, SavedView> savedViews,
    required Map<int, Correspondent> correspondents,
    required Map<int, DocumentType> documentTypes,
    required Map<int, Tag> tags,
    required Map<int, StoragePath> storagePaths,
  }) = _SavedViewLoadedState;

  const factory SavedViewState.error({
    required Map<int, Correspondent> correspondents,
    required Map<int, DocumentType> documentTypes,
    required Map<int, Tag> tags,
    required Map<int, StoragePath> storagePaths,
  }) = _SavedViewErrorState;
}
