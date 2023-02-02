import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/state/impl/correspondent_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/document_type_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/tag_repository_state.dart';
import 'package:paperless_mobile/features/inbox/bloc/state/inbox_state.dart';
import 'package:paperless_mobile/features/paged_document_view/paged_documents_mixin.dart';

class InboxCubit extends HydratedCubit<InboxState> with PagedDocumentsMixin {
  final LabelRepository<Tag, TagRepositoryState> _tagsRepository;
  final LabelRepository<Correspondent, CorrespondentRepositoryState>
      _correspondentRepository;
  final LabelRepository<DocumentType, DocumentTypeRepositoryState>
      _documentTypeRepository;

  final PaperlessDocumentsApi _documentsApi;

  final PaperlessServerStatsApi _statsApi;

  final List<StreamSubscription> _subscriptions = [];

  @override
  PaperlessDocumentsApi get api => _documentsApi;

  Timer? _taskTimer;
  InboxCubit(
    this._tagsRepository,
    this._documentsApi,
    this._correspondentRepository,
    this._documentTypeRepository,
    this._statsApi,
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
    //TODO: Do this properly in a background task.
    _taskTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      refreshItemsInInboxCount();
    });
  }

  void refreshItemsInInboxCount() async {
    final stats = await _statsApi.getServerStatistics();
    emit(state.copyWith(itemsInInboxCount: stats.documentsInInbox));
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
          hasLoaded: true,
          value: [],
          inboxTags: [],
        ),
      );
    }
    emit(state.copyWith(inboxTags: inboxTags));
    return updateFilter(
      filter: DocumentFilter(
        sortField: SortField.added,
        tags: IdsTagsQuery.fromIds(inboxTags),
      ),
    );
  }

  ///
  /// Updates the document with all inbox tags removed and removes the document
  /// from the inbox.
  ///
  Future<Iterable<int>> removeFromInbox(DocumentModel document) async {
    final tagsToRemove =
        document.tags.toSet().intersection(state.inboxTags.toSet());

    final updatedTags = {...document.tags}..removeAll(tagsToRemove);
    await api.update(
      document.copyWith(tags: updatedTags),
    );
    await remove(document);
    return tagsToRemove;
  }

  ///
  /// Adds the previously removed tags to the document and performs an update.
  ///
  Future<void> undoRemoveFromInbox(
    DocumentModel document,
    Iterable<int> removedTags,
  ) async {
    final updatedDoc = document.copyWith(
      tags: {...document.tags, ...removedTags},
    );
    await _documentsApi.update(updatedDoc);
    return reload();
  }

  ///
  /// Removes inbox tags from all documents in the inbox.
  ///
  Future<void> clearInbox() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _documentsApi.bulkAction(
        BulkModifyTagsAction.removeTags(
          state.documents.map((e) => e.id),
          state.inboxTags,
        ),
      );
      emit(state.copyWith(
        hasLoaded: true,
        value: [],
      ));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void replaceUpdatedDocument(DocumentModel document) {
    if (document.tags.any((id) => state.inboxTags.contains(id))) {
      // If replaced document still has inbox tag assigned:
      replace(document);
    } else {
      // Remove document from inbox.
      remove(document);
    }
  }

  Future<void> assignAsn(DocumentModel document) async {
    if (document.archiveSerialNumber == null) {
      final int asn = await _documentsApi.findNextAsn();
      final updatedDocument = await _documentsApi
          .update(document.copyWith(archiveSerialNumber: asn));
      replace(updatedDocument);
    }
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
    _taskTimer?.cancel();
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    return super.close();
  }
}
