import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';

///
/// Mixin which adds functionality to manage labels to [Bloc]s.
///
mixin LabelCubitMixin<T> on BlocBase<T> {
  LabelRepository get labelRepository;

  Future<Correspondent> addCorrespondent(Correspondent item) async {
    assert(item.id == null);
    final addedItem = await labelRepository.createCorrespondent(item);
    return addedItem;
  }

  Future<void> reloadCorrespondents() {
    return labelRepository.findAllCorrespondents();
  }

  Future<Correspondent> replaceCorrespondent(Correspondent item) async {
    assert(item.id != null);
    final updatedItem = await labelRepository.updateCorrespondent(item);
    return updatedItem;
  }

  Future<void> removeCorrespondent(Correspondent item) async {
    assert(item.id != null);
    if (labelRepository.state.correspondents.containsKey(item.id)) {
      await labelRepository.deleteCorrespondent(item);
    }
  }

  Future<DocumentType> addDocumentType(DocumentType item) async {
    assert(item.id == null);
    final addedItem = await labelRepository.createDocumentType(item);
    return addedItem;
  }

  Future<void> reloadDocumentTypes() {
    return labelRepository.findAllDocumentTypes();
  }

  Future<DocumentType> replaceDocumentType(DocumentType item) async {
    assert(item.id != null);
    final updatedItem = await labelRepository.updateDocumentType(item);
    return updatedItem;
  }

  Future<void> removeDocumentType(DocumentType item) async {
    assert(item.id != null);
    if (labelRepository.state.documentTypes.containsKey(item.id)) {
      await labelRepository.deleteDocumentType(item);
    }
  }

  Future<StoragePath> addStoragePath(StoragePath item) async {
    assert(item.id == null);
    final addedItem = await labelRepository.createStoragePath(item);
    return addedItem;
  }

  Future<void> reloadStoragePaths() {
    return labelRepository.findAllStoragePaths();
  }

  Future<StoragePath> replaceStoragePath(StoragePath item) async {
    assert(item.id != null);
    final updatedItem = await labelRepository.updateStoragePath(item);
    return updatedItem;
  }

  Future<void> removeStoragePath(StoragePath item) async {
    assert(item.id != null);
    if (labelRepository.state.storagePaths.containsKey(item.id)) {
      await labelRepository.deleteStoragePath(item);
    }
  }

  Future<Tag> addTag(Tag item) async {
    assert(item.id == null);
    final addedItem = await labelRepository.createTag(item);
    return addedItem;
  }

  Future<void> reloadTags() {
    return labelRepository.findAllTags();
  }

  Future<Tag> replaceTag(Tag item) async {
    assert(item.id != null);
    final updatedItem = await labelRepository.updateTag(item);
    return updatedItem;
  }

  Future<void> removeTag(Tag item) async {
    assert(item.id != null);
    if (labelRepository.state.tags.containsKey(item.id)) {
      await labelRepository.deleteTag(item);
    }
  }
}
