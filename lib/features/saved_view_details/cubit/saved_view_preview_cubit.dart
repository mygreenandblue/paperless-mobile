import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/paperless_api.dart';

part 'saved_view_preview_state.dart';
part 'saved_view_preview_cubit.freezed.dart';

class SavedViewPreviewCubit extends Cubit<SavedViewPreviewState> {
  final PaperlessDocumentsApi _api;
  final SavedView view;
  SavedViewPreviewCubit(this._api, this.view)
      : super(const SavedViewPreviewState.initial());

  Future<void> initialize() async {
    emit(const SavedViewPreviewState.loading());
    try {
      final documents = await _api.findAll(
        view.toDocumentFilter().copyWith(
              page: 1,
              pageSize: 5,
            ),
      );
      emit(SavedViewPreviewState.loaded(documents: documents.results));
    } catch (e) {
      emit(const SavedViewPreviewState.error());
    }
  }
}
