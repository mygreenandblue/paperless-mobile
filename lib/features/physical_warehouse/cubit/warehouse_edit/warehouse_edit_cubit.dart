import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/transient_error.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/core/extensions/warehouse_extentions.dart';
import 'package:paperless_mobile/core/notifier/warehouse_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/warehouse_repository.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/physical_warehouse/cubit/warehouse_paged/paged_warehouse_sate.dart';
import 'package:paperless_mobile/features/physical_warehouse/cubit/warehouse_paged/warehouse_paging_bloc_mixin.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';

part 'warehouse_edit_state.dart';

class WarehouseEditCubit extends Cubit<WarehouseEditState>
    with WarehousePagingBlocMixin {
  @override
  final PhysicalWarehouseApi api;

  @override
  final ConnectivityStatusService connectivityStatusService;

  @override
  final WarehouseChangedNotifier notifier;

  @override
  final String type;

  final LocalUserAppState _userState;
  final WarehouseRepository warehouseRepository;

  WarehouseEditCubit(
    this.api,
    this.notifier,
    this._userState,
    this.connectivityStatusService,
    this.warehouseRepository,
    this.type,
  ) : super(WarehouseEditState(
          filter: _userState.currentWarehouseFilter,
        )) {
    notifier.addListener(
      this,
      onUpdated: (warehouse) {
        replace(warehouse);
        emit(
          state.copyWith(
              selection:
                  state.selection.withWarehousereplaced(warehouse).toList()),
        );
      },
      onDeleted: (warehouse) {
        remove(warehouse);
        emit(
          state.copyWith(
            selection: state.selection.withWarehouseRemoved(warehouse).toList(),
          ),
        );
      },
    );
  }

  // Future<void> bulkDelete(List<DocumentModel> documents) async {
  //   await api.bulkAction(
  //     BulkDeleteAction(documents.map((doc) => doc.id)),
  //   );
  //   for (final deletedDoc in documents) {
  //     notifier.notifyDeleted(deletedDoc);
  //   }
  //   await reload();
  // }

  void toggleDocumentSelection(WarehouseModel model) {
    if (state.selectedIds.contains(model.id)) {
      emit(
        state.copyWith(
          selection: state.selection
              .where((element) => element.id != model.id)
              .toList(),
        ),
      );
    } else {
      emit(state.copyWith(selection: [...state.selection, model]));
    }
  }

  void resetSelection() {
    emit(state.copyWith(selection: []));
  }

  void reset() {
    emit(const WarehouseEditState());
  }

  // Future<Iterable<String>> autocomplete(String query) async {
  //   final res = await api.autocomplete(query);
  //   return res;
  // }

  @override
  Future<void> close() {
    notifier.removeListener(this);
    return super.close();
  }

  @override
  Future<void> onFilterUpdated(WarehouseFilter filter) async {
    _userState.currentWarehouseFilter = filter;
    await _userState.save();
  }

  Future<void> addWarehouse({
    required String name,
    String? type,
    int? parentWarehouse,
    int? id,
  }) async {
    try {
      await api.createWarehouse(
        type: type,
        name: name,
        parentWarehouse: parentWarehouse,
      );
    } on PaperlessApiException catch (error) {
      addError(TransientPaperlessApiError(
        code: error.code,
        details: error.details,
      ));
    }
  }

  Future<void> update({
    required String name,
    String? type,
    int? parentWarehouse,
    int? id,
  }) async {
    try {
      await api.updateWarehouse(
        id: id,
        type: type,
        name: name,
        parentWarehouse: parentWarehouse,
      );
    } on PaperlessApiException catch (error) {
      addError(TransientPaperlessApiError(
        code: error.code,
        details: error.details,
      ));
    }
  }

  // @override
  // DocumentsState? fromJson(Map<String, dynamic> json) {
  //   return DocumentsState.fromJson(json);
  // }

  // @override
  // Map<String, dynamic>? toJson(DocumentsState state) {
  //   return state.toJson();
  // }
}
