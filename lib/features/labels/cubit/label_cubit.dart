import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';

part 'label_cubit.freezed.dart';
part 'label_state.dart';

class LabelCubit extends Cubit<LabelState> {
  final LabelRepository labelRepository;

  LabelCubit(this.labelRepository) : super(const LabelState()) {
    labelRepository.addListener(_updateStateListener);
  }

  void _updateStateListener() {
    emit(state.copyWith(
      correspondents: labelRepository.correspondents,
      documentTypes: labelRepository.documentTypes,
      storagePaths: labelRepository.storagePaths,
      tags: labelRepository.tags,
      warehouses: labelRepository.warehouses,
      shelfs: labelRepository.shelfs,
      boxcases: labelRepository.boxcases,
    ));
  }

  Future<void> reload({
    required bool loadCorrespondents,
    required bool loadDocumentTypes,
    required bool loadStoragePaths,
    required bool loadTags,
    required bool loadWarehouses,
  }) {
    return labelRepository.initialize(
      loadCorrespondents: loadCorrespondents,
      loadDocumentTypes: loadDocumentTypes,
      loadStoragePaths: loadStoragePaths,
      loadTags: loadTags,
      loadWarehouses: loadWarehouses,
    );
  }

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
    if (labelRepository.correspondents.containsKey(item.id)) {
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
    if (labelRepository.documentTypes.containsKey(item.id)) {
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
    if (labelRepository.storagePaths.containsKey(item.id)) {
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
    if (labelRepository.tags.containsKey(item.id)) {
      await labelRepository.deleteTag(item);
    }
  }

  Future<Warehouse> addWarehouse(Warehouse item) async {
    assert(item.id == null);
    final addedItem = await labelRepository.createWarehouse(item);
    return addedItem;
  }

  Future<void> reloadWarehouses() {
    return labelRepository.findAllWarehouses();
  }

  Future<Warehouse> replaceWarehouse(Warehouse item) async {
    assert(item.id != null);
    final updatedItem = await labelRepository.updateWarehouse(item);
    return updatedItem;
  }

  Future<void> removeWarehouse(Warehouse item) async {
    assert(item.id != null);
    if (labelRepository.warehouses.containsKey(item.id)) {
      await labelRepository.deleteWarehouse(item);
    }
  }

  Future<Warehouse> addShelf(Warehouse item) async {
    assert(item.id == null);
    final addedItem = await labelRepository.createShelf(item);
    return addedItem;
  }

  Future<void> reloadShelfs() {
    return labelRepository.findAllShelfs();
  }

  Future<Warehouse> replaceShelf(Warehouse item) async {
    assert(item.id != null);
    final updatedItem = await labelRepository.updateShelf(item);
    return updatedItem;
  }

  Future<void> removeShelf(Warehouse item) async {
    assert(item.id != null);
    if (labelRepository.shelfs.containsKey(item.id)) {
      await labelRepository.deleteShelf(item);
    }
  }

  Future<Warehouse> addBoxcase(Warehouse item) async {
    assert(item.id == null);
    final addedItem = await labelRepository.createBoxcase(item);
    return addedItem;
  }

  Future<void> reloadBoxcases() {
    return labelRepository.findAllBoxcases();
  }

  Future<Warehouse> replaceBoxcasee(Warehouse item) async {
    assert(item.id != null);
    final updatedItem = await labelRepository.updateBoxcase(item);
    return updatedItem;
  }

  Future<void> removeBoxcase(Warehouse item) async {
    assert(item.id != null);
    if (labelRepository.boxcases.containsKey(item.id)) {
      await labelRepository.deleteBoxcase(item);
    }
  }

  Future<void> reloadDetailsWarehouse(int? id) async {
    assert(id != null);
    emit(state.copyWith(isLoading: true));

    try {
      await labelRepository.findDetailsWarehouse(id!);
      emit(state.copyWith(shelfs: labelRepository.shelfs, isLoading: false));
    } catch (e) {
      e.toString();
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> reloadDetailsShelf(int? id) async {
    assert(id != null);
    emit(state.copyWith(isLoading: true));

    try {
      await labelRepository.findDetailsShelf(id!);
      emit(
          state.copyWith(boxcases: labelRepository.boxcases, isLoading: false));
    } catch (e) {
      e.toString();
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> reloadDetailsBoxcase(int id) {
    return labelRepository.findDetailsBoxcase(id);
  }

  void onChangeWarehouse(String text) async {
    emit(state.copyWith(selectedWarehouse: text));
    int? foundIdWarehouse;

    if (state.warehouses.isEmpty) {
      return;
    }

    labelRepository.warehouses.forEach((key, mapValue) {
      if (mapValue.toString().toLowerCase() ==
          state.selectedWarehouse.toString().toLowerCase()) {
        foundIdWarehouse = key;
      }
    });

    if (foundIdWarehouse != null) {
      emit(state.copyWith(idWarehouse: foundIdWarehouse!));

      try {
        await labelRepository.findDetailsWarehouse(foundIdWarehouse!);
        emit(state.copyWith(shelfs: labelRepository.shelfs));
      } catch (error) {
        print("Error while finding details: $error");
      }
    }
  }

  void onChangeShelf(String text) async {
    emit(state.copyWith(selectedShelf: text));
    int? foundIdWarehouse;

    if (state.shelfs.isEmpty) {
      return;
    }

    labelRepository.shelfs.forEach((key, mapValue) {
      if (mapValue.toString().toLowerCase() ==
          state.selectedShelf.toString().toLowerCase()) {
        foundIdWarehouse = key;
      }
    });

    if (foundIdWarehouse != null) {
      emit(state.copyWith(idShelf: foundIdWarehouse!));

      try {
        await labelRepository.findDetailsShelf(foundIdWarehouse!);
        emit(state.copyWith(boxcases: state.boxcases));
      } catch (error) {
        print("Error while finding details: $error");
      }
    }
  }

  Future<void> loadAllWarehouseContains(int id) async {
    emit(state.copyWith(isLoading: true));

    try {
      await labelRepository.findAllWarehouses();
      final idWarehouse = labelRepository
          .warehouses[labelRepository.shelfs[id]!.parentWarehouse]!.id;
      await labelRepository.findDetailsWarehouse(idWarehouse!);

      emit(state.copyWith(
          warehouses: labelRepository.warehouses,
          shelfs: labelRepository.shelfs,
          isLoading: false));
    } catch (e) {
      e.toString();
    } finally {
      emit(state.copyWith(
          warehouses: labelRepository.warehouses,
          shelfs: labelRepository.shelfs,
          isLoading: false));
    }
  }

  Future<void> loadAll() async {
    emit(state.copyWith(isLoading: true));

    try {
      await labelRepository.findAllWarehouses();
      await labelRepository.findAllShelfs();
      await labelRepository.findAllBoxcases();

      emit(state.copyWith(
          warehouses: labelRepository.warehouses,
          shelfs: labelRepository.shelfs,
          boxcases: labelRepository.boxcases,
          isLoading: false));
    } catch (e) {
      e.toString();
    } finally {
      emit(state.copyWith(
          warehouses: labelRepository.warehouses,
          shelfs: labelRepository.shelfs,
          boxcases: labelRepository.boxcases,
          isLoading: false));
    }
  }

  Future<void> loadBoxcase() async {
    emit(state.copyWith(isLoading: true));

    try {
      await labelRepository.findAllBoxcases();

      emit(
          state.copyWith(boxcases: labelRepository.boxcases, isLoading: false));
    } catch (e) {
      e.toString();
    } finally {
      emit(
          state.copyWith(boxcases: labelRepository.boxcases, isLoading: false));
    }
  }

  Future<void> loadDetailsAllWarehouse(int id) async {
    emit(state.copyWith(isLoading: true));

    try {
      await labelRepository.findDetailsWarehouse(labelRepository
          .shelfs[labelRepository.boxcases[id]?.parentWarehouse]!
          .parentWarehouse!);
      await labelRepository.findDetailsShelf(labelRepository
          .shelfs[labelRepository.boxcases[id]?.parentWarehouse]!.id!);

      emit(state.copyWith(
          shelfs: labelRepository.shelfs,
          boxcases: labelRepository.boxcases,
          isLoading: false));
    } catch (e) {
      e.toString();
    } finally {
      emit(state.copyWith(
          shelfs: labelRepository.shelfs,
          boxcases: labelRepository.boxcases,
          isLoading: false));
    }
  }

  @override
  Future<void> close() {
    labelRepository.removeListener(_updateStateListener);
    return super.close();
  }
}
