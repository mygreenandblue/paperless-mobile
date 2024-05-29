// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/database/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';

import 'package:paperless_mobile/features/physical_warehouse/cubit/warehouse_cubit/warehouse_cubit.dart';
import 'package:paperless_mobile/features/physical_warehouse/cubit/warehouse_edit/warehouse_edit_cubit.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/impl/add_physical_warehouse_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class AddBriefcasePage extends StatefulWidget {
  final String? initialName;
  final String type;

  const AddBriefcasePage({
    Key? key,
    this.initialName,
    required this.type,
  }) : super(key: key);

  @override
  State<AddBriefcasePage> createState() => _AddBriefcasePageState();
}

class _AddBriefcasePageState extends State<AddBriefcasePage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();
  Map<String, String> _errors = {};

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount).listenable(),
        builder: (context, box, child) {
          final currentUserId =
              Hive.box<GlobalSettings>(HiveBoxes.globalSettings)
                  .getValue()!
                  .loggedInUserId;
          final user = box.get(currentUserId)!.paperlessUser;
          return BlocProvider(
            create: (context) => WarehouseEditCubit(
                context.read(),
                context.read(),
                Hive.box<LocalUserAppState>(HiveBoxes.localUserAppState)
                    .get(currentUserId)!,
                context.read(),
                context.read(),
                widget.type)
              ..initialize(),
            child: BlocBuilder<WarehouseCubit, WarehouseState>(
              builder: (context, state) {
                return AddPhysicalWarehousePage<WarehouseModel>(
                  formKey: _formKey,
                  pageTitle: Text(S.of(context)!.addBriefcase),
                  fromJsonT: WarehouseModel.fromJson,
                  initialName: widget.initialName,
                  labelButtonSubmit: S.of(context)!.create,
                  type: widget.type,
                  initialFilter:
                      context.read<WarehouseEditCubit>().state.filter,
                );
              },
            ),
          );
        });
  }
}
