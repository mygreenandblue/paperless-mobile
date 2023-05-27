import 'dart:async';

import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/persistent_repository.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository_state.dart';

class SavedViewRepository extends PersistentRepository<SavedViewRepositoryState> {
  final PaperlessSavedViewsApi _api;

  SavedViewRepository(this._api) : super(const SavedViewRepositoryState()) {
    initialize();
  }

  Future<void> initialize() {
    return findAll();
  }

  Future<SavedView> create(SavedView object) async {
    final created = await _api.save(object);
    final updatedState = {...state.savedViews}..putIfAbsent(created.id!, () => created);
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
      final updatedState = {...state.savedViews}..update(id, (_) => found, ifAbsent: () => found);
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
  Future<void> clear() async {
    await super.clear();
    emit(const SavedViewRepositoryState());
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
