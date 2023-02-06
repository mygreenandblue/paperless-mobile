abstract class IndexedRepositoryState<T> {
  final Map<int, T>? values;
  final bool hasLoaded;

  const IndexedRepositoryState({
    required this.values,
    this.hasLoaded = false,
  }) : assert(!(values == null) || !hasLoaded);

  IndexedRepositoryState.loaded(this.values) : hasLoaded = true;

  IndexedRepositoryState<T> copyWith({
    Map<int, T>? values,
    bool? hasLoaded,
  });
}
