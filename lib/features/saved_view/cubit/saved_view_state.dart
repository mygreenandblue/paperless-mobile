part of 'saved_view_cubit.dart';

@freezed
class SavedViewState with _$SavedViewState {
  const factory SavedViewState.initial() = _SavedViewIntialState;

  const factory SavedViewState.loading() = _SavedViewLoadingState;

  const factory SavedViewState.loaded({required Map<int, SavedView> savedViews}) =
      _SavedViewLoadedState;

  const factory SavedViewState.error() = _SavedViewErrorState;
}
