import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:collection/collection.dart';
import 'package:paperless_mobile/core/repository/state/impl/correspondent_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/document_type_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/storage_path_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/tag_repository_state.dart';

part 'edit_document_state.dart';

class EditDocumentCubit extends Cubit<EditDocumentState> {
  final DocumentModel _initialDocument;
  final PaperlessDocumentsApi _docsApi;

  final DocumentChangedNotifier _notifier;
  final LabelRepository<Correspondent> _correspondentRepository;
  final LabelRepository<DocumentType> _documentTypeRepository;
  final LabelRepository<StoragePath> _storagePathRepository;
  final LabelRepository<Tag> _tagRepository;
  final List<StreamSubscription> _subscriptions = [];

  EditDocumentCubit(
    DocumentModel document, {
    required PaperlessDocumentsApi documentsApi,
    required LabelRepository<Correspondent> correspondentRepository,
    required LabelRepository<DocumentType> documentTypeRepository,
    required LabelRepository<StoragePath> storagePathRepository,
    required LabelRepository<Tag> tagRepository,
    required DocumentChangedNotifier notifier,
  })  : _initialDocument = document,
        _docsApi = documentsApi,
        _correspondentRepository = correspondentRepository,
        _documentTypeRepository = documentTypeRepository,
        _storagePathRepository = storagePathRepository,
        _tagRepository = tagRepository,
        _notifier = notifier,
        super(
          EditDocumentState(
            document: document,
            correspondents: correspondentRepository.current?.values ?? {},
            documentTypes: documentTypeRepository.current?.values ?? {},
            storagePaths: storagePathRepository.current?.values ?? {},
            tags: tagRepository.current?.values ?? {},
          ),
        ) {
    _notifier.subscribe(this, onUpdated: replace);
    _subscriptions.add(
      _correspondentRepository.values
          .listen((v) => emit(state.copyWith(correspondents: v?.values))),
    );
    _subscriptions.add(
      _documentTypeRepository.values
          .listen((v) => emit(state.copyWith(documentTypes: v?.values))),
    );
    _subscriptions.add(
      _storagePathRepository.values
          .listen((v) => emit(state.copyWith(storagePaths: v?.values))),
    );
    _subscriptions.add(
      _tagRepository.values.listen(
        (v) => emit(state.copyWith(tags: v?.values)),
      ),
    );
  }

  Future<void> updateDocument(DocumentModel document) async {
    final updated = await _docsApi.update(document);
    _notifier.notifyUpdated(updated);

    // Reload changed labels (documentCount property changes with removal/add)
    if (document.documentType != _initialDocument.documentType) {
      _documentTypeRepository
          .find((document.documentType ?? _initialDocument.documentType)!);
    }
    if (document.correspondent != _initialDocument.correspondent) {
      _correspondentRepository
          .find((document.correspondent ?? _initialDocument.correspondent)!);
    }
    if (document.storagePath != _initialDocument.storagePath) {
      _storagePathRepository
          .find((document.storagePath ?? _initialDocument.storagePath)!);
    }
    if (!const DeepCollectionEquality.unordered()
        .equals(document.tags, _initialDocument.tags)) {
      _tagRepository.findAll(document.tags);
    }
  }

  void replace(DocumentModel document) {
    emit(state.copyWith(document: document));
  }

  @override
  Future<void> close() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _notifier.unsubscribe(this);
    return super.close();
  }
}
