import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/features/logging/data/logger.dart';

class LabelRepository extends ChangeNotifier {
  final EdocsLabelsApi _api;

  Map<int, Correspondent> correspondents = {};
  Map<int, DocumentType> documentTypes = {};
  Map<int, StoragePath> storagePaths = {};
  Map<int, Tag> tags = {};
  Map<int, Warehouse> warehouses = {};
  Map<int, Warehouse> shelfs = {};
  Map<int, Warehouse> boxcases = {};
  Map<String, Folder> folders = {};
  Map<String, DocumentModel> documents = {};
  Map<int, FolderDetails> folderDetails = {};

  LabelRepository(this._api);

  // Resets the repository to its initial state and loads all data from the API.
  Future<void> initialize({
    required bool loadCorrespondents,
    required bool loadDocumentTypes,
    required bool loadStoragePaths,
    required bool loadTags,
    required bool loadWarehouses,
    required bool loadFolders,
  }) async {
    correspondents = {};
    documentTypes = {};
    storagePaths = {};
    tags = {};
    warehouses = {};
    shelfs = {};
    boxcases = {};
    folders = {};

    await Future.wait([
      if (loadCorrespondents) findAllCorrespondents(),
      if (loadDocumentTypes) findAllDocumentTypes(),
      if (loadStoragePaths) findAllStoragePaths(),
      if (loadTags) findAllTags(),
      if (loadWarehouses) findAllWarehouses(),
      if (loadWarehouses) findAllShelfs(),
      if (loadWarehouses) findAllBoxcases(),
      if (loadFolders) findAllFolders(),
      if (loadFolders) findAllDocuments(),
    ]);
  }

  Future<Tag> createTag(Tag object) async {
    final created = await _api.saveTag(object);
    tags = {...tags, created.id!: created};
    notifyListeners();
    return created;
  }

  Future<int> deleteTag(Tag tag) async {
    await _api.deleteTag(tag);
    tags.remove(tag.id!);
    notifyListeners();
    return tag.id!;
  }

  Future<Tag?> findTag(int id) async {
    final tag = await _api.getTag(id);
    if (tag != null) {
      tags = {...tags, id: tag};
      notifyListeners();
      return tag;
    }
    return null;
  }

  Future<Iterable<Tag>> findAllTags([Iterable<int>? ids]) async {
    logger.fd(
      "Loading ${ids?.isEmpty ?? true ? "all" : "a subset of"} tags"
      "${ids?.isEmpty ?? true ? "" : " (${ids!.join(",")})"}...",
      className: runtimeType.toString(),
      methodName: "findAllTags",
    );
    final data = await _api.getTags(ids);
    if (ids?.isNotEmpty ?? false) {
      logger.fd(
        "Successfully updated subset of tags: ${ids!.join(",")}",
        className: runtimeType.toString(),
        methodName: "findAllTags",
      );
      // Only update the tags that were requested, keep existing ones.
      tags = {...tags, for (var tag in data) tag.id!: tag};
    } else {
      logger.fd(
        "Successfully updated all tags.",
        className: runtimeType.toString(),
        methodName: "findAllTags",
      );
      tags = {for (var tag in data) tag.id!: tag};
    }
    notifyListeners();
    return data;
  }

  Future<Tag> updateTag(Tag tag) async {
    final updated = await _api.updateTag(tag);
    tags = {...tags, updated.id!: updated};
    notifyListeners();
    return updated;
  }

  Future<Correspondent> createCorrespondent(Correspondent correspondent) async {
    final created = await _api.saveCorrespondent(correspondent);
    correspondents = {...correspondents, created.id!: created};
    notifyListeners();
    return created;
  }

  Future<int> deleteCorrespondent(Correspondent correspondent) async {
    await _api.deleteCorrespondent(correspondent);
    correspondents.remove(correspondent.id!);
    notifyListeners();
    return correspondent.id!;
  }

  Future<Correspondent?> findCorrespondent(int id) async {
    final correspondent = await _api.getCorrespondent(id);
    if (correspondent != null) {
      correspondents = {...correspondents, id: correspondent};
      notifyListeners();
      return correspondent;
    }
    return null;
  }

  Future<Iterable<Correspondent>> findAllCorrespondents() async {
    final data = await _api.getCorrespondents();
    correspondents = {for (var element in data) element.id!: element};
    notifyListeners();
    return data;
  }

