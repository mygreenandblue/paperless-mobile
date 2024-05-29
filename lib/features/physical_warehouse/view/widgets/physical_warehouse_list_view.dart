import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/widgets/offline_widget.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/physical_warehouse/cubit/warehouse_cubit/warehouse_cubit.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/widgets/physical_warehouse_list_item.dart';

class PhysicalWarehouseListView<T extends WarehouseModel>
    extends StatefulWidget {
  final List<T> warehouses;
  // final DocumentFilter Function(Label) filterBuilder;
  final void Function(T) onEdit;
  final bool canEdit;
  final void Function() onAddNew;
  final Future<void> Function(T warehouse) onDel;
  final bool canAddNew;
  final bool canDel;
  final Widget Function(T)? contentBuilder;
  final String emptyStateDescription;
  final String emptyStateActionButtonItem;
  final String type;

  const PhysicalWarehouseListView({
    super.key,
    // required this.filterBuilder,
    this.contentBuilder,
    required this.onEdit,
    required this.emptyStateDescription,
    required this.onAddNew,
    required this.emptyStateActionButtonItem,
    required this.warehouses,
    required this.canEdit,
    required this.canAddNew,
    required this.canDel,
    required this.onDel,
    required this.type,
  });

  @override
  State<PhysicalWarehouseListView<T>> createState() =>
      _PhysicalWarehouseListViewState<T>();
}

class _PhysicalWarehouseListViewState<T extends WarehouseModel>
    extends State<PhysicalWarehouseListView<T>> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, connectivityState) {
        if (!connectivityState.isConnected) {
          return const SliverFillRemaining(child: OfflineWidget());
        }

        if (widget.warehouses.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.emptyStateDescription,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: widget.canAddNew ? widget.onAddNew : null,
                    child: Text(widget.emptyStateActionButtonItem),
                  ),
                ].padded(),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final w = widget.warehouses[index];

              return PhysicalWarehouseListItem<T>(
                type: widget.type,
                name: w.name ?? '/',
                organization: 'organization',
                onEdit: widget.canEdit ? widget.onEdit : null,
                onDelete: widget.onDel,
                warehouseModel: w,
                shelf: w.parentWarehouse?.name,
                warehouse: widget.type == 'Boxcase'
                    ? w.parentWarehouse?.parentWarehouse?.name
                    : w.parentWarehouse?.name,
              );
            },
            childCount: widget.warehouses.length,
          ),
        );
      },
    );
  }
}
