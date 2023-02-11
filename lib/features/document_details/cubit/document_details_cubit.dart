import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_filex/open_filex.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'document_details_state.dart';

class DocumentDetailsCubit extends Cubit<DocumentDetailsState> {
  final PaperlessDocumentsApi _api;
  final DocumentChangedNotifier _notifier;

  final List<StreamSubscription> _subscriptions = [];
  DocumentDetailsCubit(
    this._api,
    this._notifier, {
    required DocumentModel initialDocument,
  }) : super(DocumentDetailsState(document: initialDocument)) {
    _notifier.subscribe(this, onUpdated: replace);
    loadSuggestions();
  }

  Future<void> delete(DocumentModel document) async {
    await _api.delete(document);
    _notifier.notifyDeleted(document);
  }

  Future<void> loadSuggestions() async {
    final suggestions = await _api.findSuggestions(state.document);
    emit(state.copyWith(suggestions: suggestions));
  }

  Future<void> loadFullContent() async {
    final doc = await _api.find(state.document.id);
    if (doc == null) {
      return;
    }
    emit(state.copyWith(
      isFullContentLoaded: true,
      fullContent: doc.content,
    ));
  }

  Future<void> assignAsn(DocumentModel document) async {
    if (document.archiveSerialNumber == null) {
      final int asn = await _api.findNextAsn();
      final updatedDocument =
          await _api.update(document.copyWith(archiveSerialNumber: asn));
      _notifier.notifyUpdated(updatedDocument);
    }
  }

  Future<ResultType> openDocumentInSystemViewer() async {
    final cacheDir = await FileService.temporaryDirectory;

    final metaData = await _api.getMetaData(state.document);
    final bytes = await _api.download(state.document);

    final file = File('${cacheDir.path}/${metaData.mediaFilename}')
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);

    return OpenFilex.open(file.path, type: "application/pdf").then(
      (value) => value.type,
    );
  }

  void replace(DocumentModel document) {
    emit(state.copyWith(document: document));
  }

  Future<void> shareDocument() async {
    final documentBytes = await _api.download(state.document);
    final dir = await getTemporaryDirectory();
    final String path = "${dir.path}/${state.document.originalFileName}";
    await File(path).writeAsBytes(documentBytes);
    Share.shareXFiles(
      [
        XFile(
          path,
          name: state.document.originalFileName,
          mimeType: "application/pdf",
          lastModified: state.document.modified,
        ),
      ],
      subject: state.document.title,
    );
  }

  @override
  Future<void> close() {
    for (final element in _subscriptions) {
      element.cancel();
    }
    _notifier.unsubscribe(this);
    return super.close();
  }
}
