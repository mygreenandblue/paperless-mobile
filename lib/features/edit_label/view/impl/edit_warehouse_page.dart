import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/bloc/connectivity_cubit.dart';
import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/features/edit_label/view/edit_label_page.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class EditWarehousePage extends StatelessWidget {
  final Warehouse warehouse;
  const EditWarehousePage({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) {
        return LabelCubit(
          context.read(),
        );
      },
      child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, cennected) {
          if (warehouse.parentWarehouse != null) {
            context
                .read<LabelCubit>()
                .loadAllWarehouseContains(warehouse.parentWarehouse!);
          }

          return BlocBuilder<LabelCubit, LabelState>(
            builder: (context, state) {
              return state.isLoading
                  ? Scaffold(
                      appBar: AppBar(
                        title: Text(S.of(context)!.edit),
                      ),
                      body: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : EditLabelPage<Warehouse>(
                      type: warehouse.type,
                      label: warehouse,
                      fromJsonT: Warehouse.fromJson,
                      onSubmit: (context, label) => warehouse.type ==
                              'Warehouse'
                          ? context.read<LabelCubit>().replaceWarehouse(label)
                          : warehouse.type == 'Shelf'
                              ? context.read<LabelCubit>().replaceShelf(label)
                              : context
                                  .read<LabelCubit>()
                                  .replaceBoxcasee(label),
                      onDelete: (context, label) => warehouse.type ==
                              'Warehouse'
                          ? context.read<LabelCubit>().removeWarehouse(label)
                          : warehouse.type == 'Shelf'
                              ? context.read<LabelCubit>().removeShelf(label)
                              : context.read<LabelCubit>().removeBoxcase(label),
                      canDelete: context
                          .watch<LocalUserAccount>()
                          .edocsUser
                          .canDeleteWarehouse,
                      onChangedWarehouse: (w) {
                        context.read<LabelCubit>().onChangeWarehouse(w!);
                      },
                      onChangedShelf: (sh) {
                        context.read<LabelCubit>().onChangeShelf(sh!);
                      },
                      parentId: state.idShelf,
                      initialWarehouse: warehouse.parentWarehouse,
                    );
            },
          );
        },
      ),
    );
  }
}
