import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';

extension DocumentModelIterableExtension on Iterable<DocumentModel> {
  Iterable<int> get ids => map((e) => e.id);

  Iterable<DocumentModel> withDocumentreplaced(DocumentModel document) {
    return map((e) => e.id == document.id ? document : e);
  }

  bool containsDocument(DocumentModel document) {
    return ids.contains(document.id);
  }

  Iterable<DocumentModel> withDocumentRemoved(DocumentModel document) {
    return whereNot((element) => element.id == document.id);
  }
}

extension SessionAwareDownloadIdExtension on DocumentModel {
  String buildThumbnailUrl(BuildContext context) =>
      context.read<EdocsDocumentsApi>().getThumbnailUrl(id);
}
