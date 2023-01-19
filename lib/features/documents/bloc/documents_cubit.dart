import 'dart:async';
import 'dart:developer';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository.dart';
import 'package:paperless_mobile/features/documents/bloc/documents_state.dart';
import 'package:paperless_mobile/features/paged_document_view/documents_paging_mixin.dart';

class DocumentsCubit extends HydratedCubit<DocumentsState>
    with DocumentsPagingMixin {
  @override
  final PaperlessDocumentsApi api;

  final SavedViewRepository _savedViewRepository;

  DocumentsCubit(this.api, this._savedViewRepository)
      : super(const DocumentsState());

  Future<void> bulkRemove(List<DocumentModel> documents) async {
    log("[DocumentsCubit] bulkRemove");
    await api.bulkAction(
      BulkDeleteAction(documents.map((doc) => doc.id)),
    );
    await reload();
  }

  Future<void> bulkEditTags(
    Iterable<DocumentModel> documents, {
    Iterable<int> addTags = const [],
    Iterable<int> removeTags = const [],
  }) async {
    log("[DocumentsCubit] bulkEditTags");
    await api.bulkAction(BulkModifyTagsAction(
      documents.map((doc) => doc.id),
      addTags: addTags,
      removeTags: removeTags,
    ));
    await reload();
  }

  void toggleDocumentSelection(DocumentModel model) {
    log("[DocumentsCubit] toggleSelection");
    if (state.selectedIds.contains(model.id)) {
      emit(
        state.copyWith(
          selection: state.selection
              .where((element) => element.id != model.id)
              .toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(selection: [...state.selection, model]),
      );
    }
  }

  void resetSelection() {
    log("[DocumentsCubit] resetSelection");
    emit(state.copyWith(selection: []));
  }

  void reset() {
    log("[DocumentsCubit] reset");
    emit(const DocumentsState());
  }

  Future<void> selectView(int id) async {
    emit(state.copyWith(isLoading: true));
    try {
      final filter =
          _savedViewRepository.current?.values[id]?.toDocumentFilter();
      if (filter == null) {
        return;
      }
      final results = await api.findAll(filter.copyWith(page: 1));
      emit(
        DocumentsState(
          filter: filter,
          hasLoaded: true,
          isLoading: false,
          selectedSavedViewId: id,
          value: [results],
        ),
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<Iterable<String>> autocomplete(String query) async {
    final res = await api.autocomplete(query);
    return res;
  }

  void unselectView() {
    emit(state.copyWith(selectedSavedViewId: null));
  }

  @override
  DocumentsState? fromJson(Map<String, dynamic> json) {
    return DocumentsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(DocumentsState state) {
    return state.toJson();
  }
}
