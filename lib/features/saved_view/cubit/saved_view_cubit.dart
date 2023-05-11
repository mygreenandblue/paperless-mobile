import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository.dart';

part 'saved_view_state.dart';
part 'saved_view_cubit.freezed.dart';

class SavedViewCubit extends Cubit<SavedViewState> {
  final SavedViewRepository _savedViewRepository;

  SavedViewCubit(this._savedViewRepository) : super(const SavedViewState.initial()) {
    _savedViewRepository.addListener(
      this,
      onChanged: (views) {
        emit(
          state.maybeWhen(
            loaded: (savedViews) => (state as _SavedViewLoadedState).copyWith(
              savedViews: views.savedViews,
            ),
            orElse: () => state,
          ),
        );
      },
    );
  }

  Future<SavedView> add(SavedView view) async {
    return _savedViewRepository.create(view);
  }

  Future<int> remove(SavedView view) {
    return _savedViewRepository.delete(view);
  }

  Future<void> initialize() async {
    final views = await _savedViewRepository.findAll();
    final values = {for (var element in views) element.id!: element};
    if (!isClosed) {
      emit(
        SavedViewState.loaded(
          savedViews: values,
        ),
      );
    }
  }

  Future<void> reload() => initialize();

  @override
  Future<void> close() {
    _savedViewRepository.removeListener(this);
    return super.close();
  }
}
