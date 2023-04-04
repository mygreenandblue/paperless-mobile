import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';

part 'document_edit_state.dart';
part 'document_edit_cubit.freezed.dart';

class DocumentEditCubit extends Cubit<DocumentEditState> {
  final DocumentModel _initialDocument;
  final PaperlessDocumentsApi _docsApi;

  final DocumentChangedNotifier _notifier;
  final LabelRepository _labelRepository;
  final List<StreamSubscription> _subscriptions = [];

  DocumentEditCubit(
    this._labelRepository,
    this._docsApi,
    this._notifier, {
    required DocumentModel document,
  })  : _initialDocument = document,
        super(
          DocumentEditState(
            document: document,
            correspondents: _labelRepository.state.correspondents,
            documentTypes: _labelRepository.state.documentTypes,
            storagePaths: _labelRepository.state.storagePaths,
            tags: _labelRepository.state.tags,
          ),
        ) {
    _notifier.subscribe(this, onUpdated: replace);
    _labelRepository.subscribe(
      this,
      onStateChanged: (labels) => emit(state.copyWith()),
    );
  }

  Future<void> updateDocument(DocumentModel document) async {
    final updated = await _docsApi.update(document);
    _notifier.notifyUpdated(updated);

    // Reload changed labels (documentCount property changes with removal/add)
    if (document.documentType != _initialDocument.documentType) {
      _labelRepository.findDocumentType(
          (document.documentType ?? _initialDocument.documentType)!);
    }
    if (document.correspondent != _initialDocument.correspondent) {
      _labelRepository.findCorrespondent(
          (document.correspondent ?? _initialDocument.correspondent)!);
    }
    if (document.storagePath != _initialDocument.storagePath) {
      _labelRepository.findStoragePath(
          (document.storagePath ?? _initialDocument.storagePath)!);
    }
    if (!const DeepCollectionEquality.unordered()
        .equals(document.tags, _initialDocument.tags)) {
      _labelRepository.findAllTags(document.tags);
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
