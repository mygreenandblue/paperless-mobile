import 'package:paperless_api/src/models/models.dart';

///
/// Provides basic CRUD operations for labels, including:
/// <ul>
///    <li>Correspondents</li>
///    <li>Document Types</li>
///    <li>Tags</li>
///    <li>Storage Paths</li>
/// </ul>
///
abstract class PaperlessLabelsApi {
  Future<Correspondent?> getCorrespondent(int id);
  Future<List<Correspondent>> getCorrespondents([Iterable<int>? ids]);
  Future<Correspondent> saveCorrespondent(Correspondent correspondent);
  Future<Correspondent> updateCorrespondent(Correspondent correspondent);
  Future<int> deleteCorrespondent(Correspondent correspondent);

  Future<Tag?> getTag(int id);
  Future<List<Tag>> getTags([Iterable<int>? ids]);
  Future<Tag> saveTag(Tag tag);
  Future<Tag> updateTag(Tag tag);
  Future<int> deleteTag(Tag tag);

  Future<DocumentType?> getDocumentType(int id);
  Future<List<DocumentType>> getDocumentTypes([Iterable<int>? ids]);
  Future<DocumentType> saveDocumentType(DocumentType type);
  Future<DocumentType> updateDocumentType(DocumentType documentType);
  Future<int> deleteDocumentType(DocumentType documentType);

  Future<StoragePath?> getStoragePath(int id);
  Future<List<StoragePath>> getStoragePaths([Iterable<int>? ids]);
  Future<StoragePath> saveStoragePath(StoragePath path);
  Future<StoragePath> updateStoragePath(StoragePath path);
  Future<int> deleteStoragePath(StoragePath path);

  Future<Warehouse?> getWarehouse(int id);
  Future<List<Warehouse>> getWarehouses([Iterable<int>? ids]);
  Future<int> deleteWarehouse(Warehouse warehouse);

  Future<Warehouse?> getShelf(int id);
  Future<List<Warehouse>> getShelfs([Iterable<int>? ids]);
  Future<int> deleteShelf(Warehouse warehouse);

  Future<Warehouse?> getBoxcase(int id);
  Future<List<Warehouse>> getBoxcases([Iterable<int>? ids]);
  Future<int> deleteBoxcase(Warehouse warehouse);

  Future<Warehouse> saveWarehouse(Warehouse warehouse);
  Future<Warehouse> updateWarehouse(Warehouse warehouse);

  Future<List<Warehouse>> getDetails(int id, [Iterable<int>? ids]);
}
