import 'dart:typed_data';

import 'package:edocs_api/src/models/models.dart';

abstract class EdocsDocumentsApi {
  /// Uploads a document using a form data request and from server version 1.11.3
  /// returns the celery task id which can be used to track the status of the document.
  Future<String?> create(
    Uint8List documentBytes, {
    required String filename,
    required String title,
    DateTime? createdAt,
    int? documentType,
    int? correspondent,
    Iterable<int> tags = const [],
    int? asn,
    void Function(double progress)? onProgressChanged,
    int? warehouse,
    int? folder,
  });
  Future<DocumentModel> update(DocumentModel doc);
  Future<int> findNextAsn();
  Future<PagedSearchResult<DocumentModel>> findAll(DocumentFilter filter);
  Future<DocumentModel> find(int id);
  Future<int> delete(DocumentModel doc);
  Future<DocumentMetaData> getMetaData(int id);
  Future<DocumentModel> deleteNote(DocumentModel document, int noteId);
  Future<Iterable<int>> bulkAction(BulkAction action);
  Future<Uint8List> getPreview(int docId);
  String getThumbnailUrl(int docId);
  Future<Uint8List> downloadDocument(int id, {bool original});
  Future<void> downloadToFile(
    int id,
    String localFilePath, {
    bool original = false,
    void Function(double progress)? onProgressChanged,
  });
  Future<FieldSuggestions> findSuggestions(DocumentModel document);

  Future<List<String>> autocomplete(String query, [int limit = 10]);

  Future<DocumentModel> addNote(
      {required DocumentModel document, required String text});
}
