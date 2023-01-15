import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/state/impl/correspondent_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/document_type_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/tag_repository_state.dart';
import 'package:paperless_mobile/features/inbox/bloc/state/inbox_state.dart';

class InboxCubit extends HydratedCubit<InboxState> {
  final LabelRepository<Tag, TagRepositoryState> _tagsRepository;
  final LabelRepository<Correspondent, CorrespondentRepositoryState>
      _correspondentRepository;
  final LabelRepository<DocumentType, DocumentTypeRepositoryState>
      _documentTypeRepository;

  final PaperlessDocumentsApi _documentsApi;

  final List<StreamSubscription> _subscriptions = [];

  InboxCubit(
    this._tagsRepository,
    this._documentsApi,
    this._correspondentRepository,
    this._documentTypeRepository,
  ) : super(
          InboxState(
            availableCorrespondents:
                _correspondentRepository.current?.values ?? {},
            availableDocumentTypes:
                _documentTypeRepository.current?.values ?? {},
            availableTags: _tagsRepository.current?.values ?? {},
          ),
        ) {
    _subscriptions.add(
      _tagsRepository.values.listen((event) {
        if (event?.hasLoaded ?? false) {
          emit(state.copyWith(availableTags: event!.values));
        }
      }),
    );
    _subscriptions.add(
      _correspondentRepository.values.listen((event) {
        if (event?.hasLoaded ?? false) {
          emit(state.copyWith(
            availableCorrespondents: event!.values,
          ));
        }
      }),
    );
    _subscriptions.add(
      _documentTypeRepository.values.listen((event) {
        if (event?.hasLoaded ?? false) {
          emit(state.copyWith(availableDocumentTypes: event!.values));
        }
      }),
    );
  }

  ///
  /// Fetches inbox tag ids and loads the inbox items (documents).
  ///
  Future<void> initializeInbox() async {
    final inboxTags = await _tagsRepository.findAll().then(
          (tags) => tags.where((t) => t.isInboxTag ?? false).map((t) => t.id!),
        );
    if (inboxTags.isEmpty) {
      // no inbox tags = no inbox items.
      return emit(
        state.copyWith(
          isLoaded: true,
          inboxItems: [],
          inboxTags: [],
        ),
      );
    }
    final inboxDocuments = await _documentsApi
        .findAll(DocumentFilter(
          tags: AnyAssignedTagsQuery(tagIds: inboxTags),
          sortField: SortField.added,
        ))
        .then((psr) => psr.results);
    final newState = state.copyWith(
      isLoaded: true,
      inboxItems: inboxDocuments,
      inboxTags: inboxTags,
    );
    emit(newState);
  }

  ///
  /// Updates the document with all inbox tags removed and removes the document
  /// from the currently loaded inbox documents.
  ///
  Future<Iterable<int>> remove(DocumentModel document) async {
    final tagsToRemove =
        document.tags.toSet().intersection(state.inboxTags.toSet());

    final updatedTags = {...document.tags}..removeAll(tagsToRemove);

    await _documentsApi.update(
      document.copyWith(
        tags: updatedTags,
        overwriteTags: true,
      ),
    );
    emit(
      state.copyWith(
        isLoaded: true,
        inboxItems: state.inboxItems.where((doc) => doc.id != document.id),
      ),
    );

    return tagsToRemove;
  }

  ///
  /// Adds the previously removed tags to the document and performs an update.
  ///
  Future<void> undoRemove(
    DocumentModel document,
    Iterable<int> removedTags,
  ) async {
    final updatedDoc = document.copyWith(
      tags: {...document.tags, ...removedTags},
      overwriteTags: true,
    );
    await _documentsApi.update(updatedDoc);
    emit(state.copyWith(
      isLoaded: true,
      inboxItems: [...state.inboxItems, updatedDoc]
        ..sort((d1, d2) => d2.added.compareTo(d1.added)),
    ));
  }

  ///
  /// Removes inbox tags from all documents in the inbox.
  ///
  Future<void> clearInbox() async {
    await _documentsApi.bulkAction(
      BulkModifyTagsAction.removeTags(
        state.inboxItems.map((e) => e.id),
        state.inboxTags,
      ),
    );
    emit(state.copyWith(
      isLoaded: true,
      inboxItems: [],
    ));
  }

  void replaceUpdatedDocument(DocumentModel document) {
    if (document.tags.any((id) => state.inboxTags.contains(id))) {
      // If replaced document still has inbox tag assigned:
      emit(state.copyWith(
        inboxItems:
            state.inboxItems.map((e) => e.id == document.id ? document : e),
      ));
    } else {
      // Remove tag from inbox.
      emit(
        state.copyWith(
            inboxItems:
                state.inboxItems.where((element) => element.id != document.id)),
      );
    }
  }

  Future<void> assignAsn(DocumentModel document) async {
    if (document.archiveSerialNumber == null) {
      final int asn = await _documentsApi.findNextAsn();
      final updatedDocument = await _documentsApi
          .update(document.copyWith(archiveSerialNumber: asn));
      emit(
        state.copyWith(
            inboxItems: state.inboxItems
                .map((e) => e.id == document.id ? updatedDocument : e)),
      );
    }
  }

  Future<void> updateDocument(DocumentModel document) async {
    final updatedDocument = await _documentsApi.update(document);
    emit(
      state.copyWith(
        inboxItems: state.inboxItems.map(
          (e) => e.id == document.id ? updatedDocument : e,
        ),
      ),
    );
  }

  Future<void> deleteDocument(DocumentModel document) async {
    int deletedId = await _documentsApi.delete(document);
    emit(
      state.copyWith(
        inboxItems: state.inboxItems.where(
          (element) => element.id != deletedId,
        ),
      ),
    );
  }

  void loadSuggestions() {
    state.inboxItems
        .whereNot((doc) => state.suggestions.containsKey(doc.id))
        .map((e) => _documentsApi.findSuggestions(e))
        .forEach((suggestion) async {
      final s = await suggestion;
      emit(state.copyWith(
        suggestions: {...state.suggestions, s.documentId!: s},
      ));
    });
  }

  void acknowledgeHint() {
    emit(state.copyWith(isHintAcknowledged: true));
  }

  @override
  InboxState fromJson(Map<String, dynamic> json) {
    return InboxState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(InboxState state) {
    return state.toJson();
  }

  @override
  Future<void> close() {
    _subscriptions.forEach((element) {
      element.cancel();
    });
    return super.close();
  }
}
