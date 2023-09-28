import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';

part 'saved_view_preview_state.dart';
part 'saved_view_preview_cubit.freezed.dart';

class SavedViewPreviewCubit extends Cubit<SavedViewPreviewState> {
  final PaperlessDocumentsApi _api;
  final SavedView view;
  final ConnectivityStatusService _connectivityStatusService;
  SavedViewPreviewCubit(
    this._api,
    this._connectivityStatusService, {
    required this.view,
  }) : super(const InitialSavedViewPreviewState());

  Future<void> initialize() async {
    final isConnected =
        await _connectivityStatusService.isConnectedToInternet();
    if (!isConnected) {
      emit(const OfflineSavedViewPreviewState());
      return;
    }
    emit(const LoadingSavedViewPreviewState());
    try {
      final documents = await _api.findAll(
        view.toDocumentFilter().copyWith(
              page: 1,
              pageSize: 5,
            ),
      );
      emit(LoadedSavedViewPreviewState(documents: documents.results));
    } catch (e) {
      emit(const ErrorSavedViewPreviewState());
    }
  }
}
