import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';

import 'model/paged_documents_state.dart';

///
/// Mixin which can be used on cubits that handle documents.
/// This implements all paging and filtering logic.
///
mixin PagedDocumentsMixin<State extends PagedDocumentsState>
    on BlocBase<State> {
  PaperlessDocumentsApi get api;
  DocumentChangedNotifier get notifier;

  Future<void> loadMore() async {
    if (state.isLastPageLoaded) {
      return;
    }
    emit(state.copyWithPaged(isLoading: true));
    final newFilter = state.filter.copyWith(page: state.filter.page + 1);
    try {
      final result = await api.findAll(newFilter);
      emit(state.copyWithPaged(
        hasLoaded: true,
        filter: newFilter,
        value: [...state.value, result],
      ));
    } finally {
      emit(state.copyWithPaged(isLoading: false));
    }
  }

  ///
  /// Updates document filter and automatically reloads documents. Always resets page to 1.
  /// Use [loadMore] to load more data.
  Future<void> updateFilter({
    final DocumentFilter filter = DocumentFilter.initial,
  }) async {
    try {
      emit(state.copyWithPaged(isLoading: true));
      final result = await api.findAll(filter.copyWith(page: 1));

      emit(state.copyWithPaged(
        filter: filter,
        value: [result],
        hasLoaded: true,
      ));
    } finally {
      emit(state.copyWithPaged(isLoading: false));
    }
  }

  ///
  /// Convenience method which allows to directly use [DocumentFilter.copyWith] on the current filter.
  ///
  Future<void> updateCurrentFilter(
    final DocumentFilter Function(DocumentFilter) transformFn,
  ) async =>
      updateFilter(filter: transformFn(state.filter));

  Future<void> resetFilter() {
    final filter = DocumentFilter.initial.copyWith(
      sortField: state.filter.sortField,
      sortOrder: state.filter.sortOrder,
    );
    return updateFilter(filter: filter);
  }

  Future<void> reload() async {
    emit(state.copyWithPaged(isLoading: true));
    try {
      final filter = state.filter.copyWith(page: 1);
      final result = await api.findAll(filter);
      emit(state.copyWithPaged(
        hasLoaded: true,
        value: [result],
        isLoading: false,
        filter: filter,
      ));
    } finally {
      emit(state.copyWithPaged(isLoading: false));
    }
  }

  ///
  /// Updates a document. If [shouldReload] is false, the updated document will
  /// replace the currently loaded one, otherwise all documents will be reloaded.
  ///
  Future<void> update(
    DocumentModel document, {
    bool shouldReload = true,
  }) async {
    final updatedDocument = await api.update(document);
    if (shouldReload) {
      await reload();
    } else {
      replace(updatedDocument);
    }
  }

  ///
  /// Deletes a document and removes it from the currently loaded state.
  ///
  Future<void> delete(DocumentModel document) async {
    emit(state.copyWithPaged(isLoading: true));
    try {
      await api.delete(document);
      await remove(document);
    } finally {
      emit(state.copyWithPaged(isLoading: false));
    }
  }

  ///
  /// Removes [document] from the currently loaded state.
  /// Does not delete it from the server!
  ///
  Future<void> remove(DocumentModel document) async {
    final index = state.value.indexWhere(
      (page) => page.results.any((element) => element.id == document.id),
    );
    if (index != -1) {
      final foundPage = state.value[index];
      final replacementPage = foundPage.copyWith(
        results: foundPage.results
          ..removeWhere((element) => element.id == document.id),
      );
      final newCount = foundPage.count - 1;
      emit(
        state.copyWithPaged(
          value: state.value
              .mapIndexed(
                (currIndex, element) =>
                    (currIndex == index ? replacementPage : element)
                        .copyWith(count: newCount),
              )
              .toList(),
        ),
      );
    }
  }

  ///
  /// Replaces the document with the same id as [document] from the currently
  /// loaded state.
  ///
  Future<void> replace(DocumentModel document) async {
    final index = state.value.indexWhere(
      (page) => page.results.any((element) => element.id == document.id),
    );
    if (index != -1) {
      final foundPage = state.value[index];
      final replacementPage = foundPage.copyWith(
        results: foundPage.results..replaceRange(index, index + 1, [document]),
      );
      emit(state.copyWithPaged(
        value: state.value
            .mapIndexed((currIndex, element) =>
                currIndex == index ? replacementPage : element)
            .toList(),
      ));
    }
  }
}
