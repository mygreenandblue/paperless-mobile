import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/database/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/features/physical_warehouse/cubit/warehouse_edit/warehouse_edit_cubit.dart';

import 'package:paperless_mobile/features/physical_warehouse/view/impl/edit_physical_warehouse_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class EditBriefcasePage extends StatefulWidget {
  final String type;
  final WarehouseModel warehouseModel;

  const EditBriefcasePage(
      {super.key, required this.warehouseModel, required this.type});

  @override
  _EditBriefcasePageState createState() => _EditBriefcasePageState();
}

class _EditBriefcasePageState extends State<EditBriefcasePage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount).listenable(),
      builder: (context, box, child) {
        final currentUserId = Hive.box<GlobalSettings>(HiveBoxes.globalSettings)
            .getValue()!
            .loggedInUserId;
        final user = box.get(currentUserId)!.paperlessUser;
        return BlocProvider(
          lazy: false,
          create: (context) => WarehouseEditCubit(
              context.read(),
              context.read(),
              Hive.box<LocalUserAppState>(HiveBoxes.localUserAppState)
                  .get(currentUserId)!,
              context.read(),
              context.read(),
              widget.type) // Use widget.type to access the type parameter
            ..initialize(),
          child: BlocBuilder<WarehouseEditCubit, WarehouseEditState>(
            builder: (context, state) {
              return Builder(builder: (context) {
                return EditPhysicalWarehousePage<WarehouseModel>(
                  formKey: _formKey,
                  warehouse: widget.warehouseModel, // Use widget.warehouseModel
                  fromJsonT: WarehouseModel.fromJson,

                  canDelete: context
                      .watch<LocalUserAccount>()
                      .paperlessUser
                      .canDeleteCorrespondents,
                  type: widget.type, // Use widget.type
                  initialFilter:
                      context.read<WarehouseEditCubit>().state.filter,
                  labelButtonSubmit: S.of(context)!.save,
                );
              });
            },
          ),
        );
      },
    );
  }
}
