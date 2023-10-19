import 'package:collection/collection.dart';
import 'package:paperless_api/paperless_api.dart';

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
