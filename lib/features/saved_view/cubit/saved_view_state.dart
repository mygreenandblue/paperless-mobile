part of 'saved_view_cubit.dart';

class SavedViewState extends Equatable {
  final bool hasLoaded;
  final Map<int, SavedView> value;

  const SavedViewState({
    this.value = const {},
    this.hasLoaded = false,
  });

  @override
  List<Object?> get props => [
        hasLoaded,
        value,
      ];

  SavedViewState copyWith({
    Map<int, SavedView>? value,
    int? selectedSavedViewId,
    bool overwriteSelectedSavedViewId = false,
    bool? hasLoaded,
  }) {
    return SavedViewState(
      value: value ?? this.value,
      hasLoaded: hasLoaded ?? this.hasLoaded,
    );
  }
}
