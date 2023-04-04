import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository_state.dart';

class SavedViewRepository extends HydratedCubit<SavedViewRepositoryState> {
  final PaperlessSavedViewsApi _api;
  final Map<Object, StreamSubscription> _subscribers = {};

  void subscribe(
    Object source,
    void Function(Map<int, SavedView>) onChanged,
  ) {
    _subscribers.putIfAbsent(source, () {
      onChanged(state.savedViews);
      return stream.listen((event) => onChanged(event.savedViews));
    });
  }

  void unsubscribe(Object source) async {
    await _subscribers[source]?.cancel();
    _subscribers.remove(source);
  }

  SavedViewRepository(this._api) : super(const SavedViewRepositoryState());

  Future<SavedView> create(SavedView object) async {
    final created = await _api.save(object);
    final updatedState = {...state.savedViews}
      ..putIfAbsent(created.id!, () => created);
    emit(state.copyWith(savedViews: updatedState));
    return created;
  }

  Future<int> delete(SavedView view) async {
    await _api.delete(view);
    final updatedState = {...state.savedViews}..remove(view.id);
    emit(state.copyWith(savedViews: updatedState));
    return view.id!;
  }

  Future<SavedView?> find(int id) async {
    final found = await _api.find(id);
    if (found != null) {
      final updatedState = {...state.savedViews}
        ..update(id, (_) => found, ifAbsent: () => found);
      emit(state.copyWith(savedViews: updatedState));
    }
    return found;
  }

  Future<Iterable<SavedView>> findAll([Iterable<int>? ids]) async {
    final found = await _api.findAll(ids);
    final updatedState = {
      ...state.savedViews,
      ...{for (final view in found) view.id!: view},
    };
    emit(state.copyWith(savedViews: updatedState));
    return found;
  }

  @override
  Future<void> close() {
    _subscribers.forEach((key, subscription) {
      subscription.cancel();
    });
    return super.close();
  }

  @override
  SavedViewRepositoryState? fromJson(Map<String, dynamic> json) {
    return SavedViewRepositoryState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SavedViewRepositoryState state) {
    return state.toJson();
  }
}