  Future<Correspondent> updateCorrespondent(Correspondent correspondent) async {
    final updated = await _api.updateCorrespondent(correspondent);
    correspondents = {...correspondents, updated.id!: updated};
    notifyListeners();
    return updated;
  }

  Future<Folder> createFolder(Folder folder) async {
    final created = await _api.saveFolder(folder);
    folders = {...folders, created.id!.toString(): created};
    notifyListeners();
    return created;
  }

  Future<int> deleteFolder(Folder folder) async {
    await _api.deleteFolder(folder);
    folders.remove(folder.checksum!);
    notifyListeners();
    return folder.id!;
  }

  Future<FolderDetails?> findFolder(int id) async {
    final folder = await _api.getFolder(id);
    if (folder != null) {
      notifyListeners();
      return folder;
    }
    return null;
  }

  Future<FolderDetails?> findAllFolders() async {
    final data = await _api.getFolders();
    final folderList = data!.folders as List<Folder>;
    folders = {for (var folder in folderList) folder.checksum!: folder};

    notifyListeners();
    return data;
  }

  Future<FolderDetails?> findAllDocuments() async {
    final data = await _api.getFolders();
    final documentList = data!.documents as List<DocumentModel>;
    documents = {for (var doc in documentList) doc.checksum!: doc};
    notifyListeners();
    return data;
  }

  Future<Folder> updateFolder(Folder folder) async {
    final updated = await _api.updateFolder(folder);
    folders = {...folders, updated.id!.toString(): updated};
    notifyListeners();
    return updated;
  }

  Future<Warehouse> createWarehouse(Warehouse warehouse) async {
    final created = await _api.saveWarehouse(warehouse);
    warehouses = {...warehouses, created.id!: created};
    notifyListeners();
    return created;
  }

  Future<int> deleteWarehouse(Warehouse warehouse) async {
    await _api.deleteWarehouse(warehouse);
    warehouses.remove(warehouse.id!);
    notifyListeners();
    return warehouse.id!;
  }

  Future<Warehouse?> findWarehouse(int id) async {
    final warehouse = await _api.getWarehouse(id);
    if (warehouse != null) {
      warehouses = {...warehouses, id: warehouse};
      notifyListeners();
      return warehouse;
    }
    return null;
  }

  Future<Iterable<Warehouse>> findAllWarehouses() async {
    final data = await _api.getWarehouses();
    warehouses = {for (var element in data) element.id!: element};
    notifyListeners();
    return data;
  }

  Future<Warehouse> updateWarehouse(Warehouse warehouse) async {
    final updated = await _api.updateWarehouse(warehouse);
    warehouses = {...warehouses, updated.id!: updated};
    notifyListeners();
    return updated;
  }

  Future<int> deleteShelf(Warehouse warehouse) async {
    await _api.deleteShelf(warehouse);
    shelfs.remove(warehouse.id!);
    notifyListeners();
    return warehouse.id!;
  }

  Future<Warehouse?> findShelf(int id) async {
    final warehouse = await _api.getShelf(id);
    if (warehouse != null) {
      shelfs = {...shelfs, id: warehouse};
      notifyListeners();
      return warehouse;
    }
    return null;
  }

  Future<Iterable<Warehouse>> findAllShelfs() async {
    final data = await _api.getShelfs();
    shelfs = {for (var element in data) element.id!: element};
    notifyListeners();
    return data;
  }

  Future<Warehouse> createShelf(Warehouse warehouse) async {
    final created = await _api.saveWarehouse(warehouse);
    shelfs = {...shelfs, created.id!: created};
    notifyListeners();
    return created;
  }

  Future<Warehouse> updateShelf(Warehouse warehouse) async {
    final updated = await _api.updateWarehouse(warehouse);
    shelfs = {...shelfs, updated.id!: updated};
    notifyListeners();
    return updated;
  }

  Future<int> deleteBoxcase(Warehouse warehouse) async {
    await _api.deleteBoxcase(warehouse);
    boxcases.remove(warehouse.id!);
    notifyListeners();
    return warehouse.id!;
  }

