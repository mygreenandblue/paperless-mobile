import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/features/documents/bloc/documents_state.dart';
import 'package:paperless_mobile/features/paged_document_view/paged_documents_mixin.dart';

class DocumentsCubit extends HydratedCubit<DocumentsState>
    with PagedDocumentsMixin {
  @override
  final PaperlessDocumentsApi api;

  @override
  final DocumentChangedNotifier notifier;

  DocumentsCubit(this.api, this.notifier) : super(const DocumentsState()) {
    notifier.subscribe(
      this,
      onUpdated: replace,
      onDeleted: remove,
    );
  }

  Future<void> bulkDelete(List<DocumentModel> documents) async {
    debugPrint("[DocumentsCubit] bulkRemove");
    await api.bulkAction(
      BulkDeleteAction(documents.map((doc) => doc.id)),
    );
    for (final deletedDoc in documents) {
      notifier.notifyDeleted(deletedDoc);
    }
    await reload();
  }

  Future<void> bulkEditTags(
    Iterable<DocumentModel> documents, {
    Iterable<int> addTags = const [],
    Iterable<int> removeTags = const [],
  }) async {
    debugPrint("[DocumentsCubit] bulkEditTags");
    await api.bulkAction(BulkModifyTagsAction(
      documents.map((doc) => doc.id),
      addTags: addTags,
      removeTags: removeTags,
    ));
    await reload();
  }

  void toggleDocumentSelection(DocumentModel model) {
    debugPrint("[DocumentsCubit] toggleSelection");
    if (state.selectedIds.contains(model.id)) {
      emit(
        state.copyWith(
          selection: state.selection
              .where((element) => element.id != model.id)
              .toList(),
        ),
      );
    } else {
      emit(state.copyWith(selection: [...state.selection, model]));
    }
  }

  void resetSelection() {
    debugPrint("[DocumentsCubit] resetSelection");
    emit(state.copyWith(selection: []));
  }

  void reset() {
    debugPrint("[DocumentsCubit] reset");
    emit(const DocumentsState());
  }

  Future<Iterable<String>> autocomplete(String query) async {
    final res = await api.autocomplete(query);
    return res;
  }

  @override
  DocumentsState? fromJson(Map<String, dynamic> json) {
    return DocumentsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(DocumentsState state) {
    return state.toJson();
  }

  @override
  Future<void> close() {
    notifier.unsubscribe(this);
    return super.close();
  }
}
