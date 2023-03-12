import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';

part 'document_bulk_action_state.dart';

class DocumentBulkActionCubit extends Cubit<DocumentBulkActionState> {
  final PaperlessDocumentsApi _documentsApi;
  final LabelRepository<Correspondent> _correspondentRepository;
  final LabelRepository<DocumentType> _documentTypeRepository;
  final LabelRepository<Tag> _tagRepository;
  final LabelRepository<StoragePath> _storagePathRepository;
  final DocumentChangedNotifier _notifier;

  final List<StreamSubscription> _subscriptions = [];

  DocumentBulkActionCubit(
    this._documentsApi,
    this._correspondentRepository,
    this._documentTypeRepository,
    this._tagRepository,
    this._storagePathRepository,
    this._notifier, {
    required List<DocumentModel> selection,
  }) : super(
          DocumentBulkActionState(
            selection: selection,
            correspondentOptions:
                (_correspondentRepository.current?.hasLoaded ?? false)
                    ? _correspondentRepository.current!.values!
                    : {},
            tagOptions: (_tagRepository.current?.hasLoaded ?? false)
                ? _tagRepository.current!.values!
                : {},
            documentTypeOptions:
                (_documentTypeRepository.current?.hasLoaded ?? false)
                    ? _documentTypeRepository.current!.values!
                    : {},
            storagePathOptions:
                (_storagePathRepository.current?.hasLoaded ?? false)
                    ? _storagePathRepository.current!.values!
                    : {},
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
    _subscriptions.add(
      _tagRepository.values.listen((event) {
        if (event?.hasLoaded ?? false) {
          emit(state.copyWith(tagOptions: event!.values));
        }
      }),
    );
    _subscriptions.add(
      _correspondentRepository.values.listen((event) {
        if (event?.hasLoaded ?? false) {
          emit(state.copyWith(
            correspondentOptions: event!.values,
          ));
        }
      }),
    );
    _subscriptions.add(
      _documentTypeRepository.values.listen((event) {
        if (event?.hasLoaded ?? false) {
          emit(state.copyWith(documentTypeOptions: event!.values));
        }
      }),
    );
    _subscriptions.add(
      _storagePathRepository.values.listen((event) {
        if (event?.hasLoaded ?? false) {
          emit(state.copyWith(storagePathOptions: event!.values));
        }
      }),
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
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    return super.close();
  }
}