  Future<Warehouse?> findBoxcase(int id) async {
    final warehouse = await _api.getBoxcase(id);
    if (warehouse != null) {
      boxcases = {...boxcases, id: warehouse};
      notifyListeners();
      return warehouse;
    }
    return null;
  }

  Future<Iterable<Warehouse>> findAllBoxcases() async {
    final data = await _api.getBoxcases();
    boxcases = {for (var element in data) element.id!: element};
    notifyListeners();
    return data;
  }

  Future<Warehouse> createBoxcase(Warehouse warehouse) async {
    final created = await _api.saveWarehouse(warehouse);
    boxcases = {...boxcases, created.id!: created};
    notifyListeners();
    return created;
  }

  Future<Warehouse> updateBoxcase(Warehouse warehouse) async {
    final updated = await _api.updateWarehouse(warehouse);
    boxcases = {...boxcases, updated.id!: updated};
    notifyListeners();
    return updated;
  }

  Future<Iterable<Warehouse>> findDetailsWarehouse(int id) async {
    final data = await _api.getDetails(id);
    shelfs = {for (var element in data) element.id!: element};
    notifyListeners();
    return data;
  }

  Future<Iterable<Warehouse>> findDetailsShelf(int id) async {
    final data = await _api.getDetails(id);
    boxcases = {for (var element in data) element.id!: element};
    notifyListeners();
    return data;
  }

  Future<Iterable<Warehouse>> findDetailsBoxcase(int id) async {
    final data = await _api.getDetails(id);
    boxcases = {for (var element in data) element.id!: element};
    notifyListeners();
    return data;
  }

  Future<DocumentType> createDocumentType(DocumentType documentType) async {
    final created = await _api.saveDocumentType(documentType);
    documentTypes = {...documentTypes, created.id!: created};
    notifyListeners();
    return created;
  }

  Future<int> deleteDocumentType(DocumentType documentType) async {
    await _api.deleteDocumentType(documentType);
    documentTypes.remove(documentType.id!);
    notifyListeners();
    return documentType.id!;
  }

  Future<DocumentType?> findDocumentType(int id) async {
    final documentType = await _api.getDocumentType(id);
    if (documentType != null) {
      documentTypes = {...documentTypes, id: documentType};
      notifyListeners();
      return documentType;
    }
    return null;
  }

  Future<Iterable<DocumentType>> findAllDocumentTypes() async {
    final documentTypes = await _api.getDocumentTypes();
    this.documentTypes = {
      for (var dt in documentTypes) dt.id!: dt,
    };
    notifyListeners();
    return documentTypes;
  }

  Future<DocumentType> updateDocumentType(DocumentType documentType) async {
    final updated = await _api.updateDocumentType(documentType);
    documentTypes = {...documentTypes, updated.id!: updated};
    notifyListeners();
    return updated;
  }

  Future<StoragePath> createStoragePath(StoragePath storagePath) async {
    final created = await _api.saveStoragePath(storagePath);
    storagePaths = {...storagePaths, created.id!: created};
    notifyListeners();
    return created;
  }

  Future<int> deleteStoragePath(StoragePath storagePath) async {
    await _api.deleteStoragePath(storagePath);
    storagePaths.remove(storagePath.id!);
    notifyListeners();
    return storagePath.id!;
  }

  Future<StoragePath?> findStoragePath(int id) async {
    final storagePath = await _api.getStoragePath(id);
    if (storagePath != null) {
      storagePaths = {...storagePaths, id: storagePath};
      notifyListeners();
      return storagePath;
    }
    return null;
  }

  Future<Iterable<StoragePath>> findAllStoragePaths() async {
    final storagePaths = await _api.getStoragePaths();
    this.storagePaths = {
      for (var sp in storagePaths) sp.id!: sp,
    };
    notifyListeners();
    return storagePaths;
  }

  Future<StoragePath> updateStoragePath(StoragePath storagePath) async {
    final updated = await _api.updateStoragePath(storagePath);
    storagePaths = {...storagePaths, updated.id!: updated};
    notifyListeners();
    return updated;
  }

  // @override
  // LabelRepositoryState? fromJson(Map<String, dynamic> json) {
  //   return LabelRepositoryState.fromJson(json);
  // }

  // @override
  // Map<String, dynamic>? toJson(LabelRepositoryState state) {
  //   return state.toJson();
  // }
}
