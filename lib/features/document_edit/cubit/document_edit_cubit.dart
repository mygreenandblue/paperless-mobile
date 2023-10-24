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
  final LabelRepository _labelRepository;
  final DocumentChangedNotifier _notifier;

  DocumentEditCubit(
    this._labelRepository,
    this._docsApi,
    this._notifier, {
    required DocumentModel document,
  })  : _initialDocument = document,
        super(DocumentEditState(document: document)) {
    _notifier.addListener(
      this,
      onUpdated: (doc) {
        emit(state.copyWith(document: doc));
      },
      ids: [document.id],
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

  Future<void> loadFieldSuggestions() async {
    final suggestions = await _docsApi.findSuggestions(state.document);
    emit(state.copyWith(suggestions: suggestions));
  }

  @override
  Future<void> close() {
    _notifier.removeListener(this);
    return super.close();
  }
}
