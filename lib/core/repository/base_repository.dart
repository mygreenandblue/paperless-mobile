import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_mobile/core/repository/state/indexed_repository_state.dart';
import 'package:rxdart/subjects.dart';

///
/// Base repository class which all repositories should implement
///
abstract class BaseRepository<T> extends Cubit<IndexedRepositoryState<T>>
    with HydratedMixin {
  final IndexedRepositoryState<T> _initialState;

  BaseRepository(this._initialState) : super(_initialState) {
    hydrate();
  }

  Stream<IndexedRepositoryState<T>?> get values =>
      BehaviorSubject.seeded(state)..addStream(super.stream);

  IndexedRepositoryState<T>? get current => state;

  bool get isInitialized => state.hasLoaded;

  Future<T> create(T object);
  Future<T?> find(int id);
  Future<Iterable<T>> findAll([Iterable<int>? ids]);
  Future<T> update(T object);
  Future<int> delete(T object);

  @override
  Future<void> clear() async {
    await super.clear();
    emit(_initialState);
  }
}
