import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository_state.dart';
import 'package:paperless_mobile/core/repository/persistent_repository.dart';

class LabelRepository extends PersistentRepository<LabelRepositoryState> {
  final PaperlessLabelsApi _api;

  LabelRepository(this._api) : super(const LabelRepositoryState());

  Future<void> initialize() {
    debugPrint("Initializing labels...");
    return Future.wait([
      findAllCorrespondents(),
      findAllDocumentTypes(),
      findAllStoragePaths(),
      findAllTags(),
    ]).catchError((error) {
      debugPrint(error.toString());
    }, test: (error) => false);
  }

  Future<Tag> createTag(Tag object) async {
    final created = await _api.saveTag(object);
    final updatedState = {...state.tags}..putIfAbsent(created.id!, () => created);
    emit(state.copyWith(tags: updatedState));
    return created;
  }

  Future<int> deleteTag(Tag tag) async {
    await _api.deleteTag(tag);
    final updatedState = {...state.tags}..removeWhere((k, v) => k == tag.id);
    emit(state.copyWith(tags: updatedState));
    return tag.id!;
  }

  Future<Tag?> findTag(int id) async {
    final tag = await _api.getTag(id);
    if (tag != null) {
      final updatedState = {...state.tags}..[id] = tag;
      emit(state.copyWith(tags: updatedState));
      return tag;
    }
    return null;
  }

  Future<Iterable<Tag>> findAllTags([Iterable<int>? ids]) async {
    final tags = await _api.getTags(ids);
    final updatedState = {...state.tags}..addEntries(tags.map((e) => MapEntry(e.id!, e)));
    emit(state.copyWith(tags: updatedState));
    return tags;
  }

  Future<Tag> updateTag(Tag tag) async {
    final updated = await _api.updateTag(tag);
    final updatedState = {...state.tags}..update(updated.id!, (_) => updated);
    emit(state.copyWith(tags: updatedState));
    return updated;
  }

  Future<Correspondent> createCorrespondent(Correspondent correspondent) async {
    final created = await _api.saveCorrespondent(correspondent);
    final updatedState = {...state.correspondents}..putIfAbsent(created.id!, () => created);
    emit(state.copyWith(correspondents: updatedState));
    return created;
  }

  Future<int> deleteCorrespondent(Correspondent correspondent) async {
    await _api.deleteCorrespondent(correspondent);
    final updatedState = {...state.correspondents}..removeWhere((k, v) => k == correspondent.id);
    emit(state.copyWith(correspondents: updatedState));

    return correspondent.id!;
  }

  Future<Correspondent?> findCorrespondent(int id) async {
    final correspondent = await _api.getCorrespondent(id);
    if (correspondent != null) {
      final updatedState = {...state.correspondents}..[id] = correspondent;
      emit(state.copyWith(correspondents: updatedState));

      return correspondent;
    }
    return null;
  }

  Future<Iterable<Correspondent>> findAllCorrespondents([Iterable<int>? ids]) async {
    debugPrint("Loading correspondents...");
    final correspondents = await _api.getCorrespondents(ids);
    debugPrint("${correspondents.length} correspondents successfully loaded.");
    final updatedState = {
      ...state.correspondents,
    }..addAll({for (var element in correspondents) element.id!: element});
    debugPrint("Pushing new correspondents state.");
    emit(state.copyWith(correspondents: updatedState));
    debugPrint("New correspondents state pushed.");
    return correspondents;
  }

  Future<Correspondent> updateCorrespondent(Correspondent correspondent) async {
    final updated = await _api.updateCorrespondent(correspondent);
    final updatedState = {...state.correspondents}..update(updated.id!, (_) => updated);
    emit(state.copyWith(correspondents: updatedState));

    return updated;
  }

  Future<DocumentType> createDocumentType(DocumentType documentType) async {
    final created = await _api.saveDocumentType(documentType);
    final updatedState = {...state.documentTypes}..putIfAbsent(created.id!, () => created);
    emit(state.copyWith(documentTypes: updatedState));
    return created;
  }

  Future<int> deleteDocumentType(DocumentType documentType) async {
    await _api.deleteDocumentType(documentType);
    final updatedState = {...state.documentTypes}..removeWhere((k, v) => k == documentType.id);
    emit(state.copyWith(documentTypes: updatedState));
    return documentType.id!;
  }

  Future<DocumentType?> findDocumentType(int id) async {
    final documentType = await _api.getDocumentType(id);
    if (documentType != null) {
      final updatedState = {...state.documentTypes}..[id] = documentType;
      emit(state.copyWith(documentTypes: updatedState));
      return documentType;
    }
    return null;
  }

  Future<Iterable<DocumentType>> findAllDocumentTypes([Iterable<int>? ids]) async {
    final documentTypes = await _api.getDocumentTypes(ids);
    final updatedState = {...state.documentTypes}
      ..addEntries(documentTypes.map((e) => MapEntry(e.id!, e)));
    emit(state.copyWith(documentTypes: updatedState));
    return documentTypes;
  }

  Future<DocumentType> updateDocumentType(DocumentType documentType) async {
    final updated = await _api.updateDocumentType(documentType);
    final updatedState = {...state.documentTypes}..update(updated.id!, (_) => updated);
    emit(state.copyWith(documentTypes: updatedState));
    return updated;
  }

  Future<StoragePath> createStoragePath(StoragePath storagePath) async {
    final created = await _api.saveStoragePath(storagePath);
    final updatedState = {...state.storagePaths}..putIfAbsent(created.id!, () => created);
    emit(state.copyWith(storagePaths: updatedState));
    return created;
  }

  Future<int> deleteStoragePath(StoragePath storagePath) async {
    await _api.deleteStoragePath(storagePath);
    final updatedState = {...state.storagePaths}..removeWhere((k, v) => k == storagePath.id);
    emit(state.copyWith(storagePaths: updatedState));
    return storagePath.id!;
  }

  Future<StoragePath?> findStoragePath(int id) async {
    final storagePath = await _api.getStoragePath(id);
    if (storagePath != null) {
      final updatedState = {...state.storagePaths}..[id] = storagePath;
      emit(state.copyWith(storagePaths: updatedState));
      return storagePath;
    }
    return null;
  }

  Future<Iterable<StoragePath>> findAllStoragePaths([Iterable<int>? ids]) async {
    final storagePaths = await _api.getStoragePaths(ids);
    final updatedState = {...state.storagePaths}
      ..addEntries(storagePaths.map((e) => MapEntry(e.id!, e)));
    emit(state.copyWith(storagePaths: updatedState));
    return storagePaths;
  }

  Future<StoragePath> updateStoragePath(StoragePath storagePath) async {
    final updated = await _api.updateStoragePath(storagePath);
    final updatedState = {...state.storagePaths}..update(updated.id!, (_) => updated);
    emit(state.copyWith(storagePaths: updatedState));
    return updated;
  }

  @override
  Future<void> clear() async {
    await super.clear();
    emit(const LabelRepositoryState());
  }

  @override
  LabelRepositoryState? fromJson(Map<String, dynamic> json) {
    return LabelRepositoryState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(LabelRepositoryState state) {
    return state.toJson();
  }
}
