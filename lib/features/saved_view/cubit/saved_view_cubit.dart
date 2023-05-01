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
  final LabelRepository _labelRepository;

  SavedViewCubit(this._savedViewRepository, this._labelRepository)
      : super(
          SavedViewState.initial(
            correspondents: _labelRepository.state.correspondents,
            documentTypes: _labelRepository.state.documentTypes,
            storagePaths: _labelRepository.state.storagePaths,
            tags: _labelRepository.state.tags,
          ),
        ) {
    _labelRepository.addListener(
      this,
      onChanged: (labels) {
        emit(
          state.copyWith(
            correspondents: labels.correspondents,
            documentTypes: labels.documentTypes,
            tags: labels.tags,
            storagePaths: labels.storagePaths,
          ),
        );
      },
    );

    _savedViewRepository.addListener(
      this,
      onChanged: (views) {
        emit(
          state.maybeWhen(
            loaded: (savedViews, correspondents, documentTypes, tags, storagePaths) =>
                (state as _SavedViewLoadedState).copyWith(
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
      emit(SavedViewState.loaded(
        savedViews: values,
        correspondents: state.correspondents,
        documentTypes: state.documentTypes,
        storagePaths: state.storagePaths,
        tags: state.tags,
      ));
    }
  }

  Future<void> reload() => initialize();

  @override
  Future<void> close() {
    _savedViewRepository.removeListener(this);
    _labelRepository.removeListener(this);
    return super.close();
  }
}
