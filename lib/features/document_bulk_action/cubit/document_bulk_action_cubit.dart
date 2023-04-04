import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_bulk_action_state.dart';
part 'document_bulk_action_cubit.freezed.dart';

class DocumentBulkActionCubit extends Cubit<DocumentBulkActionState> {
  final PaperlessDocumentsApi _documentsApi;
  final LabelRepository _labelRepository;
  final DocumentChangedNotifier _notifier;

  DocumentBulkActionCubit(
    this._documentsApi,
    this._labelRepository,
    this._notifier, {
    required List<DocumentModel> selection,
  }) : super(
          DocumentBulkActionState(
            selection: selection,
            correspondents: _labelRepository.state.correspondents,
            documentTypes: _labelRepository.state.documentTypes,
            storagePaths: _labelRepository.state.storagePaths,
            tags: _labelRepository.state.tags,
          ),
        ) {
    _notifier.subscribe(
      this,
      onDeleted: (document) {
        // Remove items from internal selection after the document was deleted.
        emit(
          state.copyWith(
            selection: state.selection
                .whereNot((element) => element.id == document.id)
                .toList(),
          ),
        );
      },
    );
    _labelRepository.subscribe(
      this,
      onChanged: (labels) {
        emit(
          state.copyWith(
            correspondents: labels.correspondents,
            documentTypes: labels.documentTypes,
            storagePaths: labels.storagePaths,
            tags: labels.tags,
          ),
        );
      },
    );
  }

  Future<void> bulkDelete() async {
    final deletedDocumentIds = await _documentsApi.bulkAction(
      BulkDeleteAction(state.selection.map((e) => e.id).toList()),
    );
    final deletedDocuments = state.selection
        .where((element) => deletedDocumentIds.contains(element.id));
    for (final doc in deletedDocuments) {
      _notifier.notifyUpdated(doc);
    }
  }

  Future<void> bulkModifyCorrespondent(int? correspondentId) async {
    final modifiedDocumentIds = await _documentsApi.bulkAction(
      BulkModifyLabelAction.correspondent(
        state.selectedIds,
        labelId: correspondentId,
      ),
    );
    final updatedDocuments = state.selection
        .where((element) => modifiedDocumentIds.contains(element.id))
        .map((doc) => doc.copyWith(correspondent: () => correspondentId));
    for (final doc in updatedDocuments) {
      _notifier.notifyUpdated(doc);
    }
  }

  Future<void> bulkModifyDocumentType(int? documentTypeId) async {
    final modifiedDocumentIds = await _documentsApi.bulkAction(
      BulkModifyLabelAction.documentType(
        state.selectedIds,
        labelId: documentTypeId,
      ),
    );
    final updatedDocuments = state.selection
        .where((element) => modifiedDocumentIds.contains(element.id))
        .map((doc) => doc.copyWith(documentType: () => documentTypeId));
    for (final doc in updatedDocuments) {
      _notifier.notifyUpdated(doc);
    }
  }

  Future<void> bulkModifyStoragePath(int? storagePathId) async {
    final modifiedDocumentIds = await _documentsApi.bulkAction(
      BulkModifyLabelAction.storagePath(
        state.selectedIds,
        labelId: storagePathId,
      ),
    );
    final updatedDocuments = state.selection
        .where((element) => modifiedDocumentIds.contains(element.id))
        .map((doc) => doc.copyWith(storagePath: () => storagePathId));
    for (final doc in updatedDocuments) {
      _notifier.notifyUpdated(doc);
    }
  }

  Future<void> bulkModifyTags({
    Iterable<int> addTagIds = const [],
    Iterable<int> removeTagIds = const [],
  }) async {
    final modifiedDocumentIds = await _documentsApi.bulkAction(
      BulkModifyTagsAction(
        state.selectedIds,
        addTags: addTagIds,
        removeTags: removeTagIds,
      ),
    );
    final updatedDocuments = state.selection
        .where((element) => modifiedDocumentIds.contains(element.id))
        .map(
          (doc) => doc.copyWith(
            tags: [
              ...doc.tags.toSet().difference(addTagIds.toSet()),
              ...addTagIds
            ],
          ),
        );
    for (final doc in updatedDocuments) {
      _notifier.notifyUpdated(doc);
    }
  }

  @override
  Future<void> close() {
    _notifier.unsubscribe(this);
    _labelRepository.unsubscribe(this);
    return super.close();
  }
}
