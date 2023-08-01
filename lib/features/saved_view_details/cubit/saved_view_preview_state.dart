part of 'saved_view_preview_cubit.dart';

@freezed
class SavedViewPreviewState with _$SavedViewPreviewState {
  const factory SavedViewPreviewState.initial() = _Initial;
  const factory SavedViewPreviewState.loading() = _Loading;
  const factory SavedViewPreviewState.loaded({
    required List<DocumentModel> documents,
  }) = _Loaded;
  const factory SavedViewPreviewState.error() = _Error;
}
